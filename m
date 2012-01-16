Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab2APTrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 14:47:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50217 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029Ab2APTrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 14:47:45 -0500
Date: Mon, 16 Jan 2012 11:47:32 -0800
Message-Id: <201201161947.q0GJlWqF012943@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/rdrand additional for v3.3-rc1
Cc: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 16 Jan 2012 11:47:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit 53999bf34d55981328f8ba9def558d3e104d6e36:

  error: implicit declaration of function 'module_flags_taint' (2012-01-15 16:21:07 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/rdrand

The head of this tree is 2dac8e54f988ab58525505d7ef982493374433c3.

This is simply Ted's patch to use RDRAND for initializing the random
number pools, when available, with an additional patch to make it run
the exact number of times needed; as written it would run twice the
necessary number of iterations on 64-bit platforms.

H. Peter Anvin (1):
      random: Adjust the number of loops when initializing

Theodore Ts'o (1):
      random: Use arch-specific RNG to initialize the entropy store

 drivers/char/random.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 732215b..54ca8b2 100644
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
+	for (i = r->poolinfo->POOLBYTES; i > 0; i -= sizeof flags) {
+		if (!arch_get_random_long(&flags))
+			break;
+		mix_pool_bytes(r, &flags, sizeof(flags));
+	}
 	mix_pool_bytes(r, utsname(), sizeof(*(utsname())));
 }
 
