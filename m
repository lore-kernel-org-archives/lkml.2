Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203Ab2HOTtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:49:00 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62724 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756120Ab2HOTs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:48:57 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Xi Wang <xi.wang@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 009/165] ext4: fix undefined behavior in ext4_fill_flex_info()
Date: Wed, 15 Aug 2012 15:45:53 -0400
Message-ID: <1345060109-9187-10-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xi Wang <xi.wang@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d50f2ab6f050311dbf7b8f5501b25f0bf64a439b upstream.

Commit 503358ae01b70ce6909d19dd01287093f6b6271c ("ext4: avoid divide by
zero when trying to mount a corrupted file system") fixes CVE-2009-4307
by performing a sanity check on s_log_groups_per_flex, since it can be
set to a bogus value by an attacker.

	sbi->s_log_groups_per_flex = sbi->s_es->s_log_groups_per_flex;
	groups_per_flex = 1 << sbi->s_log_groups_per_flex;

	if (groups_per_flex < 2) { ... }

This patch fixes two potential issues in the previous commit.

1) The sanity check might only work on architectures like PowerPC.
On x86, 5 bits are used for the shifting amount.  That means, given a
large s_log_groups_per_flex value like 36, groups_per_flex = 1 << 36
is essentially 1 << 4 = 16, rather than 0.  This will bypass the check,
leaving s_log_groups_per_flex and groups_per_flex inconsistent.

2) The sanity check relies on undefined behavior, i.e., oversized shift.
A standard-confirming C compiler could rewrite the check in unexpected
ways.  Consider the following equivalent form, assuming groups_per_flex
is unsigned for simplicity.

	groups_per_flex = 1 << sbi->s_log_groups_per_flex;
	if (groups_per_flex == 0 || groups_per_flex == 1) {

We compile the code snippet using Clang 3.0 and GCC 4.6.  Clang will
completely optimize away the check groups_per_flex == 0, leaving the
patched code as vulnerable as the original.  GCC keeps the check, but
there is no guarantee that future versions will do the same.

Signed-off-by: Xi Wang <xi.wang@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/super.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index cd35e34..6928d5a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1796,17 +1796,16 @@ static int ext4_fill_flex_info(struct super_block *sb)
 	struct ext4_group_desc *gdp = NULL;
 	ext4_group_t flex_group_count;
 	ext4_group_t flex_group;
-	int groups_per_flex = 0;
+	unsigned int groups_per_flex = 0;
 	size_t size;
 	int i;
 
 	sbi->s_log_groups_per_flex = sbi->s_es->s_log_groups_per_flex;
-	groups_per_flex = 1 << sbi->s_log_groups_per_flex;
-
-	if (groups_per_flex < 2) {
+	if (sbi->s_log_groups_per_flex < 1 || sbi->s_log_groups_per_flex > 31) {
 		sbi->s_log_groups_per_flex = 0;
 		return 1;
 	}
+	groups_per_flex = 1 << sbi->s_log_groups_per_flex;
 
 	/* We allocate both existing and potentially added groups */
 	flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
-- 
1.7.12.rc2

