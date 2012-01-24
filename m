Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab2AXCoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:44:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50142 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756605Ab2AXCoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:44:19 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:24 2012
Message-Id: <20120124023924.579995762@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:33:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Xi Wang <xi.wang@gmail.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [007/129] ext4: fix undefined behavior in ext4_fill_flex_info()
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 2513
Lines: 67

From: Xi Wang <xi.wang@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/super.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2006,17 +2006,16 @@ static int ext4_fill_flex_info(struct su
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


