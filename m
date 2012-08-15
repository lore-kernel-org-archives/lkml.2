Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab2HOUB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:01:26 -0400
Received: from mail1.windriver.com ([147.11.146.13]:63144 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab2HOTwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:52:43 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 149/165] random: Adjust the number of loops when initializing
Date: Wed, 15 Aug 2012 15:48:13 -0400
Message-ID: <1345060109-9187-150-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@linux.intel.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 2dac8e54f988ab58525505d7ef982493374433c3 upstream.

When we are initializing using arch_get_random_long() we only need to
loop enough times to touch all the bytes in the buffer; using
poolwords for that does twice the number of operations necessary on a
64-bit machine, since in the random number generator code "word" means
32 bits.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Link: http://lkml.kernel.org/r/1324589281-31931-1-git-send-email-tytso@mit.edu
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/random.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 4874f55..fce764d 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -968,7 +968,7 @@ static void init_std_data(struct entropy_store *r)
 
 	now = ktime_get_real();
 	mix_pool_bytes(r, &now, sizeof(now));
-	for (i = r->poolinfo->poolwords; i; i--) {
+	for (i = r->poolinfo->POOLBYTES; i > 0; i -= sizeof flags) {
 		if (!arch_get_random_long(&flags))
 			break;
 		mix_pool_bytes(r, &flags, sizeof(flags));
-- 
1.7.12.rc2

