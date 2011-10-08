Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072Ab1JHHl6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 03:41:58 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:40243 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1JHHl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 03:41:56 -0400
Date: Sat, 8 Oct 2011 00:42:07 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Theodore Tso <tytso@mit.edu>, David Miller <davem@davemloft.net>
Cc: Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mingming Cao <cmm@us.ibm.com>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH v5.1 4/4] crc32: Select an algorithm via kconfig
Message-ID: <20111008074207.GK12447@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20111004235357.1560.12602.stgit@elm3c44.beaverton.ibm.com> <20111004235429.1560.89556.stgit@elm3c44.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111004235429.1560.89556.stgit@elm3c44.beaverton.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, the description of CRC32_SLICEBY4 is a bit screwy.  Let's try that again.
---
Allow the kernel builder to choose a crc32* algorithm for the kernel.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 lib/Kconfig     |   36 ++++++++++++++++++++++++++++++++++++
 lib/crc32defs.h |   18 ++++++++++++++++++
 2 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/lib/Kconfig b/lib/Kconfig
index 477be04..27881d9 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -70,6 +70,42 @@ config CRC32_SELFTEST
 	  and crc32_be over byte strings with random alignment and length
 	  and computes the total elapsed time and number of bytes processed.
 
+choice
+	prompt "CRC32 implementation"
+	depends on CRC32
+	default CRC32_SLICEBY8
+
+config CRC32_SLICEBY8
+	bool "Slice by 8 bytes"
+	help
+	  Calculate checksum 8 bytes at a time with a clever slicing algorithm.
+	  This is the fastest algorithm, but comes with a 8KiB lookup table.
+	  Most modern processors have enough cache that this shouldn't be
+	  a problem.
+
+	  If you don't know which to choose, choose this one.
+
+config CRC32_SLICEBY4
+	bool "Slice by 4 bytes"
+	help
+	  Calculate checksum 4 bytes at a time with a clever slicing algorithm.
+	  This is a bit slower than slice by 8, but has a smaller 4KiB lookup
+	  table.
+
+config CRC32_SARWATE
+	bool "Sarwate's Algorithm (one byte at a time)"
+	help
+	  Calculate checksum a byte at a time using Sarwate's algorithm.  This
+	  is not particularly fast, but has a small 256 byte lookup table.
+
+config CRC32_BIT
+	bool "Classic Algorithm (one bit at a time)"
+	help
+	  Calculate checksum one bit at a time.  This is VERY slow, but has
+	  no lookup table.  This is provided as a debugging option.
+
+endchoice
+
 config CRC7
 	tristate "CRC7 functions"
 	help
diff --git a/lib/crc32defs.h b/lib/crc32defs.h
index 6fd1917..64cba2c 100644
--- a/lib/crc32defs.h
+++ b/lib/crc32defs.h
@@ -13,6 +13,24 @@
  */
 #define CRC32C_POLY_LE 0x82F63B78
 
+/* Try to choose an implementation variant via Kconfig */
+#ifdef CONFIG_CRC32_SLICEBY8
+# define CRC_LE_BITS 64
+# define CRC_BE_BITS 64
+#endif
+#ifdef CONFIG_CRC32_SLICEBY4
+# define CRC_LE_BITS 32
+# define CRC_BE_BITS 32
+#endif
+#ifdef CONFIG_CRC32_SARWATE
+# define CRC_LE_BITS 8
+# define CRC_BE_BITS 8
+#endif
+#ifdef CONFIG_CRC32_BIT
+# define CRC_LE_BITS 1
+# define CRC_BE_BITS 1
+#endif
+
 /*
  * How many bits at a time to use.  Valid values are 1, 2, 4, 8, 32 and 64.
  * For less performance-sensitive, use 4 or 8 to save table size.
