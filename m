Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab1ICG51 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 02:57:27 -0400
Received: from nm12.bullet.mail.ird.yahoo.com ([77.238.189.65]:31450 "HELO
	nm12.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752843Ab1ICG5Z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 02:57:25 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 829096.37548.bm@omp1026.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=oy3rxyzvYmDP687VmZOmKp03Egy+m1JnOrTHctqGOcfmFyIfTioSBZ0vA+CGteTIpILloj4cr3jw5JtxLLWRxN9cSyirQmy5LOCPkW3h9DH6nGuGfAoyNqqQizOTvS0WAybZfKD8tIjuoMVxlSiJskePuHOf/iRtQsYP+WObc44=;
X-YMail-OSG: F1CWkjAVM1k0NEms_IGu9O_L6JbxVFzbGNnNdHNEploUpcL
 wabg2cIYlLRTQ6mVfn5yiY90gGCn8HOTVvP8.2yTcKxKnKuXtxuRmopGJlB8
 72pz_jDrBPx82iFBe74uNoyw8biX8xBomVIG3DDwIw8jmqtNm.can5z9ISG.
 NH7DO6wnhhT0QlGqmyHmFFRfn3xal_umRRLXhrIu24Na8_O4bAa1RcKdjKvh
 4yrlnLuH6kE5EDVNV8a1I8pyNnEp_j.ESA.XGaEt5SHNz7QK63fkqwz82V2p
 HTGfA67tJWqT.l_y7xmvphXYrmTbqFpdeW7xP1.mk97wcIdQbhJ7qyPAsQFr
 fA2MQAEx8RFkgmQ3Ye9S5R9AX8IBNZENlAwW2o3OkhSckyoQPlT8OLFuKgFo
 HmVhn5QMBL1gHlgt4M4u4
X-Mailer: YahooMailClassic/14.0.5 YahooMailWebService/0.8.113.315625
Message-ID: <1315033043.56167.YahooMailClassic@web29515.mail.ird.yahoo.com>
Date: Sat, 3 Sep 2011 07:57:23 +0100 (BST)
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
To: Pavel Ivanov <paivanof@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <CAG1a4rv34aM6_PU9qhdXV0KRoN=TFC03J1zrV07nPAkn0m5S1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Sat, 3/9/11, Pavel Ivanov <paivanof@gmail.com> wrote:

> On Fri, Sep 2, 2011 at 11:59 PM,
> Hin-Tak Leung <hintak_leung@yahoo.co.uk>
> wrote:
> >> With kernel 3.1.0-rc4 any attempt to connect iPod
> to USB
> >> leads to
> >> kernel oops. I'd say that stacktrace of the oops
> is pretty
> >> much random
> >> and not related to HFS. But I was able to get
> useful info
> >> from it when
> >> I recompiled with CONFIG_SLUB_DEBUG_ON=y. In this
> case I
> >> don't get
> >> oops but the following instead:
> >
> > There are a few hfsplus related changes to do
> protection against invalid data like this, but may be there
> are more. It would be useful to have the output from your
> > objdump -l -d hfsplus.ko | grep  -A 1000
> '<hfsplus_fill_super>'
> > (the -l gives line numbers against the kernel tree, so
> would be useful if you run this against the ko there...)
> 
> Output of this command is in attachment.

That's interesting. You said "hfs: filesystem size too large." always appears twice (with kernel 3.1-rc4) before it oops. And in your 2.6.38.11 kernel, you had "hfs: unable to find HFS+ superblock" twice.

The oops place is the "kfree(sbi->s_backup_vhdr)" in line 529 in fs/hfsplus/super.c:

527: out_free_vhdr:
528:        kfree(sbi->s_vhdr);
529:        kfree(sbi->s_backup_vhdr);

It would appear the s_backup_vhdr is somehow garbage but that was not caught in the 3.1-rc4 version of hfsplus_read_wrapper() ; it was caught by the 2.6.38.11 version of hfsplus_read_wrapper(). hfsplus_read_wrapper() was changed in the 2.6.39/3.0 time frame by this:

    commit 52399b171dfaea02b6944cd6feba49b624147126
    Author: Christoph Hellwig <hch@tuxera.com>
    Date:   Tue Nov 23 14:37:47 2010 +0100
    
        hfsplus: use raw bio access for the volume headers

That's code I don't quite understand (I worked on the hfsplus journal code recently, supposedly mentoring for that GSoC project).

If you are happy enough to do a bit of experimenting, can you try putting a 
"if(sbi->s_backup_vhdr)" before line 529?

Also it is curious why it wasn't caught in wrapper.c arond 229 to 236 ending with:
"if (sbi->s_backup_vhdr->signature != sbi->s_vhdr->signature)"


The file system too large comes from line 402 in super.c:
-----------------------
        err = generic_check_addressable(sbi->alloc_blksz_shift,
                                        sbi->total_blocks);
        if (err) {
                printk(KERN_ERR "hfs: filesystem size too large.\n");
                goto out_free_vhdr;

-----------------------
So it might be interesting to see what is too large... try changing that to:

printk(KERN_ERR "hfs: filesystem size too large blksz_shift=%d, total_blocks=%d\n", sbi->alloc_blksz_shift, sbi->total_blocks);

?

It is a 42GB image - if it were smaller I would suggest dd'ing that and upload it somewhere to check...



