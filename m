Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1IWWwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:52:30 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:33032 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab1IWWw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:52:29 -0400
Date: Fri, 23 Sep 2011 15:51:35 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Joel Becker <jlbec@evilplan.org>,
        Andreas Dilger <adilger@dilger.ca>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [RFC] jbd2 metadata checksumming
Message-ID: <20110923225135.GN12086@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
x-cbid: 11092322-3270-0000-0000-00000061DD8B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While I'm working on adding metadata checksumming to ext4, I figured that I
ought to look into the similar feature in jbd2.  At first I thought I'd simply
change the default crc algorithm to crc32c and update the field in the commit
block, but then it was suggested to me that I move that field into the journal
superblock so that during recovery we don't have to scan ahead through the
transaction to find the commit block so that we can learn the algorithm type.

Doing that seems to require a format change to the superblock to add that
field.  I think that adding the crc-type field to the superblock is a rocompat
change since we're not changing existing fields, just adding fields.  It looks
like the kernel and e2fsprogs code both reject a journal if they find unknown
rocompat bits set.  (Using a journal in ro mode is not useful.)

I decided to dig deeper to see what exactly the journal checksum covers.  It
appears to me that the superblock, revocation blocks, and commit blocks are not
covered by a checksum.  Revocation blocks ought to be checksummed because a
lost write involving the second sector of a suitably large revocation block
could result in the wrong blocks being skipped during recovery.  It seems like
it would be easy to extend the current journal_checksum feature to cover the
commit block, and adding a checksum to the superblock seems trivial.

Lastly, if I'm already making change, I might as well bake the journal UUID
into the checksum as well.  The transaction ID is already in each metadata
block by virtue of the common block header.

So to summarize, I propose:

1. Adding a JBD2_FEATURE_ROCOMPAT_CHECKSUM_V2 field, which provides:
2. A u8 field at offset 0x50 in the superblock which identifies the checksum
   algorithm that's in use;
3. A u32 field at offset 0x54 in the superblock to hold the superblock's
   checksum;
4. Changing the revocation block code to put a checksum in the 4 bytes
   following the revocation data, and to ensure those 4 bytes always exist;
5. Adding the journal UUID to each checksum computation;
6. Extend the commit checksum to cover the commit block itself, with the commit
   block checksum field zeroed during the computation, of course;
7. Changing the default algorithm to crc32c; and
8. Updating ext4 to enable both checksum fields at journal load time, if the
   user supplies the journal_checksum mount option.

Thoughts?

--D

