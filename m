Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750878Ab2I3KP6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 06:15:58 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:3902 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750716Ab2I3KP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 06:15:57 -0400
Message-ID: <1349000155.1553.27.camel@x61.thuisdomein>
Subject: [PATCH] regmap: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 30 Sep 2012 12:15:55 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 30 Sep 2012 10:15:56.0044 (UTC) FILETIME=[94460CC0:01CD9EF4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building regmap.o triggers this GCC warning:
    drivers/base/regmap/regmap.c: In function ‘regmap_raw_read’:
    drivers/base/regmap/regmap.c:1172:6: warning: ‘ret’ may be used uninitialized in this function [-Wmaybe-uninitialized]

It seems 'ret' should always be set when this function returns. See, the
else-branch can leave 'ret' uninitialized only if 'val_count' is zero.
But if 'val_count' is zero regmap_volatile_range() will return true.
That implies that 'ret' will be set in the if-branch. ('val_count' could
be zero if 'val_len' is, for example, zero. That would be useless input,
however.)

Anyhow, initializing 'ret' to -EINVAL silences GCC and is harmless.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
I noticed this warning while building v3.6-rc7 on current Fedora 17,
using Fedora's default config.

 drivers/base/regmap/regmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index c241ae2..025f41c 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1169,12 +1169,12 @@ int regmap_raw_read(struct regmap *map, unsigned int reg, void *val,
 	size_t val_bytes = map->format.val_bytes;
 	size_t val_count = val_len / val_bytes;
 	unsigned int v;
-	int ret, i;
+	int i, ret = -EINVAL;
 
 	if (val_len % map->format.val_bytes)
-		return -EINVAL;
+		return ret;
 	if (reg % map->reg_stride)
-		return -EINVAL;
+		return ret;
 
 	map->lock(map);
 
-- 
1.7.11.4

