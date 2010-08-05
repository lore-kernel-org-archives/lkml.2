Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475Ab0HEBcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 21:32:35 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6935 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab0HEBce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 21:32:34 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6064"; a="49780443"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org, linux-arm-msm@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: [PATCH] checkpatch: Fix extraneous EXPORT_SYMBOL* warnings
Date: Wed,  4 Aug 2010 18:32:01 -0700
Message-Id: <1280971922-18466-1-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are caused by checkpatch incorrectly parsing its
internal representation of a statement block for struct's
(or anything else that is a statement block encapsulated
in {}'s that also ends with a ';'). Fix this by properly
parsing a statement block.

An example:
	diff --git a/dummy.c b/dummy.c
	new file mode 100644
	index 0000000..3a932a5
	--- /dev/null
	+++ b/dummy.c
	@@ -0,0 +1,12 @@
	+struct dummy_type dummy = {
	+	.foo	= "baz",
	+};
	+EXPORT_SYMBOL_GPL(dummy);
	+
	+static int dummy_func(void)
	+{
	+	return -EDUMMYCODE;
	+}
	+EXPORT_SYMBOL_GPL(dummy_func);

	WARNING: EXPORT_SYMBOL(foo); should immediately \
		follow its function/variable
	#19: FILE: dummy.c:4:
	+EXPORT_SYMBOL_GPL(dummy);

The above warning is issued when it should not be.

Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
---
 scripts/checkpatch.pl |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index bd88f11..6affee2 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -552,6 +552,9 @@ sub ctx_statement_block {
 			$type = ($level != 0)? '{' : '';
 
 			if ($level == 0) {
+				if (substr($blk, $off + 1, 1) eq ';') {
+					$off++;
+				}
 				last;
 			}
 		}
-- 
1.7.2

