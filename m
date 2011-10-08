Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab1JHH7C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 03:59:02 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58089 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab1JHH64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 03:58:56 -0400
Subject: [PATCH 23/28] jbd2: Grab a reference to the crc32c driver only when
	necessary
To: Andreas Dilger <adilger.kernel@dilger.ca>, Theodore Tso <tytso@mit.edu>,
        "Darrick J. Wong" <djwong@us.ibm.com>
From: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Sunil Mushran <sunil.mushran@oracle.com>,
        Martin K Petersen <martin.petersen@oracle.com>,
        Greg Freemyer <greg.freemyer@gmail.com>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Mingming Cao <cmm@us.ibm.com>,
        Joel Becker <jlbec@evilplan.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
Date: Sat, 08 Oct 2011 00:56:15 -0700
Message-ID: <20111008075615.20506.97385.stgit@elm3c44.beaverton.ibm.com>
In-Reply-To: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com>
References: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Obtain a reference to the crc32c driver only when the journal needs it for
checksum v2.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/jbd2/Kconfig      |    2 ++
 fs/jbd2/journal.c    |   22 ++++++++++++++++++++++
 include/linux/jbd2.h |   23 +++++++++++++++++++++++
 3 files changed, 47 insertions(+), 0 deletions(-)


diff --git a/fs/jbd2/Kconfig b/fs/jbd2/Kconfig
index f32f346..69a48c2 100644
--- a/fs/jbd2/Kconfig
+++ b/fs/jbd2/Kconfig
@@ -1,6 +1,8 @@
 config JBD2
 	tristate
 	select CRC32
+	select CRYPTO
+	select CRYPTO_CRC32C
 	help
 	  This is a generic journaling layer for block devices that support
 	  both 32-bit and 64-bit block numbers.  It is currently used by
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 8d8985e..5c76a8b 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1276,6 +1276,16 @@ static int journal_get_superblock(journal_t *journal)
 		goto out;
 	}
 
+	/* Load the checksum driver */
+	if (JBD2_HAS_INCOMPAT_FEATURE(journal, JBD2_FEATURE_INCOMPAT_CSUM_V2)) {
+		journal->j_chksum_driver = crypto_alloc_shash("crc32c", 0, 0);
+		if (IS_ERR(journal->j_chksum_driver)) {
+			err = PTR_ERR(journal->j_chksum_driver);
+			journal->j_chksum_driver = NULL;
+			goto out;
+		}
+	}
+
 	set_buffer_verified(bh);
 
 	return 0;
@@ -1432,6 +1442,8 @@ int jbd2_journal_destroy(journal_t *journal)
 		iput(journal->j_inode);
 	if (journal->j_revoke)
 		jbd2_journal_destroy_revoke(journal);
+	if (journal->j_chksum_driver)
+		crypto_free_shash(journal->j_chksum_driver);
 	kfree(journal->j_wbuf);
 	kfree(journal);
 
@@ -1548,6 +1560,16 @@ int jbd2_journal_set_features (journal_t *journal, unsigned long compat,
 		sb->s_checksum_type = JBD2_CRC32C_CHKSUM;
 		sb->s_feature_compat &=
 			~cpu_to_be32(JBD2_FEATURE_COMPAT_CHECKSUM);
+
+		/* Load the checksum driver */
+		if (journal->j_chksum_driver == NULL) {
+			journal->j_chksum_driver = crypto_alloc_shash("crc32c",
+								      0, 0);
+			if (IS_ERR(journal->j_chksum_driver)) {
+				journal->j_chksum_driver = NULL;
+				return 0;
+			}
+		}
 	}
 
 	/* If enabling v1 checksums, downgrade superblock */
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 69ca172..53df865 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -31,6 +31,7 @@
 #include <linux/mutex.h>
 #include <linux/timer.h>
 #include <linux/slab.h>
+#include <crypto/hash.h>
 #endif
 
 #define journal_oom_retry 1
@@ -1010,6 +1011,9 @@ struct journal_s
 
 	/* Precomputed UUID checksum */
 	__u32 j_uuid_crc;
+
+	/* Reference to checksum algorithm driver via cryptoapi */
+	struct crypto_shash *j_chksum_driver;
 };
 
 /*
@@ -1328,6 +1332,25 @@ static inline int jbd_space_needed(journal_t *journal)
 
 extern int jbd_blocks_per_page(struct inode *inode);
 
+static inline u32 jbd2_chksum(journal_t *journal, u32 crc,
+			      const void *address, unsigned int length)
+{
+	struct {
+		struct shash_desc shash;
+		char ctx[crypto_shash_descsize(journal->j_chksum_driver)];
+	} desc;
+	int err;
+
+	desc.shash.tfm = journal->j_chksum_driver;
+	desc.shash.flags = 0;
+	*(u32 *)desc.ctx = crc;
+
+	err = crypto_shash_update(&desc.shash, address, length);
+	BUG_ON(err);
+
+	return *(u32 *)desc.ctx;
+}
+
 #ifdef __KERNEL__
 
 #define buffer_trace_init(bh)	do {} while (0)

