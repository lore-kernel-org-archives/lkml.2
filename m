Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab0GIIpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 04:45:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53059 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab0GIIpb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 04:45:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AFGIizUWVVsdfZWEfTWJgZ8Kz38r7laqe80tY3F5nznjgOME1xlxkvGp3lyXcC97mF
         CPPho10CtzBCFGc8DgO3yIi17w9PFShfz6abZqYZx5ipn/t3rCu8lH07foj+ff1tNZ7X
         nlzZi5IBQHQwUj1LPwRfspCFynMAx/trkqE9Q=
MIME-Version: 1.0
In-Reply-To: <1278645989.1537.133.camel@gandalf.stny.rr.com>
References: <loom.20100705T144459-919@post.gmane.org> <20100708132237.GA22830@goodmis.org> 
	<AANLkTilsXUjNNDcC4ZA9m8hBDqzcoh5NGbNd4XX5xx5s@mail.gmail.com> 
	<1278645989.1537.133.camel@gandalf.stny.rr.com>
From: Zeev Tarantov <zeev.tarantov@gmail.com>
Date: Fri, 9 Jul 2010 11:45:09 +0300
Message-ID: <AANLkTinkKVmB0fpVeqUkMeqe3ZYeXJdI8xDuzJEOjYwh@mail.gmail.com>
Subject: Re: 2.6.35 regression
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 9, 2010 at 06:26, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 2010-07-08 at 21:53 +0300, Zeev Tarantov wrote:
>
>> With gcc 4.5.1 rev. 161655 objdump shows:
>> Disassembly of section .data:
>>
>> ffffffff8173c438 <__start_syscalls_metadata>:
>>         ...
>>
>> ffffffff8173c440 <__syscall_meta__mmap>:
>> ffffffff8173c440:       2b ab 5f 81 ff ff       sub    -0x7ea1(%rbx),%ebp
>
> Yeah, this is definitely the issue. It starts off at ffffffff8173c438,
> when the first item is really at ffffffff8173c440.
>
> Can you try this patch out:
>
> -- Steve
>
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 7f614ce..13ebb54 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -124,7 +124,8 @@ extern struct trace_event_functions enter_syscall_print_funcs;
>  extern struct trace_event_functions exit_syscall_print_funcs;
>
>  #define SYSCALL_TRACE_ENTER_EVENT(sname)                               \
> -       static struct syscall_metadata __syscall_meta_##sname;          \
> +       static struct syscall_metadata                                  \
> +       __attribute__((__aligned__(4))) __syscall_meta_##sname;         \
>        static struct ftrace_event_call                                 \
>        __attribute__((__aligned__(4))) event_enter_##sname;            \
>        static struct ftrace_event_call __used                          \
> @@ -138,7 +139,8 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>        }
>
>  #define SYSCALL_TRACE_EXIT_EVENT(sname)                                        \
> -       static struct syscall_metadata __syscall_meta_##sname;          \
> +       static struct syscall_metadata                                  \
> +       __attribute__((__aligned__(4))) __syscall_meta_##sname;         \
>        static struct ftrace_event_call                                 \
>        __attribute__((__aligned__(4))) event_exit_##sname;             \
>        static struct ftrace_event_call __used                          \
>
>
>
>

Boots fine with this applied.
Linux version 2.6.35-rc4 (wolf@wolfpc) (gcc version 4.5.1-pre9999
20100701 (prerelease) rev. 161655 (Gentoo SVN) ) #5 SMP Fri Jul 9
11:13:08 IDT 2010

I hope Linus accepts this patch as it seems to me the compiler is
doing something it is allowed to do.

Thank you for the prompt response!

-Zeev
