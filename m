Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab3ABLDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 06:03:15 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:52498 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab3ABLDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 06:03:13 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=YO+FcVZrxpdWV6Mo6AkY2Rtp7tuV51ZJEd1ZQZEmJbs= c=1 sm=1
 a=0Z2zpp6RY3MA:10 a=TPbdJ-YLJ1kA:10 a=FGLzUi7B6sIA:10 a=BLceEmwcHowA:10
 a=kj9zAlcOel0A:10 a=eeMGdU6VVFt2UVJcxx6VzA==:17 a=XjXHVkDAlsmo5O86-cYA:9
 a=CjuIK1q_8ugA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
From: Daniel Phillips <lkml@phunq.net>
To: Shentino <shentino@gmail.com>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tux3@phunq.net
Subject: Re: Tux3 report: New news for the new year
Date: Wed, 02 Jan 2013 03:03:13 -0800
Message-ID: <8397253.yJIEVV2VgF@mars>
Organization: tux3.org
User-Agent: KMail/4.9.3 (Linux/3.2.0-35-generic-pae; KDE/4.9.3; i686; ; )
In-Reply-To: <CAGDaZ_pDCyMs8BA5XaM19kEcm1X=LwawSsWLit=kqftxpyV_Yw@mail.gmail.com>
References: <2597526.usDRg4h3X1@mars> <18617468.vkbTvjxc0P@mars> <CAGDaZ_pDCyMs8BA5XaM19kEcm1X=LwawSsWLit=kqftxpyV_Yw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 01, 2013 10:58:35 PM Shentino wrote:
> From what I can tell on the design, tux3 is "fsync satiating" with a
> single disk write.  It writes the data to the final location, updates
> the log, and at that point the data is considered committed and it can
> let userspace go on its merry way and take care of rolling up the
> changes later.

Yes, correct. I think we currently sync a small file create+write with seven 
blocks and a file rewrite with four blocks, including the commit block and only 
one long seek. We haven't benchmarked that yet, but it sounds fast. There are 
two synchronous waits in the backend, but the frontend only waits on the 
commit block completion in the task doing the sync while other concurrent 
filesystem operations just keep going.

> If I understand btrfs correctly though it has to block
> until the cow logic percolates all the way up to the superblock.

A careful reading of the Btrfs design doc left me confused about that. Perhaps 
Btrfs devs could clarify?

> One other thing that interests me is this "page forking" that allows
> userspace to write to a page that's already busy being written to
> disk.  From what I heard it bypasses a stall caused by userspace I/O
> hitting a locked page.

Page forking is an amazing thing and should really head into core, after being 
thoroughly proved out of course.

> Finally, atime handling.  I personally dislike the forced default of
> "relatime" for mount options and anything that can let atime updates
> happen without being a bottleneck is a plus for me.

Atime is an odious invention indeed from a developer's perspective, but 
apparently well loved by some users and has real applications. Knowing which 
videos you watched recently apparently being one of them. We have a pretty 
good plan for it that is actually just a small development item, the main 
feature of which is avoiding polluting the inode table btree, which would 
cause a lot of churn and aggravate allocate-on-write issues that are already 
difficult, plus be horribly unfriendly to flash. Instead, we churn a dedicated 
btree array (actually a regular file) where the write-on-reads are densely 
concentrated. It somehow feels good to quarantine this craziness at least.

Regards,

Daniel

