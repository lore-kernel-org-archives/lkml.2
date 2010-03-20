Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091Ab0CTGMO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 02:12:14 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:36853 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab0CTGMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 02:12:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mLzNUYY9FMgIDd5zeZWesUyve/sO0dVeFLeb5GsrmDcF814x2gdTMvqstB9qe7TUyk
         y5w/Cp23fgBQn3y+9zNyaxF+r9ty5Pb2bU7iSs0K/F7ONaXcvUK9fSmLBh39+y3ZIIpp
         RhuPNZKh83wo+SQhAUs8vvB95hccEEzsb0lX0=
Date: Sat, 20 Mar 2010 07:12:17 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       laijs@cn.fujitsu.com, lizf@cn.fujitsu.com, hpa@zytor.com,
       tglx@linutronix.de, mhiramat@redhat.com, heiko.carstens@de.ibm.com,
       benh@kernel.crashing.org, davem@davemloft.net, lethal@linux-sh.org,
       schwidefsky@de.ibm.com, brueckner@linux.vnet.ibm.com,
       tony.luck@intel.com
Subject: Re: [PATCH 06/14] tracing: add tracing support for compat syscalls
Message-ID: <20100320061215.GN5085@nowhere>
References: <cover.1268749695.git.jbaron@redhat.com> <a75e730f4fc49c3657d6e407fb16a3508ec321a9.1268749695.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a75e730f4fc49c3657d6e407fb16a3508ec321a9.1268749695.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 01:46:36PM -0400, Jason Baron wrote:
>  #else /* CONFIG_COMPAT */
>  
> +#define NR_syscalls_compat 0
> +
>  static inline int is_compat_task(void)
>  {
>  	return 0;
> diff --git a/include/trace/syscall.h b/include/trace/syscall.h
> index 8f5ac38..1cc1d1e 100644
> --- a/include/trace/syscall.h
> +++ b/include/trace/syscall.h
> @@ -22,6 +22,7 @@
>  struct syscall_metadata {
>  	const char	*name;
>  	int		syscall_nr;
> +	int		compat_syscall_nr;



Why do you need both syscall_nr and compat_syscall_nr?
Compat and usual syscalls never share the same syscall
metadata.



> +#ifdef __HAVE_ARCH_FTRACE_COMPAT_SYSCALLS
> +	if (NR_syscalls_compat) {
> +		int match;
> +		struct ftrace_event_call *ftrace_event;
> +
> +		compat_syscalls_metadata = kzalloc(sizeof(*syscalls_metadata) *
> +						NR_syscalls_compat, GFP_KERNEL);
> +		if (!compat_syscalls_metadata) {
> +			WARN_ON(1);
> +			kfree(syscalls_metadata);
> +			return -ENOMEM;
> +		}
> +		for (i = 0; i < NR_syscalls_compat; i++) {
> +			addr = arch_compat_syscall_addr(i);
> +			meta = find_syscall_meta(addr);
> +			if (!meta)
> +				continue;
> +
> +			meta->compat_syscall_nr = i;
> +			compat_syscalls_metadata[i] = meta;
> +		}
> +		/* now check if any compat_syscalls are not referenced */
> +		for (ftrace_event = __start_ftrace_events;
> +			(unsigned long)ftrace_event <
> +			(unsigned long)__stop_ftrace_events; ftrace_event++) {



You could reuse for_each_event()



> +			match = 0;
> +			if (!ftrace_event->name)
> +				continue;
> +			if (strcmp(ftrace_event->system, "compat_syscalls"))
> +				continue;
> +			for (i = 0; i < NR_syscalls_compat; i++) {
> +				if (ftrace_event->data ==
> +						compat_syscalls_metadata[i]) {
> +					match = 1;
> +					break;


Nano-neat: starting the whole block with if (NR_syscalls_compat)
or making the whole a separate init_ftrace_syscalls() would
have made it win one level of indentation.



> +				}
> +			}
> +			if (!match)
> +				ftrace_event->name = NULL;



Nice :)

Thanks.

