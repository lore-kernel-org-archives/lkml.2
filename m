Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab0GJPgm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 11:36:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43986 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717Ab0GJPgk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 11:36:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TYEYpOgipQB8aSrnrwwNGnJUs5J/HbFj8IR7A+zSKwwUjNWYjxOPvcBr/DASm+heBV
         EdQNUmHgMSaFChscbvcDMfI6VUkj98/JCEhuTbJsU3dmodDqdP4vCtht3OzXuklDiPFx
         QpXA/FPZTmkztk/k3HLju91v3ETvpxcy7h/CQ=
MIME-Version: 1.0
In-Reply-To: <20100710134849.GA15800@merkur.ravnborg.org>
References: <1278705402.1537.157.camel@gandalf.stny.rr.com> 
	<20100709203301.GA13839@merkur.ravnborg.org> <AANLkTinWkfkXNVA2Sx-apVQMZa-5ehugtd7JQ36np7xM@mail.gmail.com> 
	<1278721339.1537.166.camel@gandalf.stny.rr.com> <20100710063459.GA14596@merkur.ravnborg.org> 
	<AANLkTim7jTSaDaQTudR3e-DMBDrg9n00Hor8QdDQoVo_@mail.gmail.com> 
	<1278761646.1537.182.camel@gandalf.stny.rr.com> <20100710134849.GA15800@merkur.ravnborg.org>
From: Zeev Tarantov <zeev.tarantov@gmail.com>
Date: Sat, 10 Jul 2010 18:36:17 +0300
Message-ID: <AANLkTim85F2BSG7ZUXsByOu8w8tDNELG-xUEGnfzODiN@mail.gmail.com>
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

On Sat, Jul 10, 2010 at 16:48, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Sat, Jul 10, 2010 at 07:34:05AM -0400, Steven Rostedt wrote:
>> On Sat, 2010-07-10 at 13:18 +0300, Zeev Tarantov wrote:
>> > On Sat, Jul 10, 2010 at 09:35, Sam Ravnborg <sam@ravnborg.org> wrote:
>>
>> > > +/*
>> > > + * Align to a 32 byte boundary equal to the
>> > > + * alignment gcc 4.5 uses for a struct
>> > > + */
>> > > +#define STRUCT_ALIGN() . = ALIGN(32)
>> > > +
>>
>> What I'm nervous about is when gcc 4.8 decides to up the alignment to
>> 64.
>>
>> Maybe we should have both patches, just to be safe.
>
> Another approach could be to just stop playing games with alignment
> and use the fact that __stop_syscalls_metadata point to next byte
> after last entry.
>
> Something like the below untested patch.
>
> But to fix the current regression I prefer the simpler
> patch that just fixup the aligment.
>
>        Sam
>
>
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 34e3580..50e9606 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -79,15 +79,19 @@ static struct syscall_metadata *find_syscall_meta(unsigned long syscall)
>        stop = (struct syscall_metadata *)__stop_syscalls_metadata;
>        kallsyms_lookup(syscall, NULL, NULL, NULL, str);
>
> -       for ( ; start < stop; start++) {
> +       /*
> +        * start may point a few bytes before first entry
> +        * stop points at first byte after last entry
> +        */
> +       for (stop--; stop >= start; stop--) {
>                /*
>                 * Only compare after the "sys" prefix. Archs that use
>                 * syscall wrappers may have syscalls symbols aliases prefixed
>                 * with "SyS" instead of "sys", leading to an unwanted
>                 * mismatch.
>                 */
> -               if (start->name && !strcmp(start->name + 3, str + 3))
> -                       return start;
> +               if (stop->name && !strcmp(stop->name + 3, str + 3))
> +                       return stop;
>        }
>        return NULL;
>  }
>

This also boots (source from tarball with only this patch, same config
& compiler).
Tested-by: Zeev Tarantov <zeev.tarantov@gmail.com>

-Zeev
