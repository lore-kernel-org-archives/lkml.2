Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973Ab1LPMbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 07:31:18 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33904 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab1LPMbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 07:31:05 -0500
Message-ID: <4EEB3A02.3090201@gmail.com>
Date: Fri, 16 Dec 2011 13:30:58 +0100
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Mike Waychison <mikew@google.com>,
        Andi Kleen <andi@firstfloor.org>, Peter Jones <pjones@redhat.com>
Subject: [PATCH v2] x86, efi: Break up large initrd reads
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>  <1318848017-12301-11-git-send-email-matt@console-pimps.org>  <4E9C8AAC.7080803@gmail.com>  <1321383097.2657.9.camel@mfleming-mobl1.ger.corp.intel.com>  <4ECC4207.3010607@gmail.com>  <1322076468.24448.18.camel@mfleming-mobl1.ger.corp.intel.com>  <4ECE5803.3060203@gmail.com>  <1322168216.24448.61.camel@mfleming-mobl1.ger.corp.intel.com>  <4ECEF144.8020303@gmail.com> <1322210899.24448.66.camel@mfleming-mobl1.ger.corp.intel.com> <4EE689D5.4070600@zytor.com> <4EE798CF.7080903@linux.intel.com> <4EE93262.2030206@gmail.com> <4EE93302.9090900@zytor.com>
In-Reply-To: <4EE93302.9090900@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 11/11] x86, efi: Break up large initrd reads

The efi boot stub tries to read the entire initrd in 1 go,
however some efi implementations hang if too much if asked
to read too much data at the same time. After some
experimentation I found out that my asrock p67 board will
hang if asked to read chunks of 4MiB, so use a safe value.

elilo reads in chunks of 16KiB, but since that requires
many read calls I use a value of 1 MiB. hpa suggested
adding individual blacklists for when systems are found
where this value causes a crash.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
---

v2: Bump read size to 1 MiB, and use a #define for chunk size

 arch/x86/boot/compressed/eboot.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 8627a56..df4f552 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -23,6 +23,7 @@
 #define DESC_TYPE_CODE_DATA	(1 << 0)
 
 #define EFI_PAGE_SIZE		(1UL << EFI_PAGE_SHIFT)
+#define EFI_READ_CHUNK_SIZE	(1024 * 1024)
 
 #define PIXEL_RGB_RESERVED_8BIT_PER_COLOR		0
 #define PIXEL_BGR_RESERVED_8BIT_PER_COLOR		1
@@ -695,14 +696,22 @@ grow:
 			u64 size;
 
 			size = initrds[j].size;
-			status = efi_call_phys3(fh->read, initrds[j].handle,
-						&size, addr);
-			if (status != EFI_SUCCESS)
-				goto free_initrd_total;
+			while (size) {
+				u64 chunksize;
+				if (size > EFI_READ_CHUNK_SIZE)
+					chunksize = EFI_READ_CHUNK_SIZE;
+				else
+					chunksize = size;
+				status = efi_call_phys3(fh->read,
+							initrds[j].handle,
+							&chunksize, addr);
+				if (status != EFI_SUCCESS)
+					goto free_initrd_total;
+				addr += chunksize;
+				size -= chunksize;
+			}
 
 			efi_call_phys1(fh->close, initrds[j].handle);
-
-			addr += size;
 		}
 
 	}
-- 
1.7.7.4


