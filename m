Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab1DFWoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 18:44:12 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50183 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab1DFWoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 18:44:10 -0400
Date: Wed, 6 Apr 2011 15:44:10 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] Add inode checksum support to ext4
Message-ID: <20110406224410.GB24354@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I spent last week analyzing a client's corrupted ext3 image to see if I could
determine what had gone wrong and caused the filesystem to blow apart.  As best
as I could tell, a data block got miswritten into a different sector ... which
happened to be an indirect block.  Some time later the indirect block, which
now pointed at one of the inode tables (among other things that shouldn't ever
become file data) was loaded as part of a file write, which caused that inode
table to be blown to smithereens.  Just for fun I tried reading from one of
these busted-inode files and ... failed to encounter any errors.  Somehow, they
didn't find it funny that ext3 would read block numbers from a table with the
contents "ibm.com" with a straight face.  Fortunately there were backups. :)

The client at this point asked if ext4 would do a better job of sanity
checking, which got me to wonder why ext4 checksums block groups but not
inodes.  It's on Ted's todo list, but apparently nobody wrote any patch, so I
did.  The following two patches are a first draft of adding inode checksum
support to both the kernel driver and to the various e2fsprogs.

If you have an existing ext* fs with 256-byte inodes, you ought to be able to
"tune2fs -O inode_csum /dev/XXX", fsck /dev/XXX, and mount the filesystem with
checksumming enabled.  It seems to work for me (i386/x86-64), but I'm looking
for comments for improvement and perhaps some more testing (ppc64 is still
building).  This inode checksum feature is not enabled by default.

--D
