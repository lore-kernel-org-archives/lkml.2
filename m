Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab1LFU76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 15:59:58 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57255 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753874Ab1LFU74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 15:59:56 -0500
Date: Tue, 6 Dec 2011 12:59:40 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Andreas Dilger <adilger@dilger.ca>
Cc: "Ted Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Sunil Mushran <sunil.mushran@oracle.com>,
        Martin K Petersen <martin.petersen@oracle.com>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Mingming Cao <cmm@us.ibm.com>,
        Joel Becker <jlbec@evilplan.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        Coly Li <colyli@gmail.com>
Subject: Re: [PATCH 07/22] ext4: Create bitmap checksum helper functions
Message-ID: <20111206205940.GH7137@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com> <20111128232703.19194.55084.stgit@elm3c44.beaverton.ibm.com> <20111205163329.GC32031@thunk.org> <3DBC0B29-0498-47B7-9E79-98FF4BFDC56E@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3DBC0B29-0498-47B7-9E79-98FF4BFDC56E@dilger.ca>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
x-cbid: 11120620-8974-0000-0000-000003FB3EDC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 10:19:12AM -0700, Andreas Dilger wrote:
> On 2011-12-05, at 9:33, Ted Ts'o <tytso@mit.edu> wrote:
> > Note: it's strictly speaking not necessary to mix in the group and
> > s_csum_seed here.  It's useful for the inode table blocks (ITB's)
> > because the checksum for a particular ITB is located *in* the ITB
> > itself.  So if an ITB gets written to the wrong place, and in
> > particular, on top of another ITB, we want to be able to know which
> > cloned copy was written to the wrong place on disk.
> > 
> > But in the case of the inode and block allocation bitmaps, the
> > checksums are stored in the block group descriptors; so if the bitmap
> > is written to the wrong place (and on top of another bitmap), the
> > checksum will fail to verify, independent of whether we've mixed in
> > the fs-specific csum seed and the group number.
> > 
> > So I'd suggest dropping this, which will shave a few cycles off of the
> > checksum calculation, and it will also simplify the code since we
> > won't need this particular function.
> 
> I wouldn't mind keeping the group just to be consistent with all of the other
> checksums that are used in the filesystem, which are largely inside the
> structure being checked.
> 
> The s_uuid is definitely useful to keep as the seed because the block and
> inode bitmaps are not initialized at mke2fs time with uninit_bg, and it is
> possible to read a stale bitmap from disk that might belong to an earlier
> instance of the filesystem in case of a failed or misplaced write of the
> correct bitmap. 

Hmm... let's say you have bitmap B before mkfs and bitmap B' after mkfs + some
file writes.  B' is lost during write.  It would be bad if B != B' and
crc32c(B) == crc32c(B'), in which case you'd use the wrong bitmap.

I suppose having the fsuuid + groupnum would probably help to make the inputs
to crc32c() more distinct, which would be useful since iirc P(collision)
decreases as the Hamming distance increases.  I'm running a simulation to check
that claim.

--D

> That isn't important for e2fsck, since it doesn't really use the bitmaps, but
> it is important for the kernel not to use bad bitmaps and corrupt the
> filesystem further. 
> 
> Cheers, Andreas--
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

