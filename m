Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792Ab2GGRL3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 13:11:29 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42478 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab2GGRL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 13:11:28 -0400
Date: Sat, 7 Jul 2012 10:11:22 -0700
From: Kees Cook <keescook@chromium.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        ewust@umich.edu, zakir@umich.edu, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, stable@vger.kernel.org
Subject: [PATCH] random: only use gathered bytes from arch_get_random_long
Message-ID: <20120707171122.GD28340@outflux.net>
References: <1341614704-24965-1-git-send-email-tytso@mit.edu>
 <1341614704-24965-8-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341614704-24965-8-git-send-email-tytso@mit.edu>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While very unlikely, it is possible for arch_get_random_long() to fail
in the middle of the loop in xfer_secondary_pool(), which would mean
that the loop could stop with only part of u.hwrand populated, leading
to mix_pool_bytes() injecting uninitialized or already injected bytes
instead of fresh bytes. This changes the mix_pool_bytes() call to only
inject the successfully gathered bytes.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
---
Should be applied on top of the tytso/random dev branch.
---
 drivers/char/random.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index aaf4629..6fc3128 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -879,7 +879,7 @@ static void xfer_secondary_pool(struct entropy_store *r, size_t nbytes)
 		if (arch_get_random_long(&u.hwrand[i]))
 			break;
 	if (i)
-		mix_pool_bytes(r, &u.hwrand, sizeof(u.hwrand), 0);
+		mix_pool_bytes(r, &u.hwrand, i * sizeof(u.hwrand[0]), 0);
 }
 
 /*
-- 
1.7.0.4

-- 
Kees Cook
Chrome OS Security
