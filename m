Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621Ab0ELLCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 07:02:32 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:53100 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab0ELLCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 07:02:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vCnB5cXXRbyBm5fJODzSeIWiMszZrSW/EhuwgSRoeZ1asmrRHV7jlnIQ7USbapn2wa
         Nso9l35iJB5vXHWSCFqzc6kEQYjeqc3nurO7VHgOi225Kewr23iXAyryciJG8hNsZ6Ox
         ePOQb6Ib272uYn5Iu6+Vrr73geG2C6yL+ZCjQ=
Date: Wed, 12 May 2010 13:02:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 11/11] Uprobes traceevents patch.
Message-ID: <20100512110224.GB5408@nowhere>
References: <20100331155106.4181.50759.sendpatchset@localhost6.localdomain6> <20100331155311.4181.85103.sendpatchset@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331155311.4181.85103.sendpatchset@localhost6.localdomain6>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 09:23:11PM +0530, Srikar Dronamraju wrote:
> Uprobes Trace_events interface 
> 
> The following patch implements trace_event support for uprobes. In its
> current form it can be used to put probes at a specified text address
> in a process and dump the required registers when the code flow reaches
> the probed address.
> 
> This is based on trace_events for kprobes to the extent that it may
> resemble that file on 2.6.34-rc3.
> 
> The following example shows how to dump the instruction pointer and %ax a
> register at the probed text address.
> 
> Start a process to trace. Get the address to trace.
>   [Here pid is asssumed as 3548]
>   [Address to trace is 0x0000000000446420]
>   [Registers to be dumped are %ip and %ax]
> 
> # cd /sys/kernel/debug/tracing/
> # echo 'p 3548:0x0000000000446420 %ip %ax' > uprobe_events
> # cat uprobe_events
> p:uprobes/p_3548_0x0000000000446420 3548:0x0000000000446420 %ip=%ip %ax=%ax
> # cat events/uprobes/p_3548_0x0000000000446420/enable
> 0
> [enable the event]
> # echo 1 > events/uprobes/p_3548_0x0000000000446420/enable
> # cat events/uprobes/p_3548_0x0000000000446420/enable
> 1
> # #### do some activity on the program so that it hits the breakpoint
> # cat uprobe_profile
>   3548 p_3548_0x0000000000446420                                234
> # head trace
> # tracer: nop
> #
> #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
> #              | |       |          |         |
>              zsh-3548  [001]   294.285812: p_3548_0x0000000000446420: (0x446420) %ip=446421 %ax=1
>              zsh-3548  [001]   294.285884: p_3548_0x0000000000446420: (0x446420) %ip=446421 %ax=1
>              zsh-3548  [001]   294.285894: p_3548_0x0000000000446420: (0x446420) %ip=446421 %ax=1
>              zsh-3548  [001]   294.285903: p_3548_0x0000000000446420: (0x446420) %ip=446421 %ax=1
>              zsh-3548  [001]   294.285912: p_3548_0x0000000000446420: (0x446420) %ip=446421 %ax=1
>              zsh-3548  [001]   294.285922: p_3548_0x0000000000446420: (0x446420) %ip=446421 %ax=1
> 
> TODO: Documentation/trace/uprobetrace.txt
> 
> Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> ---
> 
>  kernel/trace/Kconfig        |    8 
>  kernel/trace/Makefile       |    1 
>  kernel/trace/trace.h        |   12 +
>  kernel/trace/trace_uprobe.c |  926 +++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 947 insertions(+), 0 deletions(-)
>  create mode 100644 kernel/trace/trace_uprobe.c
> 
> 
> diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
> index 13e13d4..1435e09 100644
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -557,6 +557,14 @@ config RING_BUFFER_BENCHMARK
>  
>  	  If unsure, say N.
>  
> +config UPROBE_EVENT
> +	depends on UPROBES
> +	bool "Enable uprobes-based dynamic events"
> +	select TRACING
> +	default y
> +	help
> +	  This allows the user to add tracing events (similar to tracepoints)
> +	  on the fly via the traceevents interface.



That doesn't explain much what it does. Please explain its goal of
creating a trace event on top of a userspace dynamic probe.



> +#define MAX_TRACE_ARGS 128
> +#define MAX_ARGSTR_LEN 63
> +#define MAX_EVENT_NAME_LEN 64


This can be shared with kprobes in a new kernel/trace/dyn_probes.h
or something.




> +const char *ureserved_field_names[] = {
> +	"common_type",
> +	"common_flags",
> +	"common_preempt_count",
> +	"common_pid",
> +	"common_tgid",
> +	"common_lock_depth",


Same here.



> +/* Register a trace_uprobe and probe_event */
> +static int register_trace_uprobe(struct trace_uprobe *tp)
> +{
> +	struct trace_uprobe *old_tp;
> +	int ret;
> +
> +	mutex_lock(&uprobe_lock);
> +
> +	/* register as an event */
> +	old_tp = find_probe_event(tp->call.name, tp->call.system);
> +	if (old_tp) {
> +		/* delete old event */
> +		unregister_trace_uprobe(old_tp);
> +		free_trace_uprobe(old_tp);
> +	}
> +	ret = register_uprobe_event(tp);
> +	if (ret) {
> +		pr_warning("Faild to register probe event(%d)\n", ret);


"Failed"


> +static int create_trace_uprobe(int argc, char **argv)
> +{
> +	/*
> +	 * Argument syntax:
> +	 *  - Add uprobe: p[:[GRP/]EVENT] VADDR@PID [%REG]
> +	 *
> +	 *  - Remove uprobe: -:[GRP/]EVENT
> +	 */
> +	struct trace_uprobe *tp;
> +	int i, ret = 0;
> +	int is_delete = 0;
> +	char *arg = NULL, *event = NULL, *group = NULL;
> +	void *addr = NULL;
> +	pid_t pid = 0;
> +	char buf[MAX_EVENT_NAME_LEN];
> +
> +	/* argc must be >= 1 */
> +	if (argv[0][0] == '-')
> +		is_delete = 1;
> +	else if (argv[0][0] != 'p') {
> +		pr_info("Probe definition must be started with 'p', 'r' or"
> +			" '-'.\n");
> +		return -EINVAL;
> +	}
> +
> +	if (argv[0][1] == ':') {
> +		event = &argv[0][2];
> +		if (strchr(event, '/')) {
> +			group = event;
> +			event = strchr(group, '/') + 1;
> +			event[-1] = '\0';
> +			if (strlen(group) == 0) {
> +				pr_info("Group name is not specified\n");
> +				return -EINVAL;
> +			}
> +		}
> +		if (strlen(event) == 0) {
> +			pr_info("Event name is not specified\n");
> +			return -EINVAL;
> +		}
> +	}
> +	if (!group)
> +		group = UPROBE_EVENT_SYSTEM;
> +
> +	if (is_delete) {
> +		if (!event) {
> +			pr_info("Delete command needs an event name.\n");
> +			return -EINVAL;
> +		}
> +		tp = find_probe_event(event, group);
> +		if (!tp) {
> +			pr_info("Event %s/%s doesn't exist.\n", group, event);
> +			return -ENOENT;
> +		}
> +		/* delete an event */
> +		unregister_trace_uprobe(tp);



Doesn't seem to be under uprobe_lock.



> +/* Make a debugfs interface for controling probe points */
> +static __init int init_uprobe_trace(void)
> +{
> +	struct dentry *d_tracer;
> +	struct dentry *entry;
> +
> +	d_tracer = tracing_init_dentry();
> +	if (!d_tracer)
> +		return 0;
> +
> +	entry = debugfs_create_file("uprobe_events", 0644, d_tracer,
> +				    NULL, &uprobe_events_ops);
> +
> +	/* Event list interface */
> +	if (!entry)
> +		pr_warning("Could not create debugfs "
> +			   "'uprobe_events' entry\n");



You can use trace_create_file I think.



> +
> +	/* Profile interface */
> +	entry = debugfs_create_file("uprobe_profile", 0444, d_tracer,
> +				    NULL, &uprobe_profile_ops);
> +
> +	if (!entry)
> +		pr_warning("Could not create debugfs "
> +			   "'uprobe_profile' entry\n");
> +	return 0;
> +}
> +fs_initcall(init_uprobe_trace);



Thanks.

