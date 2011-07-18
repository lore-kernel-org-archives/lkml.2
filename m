Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab1GRIYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 04:24:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:9124 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab1GRIYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 04:24:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,221,1309762800"; 
   d="scan'208";a="28353540"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 2/2] lib: call native hex_to_bin() inside _kstrtoull()
Date: Mon, 18 Jul 2011 11:23:24 +0300
Message-Id: <5e634c6aaeea13b4a1a541fad0b776180ccfd80b.1310977380.git.andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <e01fb9d779703004bf2f217ec7a2c3e7220610b9.1310977380.git.andriy.shevchenko@linux.intel.com>
References: <e01fb9d779703004bf2f217ec7a2c3e7220610b9.1310977380.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <e01fb9d779703004bf2f217ec7a2c3e7220610b9.1310977380.git.andriy.shevchenko@linux.intel.com>
References: <e01fb9d779703004bf2f217ec7a2c3e7220610b9.1310977380.git.andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
---
 lib/kstrtox.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/lib/kstrtox.c b/lib/kstrtox.c
index 5099755..a26d287 100644
--- a/lib/kstrtox.c
+++ b/lib/kstrtox.c
@@ -39,25 +39,18 @@ static int _kstrtoull(const char *s, unsigned int base, unsigned long long *res)
 	acc = 0;
 	ok = 0;
 	while (*s) {
-		unsigned int val;
+		int val;
 
-		if ('0' <= *s && *s <= '9')
-			val = *s - '0';
-		else if ('a' <= TOLOWER(*s) && TOLOWER(*s) <= 'f')
-			val = TOLOWER(*s) - 'a' + 10;
-		else if (*s == '\n' && *(s + 1) == '\0')
+		if (unlikely(*s == '\n' && *(s + 1) == '\0'))
 			break;
-		else
-			return -EINVAL;
 
-		if (val >= base)
+		val = hex_to_bin(*s++);
+		if (val >= base || val < 0)
 			return -EINVAL;
 		if (acc > div_u64(ULLONG_MAX - val, base))
 			return -ERANGE;
 		acc = acc * base + val;
 		ok = 1;
-
-		s++;
 	}
 	if (!ok)
 		return -EINVAL;
-- 
1.7.5.4

