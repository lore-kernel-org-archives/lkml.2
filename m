Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab2JAXEZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:04:25 -0400
Received: from 1wt.eu ([62.212.114.60]:35696 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757856Ab2JAXEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:04:20 -0400
Message-Id: <20121001225204.563100940@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:41 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Theodore Tso" <tytso@mit.edu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 164/180] random: Use arch-specific RNG to initialize the entropy store
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/char/random.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index ac74029..d67890f 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -965,6 +965,7 @@ EXPORT_SYMBOL(get_random_bytes);
  */
 static void init_std_data(struct entropy_store *r)
 {
+	int i;
 	ktime_t now;
 	unsigned long flags;
 
@@ -974,6 +975,11 @@ static void init_std_data(struct entropy_store *r)
 
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
1.7.2.1.45.g54fbc



