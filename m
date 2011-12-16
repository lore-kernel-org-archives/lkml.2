Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030203Ab1LPUAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:00:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45314 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964823Ab1LPTwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 14:52:15 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 11:42:11 2011
Message-Id: <20111216194211.190237974@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 11:40:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jan Kara <jack@suse.cz>,
        Eryu Guan <guaneryu@gmail.com>, "Theodore Tso" <tytso@mit.edu>,
        =?UTF-8?q?Moritz=20M=C3=BChlenhoff?= <jmm@inutil.org>
Subject: [27/45] jbd/jbd2: validate sb->s_first in journal_get_superblock()
In-Reply-To: <20111216194603.GA15028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eryu Guan <guaneryu@gmail.com>

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
 2 files changed, 16 insertions(+)

--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1131,6 +1131,14 @@ static int journal_get_superblock(journa
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
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1251,6 +1251,14 @@ static int journal_get_superblock(journa
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


