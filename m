Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab0FACke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 22:40:34 -0400
Received: from sh.osrg.net ([192.16.179.4]:55595 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab0FACkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 22:40:31 -0400
Date: Tue, 1 Jun 2010 11:40:15 +0900
To: James.Bottomley@suse.de
Cc: martin.petersen@oracle.com, christof.schmitt@de.ibm.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Wrong DIF guard tag on ext2 write
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <1275318102.2823.47.camel@mulgrave.site>
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
	<yq1iq64kv9f.fsf@sermon.lab.mkp.net>
	<1275318102.2823.47.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100601113947X.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 01 Jun 2010 11:40:16 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 May 2010 10:01:42 -0500
James Bottomley <James.Bottomley@suse.de> wrote:

> On Mon, 2010-05-31 at 10:20 -0400, Martin K. Petersen wrote:
> > >>>>> "Christof" == Christof Schmitt <christof.schmitt@de.ibm.com> writes:
> > 
> > Christof> Since the guard tags are created in Linux, it seems that the
> > Christof> data attached to the write request changes between the
> > Christof> generation in bio_integrity_generate and the call to
> > Christof> sd_prep_fn.
> > 
> > Yep, known bug.  Page writeback locking is messed up for buffer_head
> > users.  The extNfs folks volunteered to look into this a while back but
> > I don't think they have found the time yet.
> > 
> > 
> > Christof> Using ext3 or ext4 instead of ext2 does not show the problem.
> > 
> > Last I looked there were still code paths in ext3 and ext4 that
> > permitted pages to be changed during flight.  I guess you've just been
> > lucky.
> 
> Pages have always been modifiable in flight.  The OS guarantees they'll
> be rewritten, so the drivers can drop them if it detects the problem.
> This is identical to the iscsi checksum issue (iscsi adds a checksum
> because it doesn't trust TCP/IP and if the checksum is generated in
> software, there's time between generation and page transmission for the
> alteration to occur).  The solution in the iscsi case was not to
> complain if the page is still marked dirty.

In the iSCSI case, what we do is decreasing chance that pages in
flight could be modified (use sendmsg instead of sendpage) and praying.

If the initiator sends the wrong checksum, the target complains (and
starts the recovery process). The target can't know if the page is
marked dirty or not.
