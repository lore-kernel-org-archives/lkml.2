Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030987Ab2CFUuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 15:50:46 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54159 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030946Ab2CFUum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 15:50:42 -0500
Subject: [PATCH 21/23] jbd2: Checksum commit blocks
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
Date: Tue, 06 Mar 2012 12:50:28 -0800
Message-ID: <20120306205028.1663.34780.stgit@elm3b70.beaverton.ibm.com>
In-Reply-To: <20120306204750.1663.96751.stgit@elm3b70.beaverton.ibm.com>
References: <20120306204750.1663.96751.stgit@elm3b70.beaverton.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030620-9360-0000-0000-0000044A208B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Calculate and verify the checksum of commit blocks.  In checksum v2, deprecate
most of the checksum v1 commit block checksum fields, since each block has its
own checksum.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---
 fs/jbd2/commit.c   |   19 +++++++++++++++++++
 fs/jbd2/recovery.c |   31 +++++++++++++++++++++++++++++++
 2 files changed, 50 insertions(+), 0 deletions(-)


diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 7acc318..fce7c53 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -86,6 +86,24 @@ nope:
 	__brelse(bh);
 }
 
+static void jbd2_commit_block_csum_set(journal_t *j,
+				       struct journal_head *descriptor)
+{
+	struct commit_header *h;
+	__u32 csum;
+
+	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
+		return;
+
+	h = (struct commit_header *)(jh2bh(descriptor)->b_data);
+	h->h_chksum_type = 0;
+	h->h_chksum_size = 0;
+	h->h_chksum[0] = 0;
+	csum = jbd2_chksum(j, j->j_csum_seed, jh2bh(descriptor)->b_data,
+			   j->j_blocksize);
+	h->h_chksum[0] = cpu_to_be32(csum);
+}
+
 /*
  * Done it all: now submit the commit record.  We should have
  * cleaned up our previous buffers by now, so if we are in abort
@@ -129,6 +147,7 @@ static int journal_submit_commit_record(journal_t *journal,
 		tmp->h_chksum_size 	= JBD2_CRC32_CHKSUM_SIZE;
 		tmp->h_chksum[0] 	= cpu_to_be32(crc32_sum);
 	}
+	jbd2_commit_block_csum_set(journal, descriptor);
 
 	JBUFFER_TRACE(descriptor, "submit commit block");
 	lock_buffer(bh);
diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 513006b..a757d8d 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -372,6 +372,24 @@ static int calc_chksums(journal_t *journal, struct buffer_head *bh,
 	return 0;
 }
 
+static int jbd2_commit_block_csum_verify(journal_t *j, void *buf)
+{
+	struct commit_header *h;
+	__u32 provided, calculated;
+
+	if (!JBD2_HAS_INCOMPAT_FEATURE(j, JBD2_FEATURE_INCOMPAT_CSUM_V2))
+		return 1;
+
+	h = buf;
+	provided = h->h_chksum[0];
+	h->h_chksum[0] = 0;
+	calculated = jbd2_chksum(j, j->j_csum_seed, buf, j->j_blocksize);
+	h->h_chksum[0] = provided;
+
+	provided = be32_to_cpu(provided);
+	return provided == calculated;
+}
+
 static int do_one_pass(journal_t *journal,
 			struct recovery_info *info, enum passtype pass)
 {
@@ -682,6 +700,19 @@ static int do_one_pass(journal_t *journal,
 				}
 				crc32_sum = ~0;
 			}
+			if (pass == PASS_SCAN &&
+			    !jbd2_commit_block_csum_verify(journal,
+							   bh->b_data)) {
+				info->end_transaction = next_commit_ID;
+
+				if (!JBD2_HAS_INCOMPAT_FEATURE(journal,
+				     JBD2_FEATURE_INCOMPAT_ASYNC_COMMIT)) {
+					journal->j_failed_commit =
+						next_commit_ID;
+					brelse(bh);
+					break;
+				}
+			}
 			brelse(bh);
 			next_commit_ID++;
 			continue;

