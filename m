Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0LGE5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 23:57:12 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35589 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138Ab0LGE5L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 23:57:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=ks7bCdrfnQ2IRgIPWC+5vVz7E0WtVkJcDqg3BVPGKGKi2tIToEVnYdVCiG20d0c5ID
         i5YZ7/nK/4svQrRDndVD/W6xn7eqEw20/GKk7NtRFkfaZ76m5clKg0MubBHcbXSqo+EC
         +6YBO1SqUL+SPy2m3VqHI2tplekjC6U5uHHtc=
MIME-Version: 1.0
In-Reply-To: <1291696151-4336-5-git-send-email-imunsie@au1.ibm.com>
References: <1291696151-4336-1-git-send-email-imunsie@au1.ibm.com> <1291696151-4336-5-git-send-email-imunsie@au1.ibm.com>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 6 Dec 2010 23:56:49 -0500
X-Google-Sender-Auth: bCPm915vsj4lt3YvIMki-w8aDn0
Message-ID: <AANLkTik7O=xVP2WuD+AV-oQqg9heT4fVbEa65W+BRq11@mail.gmail.com>
Subject: Re: [PATCH 4/6] ftrace syscalls: Allow arch specific syscall symbol matching
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: Avantika Mathur <mathur@linux.vnet.ibm.com>,
        Jason Baron <jbaron@redhat.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 6, 2010 at 23:29, Ian Munsie wrote:
> From: Ian Munsie <imunsie@au1.ibm.com>
>
> Some architectures have unusual symbol names and the generic code to
> match the symbol name with the function name for the syscall metadata
> will fail. For example, symbols on PPC64 start with a period and the
> generic code will fail to match them.
>
> This patch splits out the match logic into a standalone weak function
> that can be overridden on archs with unusual symbol names.
>
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -527,6 +527,7 @@ extern enum ftrace_dump_mode ftrace_dump_on_oops;
>  #ifdef CONFIG_FTRACE_SYSCALLS
>
>  unsigned long arch_syscall_addr(int nr);
> +bool arch_syscall_match_sym_name(const char *sym, const char *name);
>
>  #endif /* CONFIG_FTRACE_SYSCALLS */
>
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -81,13 +81,7 @@ static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
>        kallsyms_lookup(syscall, NULL, NULL, NULL, str);
>
>        for ( ; start < stop; start++) {
> -               /*
> -                * Only compare after the "sys" prefix. Archs that use
> -                * syscall wrappers may have syscalls symbols aliases prefixed
> -                * with "SyS" instead of "sys", leading to an unwanted
> -                * mismatch.
> -                */
> -               if (start->name && !strcmp(start->name + 3, str + 3))
> +               if (start->name && arch_syscall_match_sym_name(str, start->name))
>                        return start;
>        }
>        return NULL;
> @@ -452,6 +446,17 @@ unsigned long __init __weak arch_syscall_addr(int nr)
>        return (unsigned long)sys_call_table[nr];
>  }
>
> +bool __weak arch_syscall_match_sym_name(const char *sym, const char *name)
> +{
> +       /*
> +        * Only compare after the "sys" prefix. Archs that use
> +        * syscall wrappers may have syscalls symbols aliases prefixed
> +        * with "SyS" instead of "sys", leading to an unwanted
> +        * mismatch.
> +        */
> +       return (!strcmp(sym + 3, name + 3));
> +}

useless set of parenthesis, and this overhead sucks.  weak +
additional function call just for a strcmp for most people ?  why not
make it into a define in the header:
#ifndef arch_syscall_match_sym_name
#define arch_syscall_match_sym_name(sym, name) !strcmp(sym + 3, name + 3)
#endif
-mike
