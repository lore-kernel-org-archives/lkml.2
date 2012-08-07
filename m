Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964867Ab2HGDxF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:53:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59635 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757290Ab2HGDiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:12 -0400
Message-Id: <20120807032757.992864060@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:08 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "H. Peter Anvin" <hpa@linux.intel.com>,
        "Theodore Tso" <tytso@mit.edu>
Subject: [ 13/70] random: Adjust the number of loops when initializing
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit 2dac8e54f988ab58525505d7ef982493374433c3 upstream.

When we are initializing using arch_get_random_long() we only need to
loop enough times to touch all the bytes in the buffer; using
poolwords for that does twice the number of operations necessary on a
64-bit machine, since in the random number generator code "word" means
32 bits.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Link: http://lkml.kernel.org/r/1324589281-31931-1-git-send-email-tytso@mit.edu
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 3079477..9a2156d 100644
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


