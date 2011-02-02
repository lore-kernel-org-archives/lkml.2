Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab1BBOEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 09:04:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:60198 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754318Ab1BBOEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 09:04:48 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=up3NAqt5ug8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=mWdW7UwM6_3bdX58knwA:9 a=oqzHFQWA_DJUMff9EMYA:7 a=XEFNZr8a7HwDXfJYs1rCXtptHckA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 4/6] ftrace syscalls: Allow arch specific syscall
 symbol matching
From: Steven Rostedt <rostedt@goodmis.org>
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, Andreas Dilger <adilger@dilger.ca>,
        Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Jason Baron <jbaron@redhat.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Alexander Graf <agraf@suse.de>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Scott Wood <scottwood@freescale.com>, Nathan Lynch <ntl@pobox.com>,
        Avantika Mathur <mathur@linux.vnet.ibm.com>,
        David Gibson <dwg@au1.ibm.com>, Andreas Schwab <schwab@linux-m68k.org>,
        Namhyung Kim <namhyung@gmail.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
In-Reply-To: <1296630718-17537-5-git-send-email-imunsie@au1.ibm.com>
References: <1296630718-17537-1-git-send-email-imunsie@au1.ibm.com>
	 <1296630718-17537-5-git-send-email-imunsie@au1.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 02 Feb 2011 09:04:44 -0500
Message-ID: <1296655484.10797.47.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 18:11 +1100, Ian Munsie wrote:

I'll answer your question here.

> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index dcd6a7c..0d0e109 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -527,6 +527,15 @@ extern enum ftrace_dump_mode ftrace_dump_on_oops;
>  #ifdef CONFIG_FTRACE_SYSCALLS
>  
>  unsigned long arch_syscall_addr(int nr);
> +#ifndef arch_syscall_match_sym_name
> +/*
> + * Only compare after the "sys" prefix. Archs that use
> + * syscall wrappers may have syscalls symbols aliases prefixed
> + * with "SyS" instead of "sys", leading to an unwanted
> + * mismatch.
> + */
> +#define arch_syscall_match_sym_name(sym, name) !strcmp(sym + 3, name + 3)

Instead, you could have:

#ifndef ARCH_HAS_SYSCALL_MATCH_SYM_NAME

static inline arch_syscall_match_sym_name(const char *sym, const char *name)
{
	return strcmp(sym + 3, name + 3) != 0;
}


If an arch needs to make its own, then it can simply override it by
creating its own version and defining:

#define ARCH_HAS_SYSCALL_MATCH_SYM_NAME

Just like they do when an arch has its own strcmp.

This just keeps things cleaner. I like to avoid macros as they can have
nasty side effects (never would have guess that if you look at what I've
done in trace/ftrace.h ;-)

For example, if we use your call as:

arch_syscall_match_sym_name(str = sym[5], name);

That str would end up being something unexpected. I'm not condoning such
side-effect code, but it is something to think about when using macros.

-- Steve


> +#endif
>  
>  #endif /* CONFIG_FTRACE_SYSCALLS */
>  
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 33360b9..76bffba 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -72,13 +72,7 @@ static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
>  	kallsyms_lookup(syscall, NULL, NULL, NULL, str);
>  
>  	for ( ; start < stop; start++) {
> -		/*
> -		 * Only compare after the "sys" prefix. Archs that use
> -		 * syscall wrappers may have syscalls symbols aliases prefixed
> -		 * with "SyS" instead of "sys", leading to an unwanted
> -		 * mismatch.
> -		 */
> -		if (start->name && !strcmp(start->name + 3, str + 3))
> +		if (start->name && arch_syscall_match_sym_name(str, start->name))
>  			return start;
>  	}
>  	return NULL;


