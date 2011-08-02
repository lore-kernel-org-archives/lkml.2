Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab1HBWFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 18:05:13 -0400
Received: from vms173019pub.verizon.net ([206.46.173.19]:34910 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390Ab1HBWFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 18:05:09 -0400
Date: Tue, 02 Aug 2011 18:05:00 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-acpi@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Huang Ying <ying.huang@intel.com>
Subject: Re: linux-next: Tree for July 20 (acpi/apei/ghes)
In-reply-to: <20110720093829.aae2ec63.rdunlap@xenotime.net>
Message-id: <alpine.LFD.2.02.1108021803530.25237@x980>
References: <20110720180041.5774ca335e6697c17374dca5@canb.auug.org.au>
 <20110720093633.ca9cf794.rdunlap@xenotime.net>
 <20110720093829.aae2ec63.rdunlap@xenotime.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: MULTIPART/MIXED; BOUNDARY="8323328-1257865506-1312322700=:25237"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1257865506-1312322700=:25237
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

From: Len Brown <len.brown@intel.com>
Subject: [PATCH] APEI GHES: 32-bit buildfix

drivers/acpi/apei/ghes.c:542: warning: integer overflow in expression
drivers/acpi/apei/ghes.c:619: warning: integer overflow in expression

ghes.c:(.text+0x46289): undefined reference to `__udivdi3'
  in function ghes_estatus_cache_add().

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/apei/ghes.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index e92c47c..0784f99 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -65,7 +65,7 @@
 
 #define GHES_ESTATUS_CACHES_SIZE	4
 
-#define GHES_ESTATUS_IN_CACHE_MAX_NSEC	(10 * NSEC_PER_SEC)
+#define GHES_ESTATUS_IN_CACHE_MAX_NSEC	10000000000ULL
 /* Prevent too many caches are allocated because of RCU */
 #define GHES_ESTATUS_CACHE_ALLOCED_MAX	(GHES_ESTATUS_CACHES_SIZE * 3 / 2)
 
@@ -622,7 +622,8 @@ static void ghes_estatus_cache_add(
 			break;
 		}
 		count = atomic_read(&cache->count);
-		period = duration / (count + 1);
+		period = duration;
+		do_div(period, (count + 1));
 		if (period > max_period) {
 			max_period = period;
 			slot = i;
-- 
1.7.6.396.ge0613


--8323328-1257865506-1312322700=:25237--
