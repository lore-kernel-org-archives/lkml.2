Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab2HOUZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:25:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:36772 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566Ab2HOTuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:50:22 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Jouni Malinen <jouni@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 057/165] cfg80211: Fix validation of AKM suites
Date: Wed, 15 Aug 2012 15:46:41 -0400
Message-ID: <1345060109-9187-58-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jouni Malinen <jouni@qca.qualcomm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 1b9ca0272ffae212e726380f66777b30a56ed7a5 upstream.

Incorrect variable was used in validating the akm_suites array from
NL80211_ATTR_AKM_SUITES. In addition, there was no explicit
validation of the array length (we only have room for
NL80211_MAX_NR_AKM_SUITES).

This can result in a buffer write overflow for stack variables with
arbitrary data from user space. The nl80211 commands using the affected
functionality require GENL_ADMIN_PERM, so this is only exposed to admin
users.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/wireless/nl80211.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 56bc9b9..fde82a8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3537,9 +3537,12 @@ static int nl80211_crypto_settings(struct genl_info *info,
 		if (len % sizeof(u32))
 			return -EINVAL;
 
+		if (settings->n_akm_suites > NL80211_MAX_NR_AKM_SUITES)
+			return -EINVAL;
+
 		memcpy(settings->akm_suites, data, len);
 
-		for (i = 0; i < settings->n_ciphers_pairwise; i++)
+		for (i = 0; i < settings->n_akm_suites; i++)
 			if (!nl80211_valid_akm_suite(settings->akm_suites[i]))
 				return -EINVAL;
 	}
-- 
1.7.12.rc2

