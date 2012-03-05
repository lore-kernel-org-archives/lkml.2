Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab2CESHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 13:07:35 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:25797 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab2CESHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 13:07:33 -0500
Date: Mon, 5 Mar 2012 21:06:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v2] x86, efi: fix pointer math issue in handle_ramdisks()
Message-ID: <20120305180614.GA26880@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120303075443.GC16816@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F55009D.0058,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"filename" is a efi_char16_t string so this check for reaching the end
of the array doesn't work.  We need to cast the pointer to (u8 *) before
doing the math.

This patch changes the "filename" to "filename_16" to avoid confusion in
the future.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Rename "filename" to "filename_16"
    Also changed cast from (char *) to (u8 *) because it's not a C
    character string.  Ingo suggested (void *) but that's a GCCism
    I think.

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index fec216f..0cdfc0d 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -539,7 +539,7 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 		struct initrd *initrd;
 		efi_file_handle_t *h;
 		efi_file_info_t *info;
-		efi_char16_t filename[256];
+		efi_char16_t filename_16[256];
 		unsigned long info_sz;
 		efi_guid_t info_guid = EFI_FILE_INFO_ID;
 		efi_char16_t *p;
@@ -552,14 +552,14 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 		str += 7;
 
 		initrd = &initrds[i];
-		p = filename;
+		p = filename_16;
 
 		/* Skip any leading slashes */
 		while (*str == '/' || *str == '\\')
 			str++;
 
 		while (*str && *str != ' ' && *str != '\n') {
-			if (p >= filename + sizeof(filename))
+			if ((u8 *)p >= (u8 *)filename_16 + sizeof(filename_16))
 				break;
 
 			*p++ = *str++;
@@ -583,7 +583,7 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 				goto free_initrds;
 		}
 
-		status = efi_call_phys5(fh->open, fh, &h, filename,
+		status = efi_call_phys5(fh->open, fh, &h, filename_16,
 					EFI_FILE_MODE_READ, (u64)0);
 		if (status != EFI_SUCCESS)
 			goto close_handles;
