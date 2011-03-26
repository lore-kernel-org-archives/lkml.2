Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab1CZNvy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 09:51:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62745 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab1CZNvv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 09:51:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Evt3OymD6wWV+xYWEPJTXYgYv8m6RVpfNSlNzkPs1fZn7wNhnwTjTnDhYHkPyOAYY5
         /bAqSUKA5hBWzuwrmoXbWuQ4n/eFRcXSSLKcnWszD0Q5f4xOUOWQtTdpcyIVYwbN3Y3q
         hB7Zp3YwlyQCC7zrk+BwhronWbErpNiACC1hs=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1103251119120.26754@pobox.suse.cz>
References: <alpine.LNX.2.00.1101030002390.26685@pobox.suse.cz>
	<alpine.LNX.2.00.1101031237210.26685@pobox.suse.cz>
	<alpine.LNX.2.00.1101031421470.26685@pobox.suse.cz>
	<AANLkTinK-TYnY70Wst_FTbEtn7Dwm8wEQoWMewsYM8dh@mail.gmail.com>
	<alpine.LNX.2.00.1103251119120.26754@pobox.suse.cz>
Date: Sat, 26 Mar 2011 14:51:49 +0100
X-Google-Sender-Auth: COHT5rZz8yQ0Qy_Jp3S2mKZWEJw
Message-ID: <AANLkTi=g5z+GYkbOGbdLQcLaQkpY6yQ6tjGRjjk1H59R@mail.gmail.com>
Subject: Re: [regression v2.6.38] Re: [PATCH v2] brk: fix min_brk lower bound
 computation for COMPAT_BRK
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Fri, Mar 25, 2011 at 11:20, Jiri Kosina <jkosina@suse.cz> wrote:
> On Thu, 24 Mar 2011, Geert Uytterhoeven wrote:
>> > From: Jiri Kosina <jkosina@suse.cz>
>> > Subject: [PATCH] brk: fix min_brk lower bound computation for COMPAT_BRK
>> >
>> > Even if CONFIG_COMPAT_BRK is set in the kernel configuration, it can still
>> > be overriden by randomize_va_space sysctl.
>> >
>> > If this is the case, the min_brk computation in sys_brk() implementation
>> > is wrong, as it solely takes into account COMPAT_BRK setting, assuming
>> > that brk start is not randomized. But that might not be the case if
>> > randomize_va_space sysctl has been set to '2' at the time the binary has
>> > been loaded from disk.
>> >
>> > In such case, the check has to be done in a same way as in
>> > !CONFIG_COMPAT_BRK case.
>> >
>> > In addition to that, the check for the COMPAT_BRK case introduced back in
>> > a5b4592c ("brk: make sys_brk() honor COMPAT_BRK when computing lower
>> > bound") is slightly wrong -- the lower bound shouldn't be mm->end_code,
>> > but mm->end_data instead, as that's where the legacy applications expect
>> > brk section to start (i.e. immediately after last global variable).
>> >
>> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>> > ---
>> >  mm/mmap.c |   10 +++++++++-
>> >  1 files changed, 9 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/mm/mmap.c b/mm/mmap.c
>> > index 50a4aa0..ca2f164 100644
>> > --- a/mm/mmap.c
>> > +++ b/mm/mmap.c
>> > @@ -253,7 +253,15 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
>> >        down_write(&mm->mmap_sem);
>> >
>> >  #ifdef CONFIG_COMPAT_BRK
>> > -       min_brk = mm->end_code;
>> > +       /*
>> > +        * CONFIG_COMPAT_BRK can still be overridden by setting
>> > +        * randomize_va_space to 2, which will still make mm->start_brk
>> > +        * to be arbitrarily shifted
>> > +        */
>> > +       if (mm->start_brk > PAGE_ALIGN(mm->end_data))
>> > +               min_brk = mm->start_brk;
>> > +       else
>> > +               min_brk = mm->end_data;
>> >  #else
>> >        min_brk = mm->start_brk;
>> >  #endif
>> > --
>> > 1.7.3.1
>>
>> Sorry for chiming in this late, but I've just bisected a problem in
>> 2.6.38 to commit
>> 5520e89485252c759ee60d313e9422447659947b ("brk: fix min_brk lower bound
>> computation for COMPAT_BRK").
>>
>> When booting my very old test ramdisk on Amiga/m68k, it fails like this:
>>
>> | RAMDISK: gzip image found at block 0
>> | VFS: Mounted root (ext2 filesystem) readonly on device 1:0.
>> | warning: process `update' used the obsolete bdflush system call
>> | Fix your initscripts?
>> | init: cannot open inittab
>> | Kernel panic - not syncing: Attempted to kill init!
>>
>> Sorry for not noticing earlier, I usually boot full Debians under ARAnyM,
>> instead of booting old ramdisks with libc5-based binaries that once were
>> considered new.
>
> Oh well, one has to love the libc5-based binaries indeed.

Yeah, binaries from 1996 ;-)

> Is the patch below fixing the issue you are seeing on your Amiga/m68k?
> Thanks.
>
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 2ec8eb5..0a02531 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -262,7 +262,7 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
>        if (mm->start_brk > PAGE_ALIGN(mm->end_data))
>                min_brk = mm->start_brk;
>        else
> -               min_brk = mm->end_data;
> +               min_brk = mm->end_code;
>  #else
>        min_brk = mm->start_brk;
>  #endif

Unfortunately not...

I added some printk()s:

mm->start_brk = 0x8000a000, PAGE_ALIGN(mm->end_data = 0x8000a000)
mm->start_brk = 0x8000a000, PAGE_ALIGN(mm->end_data = 0x8000a000)
mm->start_brk = 0x8000a000, PAGE_ALIGN(mm->end_data = 0x8000a000)
mm->start_brk = 0x8000a000, PAGE_ALIGN(mm->end_data = 0x8000a000)
mm->start_brk = 0x80006000, PAGE_ALIGN(mm->end_data = 0x80004000)

I.e. just before the failure, "mm->start_brk > PAGE_ALIGN(mm->end_data)"
became true.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
