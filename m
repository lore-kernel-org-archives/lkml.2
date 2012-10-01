Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964903Ab2JAXUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:20:32 -0400
Received: from 1wt.eu ([62.212.114.60]:35393 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932959Ab2JAXBg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:01:36 -0400
Message-Id: <20121001225204.605622436@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, "Theodore Tso" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 165/180] random: Adjust the number of loops when initializing
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: H. Peter Anvin <hpa@linux.intel.com>

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/char/random.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index d67890f..5e106b1 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -975,7 +975,7 @@ static void init_std_data(struct entropy_store *r)
 
 	now = ktime_get_real();
 	mix_pool_bytes(r, &now, sizeof(now));
-	for (i = r->poolinfo->poolwords; i; i--) {
+	for (i = r->poolinfo->POOLBYTES; i > 0; i -= sizeof flags) {
 		if (!arch_get_random_long(&flags))
 			break;
 		mix_pool_bytes(r, &flags, sizeof(flags));
-- 
1.7.2.1.45.g54fbc



