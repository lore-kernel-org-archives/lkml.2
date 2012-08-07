Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab2HGDyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 23:54:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59631 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757284Ab2HGDiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 23:38:11 -0400
Message-Id: <20120807032757.853527625@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 07 Aug 2012 04:28:07 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Theodore Tso <tytso@mit.edu>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 12/70] random: Use arch-specific RNG to initialize the entropy store
In-Reply-To: <20120807032755.803571133@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/random.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 85da874..3079477 100644
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
 


