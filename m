Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932330Ab2HOUCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:02:32 -0400
Received: from mail.windriver.com ([147.11.1.11]:37348 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab2HOTwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 148/165] random: Use arch-specific RNG to initialize the entropy store
Date: Wed, 15 Aug 2012 15:48:12 -0400
Message-ID: <1345060109-9187-149-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 3e88bdff1c65145f7ba297ccec69c774afe4c785 upstream.

If there is an architecture-specific random number generator (such as
RDRAND for Intel architectures), use it to initialize /dev/random's
entropy stores.  Even in the worst case, if RDRAND is something like
AES(NSA_KEY, counter++), it won't hurt, and it will definitely help
against any other adversaries.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Link: http://lkml.kernel.org/r/1324589281-31931-1-git-send-email-tytso@mit.edu
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/random.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index ed86cae..4874f55 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -958,6 +958,7 @@ EXPORT_SYMBOL(get_random_bytes);
  */
 static void init_std_data(struct entropy_store *r)
 {
+	int i;
 	ktime_t now;
 	unsigned long flags;
 
@@ -967,6 +968,11 @@ static void init_std_data(struct entropy_store *r)
 
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
1.7.12.rc2

