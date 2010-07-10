Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab0GJKTQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 06:19:16 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:44157 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab0GJKTP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 06:19:15 -0400
X-Greylist: delayed 91229 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Jul 2010 06:19:14 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rhzZIMNRcSShLE/oKR3dyifZ4Rzf1bCwAEyxPpGoSCdJgkz/w2bzZkGUfXKryEkdjf
         HqBytXtAvOWnciSAIIKvAlOrxFjgxzn86RRcedFhKu9t1FdHx8qtPY3Q/Q1/JLR6crhx
         hahonzphAc4veSif3sNhfKUgaVr6b8WJARvM0=
MIME-Version: 1.0
In-Reply-To: <20100710063459.GA14596@merkur.ravnborg.org>
References: <1278705402.1537.157.camel@gandalf.stny.rr.com> 
	<20100709203301.GA13839@merkur.ravnborg.org> <AANLkTinWkfkXNVA2Sx-apVQMZa-5ehugtd7JQ36np7xM@mail.gmail.com> 
	<1278721339.1537.166.camel@gandalf.stny.rr.com> <20100710063459.GA14596@merkur.ravnborg.org>
From: Zeev Tarantov <zeev.tarantov@gmail.com>
Date: Sat, 10 Jul 2010 13:18:53 +0300
Message-ID: <AANLkTim7jTSaDaQTudR3e-DMBDrg9n00Hor8QdDQoVo_@mail.gmail.com>
Subject: Re: [PATCH] tracing: properly align linker defined symbols
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 09:35, Sam Ravnborg <sam@ravnborg.org> wrote:
> Zeev - please try this replacement patch.
> The alignmnet is increased to 32 bytes compared to my previous version and
> we introduce alignmnet for ftrace_events too.
>
>        Sam
>
> From 40bedb8fda25d2cf9ecdd41ab48a24104607c37e Mon Sep 17 00:00:00 2001
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Sat, 10 Jul 2010 08:24:12 +0200
> Subject: [PATCH] tracing: properly align linker defined symbols
>
> We define a number of symbols in the linker scipt like this:
>
>    __start_syscalls_metadata = .;
>    *(__syscalls_metadata)
>
> But we do not know the alignment of "." when we assign
> the __start_syscalls_metadata symbol.
> gcc started to uses bigger alignment for structs (32 bytes),
> so we saw situations where the linker due to alignment
> constraints increased the value of "." after the symbol assignment.
>
> This resulted in boot fails.
>
> Fix this by forcing a 32 byte alignment of "." before the
> assignment.
>
> This patch introduces the forced alignment for
> ftrace_events and syscalls_metadata.
> It may be required in more places.
>
> Reported-by: Zeev Tarantov <zeev.tarantov@gmail.com>
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  include/asm-generic/vmlinux.lds.h |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
>
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index 48c5299..4b5902a 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -63,6 +63,12 @@
>  /* Align . to a 8 byte boundary equals to maximum function alignment. */
>  #define ALIGN_FUNCTION()  . = ALIGN(8)
>
> +/*
> + * Align to a 32 byte boundary equal to the
> + * alignment gcc 4.5 uses for a struct
> + */
> +#define STRUCT_ALIGN() . = ALIGN(32)
> +
>  /* The actual configuration determine if the init/exit sections
>  * are handled as text/data or they can be discarded (which
>  * often happens at runtime)
> @@ -166,7 +172,11 @@
>        LIKELY_PROFILE()                                                \
>        BRANCH_PROFILE()                                                \
>        TRACE_PRINTKS()                                                 \
> +                                                                       \
> +       STRUCT_ALIGN();                                                 \
>        FTRACE_EVENTS()                                                 \
> +                                                                       \
> +       STRUCT_ALIGN();                                                 \
>        TRACE_SYSCALLS()
>
>  /*
> --
> 1.6.0.6
>
>

2.6.35-rc4 from tarball patched with only this, same config & same
compiler boots fine.

Tested-by: Zeev Tarantov <zeev.tarantov@gmail.com>

-Zeev
