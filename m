Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab0KBRyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 13:54:17 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57651 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab0KBRyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 13:54:11 -0400
Date: Tue, 2 Nov 2010 18:52:48 +0100
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Jesper Juhl <jj@chaosbits.net>, amd64-microcode@amd64.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] microcode, AMD: Cleanup code a bit
Message-ID: <20101102175248.GA25781@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_ucode_data is a memcpy() wrapper which always returns 0. Move it
into the header and make it an inline. Remove all code checking its
return value and turn it into a void.

There should be no functionality change resulting from this patch.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/microcode.h |    6 ++++++
 arch/x86/kernel/microcode_amd.c  |   25 +++++--------------------
 2 files changed, 11 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index ef51b50..2421507 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -48,6 +48,12 @@ static inline struct microcode_ops * __init init_intel_microcode(void)
 
 #ifdef CONFIG_MICROCODE_AMD
 extern struct microcode_ops * __init init_amd_microcode(void);
+
+static inline void get_ucode_data(void *to, const u8 *from, size_t n)
+{
+	memcpy(to, from, n);
+}
+
 #else
 static inline struct microcode_ops * __init init_amd_microcode(void)
 {
diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index 383d4f8..15831336 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -155,12 +155,6 @@ static int apply_microcode_amd(int cpu)
 	return 0;
 }
 
-static int get_ucode_data(void *to, const u8 *from, size_t n)
-{
-	memcpy(to, from, n);
-	return 0;
-}
-
 static void *
 get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
 {
@@ -168,8 +162,7 @@ get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
 	u8 section_hdr[UCODE_CONTAINER_SECTION_HDR];
 	void *mc;
 
-	if (get_ucode_data(section_hdr, buf, UCODE_CONTAINER_SECTION_HDR))
-		return NULL;
+	get_ucode_data(section_hdr, buf, UCODE_CONTAINER_SECTION_HDR);
 
 	if (section_hdr[0] != UCODE_UCODE_TYPE) {
 		pr_err("error: invalid type field in container file section header\n");
@@ -187,12 +180,8 @@ get_next_ucode(const u8 *buf, unsigned int size, unsigned int *mc_size)
 	if (!mc)
 		return NULL;
 
-	if (get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR, total_size)) {
-		vfree(mc);
-		mc = NULL;
-	} else {
-		*mc_size = total_size + UCODE_CONTAINER_SECTION_HDR;
-	}
+	get_ucode_data(mc, buf + UCODE_CONTAINER_SECTION_HDR, total_size);
+	*mc_size = total_size + UCODE_CONTAINER_SECTION_HDR;
 
 	return mc;
 }
@@ -203,8 +192,7 @@ static int install_equiv_cpu_table(const u8 *buf)
 	unsigned int *buf_pos = (unsigned int *)container_hdr;
 	unsigned long size;
 
-	if (get_ucode_data(&container_hdr, buf, UCODE_CONTAINER_HEADER_SIZE))
-		return 0;
+	get_ucode_data(&container_hdr, buf, UCODE_CONTAINER_HEADER_SIZE);
 
 	size = buf_pos[2];
 
@@ -220,10 +208,7 @@ static int install_equiv_cpu_table(const u8 *buf)
 	}
 
 	buf += UCODE_CONTAINER_HEADER_SIZE;
-	if (get_ucode_data(equiv_cpu_table, buf, size)) {
-		vfree(equiv_cpu_table);
-		return 0;
-	}
+	get_ucode_data(equiv_cpu_table, buf, size);
 
 	return size + UCODE_CONTAINER_HEADER_SIZE; /* add header length */
 }
-- 
1.7.3.1.50.g1e633


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
