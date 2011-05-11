Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab1EKPxX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:53:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:55892 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab1EKPxQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:53:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=ZAbWRebw6+zDNwprr/7ttp/eoplHUJlv139l9SSFaMHyeJ382n4I9sUK5HDy9lxOKt
         gmoJsBVrpN6H1VmoKWli/VMM8RI4zeGbjapCrLJ7+Zjs2hZahJuVrv7uact2GNHrHZWv
         lDHI/Id822kzA62VcOYHhJHUboCqJw2byno8Q=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=OXuR4iJFqUEa4pA=yO0aXaqEzyA@mail.gmail.com>
References: <1302960373-5309-1-git-send-email-abogani@kernel.org>
 <BANLkTi=y60Jt3-OMzbxQJzGkvzCzNJfJtA@mail.gmail.com> <BANLkTimfFEv+vZ8dYvhG0oj2Q4g+KnG4aA@mail.gmail.com>
 <BANLkTinDiGCaKPtS+ZpKf2swJpParJ4eew@mail.gmail.com> <BANLkTi=JXq+V783amiJB-qLX=7PaeH-83w@mail.gmail.com>
 <BANLkTi=OXuR4iJFqUEa4pA=yO0aXaqEzyA@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 11 May 2011 11:52:56 -0400
Message-ID: <BANLkTikFSN-DkkPNPtv1VigCg08YoB_q2g@mail.gmail.com>
Subject: Re: [PATCH 0/4] Speed up the symbols' resolution process V4
To: Alessio Igor Bogani <abogani@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 11:25, Alessio Igor Bogani wrote:
> 2011/5/11 Mike Frysinger:
>>> Sorry I don't think that is a good choice from a long term point of
>>> view. What do you think to add MODULE_SYMBOL_PREFIX to section names
>>> instead? In this way symbol and section names should always be
>>> different also on symbol prefixed archs (which are blackfin and
>>> h8300).
>>
>> that doesnt work.  it simply delays the problem to another set of
>> underscores.  so with that change, local_bh_enable/_local_bh_enable
>> work, but now send_remote_softirq/__send_remote_softirq fail:
>
> In my opinion it should work. if I use SYMBOL_PREFIX + two underscore
> for section name I should always obtain different names.
> So if SYMBOL_PREFIX is "_" section name will be "___", if
> SYMBOL_PREFIX is "__" section name will be "____" and so on.

i dont follow your logic.  SYMBOL_PREFIX is simply an underscore for
Blackfin, so you are not guaranteed unique names when you're only
prefixing more underscores.  the issue isnt with a symbol colliding
with itself, the issue is with a symbol colliding with another symbol
that has underscores added to its name.

if you export _foo/foo, you'll get an error with the current code:
/* EXPORT_SYMBOL(foo); */
        .section        ___ksymtab__foo,"a",@progbits
___ksymtab_foo:
/* EXPORT_SYMBOL(_foo); */
        .section        ___ksymtab___foo,"a",@progbits
___ksymtab__foo:

you can see how the first section and the last symbol collide

by putting the symbol prefix along the lines of the separator, you
delay it to __foo/foo:
/* EXPORT_SYMBOL(foo); */
        .section        ___ksymtab___foo,"a",@progbits
___ksymtab_foo:
/* EXPORT_SYMBOL(__foo); */
        .section        ___ksymtab_____foo,"a",@progbits
___ksymtab___foo:

the Blackfin toolchain puts the prefix before the ksymtab part while
you're putting it after, so there is always a possibility of collision
unless you pick a split char that doesnt include an underscore.

>>  CC      kernel/softirq.o
>> nano /tmp/cconhYy1.s: Assembler messages:
>> /tmp/cconhYy1.s:3664: Error: symbol `___ksymtab___send_remote_softirq'
>> is already defined
>> make[1]: *** [kernel/softirq.o] Error 1
>
> I'm a bit confused. I can build a kernel here:
> $ make ARCH=blackfin CROSS_COMPILE="bfin-uclinux-" defconfig

it's failing for me with current linux-next and the patch you posted
previously.  also, you dont need to set CROSS_COMPILE as that is the
default value for ARCH=blackfin ...

> Unfortunately I can't make skyeye emulator works to test the obtained
> kernel image.

skyeye is crap.  the latest upstream gdb/sim code can boot a kernel,
but if you aren't up-to-date with that, this binary i've been using
locally should work too:
http://blackfin.uclinux.org/uimages/bfin-elf-run

$ bfin-elf-run --env operating --model bf537 --sirev 2 ./vmlinux
earlyprintk=serial,uart0 console=ttyBF0
Linux version 2.6.39-rc7-ADI-2011R1-pre-00132-g9d91c9a
(vapier@vapier-m) (gcc version 4.3.5 (ADI-trunk/git-ce854ee) ) #16 Wed
May 11 11:55:28 EDT 2011
register early platform devices
bootconsole [early_shadow0] enabled
bootconsole [early_BFuart0] enabled
early printk enabled on early_BFuart0
Limiting kernel memory to 56MB due to anomaly 05000263
Board Memory: 64MB
Kernel Managed Memory: 64MB
Memory map:
  fixedcode = 0x00000400-0x00000490
  text      = 0x00001000-0x000f7f30
  rodata    = 0x000f7f30-0x001456ac
.............
-mike
