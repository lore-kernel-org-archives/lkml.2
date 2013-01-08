Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab3AHXif (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:38:35 -0500
Received: from mail.windriver.com ([147.11.1.11]:63698 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897Ab3AHXib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:38:31 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Eryu Guan <guaneryu@gmail.com>, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 52/77] jbd/jbd2: validate sb->s_first in journal_get_superblock()
Date: Tue, 8 Jan 2013 18:35:31 -0500
Message-ID: <1357688156-25387-53-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eryu Guan <guaneryu@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/jbd/journal.c  | 8 ++++++++
 fs/jbd2/journal.c | 8 ++++++++
 2 files changed, 16 insertions(+)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index 45905ff..70713d5 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -1070,6 +1070,14 @@ static int journal_get_superblock(journal_t *journal)
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
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index c03d4dc..7f16fea 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1186,6 +1186,14 @@ static int journal_get_superblock(journal_t *journal)
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
-- 
1.7.12.1

