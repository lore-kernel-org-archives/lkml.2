Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab1C3NvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:51:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910Ab1C3Nu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:50:59 -0400
Date: Wed, 30 Mar 2011 15:50:47 +0200 (CEST)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-27-109.brq.redhat.com
To: Arnd Bergmann <arnd@arndb.de>
cc: Kyungmin Park <kmpark@infradead.org>,
        OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v6] fat: Batched discard support for fat
In-Reply-To: <201103301522.18836.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.1103301538580.3418@dhcp-27-109.brq.redhat.com>
References: <20110328103431.GA22323@july> <201103301522.18836.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011, Arnd Bergmann wrote:

> On Monday 28 March 2011, Kyungmin Park wrote:
> > So you will go through (blocks, bytes...) 0 -> 20
> > 
> >   OOOO==O===OO===OOOOO==O===O===OOOOOOO===
> >   ^                   ^
> >   0                   20
> > 
> > So, you will call discard on extents:
> > 
> > 0-3
> > You'll skip 6 because is smaller than minlen
> > 10-11
> > 15-19
> > 
> > instead of 
> > 
> > 0-3
> > 10-11
> > 15-19
> > 30-36
> 
> Sorry for joining the discussion late, but shouldn't you also pass
> the alignment of the discards?
> 
> FAT is typically used on cheap media that have very limited support
> for garbage-collection, such as eMMC or SD cards.
> 
> On most SDHC cards, you only ever want to issue discard on full erase
> blocks (allocation units per spec), typically sized 4 MB.

I was not aware of the fact that SD cards (etc..) does have garbage
collection of some sort, or that they even have support discard, since I
thought that we have only TRIM,UNAMP/WRITE_SAME comands for SATA or SCSI
drives.

Or is there some sort of kernel mechanism doing garbage collection such
is this for the cheap media ?

> 
> If you just pass the minimum length, the file system could end up
> erasing a 4 MB section that spans two half erase blocks, or it
> could span a few clusters of the following erase block, both of
> which is not desirable from a performance point of view.

Does those cards export such information correctly ?

> 
> On other media, you have the same problem inside an erase block:
> These might be able to discard parts of an erase block efficiently,
> but normally not less than a flash page (typically 8 to 32 KB).

Well I have tested several SSD's and thinly provisioned devices, but I
have not seen any strange behaviour, other than it was terribly
unefficient to do so. See my results here:

http://people.redhat.com/lczerner/discard/test_discard.html 

the fact is that I have not tried discard size smaller than 4K, since
this is the most usual block size for the filesystem.

> 
> Again, you don't want to discard partial pages in this case, and
> that is much more important than discarding a large number of pages
> because it would result in an immediate copy-on-write operation.
> 
> Further, when you erase some pages inside of an erase block, you
> probably should not span multiple erase blocks but instead issue
> separate requests for each set of pages in one erase block.

Does it mean that we should not issue bigger discards that erase block ?
That does not sound good given my test results. Or maybe I misunderstood
your point ?

> 
> 	Arnd
> 
> 	Arnd
> 

Thanks!
-Lukas
