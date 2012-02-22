Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab2BVOAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:00:18 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:38120 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751565Ab2BVOAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:00:15 -0500
From: Matt Fleming <matt@console-pimps.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86, efi: Fix unaligned access and endian issues
Date: Wed, 22 Feb 2012 14:00:08 +0000
Message-Id: <1329919208-8700-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

We need to read from and write to 'buf' a byte at a time otherwise
it's possible we'll perform an unaligned access, which can lead to a
segfault when cross-building an x86 kernel on risc architectures.

Also, we may need to convert the endianness of the data we read
from/write to buf, so let's add some helper functions to do that.

Stephen Rothwell noticed this bug when he hit a segfault while
cross-building an x86_64 allmodconfig kernel on PowerPC.

Cc: H. Peter Anvin <hpa@zytor.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/tools/build.c |   44 ++++++++++++++++++++++++++++++------------
 1 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index 4e9bd6b..4030cb7 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -133,6 +133,26 @@ static void usage(void)
 	die("Usage: build setup system [> image]");
 }
 
+static inline u32 read32_le(u8 *src)
+{
+	u32 data;
+
+	data = *src++;
+	data |= *src++ << 8;
+	data |= *src++ << 16;
+	data |= *src++ << 24;
+
+	return data;
+}
+
+static inline void write32_le(u8 *dst, u32 data)
+{
+	*dst++ = data;
+	*dst++ = data >> 8;
+	*dst++ = data >> 16;
+	*dst++ = data >> 24;
+}
+
 int main(int argc, char ** argv)
 {
 #ifdef CONFIG_EFI_STUB
@@ -192,44 +212,42 @@ int main(int argc, char ** argv)
 
 	/* Patch the setup code with the appropriate size parameters */
 	buf[0x1f1] = setup_sectors-1;
-	buf[0x1f4] = sys_size;
-	buf[0x1f5] = sys_size >> 8;
-	buf[0x1f6] = sys_size >> 16;
-	buf[0x1f7] = sys_size >> 24;
+	write32_le(&buf[0x1f4], sys_size);
 
 #ifdef CONFIG_EFI_STUB
 	file_sz = sz + i + ((sys_size * 16) - sz);
 
-	pe_header = *(unsigned int *)&buf[0x3c];
+	pe_header = read32_le(&buf[0x3c]);
 
 	/* Size of code */
-	*(unsigned int *)&buf[pe_header + 0x1c] = file_sz;
+	write32_le(&buf[pe_header + 0x1c], file_sz);
 
 	/* Size of image */
-	*(unsigned int *)&buf[pe_header + 0x50] = file_sz;
+	write32_le(&buf[pe_header + 0x50], file_sz);
 
 #ifdef CONFIG_X86_32
 	/* Address of entry point */
-	*(unsigned int *)&buf[pe_header + 0x28] = i;
+	write32_le(&buf[pe_header + 0x28], i);
 
 	/* .text size */
-	*(unsigned int *)&buf[pe_header + 0xb0] = file_sz;
+	write32_le(&buf[pe_header + 0xb0], file_sz);
 
 	/* .text size of initialised data */
-	*(unsigned int *)&buf[pe_header + 0xb8] = file_sz;
+	write32_le(&buf[pe_header + 0xb8], file_sz);
 #else
 	/*
 	 * Address of entry point. startup_32 is at the beginning and
 	 * the 64-bit entry point (startup_64) is always 512 bytes
 	 * after.
 	 */
-	*(unsigned int *)&buf[pe_header + 0x28] = i + 512;
+	write32_le(&buf[pe_header + 0x28], i + 512);
 
 	/* .text size */
-	*(unsigned int *)&buf[pe_header + 0xc0] = file_sz;
+	write32_le(&buf[pe_header + 0xc0], file_sz);
 
 	/* .text size of initialised data */
-	*(unsigned int *)&buf[pe_header + 0xc8] = file_sz;
+	write32_le(&buf[pe_header + 0xc8], file_sz);
+
 #endif /* CONFIG_X86_32 */
 #endif /* CONFIG_EFI_STUB */
 
-- 
1.7.4.4

