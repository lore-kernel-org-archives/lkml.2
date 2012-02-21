Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809Ab2BUKCI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 05:02:08 -0500
Received: from mga05.intel.com ([192.55.52.89]:48349 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753086Ab2BUKCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 05:02:06 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of matt.fleming@intel.com designates 10.68.190.8 as permitted sender) smtp.mail=matt.fleming@intel.com
Subject: Re: build failure in Linus' tree with gcc 4.4.3
From: Matt Fleming <matt.fleming@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1329731019.3639.20.camel@mfleming-mobl1.ger.corp.intel.com>
References: <20120220133936.936bff0d5817ac609a5211e0@canb.auug.org.au>
	 <20120220142208.ab97f13b9ade345402d054fb@canb.auug.org.au>
	 <1329731019.3639.20.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Tue, 21 Feb 2012 10:01:57 +0000
Message-ID: <1329818517.3639.29.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14)
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-20 at 09:43 +0000, Matt Fleming wrote:
> On Mon, 2012-02-20 at 14:22 +1100, Stephen Rothwell wrote:
> > Which is all endian specific code that will run on the host when building
> > the kernel ...
> 
> Gah, right. I didn't think about cross-building this code.
> 
> Thanks Stephen, I'll fix this up.

Looks like the segfault is caused by an unaligned access? How does this
patch look?

>From 54b2707a6a911330d8db2f4ec2fb1baa5e38acf9 Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming@intel.com>
Date: Mon, 20 Feb 2012 17:32:42 +0000
Subject: [PATCH] x86, efi: Fix segfault caused by unaligned access

We need to use memcpy() instead of directly dereferencing a pointer
because memcpy() correctly handles the case where the
source/destination are unaligned, which can lead to a segfault when
cross-building an x86 kernel on risc architectures.

Stephen Rothwell noticed this bug when he hit a segfault while
cross-building an x86_64 allmodconfig kernel on PowerPC.

Cc: H. Peter Anvin <hpa@zytor.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/tools/build.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index 4e9bd6b..b4d85b5 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -200,36 +200,38 @@ int main(int argc, char ** argv)
 #ifdef CONFIG_EFI_STUB
 	file_sz = sz + i + ((sys_size * 16) - sz);
 
-	pe_header = *(unsigned int *)&buf[0x3c];
+	memcpy(&pe_header, &buf[0x3c], sizeof(pe_header));
 
 	/* Size of code */
-	*(unsigned int *)&buf[pe_header + 0x1c] = file_sz;
+	memcpy(&buf[pe_header + 0x1c], &file_sz, sizeof(file_sz));
 
 	/* Size of image */
-	*(unsigned int *)&buf[pe_header + 0x50] = file_sz;
+	memcpy(&buf[pe_header + 0x50], &file_sz, sizeof(file_sz));
 
 #ifdef CONFIG_X86_32
 	/* Address of entry point */
-	*(unsigned int *)&buf[pe_header + 0x28] = i;
+	memcpy(&buf[pe_header + 0x28], &i, sizeof(i));
 
 	/* .text size */
-	*(unsigned int *)&buf[pe_header + 0xb0] = file_sz;
+	memcpy(&buf[pe_header + 0xb0], &file_sz, sizeof(file_sz));
 
 	/* .text size of initialised data */
-	*(unsigned int *)&buf[pe_header + 0xb8] = file_sz;
+	memcpy(&buf[pe_header + 0xb8], &file_sz, sizeof(file_sz));
 #else
+	/* .text size */
+	memcpy(&buf[pe_header + 0xc0], &file_sz, sizeof(file_sz));
+
+	/* .text size of initialised data */
+	memcpy(&buf[pe_header + 0xc8], &file_sz, sizeof(file_sz));
+
 	/*
 	 * Address of entry point. startup_32 is at the beginning and
 	 * the 64-bit entry point (startup_64) is always 512 bytes
 	 * after.
 	 */
-	*(unsigned int *)&buf[pe_header + 0x28] = i + 512;
+	file_sz = i + 512;
+	memcpy(&buf[pe_header + 0x28], &file_sz, sizeof(file_sz));
 
-	/* .text size */
-	*(unsigned int *)&buf[pe_header + 0xc0] = file_sz;
-
-	/* .text size of initialised data */
-	*(unsigned int *)&buf[pe_header + 0xc8] = file_sz;
 #endif /* CONFIG_X86_32 */
 #endif /* CONFIG_EFI_STUB */
 
-- 
1.7.4.4



