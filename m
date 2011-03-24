Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab1CXVuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:50:21 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58219 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756946Ab1CXVuR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:50:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GUbidAtNUX+9Y23KK01JlDwZ9AJFuiKiv47C6WQN9p7GlwNEBKxM2dYdz3ojQ3ZPwu
         c4C3q9c6hIUTHCOJsnzCZKcAYw22otP9nmLc5lzTI3OQTXFAs8zgi+PosxJjlZATzl1b
         bQJCkcWuzU8nMJ64PJd0YY5je9BRqwyhcPWuc=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1101031421470.26685@pobox.suse.cz>
References: <alpine.LNX.2.00.1101030002390.26685@pobox.suse.cz>
	<alpine.LNX.2.00.1101031237210.26685@pobox.suse.cz>
	<alpine.LNX.2.00.1101031421470.26685@pobox.suse.cz>
Date: Thu, 24 Mar 2011 22:49:45 +0100
X-Google-Sender-Auth: uxUpAwtz9D4vlUWM3KyY2EJaUkU
Message-ID: <AANLkTinK-TYnY70Wst_FTbEtn7Dwm8wEQoWMewsYM8dh@mail.gmail.com>
Subject: [regression v2.6.38] Re: [PATCH v2] brk: fix min_brk lower bound
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

On Mon, Jan 3, 2011 at 14:24, Jiri Kosina <jkosina@suse.cz> wrote:
>> > diff --git a/mm/mmap.c b/mm/mmap.c
>> > index 50a4aa0..35d9f9c 100644
>> > --- a/mm/mmap.c
>> > +++ b/mm/mmap.c
>> > @@ -253,7 +253,15 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
>> >     down_write(&mm->mmap_sem);
>> >
>> >  #ifdef CONFIG_COMPAT_BRK
>> > -   min_brk = mm->end_code;
>> > +   /*
>> > +    * CONFIG_COMPAT_BRK can still be overridden by setting
>> > +    * randomize_va_space to 2, which will still make mm->start_brk
>> > +    * to be arbitrarily shifted
>> > +    */
>> > +   if (mm->start_brk > mm->end_code)
>> > +           min_brk = mm->start_brk;
>> > +   else
>> > +           min_brk = mm->end_code;
>> >  #else
>> >     min_brk = mm->start_brk;
>> >  #endif
>>
>> Hmm, actually no, that will bring us back into pre-a5b4592c era, please
>> disregard that.
>>
>> I will have to come up with something more clever (we can't just check
>> 'randomize_va_space == 2', as that would be racy for already running
>> programs).
>
> The patch below handles all the cases properly. Ingo, Andrew, please
> consider applying. Thanks.
>
>
>
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] brk: fix min_brk lower bound computation for COMPAT_BRK
>
> Even if CONFIG_COMPAT_BRK is set in the kernel configuration, it can still
> be overriden by randomize_va_space sysctl.
>
> If this is the case, the min_brk computation in sys_brk() implementation
> is wrong, as it solely takes into account COMPAT_BRK setting, assuming
> that brk start is not randomized. But that might not be the case if
> randomize_va_space sysctl has been set to '2' at the time the binary has
> been loaded from disk.
>
> In such case, the check has to be done in a same way as in
> !CONFIG_COMPAT_BRK case.
>
> In addition to that, the check for the COMPAT_BRK case introduced back in
> a5b4592c ("brk: make sys_brk() honor COMPAT_BRK when computing lower
> bound") is slightly wrong -- the lower bound shouldn't be mm->end_code,
> but mm->end_data instead, as that's where the legacy applications expect
> brk section to start (i.e. immediately after last global variable).
>
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
>  mm/mmap.c |   10 +++++++++-
>  1 files changed, 9 insertions(+), 1 deletions(-)
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 50a4aa0..ca2f164 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -253,7 +253,15 @@ SYSCALL_DEFINE1(brk, unsigned long, brk)
>        down_write(&mm->mmap_sem);
>
>  #ifdef CONFIG_COMPAT_BRK
> -       min_brk = mm->end_code;
> +       /*
> +        * CONFIG_COMPAT_BRK can still be overridden by setting
> +        * randomize_va_space to 2, which will still make mm->start_brk
> +        * to be arbitrarily shifted
> +        */
> +       if (mm->start_brk > PAGE_ALIGN(mm->end_data))
> +               min_brk = mm->start_brk;
> +       else
> +               min_brk = mm->end_data;
>  #else
>        min_brk = mm->start_brk;
>  #endif
> --
> 1.7.3.1

Sorry for chiming in this late, but I've just bisected a problem in
2.6.38 to commit
5520e89485252c759ee60d313e9422447659947b ("brk: fix min_brk lower bound
computation for COMPAT_BRK").

When booting my very old test ramdisk on Amiga/m68k, it fails like this:

| RAMDISK: gzip image found at block 0
| VFS: Mounted root (ext2 filesystem) readonly on device 1:0.
| warning: process `update' used the obsolete bdflush system call
| Fix your initscripts?
| init: cannot open inittab
| Kernel panic - not syncing: Attempted to kill init!

Sorry for not noticing earlier, I usually boot full Debians under ARAnyM,
instead of booting old ramdisks with libc5-based binaries that once were
considered new.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
