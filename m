Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab1ICXfs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 19:35:48 -0400
Received: from nm8.bullet.mail.ird.yahoo.com ([77.238.189.23]:38502 "HELO
	nm8.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752311Ab1ICXfo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 19:35:44 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 437410.65775.bm@omp1021.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=2IOgZckHPQpm97NYAUGpEgF/mUsUpy2LDmTLdbrm08StYYHy3Ps+c0dJy4EjX99uQKkq+gewBq7EzOPhnFkhPePkWUbQu3GNTMINKFNFZibOcKKiXRQOpCW2IYcbPAaWfwE4+YC0qimfuee3a9BzyZdM/hhOi845rMJIo68UIpE=;
X-YMail-OSG: 97lcakMVM1nHp0gO600utlZBz6taAEbmXH3Ax_ViaEIXnl4
 iLWZ9QJue3BNx5LgzuEo3gSb0RUfrWijCSuUYhKn2OsM28xH8TbsBHlQmFEO
 27H0cYsNMNnjBquma6wlYbD4Pdw.vkjMIQDspj47RwGe9CDMQKYWpyo07n64
 TwX1baafnVkJLSa1TsmbaymmgCzoKxcst5V.K3JGxiUXX_1Ribk8yGrdyhpC
 gihsSi0MDvrzJiKI0A95R4XjC4DLpdxCPrKD1urnjHi1stBBhd.I.85dtPUu
 W5dTAKEnFnGF34UAhfwHI4FGTiRd.m7suDgz1SHKkGmmQFbnXlW_Sjlkhb3s
 82Sm4SphnEIWjp9WMkWU3oI7jFEfWABnK3J10rsOwBfA8TkqHvIAQrI1MhkX
 KJhcuTPBc1Ld3Pt2QWefI
X-Mailer: YahooMailClassic/14.0.5 YahooMailWebService/0.8.113.315625
Message-ID: <1315092941.97677.YahooMailClassic@web29519.mail.ird.yahoo.com>
Date: Sun, 4 Sep 2011 00:35:41 +0100 (BST)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
To: Pavel Ivanov <paivanof@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <CAG1a4rs+-K8GukJE-C8a7JCbw6usdY1FLxjXM7AWYEUpADXusQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Sat, 3/9/11, Pavel Ivanov <paivanof@gmail.com> wrote:

> Hin-Tak,
> 
> "if(sbi->s_backup_vhdr)" as you suggested didn't help.
> But I made
> another change. I made fs/hfsplus/super.c to look like this
> near the
> line 529:
> 
> out_free_vhdr:
>     printk(KERN_ERR "hfs: sbi->s_vhdr =
> %p, sbi->s_backup_vhdr = %p\n",
> sbi->s_vhdr, sbi->s_backup_vhdr);
>     kfree(sbi->s_vhdr);
>     kfree(sbi->s_backup_vhdr);
> 
> And here's what I see after connecting an iPod:
> 
> [   92.549197] hfs: filesystem size too
> large blksz_shift=14,
> total_blocks=486494
> [   92.635714] hfs: sbi->s_vhdr =
> ffff88013703a690, sbi->s_backup_vhdr
> = ffff88013703e268
> [   92.730543]
> =============================================================================
> [   92.828425] BUG kmalloc-4096: Invalid
> object pointer 0xffff88013703a690
> ...
> [   93.213890]
> =============================================================================
> [   93.311834] BUG kmalloc-4096: Invalid
> object pointer 0xffff88013703e268
> ...
> [   93.868618] hfs: filesystem size too
> large blksz_shift=14,
> total_blocks=486494
> [   93.955327] hfs: sbi->s_vhdr =
> ffff8801343c37d8, sbi->s_backup_vhdr
> = ffff8801343c5120
> [   94.050133]
> =============================================================================
> [   94.148026] BUG kmalloc-4096: Invalid
> object pointer 0xffff8801343c37d8
> ...
> [   94.533895]
> =============================================================================
> [   94.631746] BUG kmalloc-4096: Invalid
> object pointer 0xffff8801343c5120
> 
> 
> So these 2 pointers are exactly what causing the trouble.

This is interesting... so it would appear that hfsplus_read_wrapper() isn't working correctly, but enough of correct information to pass checks. I just re-read your e-mail and your device has a logical block size of 4096 bytes, whereas most of the hfsplus code uses a block size of 512... you will need to look into hfsplus_submit_bio(), which is in the same file wrapper.c. 

It is going to be difficult to do anything without the actual device and 8GB is too large to be send around. Assuming it is mostly music/media and there isn't too much stuff which is too confident/private, can I ask you to send me say, the first few MB of the disk? I guess something like this:

dd if=/dev/sdb  of=diskfile-sdb  ibs=4096 count=512
dd if=/dev/sdb1 of=diskfile-sdb1 ibs=4096 count=512
dd if=/dev/sdb2 of=diskfile-sdb2 ibs=4096 count=512

should copy the first 2MB of the disk itself and the two partitions. I hope that's enough to have a look around. Be really careful with dd though - it could do some serious damage if not carefully used.  

> On Sat, Sep 3, 2011 at 2:57 AM, Hin-Tak Leung <hintak_leung@yahoo.co.uk>
> wrote:
> > --- On Sat, 3/9/11, Pavel Ivanov <paivanof@gmail.com>
> wrote:
> >
> >> On Fri, Sep 2, 2011 at 11:59 PM,
> >> Hin-Tak Leung <hintak_leung@yahoo.co.uk>
> >> wrote:
> >> >> With kernel 3.1.0-rc4 any attempt to
> connect iPod
> >> to USB
> >> >> leads to
> >> >> kernel oops. I'd say that stacktrace of
> the oops
> >> is pretty
> >> >> much random
> >> >> and not related to HFS. But I was able to
> get
> >> useful info
> >> >> from it when
> >> >> I recompiled with CONFIG_SLUB_DEBUG_ON=y.
> In this
> >> case I
> >> >> don't get
> >> >> oops but the following instead:
> >> >
> >> > There are a few hfsplus related changes to
> do
> >> protection against invalid data like this, but may
> be there
> >> are more. It would be useful to have the output
> from your
> >> > objdump -l -d hfsplus.ko | grep  -A 1000
> >> '<hfsplus_fill_super>'
> >> > (the -l gives line numbers against the kernel
> tree, so
> >> would be useful if you run this against the ko
> there...)
> >>
> >> Output of this command is in attachment.
> >
> > That's interesting. You said "hfs: filesystem size too
> large." always appears twice (with kernel 3.1-rc4) before it
> oops. And in your 2.6.38.11 kernel, you had "hfs: unable to
> find HFS+ superblock" twice.
> >
> > The oops place is the "kfree(sbi->s_backup_vhdr)"
> in line 529 in fs/hfsplus/super.c:
> >
> > 527: out_free_vhdr:
> > 528:        kfree(sbi->s_vhdr);
> > 529:        kfree(sbi->s_backup_vhdr);
> >
> > It would appear the s_backup_vhdr is somehow garbage
> but that was not caught in the 3.1-rc4 version of
> hfsplus_read_wrapper() ; it was caught by the 2.6.38.11
> version of hfsplus_read_wrapper(). hfsplus_read_wrapper()
> was changed in the 2.6.39/3.0 time frame by this:
> >
> >    commit 52399b171dfaea02b6944cd6feba49b624147126
> >    Author: Christoph Hellwig <hch@tuxera.com>
> >    Date:   Tue Nov 23 14:37:47 2010 +0100
> >
> >        hfsplus: use raw bio access for the volume
> headers
> >
> > That's code I don't quite understand (I worked on the
> hfsplus journal code recently, supposedly mentoring for that
> GSoC project).
> >
> > If you are happy enough to do a bit of experimenting,
> can you try putting a
> > "if(sbi->s_backup_vhdr)" before line 529?
> >
> > Also it is curious why it wasn't caught in wrapper.c
> arond 229 to 236 ending with:
> > "if (sbi->s_backup_vhdr->signature !=
> sbi->s_vhdr->signature)"
> >
> >
> > The file system too large comes from line 402 in
> super.c:
> > -----------------------
> >        err =
> generic_check_addressable(sbi->alloc_blksz_shift,
> >                                    
>    sbi->total_blocks);
> >        if (err) {
> >                printk(KERN_ERR "hfs:
> filesystem size too large.\n");
> >                goto out_free_vhdr;
> >
> > -----------------------
> > So it might be interesting to see what is too large...
> try changing that to:
> >
> > printk(KERN_ERR "hfs: filesystem size too large
> blksz_shift=%d, total_blocks=%d\n",
> sbi->alloc_blksz_shift, sbi->total_blocks);
> >
> > ?
> >
> > It is a 42GB image - if it were smaller I would
> suggest dd'ing that and upload it somewhere to check...
> >
> >
> >
> >
> 
