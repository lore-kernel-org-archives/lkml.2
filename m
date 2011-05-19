Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933968Ab1ESVYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:24:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38447 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932665Ab1ESVX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:23:59 -0400
Date: Thu, 19 May 2011 23:23:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/setup change for v2.6.40
Message-ID: <20110519212352.GA25131@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-setup-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-setup-for-linus


out-of-topic modifications in x86-setup-for-linus:
--------------------------------------------------
drivers/firmware/edd.c             # 0c61227: x86, setup: Fix EDD3.0 data verif

 Thanks,

	Ingo

------------------>
Gleb Natapov (1):
      x86, setup: Fix EDD3.0 data verification.


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
