Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760134Ab2EDVKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:10:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34670 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404Ab2EDUqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:46:21 -0400
Message-Id: <20120504204228.395201850@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Carpenter <dan.carpenter@oracle.com>,
        Matt Fleming <matt.fleming@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 47/75] x86, efi: Fix pointer math issue in handle_ramdisks()
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit c7b738351ba92f48b943ac59aff6b5b0f17f37c9 upstream.

"filename" is a efi_char16_t string so this check for reaching the end
of the array doesn't work.  We need to cast the pointer to (u8 *) before
doing the math.

This patch changes the "filename" to "filename_16" to avoid confusion in
the future.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: http://lkml.kernel.org/r/20120305180614.GA26880@elgon.mountain
Acked-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/boot/compressed/eboot.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -539,7 +539,7 @@ static efi_status_t handle_ramdisks(efi_
 		struct initrd *initrd;
 		efi_file_handle_t *h;
 		efi_file_info_t *info;
-		efi_char16_t filename[256];
+		efi_char16_t filename_16[256];
 		unsigned long info_sz;
 		efi_guid_t info_guid = EFI_FILE_INFO_ID;
 		efi_char16_t *p;
@@ -552,14 +552,14 @@ static efi_status_t handle_ramdisks(efi_
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
@@ -583,7 +583,7 @@ static efi_status_t handle_ramdisks(efi_
 				goto free_initrds;
 		}
 
-		status = efi_call_phys5(fh->open, fh, &h, filename,
+		status = efi_call_phys5(fh->open, fh, &h, filename_16,
 					EFI_FILE_MODE_READ, (u64)0);
 		if (status != EFI_SUCCESS)
 			goto close_handles;


