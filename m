Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908Ab1DHXNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 19:13:18 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:27600 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab1DHXNR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 19:13:17 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=H95gfW32JB/XYJSBuOTvJ8IIviFcsPdfxXHbM7LS6jM= c=1 sm=1
 a=8Sp9JVQx4AYA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10
 a=c23vf5CSMVc0QQz9B4a6RA==:17 a=ySfo2T4IAAAA:8 a=k9Vn1F81AzEP5dj0SCMA:9
 a=CjuIK1q_8ugA:10 a=hYDL2pDLfHIAtbbt:21 a=dSurigt1u4SLcxeg:21
 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH 2/2] e2fsprogs: Add support for toggling, verifying, and fixing inode checksums
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger.kernel@dilger.ca>
In-Reply-To: <20110408192530.GE24354@tux1.beaverton.ibm.com>
Date: Fri, 8 Apr 2011 17:13:13 -0600
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <001599E2-27BF-48AF-BC4E-DE8B674FF46B@dilger.ca>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com> <20110406224733.GU32706@tux1.beaverton.ibm.com> <A63BE624-6F88-432C-A029-C7A0DF6C2894@dilger.ca> <20110408192530.GE24354@tux1.beaverton.ibm.com>
To: djwong@us.ibm.com
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-08, at 1:25 PM, Darrick J. Wong wrote:
> On Fri, Apr 08, 2011 at 03:14:04AM -0600, Andreas Dilger wrote:
>> Do you have an e2fsck testcase for this code, to show that it detects/fixes
>> inodes with data corruption, and to fix the checksums after the ROCOMPAT flag
>> is set the first time?
> 
> Not yet; I suspected that some clarification of exactly that issue was needed.
> It looks to me that in general the checksum will be zero for the "flag is
> enabled but no checksum has yet been provided" case, and nonzero in the "inode
> is corrupt" case.  So if e2fsck sees zero it'd first ask to correct the
> checksum, and if it sees nonzero it'll first ask to clear the inode.  If the
> user answers no to the first question, e2fsck can then propose the second
> option.

Seems reasonable, though it is possible that the inode checksums can also become invalid due to changing the filesystem UUID.  This should probably be handled by tune2fs when the UUID is changed, with an extra prompt if INODE_CSUM is enabled to indicate that the conversion may take a long time.

Looking at the checksum algorithm you used, the inode checksum does not change if the inode is relocated due to resize (i.e. it uses the inode number and not the underlying block number).  This is convenient, and does not impact the correctness in any way - if the wrong block is read/written then the inode number used in the checksum will not match either.

>> With the "ibadness" patch in our tree, the bad checksum should be a
>> significant factor in marking the inode as garbage, but possibly not enough
>> to have it thrown out if there are no other errors in the inode.
> 
> Or e2fsck could use that heuristic; which tree is the ibadness patch in?
> Google shows a patch from 2008, but no recent discussion.

There is a relatively up-to-date version at
http://git.whamcloud.com/?p=tools/e2fsprogs.git;a=blob_plain;f=patches/e2fsprogs-ibadness-counter.patch;hb=8dd11ed9bdf0914d57d78d0c387bd21f747c1d29

> Something along the lines of: if the inode is not very bad, ask first to fix
> the checksum and second to clear the inode; if the inode seems bad, ask first
> to clear it and second to fix the checksum.

Yes, that is what I was thinking.  The real question is why the checksum would be bad in the case of no other "badness"?  If it is due to the UUID, that should be handled when the UUID is changed, and if it is due to a misplaced write (i.e. bad inode number) then it will help us to distinguish between the "real" inode and the misplaced "bad" inode.

>>> @@ -890,6 +890,11 @@ static struct e2fsck_problem problem_table[] = {
>>> 	     "(size %Is, lblk %r)\n"),
>>> 	  PROMPT_CLEAR, PR_PREEN_OK },
>>> 
>>> +	/* Fast symlink has EXTENTS_FL set */
>>> +	{ PR_1_INODE_CSUM_INVALID,
>>> +	  N_("inode %i checksum invalid.  "),
>> 
>> The comment for each problem should exactly mirror the text that is printed.
>> In this case, you haven't used the abbreviations "@i" and "@n", which would
>> normally make it much harder to search for this error string in the code, but
>> also simplifies the translation of the message.
> 
> Oops, comment blooper that was a thinko on my part.  What would the @n be for?

@i is "inode", @n is "invalid", per e2fsck/message.c.

Cheers, Andreas





