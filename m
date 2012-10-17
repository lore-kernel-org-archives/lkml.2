Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab2JQMuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 08:50:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50031 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755981Ab2JQMuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 08:50:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jaegeuk Kim <jaegeuk.kim@gmail.com>
Subject: Re: [PATCH 11/16] f2fs: add inode operations for special inodes
Date: Wed, 17 Oct 2012 12:50:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Dave Chinner <david@fromorbit.com>, Jaegeuk Kim <jaegeuk.kim@samsung.com>,
        "'Vyacheslav Dubeyko'" <slava@dubeyko.com>, viro@zeniv.linux.org.uk,
        "'Theodore Ts'o'" <tytso@mit.edu>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com> <20121016204412.GF2864@dastard> <1350426621.1958.119.camel@kjgkr>
In-Reply-To: <1350426621.1958.119.camel@kjgkr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201210171250.12130.arnd@arndb.de>
X-Provags-ID: V02:K0:ZMUANUnUr5peuh3rpqRfbLgMSb/qwQIhoOWKvtcb1jt
 baYSEiMo6HAhftBnu/cJaqd8S6AqUE1Ow4XrtH2BVuuM0/bvKa
 /ToqcezXtD7QXhrq4sm/MH73QmfGhpdiv413Rl5BIrkQD7Gf98
 TJorDM/2nY/p1X1KyqTTaQf+fNdlRhJ9ODZt+2Kw8231As97hJ
 kVMV1Dxt/zmSqybGz2/d5/aH7nFWBwVBAqwOV8sle8mqU9mAbQ
 1sBePm0Cn9Hy219T97ZoutEfyhU3O8aEe2yiNxHiaAVsj43Xvs
 76UoIRKnVWMZfJFgm4975M83m5sLbpvdQHS/BuiddW9N1WA3I1
 ZrgDakT5Yx+7eKdF0AXY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2012, Jaegeuk Kim wrote:
> > IIRC, fs2fs uses 4k inodes, so IMO per-inode xattr tress with
> > internal storage before spilling to an external block is probably
> > the best approach to take...
> 
> Yes, indeed this is the best approach to f2fs's xattr.
> Apart from giving fs hints, it is worth enough to optimize later.

I've thought a bit more about how this could be represented efficiently
in 4KB nodes. This would require a significant change of the way you
represent inodes, but can improve a number of things at the same time.

The idea is to replace the fixed area in the inode that contains block
pointers with an extensible TLV (type/length/value) list that can contain
multiple variable-length fields, like this. All TLVs together with the
fixed-length inode data can fill a 4KB block.

The obvious types would be:

* Direct file contents if the file is less than a block
* List of block pointers, as before, minimum 1, maximum until the end
  of the block
* List of indirect pointers, now also a variable length, similar to the
  list of block pointers
* List of double-indirect block pointers
* direct xattr: zero-terminated attribute name followed by contents
* indirect xattr: zero-terminated attribute name followed by up to
  16 block pointers to store a maximum of 64KB sized xattrs

This could be extended later to cover additional types, e.g. a list
of erase block pointers, triple-indirect blocks or extents.

As a variation of this, it would also be nice to turn around the order
in which the pointers are walked, to optimize for space and for growing
files, rather than for reading the beginning of a file. With this, you
can represent a 9 KB file using a list of two block pointers, and 1KB
of direct data, all in the inode. When the user adds another byte, you
only need to rewrite the inode. Similarly, a 5 MB file would have a
single indirect node (covering block pointers for 4 MB), plus 256
separate block pointers (covering the last megabyte), and a 5 GB file
can be represented using 1 double-indirect node and 256 indirect nodes,
and each of them can still be followed by direct "tail" data and
extended attributes.

	Arnd
