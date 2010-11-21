Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab0KUCuM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 21:50:12 -0500
Received: from mail.perches.com ([173.55.12.10]:1675 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756139Ab0KUCkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 21:40:06 -0500
From: Joe Perches <joe@perches.com>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        PJ Waskiewicz <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>
Cc: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 26/62] ixgbe: Use static const
Date: Sat, 20 Nov 2010 18:38:27 -0800
Message-Id: <cea5119e8784f6d18368a17b606200f2e5615187.1290305776.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1290305773.git.joe@perches.com>
References: <cover.1290305773.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using static const generally increases object text and decreases data size.
It also generally decreases overall object size.

   text	   data	    bss	    dec	    hex	filename
  31444	     56	   6552	  38052	   94a4	drivers/net/ixgbe/ixgbe_ethtool.o.new
  30905	    560	   6552	  38017	   9481	drivers/net/ixgbe/ixgbe_ethtool.o.old

Make single file scope definition for register_test_patterns.
Rename _test to register_test_patterns.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ixgbe/ixgbe_ethtool.c |   22 +++++++++++++---------
 1 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ixgbe/ixgbe_ethtool.c b/drivers/net/ixgbe/ixgbe_ethtool.c
index f9b5839..5b31775 100644
--- a/drivers/net/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ixgbe/ixgbe_ethtool.c
@@ -1157,7 +1157,7 @@ struct ixgbe_reg_test {
 #define TABLE64_TEST_HI	6
 
 /* default 82599 register test */
-static struct ixgbe_reg_test reg_test_82599[] = {
+static const struct ixgbe_reg_test reg_test_82599[] = {
 	{ IXGBE_FCRTL_82599(0), 1, PATTERN_TEST, 0x8007FFF0, 0x8007FFF0 },
 	{ IXGBE_FCRTH_82599(0), 1, PATTERN_TEST, 0x8007FFF0, 0x8007FFF0 },
 	{ IXGBE_PFCTOP, 1, PATTERN_TEST, 0xFFFFFFFF, 0xFFFFFFFF },
@@ -1181,7 +1181,7 @@ static struct ixgbe_reg_test reg_test_82599[] = {
 };
 
 /* default 82598 register test */
-static struct ixgbe_reg_test reg_test_82598[] = {
+static const struct ixgbe_reg_test reg_test_82598[] = {
 	{ IXGBE_FCRTL(0), 1, PATTERN_TEST, 0x8007FFF0, 0x8007FFF0 },
 	{ IXGBE_FCRTH(0), 1, PATTERN_TEST, 0x8007FFF0, 0x8007FFF0 },
 	{ IXGBE_PFCTOP, 1, PATTERN_TEST, 0xFFFFFFFF, 0xFFFFFFFF },
@@ -1208,18 +1208,22 @@ static struct ixgbe_reg_test reg_test_82598[] = {
 	{ 0, 0, 0, 0 }
 };
 
+static const u32 register_test_patterns[] = {
+	0x5A5A5A5A, 0xA5A5A5A5, 0x00000000, 0xFFFFFFFF
+};
+
 #define REG_PATTERN_TEST(R, M, W)                                             \
 {                                                                             \
 	u32 pat, val, before;                                                 \
-	const u32 _test[] = {0x5A5A5A5A, 0xA5A5A5A5, 0x00000000, 0xFFFFFFFF}; \
-	for (pat = 0; pat < ARRAY_SIZE(_test); pat++) {                       \
+	for (pat = 0; pat < ARRAY_SIZE(register_test_patterns); pat++) {      \
 		before = readl(adapter->hw.hw_addr + R);                      \
-		writel((_test[pat] & W), (adapter->hw.hw_addr + R));          \
+		writel((register_test_patterns[pat] & W),                     \
+		       (adapter->hw.hw_addr + R));                            \
 		val = readl(adapter->hw.hw_addr + R);                         \
-		if (val != (_test[pat] & W & M)) {                            \
-			e_err(drv, "pattern test reg %04X failed: got "   \
+		if (val != (register_test_patterns[pat] & W & M)) {           \
+			e_err(drv, "pattern test reg %04X failed: got "       \
 			      "0x%08X expected 0x%08X\n",		      \
-			      R, val, (_test[pat] & W & M));                \
+			      R, val, (register_test_patterns[pat] & W & M)); \
 			*data = R;                                            \
 			writel(before, adapter->hw.hw_addr + R);              \
 			return 1;                                             \
@@ -1246,7 +1250,7 @@ static struct ixgbe_reg_test reg_test_82598[] = {
 
 static int ixgbe_reg_test(struct ixgbe_adapter *adapter, u64 *data)
 {
-	struct ixgbe_reg_test *test;
+	const struct ixgbe_reg_test *test;
 	u32 value, before, after;
 	u32 i, toggle;
 
-- 
1.7.3.2.245.g03276.dirty

