Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab1ICUxP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 16:53:15 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46473 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab1ICUxM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 16:53:12 -0400
MIME-Version: 1.0
In-Reply-To: <1315033043.56167.YahooMailClassic@web29515.mail.ird.yahoo.com>
References: <CAG1a4rv34aM6_PU9qhdXV0KRoN=TFC03J1zrV07nPAkn0m5S1Q@mail.gmail.com>
 <1315033043.56167.YahooMailClassic@web29515.mail.ird.yahoo.com>
From: Pavel Ivanov <paivanof@gmail.com>
Date: Sat, 3 Sep 2011 16:52:40 -0400
Message-ID: <CAG1a4rs+-K8GukJE-C8a7JCbw6usdY1FLxjXM7AWYEUpADXusQ@mail.gmail.com>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hin-Tak,

"if(sbi->s_backup_vhdr)" as you suggested didn't help. But I made
another change. I made fs/hfsplus/super.c to look like this near the
line 529:

out_free_vhdr:
	printk(KERN_ERR "hfs: sbi->s_vhdr = %p, sbi->s_backup_vhdr = %p\n",
sbi->s_vhdr, sbi->s_backup_vhdr);
	kfree(sbi->s_vhdr);
	kfree(sbi->s_backup_vhdr);

And here's what I see after connecting an iPod:

[   92.549197] hfs: filesystem size too large blksz_shift=14,
total_blocks=486494
[   92.635714] hfs: sbi->s_vhdr = ffff88013703a690, sbi->s_backup_vhdr
= ffff88013703e268
[   92.730543] =============================================================================
[   92.828425] BUG kmalloc-4096: Invalid object pointer 0xffff88013703a690
...
[   93.213890] =============================================================================
[   93.311834] BUG kmalloc-4096: Invalid object pointer 0xffff88013703e268
...
[   93.868618] hfs: filesystem size too large blksz_shift=14,
total_blocks=486494
[   93.955327] hfs: sbi->s_vhdr = ffff8801343c37d8, sbi->s_backup_vhdr
= ffff8801343c5120
[   94.050133] =============================================================================
[   94.148026] BUG kmalloc-4096: Invalid object pointer 0xffff8801343c37d8
...
[   94.533895] =============================================================================
[   94.631746] BUG kmalloc-4096: Invalid object pointer 0xffff8801343c5120


So these 2 pointers are exactly what causing the trouble.


Pavel


On Sat, Sep 3, 2011 at 2:57 AM, Hin-Tak Leung <hintak_leung@yahoo.co.uk> wrote:
> --- On Sat, 3/9/11, Pavel Ivanov <paivanof@gmail.com> wrote:
>
>> On Fri, Sep 2, 2011 at 11:59 PM,
>> Hin-Tak Leung <hintak_leung@yahoo.co.uk>
>> wrote:
>> >> With kernel 3.1.0-rc4 any attempt to connect iPod
>> to USB
>> >> leads to
>> >> kernel oops. I'd say that stacktrace of the oops
>> is pretty
>> >> much random
>> >> and not related to HFS. But I was able to get
>> useful info
>> >> from it when
>> >> I recompiled with CONFIG_SLUB_DEBUG_ON=y. In this
>> case I
>> >> don't get
>> >> oops but the following instead:
>> >
>> > There are a few hfsplus related changes to do
>> protection against invalid data like this, but may be there
>> are more. It would be useful to have the output from your
>> > objdump -l -d hfsplus.ko | grep  -A 1000
>> '<hfsplus_fill_super>'
>> > (the -l gives line numbers against the kernel tree, so
>> would be useful if you run this against the ko there...)
>>
>> Output of this command is in attachment.
>
> That's interesting. You said "hfs: filesystem size too large." always appears twice (with kernel 3.1-rc4) before it oops. And in your 2.6.38.11 kernel, you had "hfs: unable to find HFS+ superblock" twice.
>
> The oops place is the "kfree(sbi->s_backup_vhdr)" in line 529 in fs/hfsplus/super.c:
>
> 527: out_free_vhdr:
> 528:        kfree(sbi->s_vhdr);
> 529:        kfree(sbi->s_backup_vhdr);
>
> It would appear the s_backup_vhdr is somehow garbage but that was not caught in the 3.1-rc4 version of hfsplus_read_wrapper() ; it was caught by the 2.6.38.11 version of hfsplus_read_wrapper(). hfsplus_read_wrapper() was changed in the 2.6.39/3.0 time frame by this:
>
>    commit 52399b171dfaea02b6944cd6feba49b624147126
>    Author: Christoph Hellwig <hch@tuxera.com>
>    Date:   Tue Nov 23 14:37:47 2010 +0100
>
>        hfsplus: use raw bio access for the volume headers
>
> That's code I don't quite understand (I worked on the hfsplus journal code recently, supposedly mentoring for that GSoC project).
>
> If you are happy enough to do a bit of experimenting, can you try putting a
> "if(sbi->s_backup_vhdr)" before line 529?
>
> Also it is curious why it wasn't caught in wrapper.c arond 229 to 236 ending with:
> "if (sbi->s_backup_vhdr->signature != sbi->s_vhdr->signature)"
>
>
> The file system too large comes from line 402 in super.c:
> -----------------------
>        err = generic_check_addressable(sbi->alloc_blksz_shift,
>                                        sbi->total_blocks);
>        if (err) {
>                printk(KERN_ERR "hfs: filesystem size too large.\n");
>                goto out_free_vhdr;
>
> -----------------------
> So it might be interesting to see what is too large... try changing that to:
>
> printk(KERN_ERR "hfs: filesystem size too large blksz_shift=%d, total_blocks=%d\n", sbi->alloc_blksz_shift, sbi->total_blocks);
>
> ?
>
> It is a 42GB image - if it were smaller I would suggest dd'ing that and upload it somewhere to check...
>
>
>
>
