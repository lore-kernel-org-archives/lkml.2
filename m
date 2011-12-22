Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab1LVV2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 16:28:07 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:40331 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270Ab1LVV2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 16:28:05 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] random: use arch-specific RNG to initialize the entropy store
Date: Thu, 22 Dec 2011 16:28:01 -0500
Message-Id: <1324589281-31931-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.7.8.11.gefc1f.dirty
In-Reply-To: <20111222210522.GG5041@thunk.org>
References: <20111222210522.GG5041@thunk.org>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is an architecture-specific random number generator (such as
RDRAND for Intel architectures), use it to initialize /dev/random's
entropy stores.  Even in the worst case, if RDRAND is something like
AES(NSA_KEY, counter++), it won't hurt, and it will definitely help
against any other adversaries.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 drivers/char/random.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 6035ab8..f10780a 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -961,6 +961,7 @@ EXPORT_SYMBOL(get_random_bytes);
  */
 static void init_std_data(struct entropy_store *r)
 {
+	int i;
 	ktime_t now;
 	unsigned long flags;
 
@@ -970,6 +971,11 @@ static void init_std_data(struct entropy_store *r)
 
 	now = ktime_get_real();
 	mix_pool_bytes(r, &now, sizeof(now));
+	for (i = r->poolinfo->poolwords; i; i--) {
+		if (!arch_get_random_long(&flags))
+			break;
+		mix_pool_bytes(r, &flags, sizeof(flags));
+	}
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
 }
 
-- 
1.7.8.11.gefc1f.dirty

