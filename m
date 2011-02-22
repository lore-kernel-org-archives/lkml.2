Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754656Ab1BVQXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 11:23:35 -0500
Received: from shawmail.shawcable.com ([64.59.128.220]:54787 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab1BVQXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 11:23:33 -0500
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Feb 2011 11:23:33 EST
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=l0hTUOwXBBZC3xuFbE1ochJnP84ph5EBJB8ZSEz2E7A= c=1 sm=1
 a=WKMNdXk8PrIA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=VnNF1IyMAAAA:8 a=gu6fZOg2AAAA:8
 a=eES8M28xnM7TtkwxsmkA:9 a=Ty9TcfQTbdpQp7fnLTsA:7
 a=jpSSE9gFxVIEUVvGb0XfFChDf3gA:4 a=CjuIK1q_8ugA:10
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
X-IronPort-AV: E=Sophos;i="4.62,207,1297062000"; 
   d="scan'208";a="405277224"
X-reinject: true
References: <20110222020022.GH32261@tux1.beaverton.ibm.com>
In-Reply-To: <20110222020022.GH32261@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (iPhone Mail 8C148a)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <180713DB-114C-454B-A91E-063AB0116251@dilger.ca>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Mingming Cao <mcao@us.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
X-Mailer: iPhone Mail (8C148a)
From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation problem
Date: Tue, 22 Feb 2011 09:13:49 -0700
To: "djwong@us.ibm.com" <djwong@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-21, at 19:00, "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> Last summer there was a long thread entitled "Wrong DIF guard tag on ext2
> write" (http://marc.info/?l=linux-scsi&m=127530531808556&w=2) that started a
> discussion about how to deal with the situation where one program tells the
> kernel to write a block to disk, the kernel computes the checksum of that data,
> and then a second program begins writing to that same block before the disk HBA
> can DMA the memory block, thereby causing the disk to complain about being sent
> invalid checksums.
> 
> I was able to write a
> trivial program to trigger the write problem, I'm pretty sure that this has not
> been fixed upstream.  (FYI, using O_DIRECT still seems fine.)

Can you please attach your reproducer? IIRC it needed mmap() to hit this problem?  Did you measure CPU usage during your testing?

> Below is a simple if naive solution: (ab)use the bounce buffering code to copy
> the memory page just prior to calculating the checksum, and send the copy and
> the checksum to the disk controller.  With this patch applied, the invalid
> guard tag messages go away.  An optimization would be to perform the copy only
> when memory contents change, but I wanted to ask peoples' opinions before
> continuing.  I don't imagine bounce buffering is particularly speedy, though I
> haven't noticed any corruption errors or weirdness yet.

I don't like adding a data copy in the IO path at all. We are just looking to enable T10 DIF for Lustre and this would definitely hurt performance significantly, even though it isn't needed there at all (since the server side has proper locking of the pages to prevent multiple writers to the same page).

> Anyway, I'm mostly wondering: what do people think of this as a starting point
> to fixing the DIF checksum problem?

I'd definitely prefer that the filesystem be in charge of deciding whether this is needed or not. If the use of the data copy can be constrained to only the minimum required cases (e.g. if fs checks for rewrite on page that is marked as Writeback and either copies or blocks until writeback is complete, as a mount option) that would be better. At that point we can compare on different hardware whether copying or blocking should be the default. 

Cheers, Andreas
