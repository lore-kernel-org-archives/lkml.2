Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760119Ab1D0WhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 18:37:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:46413 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347Ab1D0WhG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 18:37:06 -0400
Date: Wed, 27 Apr 2011 22:36:57 GMT
From: tip-bot for Gleb Natapov <gleb@redhat.com>
Message-ID: <tip-0c61227094b3ddaca2f847ee287c4a2e3762b5a2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, gleb@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20110426082132.GG2265@redhat.com>
References: <20110426082132.GG2265@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/setup] x86, setup: Fix EDD3.0 data verification.
Git-Commit-ID: 0c61227094b3ddaca2f847ee287c4a2e3762b5a2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 22:36:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0c61227094b3ddaca2f847ee287c4a2e3762b5a2
Gitweb:     http://git.kernel.org/tip/0c61227094b3ddaca2f847ee287c4a2e3762b5a2
Author:     Gleb Natapov <gleb@redhat.com>
AuthorDate: Tue, 26 Apr 2011 11:21:32 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 27 Apr 2011 14:16:12 -0700

x86, setup: Fix EDD3.0 data verification.

Check for nonzero path in edd_has_edd30() has no sense. First, it looks
at the wrong memory. Device path starts at offset 30 of the info->params
structure which is at offset 8 from the beginning of info structure,
but code looks at info + 4 instead. This was correct when code was
introduced, but around v2.6.4 three more fields were added to edd_info
structure (commit 66b61a5c in history.git). Second, even if it will check
correct memory it will always succeed since at offset 30 (params->key)
there will be non-zero values otherwise previous check would fail.

The patch replaces this bogus check with one that verifies checksum.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Link: http://lkml.kernel.org/r/20110426082132.GG2265@redhat.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/firmware/edd.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/edd.c b/drivers/firmware/edd.c
index 96c25d9..f1b7f65 100644
--- a/drivers/firmware/edd.c
+++ b/drivers/firmware/edd.c
@@ -531,8 +531,8 @@ static int
 edd_has_edd30(struct edd_device *edev)
 {
 	struct edd_info *info;
-	int i, nonzero_path = 0;
-	char c;
+	int i;
+	u8 csum = 0;
 
 	if (!edev)
 		return 0;
@@ -544,16 +544,16 @@ edd_has_edd30(struct edd_device *edev)
 		return 0;
 	}
 
-	for (i = 30; i <= 73; i++) {
-		c = *(((uint8_t *) info) + i + 4);
-		if (c) {
-			nonzero_path++;
-			break;
-		}
-	}
-	if (!nonzero_path) {
+
+	/* We support only T13 spec */
+	if (info->params.device_path_info_length != 44)
+		return 0;
+
+	for (i = 30; i < info->params.device_path_info_length + 30; i++)
+		csum += *(((u8 *)&info->params) + i);
+
+	if (csum)
 		return 0;
-	}
 
 	return 1;
 }
