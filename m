Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031199Ab2CPV2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 17:28:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41469 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964969Ab2CPV2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 17:28:06 -0400
Date: Fri, 16 Mar 2012 14:27:46 -0700
From: tip-bot for Dan Carpenter <dan.carpenter@oracle.com>
Message-ID: <tip-c7b738351ba92f48b943ac59aff6b5b0f17f37c9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com, matt.fleming@intel.com,
        dan.carpenter@oracle.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, matt.fleming@intel.com, hpa@linux.intel.com,
        dan.carpenter@oracle.com
In-Reply-To: <20120305180614.GA26880@elgon.mountain>
References: <20120305180614.GA26880@elgon.mountain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, efi:
  Fix pointer math issue in handle_ramdisks()
Git-Commit-ID: c7b738351ba92f48b943ac59aff6b5b0f17f37c9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 16 Mar 2012 14:27:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7b738351ba92f48b943ac59aff6b5b0f17f37c9
Gitweb:     http://git.kernel.org/tip/c7b738351ba92f48b943ac59aff6b5b0f17f37c9
Author:     Dan Carpenter <dan.carpenter@oracle.com>
AuthorDate: Mon, 5 Mar 2012 21:06:14 +0300
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 16 Mar 2012 13:03:24 -0700

x86, efi: Fix pointer math issue in handle_ramdisks()

"filename" is a efi_char16_t string so this check for reaching the end
of the array doesn't work.  We need to cast the pointer to (u8 *) before
doing the math.

This patch changes the "filename" to "filename_16" to avoid confusion in
the future.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: http://lkml.kernel.org/r/20120305180614.GA26880@elgon.mountain
Acked-by: Matt Fleming <matt.fleming@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/compressed/eboot.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

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
