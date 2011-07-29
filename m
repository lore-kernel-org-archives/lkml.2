Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab1G2Jss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 05:48:48 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:20272 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756088Ab1G2Jsq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 05:48:46 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=fp/YrIG6YJuYYWILSlVONgBms0XWtFqTjqHWlNKfnDg= c=1 sm=1
 a=S7acZvqNAhcA:10 a=BLceEmwcHowA:10 a=kj9zAlcOel0A:10 a=xqWC_Br6kY4A:10
 a=ofbJNMp31UCpb4tbsbNzvA==:17 a=BcX8RYgsAAAA:8 a=IXr_WNlcAAAA:8
 a=iqeqYhwfsfoXvnieMSsA:9 a=YSPxESpJc0i7945CPTUA:7 a=CjuIK1q_8ugA:10
 a=T5ZRoNnfl4MA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Subject: Re: [PATCH 0/2] Add inode checksum support to ext4
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Andreas Dilger <adilger.kernel@dilger.ca>
In-Reply-To: <20110728220735.GA27253@noexit.corp.google.com>
Date: Fri, 29 Jul 2011 03:48:45 -0600
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Andreas Dilger <aedilger@gmail.com>,
        Mingming Cao <cmm@us.ibm.com>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <0E795C1D-AD1E-4CC4-9426-2B58D98B14DC@dilger.ca>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com> <1302290868.4461.7.camel@mingming-laptop> <20110727082730.GG20655@tux1.beaverton.ibm.com> <EF1F2330-D8C4-427A-ABB9-D1E607D91A3D@gmail.com> <20110728165615.GI20655@tux1.beaverton.ibm.com> <20110728220735.GA27253@noexit.corp.google.com>
To: Joel Becker <jlbec@evilplan.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-28, at 4:07 PM, Joel Becker wrote:
> On Thu, Jul 28, 2011 at 09:56:15AM -0700, Darrick J. Wong wrote:
>>> the block. There of course is no reason to put an extent tail inside the
>>> inode itself.
>> 
>> Does anybody have any objection to using crc32c (which we can hardware
>> accelerate on new Intel boxen) over crc16?  I think it'll be pretty easy to use
> 
> 	We use ethernet crc32 in ocfs2.  btrfs uses crc32c.  Frankly, I
> could have used crc32c if I'd really thought about the hardware
> acceleration benefits.  I think it's a good idea for ext4.

The problem with crc32[c] is that if you don't have hardware acceleration
it is terribly slow.

>> some of the reserved space in the group descriptor to store checksums of the
>> block and inode bitmaps.  Adding tails to the extent tree blocks seems a bit
>> trickier than that, but not a big deal, though I guess I'll have to reshuffle
>> the extent tree to free up space at the end of the block.
>> 
>> I was also wondering what people think of adding checksums to directory files?
>> I think that it's possible to put a checksum in each directory block -- for
>> blocks containing a linear array of actual directory entries, we could zero out
>> the space past the end of the array and put a checksum at the very end of the
>> block.  For the dx_node/dx_root blocks, we could probably use the space
>> occupied by the last dx_entry to store the checksum.  Obviously, we'd have to
>> move whatever's at the end of the block elsewhere, but then, we have to do that
>> for the extent tree too.  Basically, the last 4 bytes become the checksum after
>> whatever's occupying the space is relocated. :)
> 
> 	ocfs2 adds trailer entries to every dirblock for the checksum.
> We also do our dirindex free list there.  Since ocfs2 dirblocks are ext3
> dirblocks, I bet you can rip off a lot of that code, including the
> feature compatibility stuff.  See ocfs2_fs.h.

Yes, it makes sense to just put a "fake" dirent at the end of the leaf block,
or similar.  I don't think it is necessary to modify existing directories or
extent blocks to add these structures in, if there is no room, but for new
blocks, or blocks with space it is enough.

>> It looks like there's sufficient unused space in ext4_xattr_header to add a
>> checksum.
>> 
>> Also -- should I create separate rocompat feature flags for each metadata
>> object that I add checksums to?  Or just have one flag that covers them all?
> 
> 	I really think you should checksum every metadata block.  A few
> things will take some effort to shoehorn it in, but it is worth it.
> 
> Joel
> 
> -- 
> 
> Life's Little Instruction Book #173
> 
> 	"Be kinder than necessary."
> 
> 			http://www.jlbec.org/
> 			jlbec@evilplan.org

