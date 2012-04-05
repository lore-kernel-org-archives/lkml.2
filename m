Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab2DEQzx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:55:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19520 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab2DEQzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:55:51 -0400
X-Authority-Analysis: v=2.0 cv=T5EOvo2Q c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=41d2ALJM-HAA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=K_EY4MRsd0OYTgXaTXkA:9 a=_jfklsgaMD1WJ5iGgmwA:7 a=QEXdDO2ut3YA:10 a=1Nb45NtVgWCu2Ihc:21 a=VVVaaSG9glBmPPwT:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: [PATCH 2/3] tracing: Extract out common code for
 kprobes/uprobes traceevents
From: Steven Rostedt <rostedt@goodmis.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Anton Arapov <anton@redhat.com>
In-Reply-To: <20120403010452.17852.14232.sendpatchset@srdronam.in.ibm.com>
References: <20120403010442.17852.9888.sendpatchset@srdronam.in.ibm.com>
	 <20120403010452.17852.14232.sendpatchset@srdronam.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Apr 2012 12:55:41 -0400
Message-ID: <1333644941.3764.32.camel@pippen.local.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-03 at 06:34 +0530, Srikar Dronamraju wrote:


> -/*
> - * Fetch a null-terminated string. Caller MUST set *(u32 *)dest with max
> - * length and relative data location.
> - */
> -static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
> -                                                     void *addr, void *dest)
> -{
> -       long ret;
> -       int maxlen = get_rloc_len(*(u32 *)dest);
> -       u8 *dst = get_rloc_data(dest);
> -       u8 *src = addr;
> -       mm_segment_t old_fs = get_fs();
> -       if (!maxlen)
> -               return;

> diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> new file mode 100644
> index 0000000..deb375a
> --- /dev/null
> +++ b/kernel/trace/trace_probe.c

> +DEFINE_BASIC_FETCH_FUNCS(memory)
> +/*
> + * Fetch a null-terminated string. Caller MUST set *(u32 *)dest with max
> + * length and relative data location.
> + */
> +static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
> +						      void *addr, void *dest)
> +{
> +	int maxlen;
> +	long ret;
> +
> +	maxlen = get_rloc_len(*(u32 *)dest);
> +	u8 *dst = get_rloc_data(dest);
> +	u8 *src = addr;


Please do not mix declarations and actual code. The above declares
maxlen and ret, then assigns maxlen (actual code) and then you declare
dst and src (as well as assign it).

The original version (shown at the top) is fine. Why did you change it?
Although the original should have a space:

static __kprobes void FETCH_FUNC_NAME(memory, string)(struct pt_regs *regs,
                                                     void *addr, void *dest)
{
       long ret;
       int maxlen = get_rloc_len(*(u32 *)dest);
       u8 *dst = get_rloc_data(dest);
       u8 *src = addr;
       mm_segment_t old_fs = get_fs();
					<--- new line needed (from original)
       if (!maxlen)
               return;

> +	mm_segment_t old_fs = get_fs();
> +
> +	if (!maxlen)
> +		return;
> +
> +	/*
> +	 * Try to get string again, since the string can be changed while
> +	 * probing.
> +	 */
> +	set_fs(KERNEL_DS);
> +	pagefault_disable();
> +
> +	do
> +		ret = __copy_from_user_inatomic(dst++, src++, 1);
> +	while (dst[-1] && ret == 0 && src - (u8 *)addr < maxlen);
> +
> +	dst[-1] = '\0';
> +	pagefault_enable();
> +	set_fs(old_fs);
> +
> +	if (ret < 0) {	/* Failed to fetch string */
> +		((u8 *)get_rloc_data(dest))[0] = '\0';
> +		*(u32 *)dest = make_data_rloc(0, get_rloc_offs(*(u32 *)dest));
> +	} else {
> +		*(u32 *)dest = make_data_rloc(src - (u8 *)addr,
> +					      get_rloc_offs(*(u32 *)dest));
> +	}
> +}


> +
> +#define WRITE_BUFSIZE 128

The original code had WRITE_BUFSIZE as 4096 this has it with 128. That's
a big difference. Even if you have a reason for changing this, don't do
it in this patch. That should be a separate patch with an explanation of
why this was changed.

The rest of the patch looks fine.

-- Steve

> +
> +ssize_t traceprobe_probes_write(struct file *file, const char __user *buffer,
> +				size_t count, loff_t *ppos,
> +				int (*createfn)(int, char **))
> +{
> +	char *kbuf, *tmp;
> +	int ret = 0;
> +	size_t done = 0;
> +	size_t size;
> +
> +
> 


