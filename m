Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755150Ab2BULc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 06:32:57 -0500
Received: from mga12.intel.com ([143.182.124.36]:9893 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754858Ab2BULcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 06:32:55 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of matt.fleming@intel.com designates 10.180.80.35 as permitted sender) smtp.mail=matt.fleming@intel.com
Subject: Re: build failure in Linus' tree with gcc 4.4.3
From: Matt Fleming <matt.fleming@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20120221213818.34410cc74de633cda0169819@canb.auug.org.au>
References: <20120220133936.936bff0d5817ac609a5211e0@canb.auug.org.au>
	 <20120220142208.ab97f13b9ade345402d054fb@canb.auug.org.au>
	 <1329731019.3639.20.camel@mfleming-mobl1.ger.corp.intel.com>
	 <1329818517.3639.29.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20120221213818.34410cc74de633cda0169819@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Tue, 21 Feb 2012 11:32:13 +0000
Message-ID: <1329823933.3639.6.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-02-21 at 21:38 +1100, Stephen Rothwell wrote:
> Hi Matt,
> 
> On Tue, 21 Feb 2012 10:01:57 +0000 Matt Fleming <matt.fleming@intel.com> wrote:
> >
> > Looks like the segfault is caused by an unaligned access? How does this
> > patch look?
> 
> I didn't try it, but it won't work.  PowerPC is big endian, the data you
> are copying is little endian ....

Urgh, you must feel like you're talking to a brick wall. I forgot you
mentioned the endian issue in your original post, sorry. Let's try this
one more time...

>From b3885c72be4cb06b2647a5067432da6017ea7902 Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming@intel.com>
Date: Mon, 20 Feb 2012 17:32:42 +0000
Subject: [PATCH] x86, efi: Fix unaligned access and endian issues

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
index 4e9bd6b..56efa6f 100644
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
+	data |= *src++ >> 8;
+	data |= *src++ >> 16;
+	data |= *src++ >> 24;
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



