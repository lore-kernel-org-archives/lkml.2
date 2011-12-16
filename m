Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760301Ab1LPSnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 13:43:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50177 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760286Ab1LPSnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 13:43:14 -0500
Date: Fri, 16 Dec 2011 10:43:02 -0800
From: tip-bot for Maarten Lankhorst <m.b.lankhorst@gmail.com>
Message-ID: <tip-2d2da60fb40a80cc59383121ccf763e0e0e8a42a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        m.b.lankhorst@gmail.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        m.b.lankhorst@gmail.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <4EEB3A02.3090201@gmail.com>
References: <4EEB3A02.3090201@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/efi] x86, efi: Break up large initrd reads
Git-Commit-ID: 2d2da60fb40a80cc59383121ccf763e0e0e8a42a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 16 Dec 2011 10:43:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2d2da60fb40a80cc59383121ccf763e0e0e8a42a
Gitweb:     http://git.kernel.org/tip/2d2da60fb40a80cc59383121ccf763e0e0e8a42a
Author:     Maarten Lankhorst <m.b.lankhorst@gmail.com>
AuthorDate: Fri, 16 Dec 2011 13:30:58 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 16 Dec 2011 08:34:35 -0800

x86, efi: Break up large initrd reads

The efi boot stub tries to read the entire initrd in 1 go, however
some efi implementations hang if too much if asked to read too much
data at the same time. After some experimentation I found out that my
asrock p67 board will hang if asked to read chunks of 4MiB, so use a
safe value.

elilo reads in chunks of 16KiB, but since that requires many read
calls I use a value of 1 MiB.  hpa suggested adding individual
blacklists for when systems are found where this value causes a crash.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Link: http://lkml.kernel.org/r/4EEB3A02.3090201@gmail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/boot/compressed/eboot.c |   20 ++++++++++++++------
 arch/x86/boot/compressed/eboot.h |    1 +
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 4055e63..fec216f 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -643,14 +643,22 @@ grow:
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
diff --git a/arch/x86/boot/compressed/eboot.h b/arch/x86/boot/compressed/eboot.h
index f66d023..3925166 100644
--- a/arch/x86/boot/compressed/eboot.h
+++ b/arch/x86/boot/compressed/eboot.h
@@ -12,6 +12,7 @@
 #define DESC_TYPE_CODE_DATA	(1 << 0)
 
 #define EFI_PAGE_SIZE		(1UL << EFI_PAGE_SHIFT)
+#define EFI_READ_CHUNK_SIZE	(1024 * 1024)
 
 #define PIXEL_RGB_RESERVED_8BIT_PER_COLOR		0
 #define PIXEL_BGR_RESERVED_8BIT_PER_COLOR		1
