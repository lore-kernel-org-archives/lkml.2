Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934639Ab1ETAMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:12:00 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:45855 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934842Ab1ETALy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:54 -0400
X-Sasl-enc: pEMdGg1RLUzZ2iuuicp00BS0+UVKyUDfL3+A7isOoii0 1305850313
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Mike Waychison <mikew@google.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 28/44] x86: get_bios_ebda_length()
Date: Thu, 19 May 2011 17:10:46 -0700
Message-Id: <1305850262-9575-28-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Waychison <mikew@google.com>

Add a wrapper routine that tells us the length of the EBDA if it is
present.  This guy also ensures that the returned length doesn't let the
EBDA run past the 640KiB mark.

Signed-off-by: Mike Waychison <mikew@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/include/asm/bios_ebda.h |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/bios_ebda.h b/arch/x86/include/asm/bios_ebda.h
index 3c75210..5174cf0 100644
--- a/arch/x86/include/asm/bios_ebda.h
+++ b/arch/x86/include/asm/bios_ebda.h
@@ -14,6 +14,27 @@ static inline unsigned int get_bios_ebda(void)
 	return address;	/* 0 means none */
 }
 
+/*
+ * Return the sanitized length of the EBDA in bytes, if it exists.
+ */
+static inline unsigned int get_bios_ebda_length(void)
+{
+	unsigned int address;
+	unsigned int length;
+
+	address = get_bios_ebda();
+	if (!address)
+		return 0;
+
+	/* EBDA length is byte 0 of the EBDA (stored in KiB) */
+	length = *(unsigned char *)phys_to_virt(address);
+	length <<= 10;
+
+	/* Trim the length if it extends beyond 640KiB */
+	length = min_t(unsigned int, (640 * 1024) - address, length);
+	return length;
+}
+
 void reserve_ebda_region(void);
 
 #ifdef CONFIG_X86_CHECK_BIOS_CORRUPTION
-- 
1.7.4.2

