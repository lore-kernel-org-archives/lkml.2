Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab1KYBhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 20:37:14 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57113 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757Ab1KYBhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 20:37:12 -0500
Message-ID: <4ECEF144.8020303@gmail.com>
Date: Fri, 25 Nov 2011 02:37:08 +0100
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Mike Waychison <mikew@google.com>, Andi Kleen <andi@firstfloor.org>,
        Peter Jones <pjones@redhat.com>
Subject: [PATCH] x86, efi: Break up large initrd reads
References: <1318848017-12301-1-git-send-email-matt@console-pimps.org>  <1318848017-12301-11-git-send-email-matt@console-pimps.org>  <4E9C8AAC.7080803@gmail.com>  <1321383097.2657.9.camel@mfleming-mobl1.ger.corp.intel.com>  <4ECC4207.3010607@gmail.com>  <1322076468.24448.18.camel@mfleming-mobl1.ger.corp.intel.com>  <4ECE5803.3060203@gmail.com> <1322168216.24448.61.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1322168216.24448.61.camel@mfleming-mobl1.ger.corp.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The efi boot stub tries to read the entire initrd in 1 go,
however some efi implementations hang if too much if asked
to read too much data at the same time. After some
experimentation I found out that my asrock p67 board will
hang if asked to read chunks of 4mb, so use a safe value.

>From elilo source code:
/*
 * We load by chunks rather than a single big read because
 * early versions of EFI had troubles loading files
 * from floppies in a single big request.  Breaking
 * the read down into chunks of 4KB fixed that
 * problem. While this problem has been fixed, we still prefer
 * this method because it tells us whether or not we're making
 * forward progress.
 */

While the comment says 4KB, it's using 4 * EFI_PAGE_SIZE (16KB),
so I went by the safest route of following elilo here.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
---
 arch/x86/boot/compressed/eboot.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 8627a56..a26be50 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -695,14 +695,22 @@ grow:
 			u64 size;
 
 			size = initrds[j].size;
-			status = efi_call_phys3(fh->read, initrds[j].handle,
-						&size, addr);
-			if (status != EFI_SUCCESS)
-				goto free_initrd_total;
+			while (size) {
+				u64 chunksize;
+				if (size > 4 * EFI_PAGE_SIZE)
+					chunksize = 4 * EFI_PAGE_SIZE;
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
1.7.7.1



