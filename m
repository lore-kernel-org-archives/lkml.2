Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208Ab2BEWaD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:30:03 -0500
Received: from 1wt.eu ([62.212.114.60]:62179 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004Ab2BEWaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:30:00 -0500
Message-Id: <20120205220951.971826887@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:48 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <guaneryu@gmail.com>,
        "Theodore Tso" <tytso@mit.edu>,
        =?ISO-8859-15?q?Moritz=20M=FChlenhoff?= <jmm@inutil.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 59/91] jbd/jbd2: validate sb->s_first in journal_get_superblock()
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 8762202dd0d6e46854f786bdb6fb3780a1625efe upstream.

I hit a J_ASSERT(blocknr != 0) failure in cleanup_journal_tail() when
mounting a fsfuzzed ext3 image. It turns out that the corrupted ext3
image has s_first = 0 in journal superblock, and the 0 is passed to
journal->j_head in journal_reset(), then to blocknr in
cleanup_journal_tail(), in the end the J_ASSERT failed.

So validate s_first after reading journal superblock from disk in
journal_get_superblock() to ensure s_first is valid.

The following script could reproduce it:

fstype=ext3
blocksize=1024
img=$fstype.img
offset=0
found=0
magic="c0 3b 39 98"

dd if=/dev/zero of=$img bs=1M count=8
mkfs -t $fstype -b $blocksize -F $img
filesize=`stat -c %s $img`
while [ $offset -lt $filesize ]
do
        if od -j $offset -N 4 -t x1 $img | grep -i "$magic";then
                echo "Found journal: $offset"
                found=1
                break
        fi
        offset=`echo "$offset+$blocksize" | bc`
done

if [ $found -ne 1 ];then
        echo "Magic \"$magic\" not found"
        exit 1
fi

dd if=/dev/zero of=$img seek=$(($offset+23)) conv=notrunc bs=1 count=1

mkdir -p ./mnt
mount -o loop $img ./mnt

Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Moritz Mühlenhoff <jmm@inutil.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/jbd/journal.c  |    8 ++++++++
 fs/jbd2/journal.c |    8 ++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

Index: longterm-2.6.27/fs/jbd/journal.c
===================================================================
--- longterm-2.6.27.orig/fs/jbd/journal.c	2012-02-05 22:34:33.178914769 +0100
+++ longterm-2.6.27/fs/jbd/journal.c	2012-02-05 22:34:43.263916090 +0100
@@ -1030,6 +1030,14 @@
 		goto out;
 	}
 
+	if (be32_to_cpu(sb->s_first) == 0 ||
+	    be32_to_cpu(sb->s_first) >= journal->j_maxlen) {
+		printk(KERN_WARNING
+			"JBD: Invalid start block of journal: %u\n",
+			be32_to_cpu(sb->s_first));
+		goto out;
+	}
+
 	return 0;
 
 out:
Index: longterm-2.6.27/fs/jbd2/journal.c
===================================================================
--- longterm-2.6.27.orig/fs/jbd2/journal.c	2012-02-05 22:34:33.183914664 +0100
+++ longterm-2.6.27/fs/jbd2/journal.c	2012-02-05 22:34:43.272916600 +0100
@@ -1369,6 +1369,14 @@
 		goto out;
 	}
 
+	if (be32_to_cpu(sb->s_first) == 0 ||
+	    be32_to_cpu(sb->s_first) >= journal->j_maxlen) {
+		printk(KERN_WARNING
+			"JBD2: Invalid start block of journal: %u\n",
+			be32_to_cpu(sb->s_first));
+		goto out;
+	}
+
 	return 0;
 
 out:


