Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab1CLBn5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 20:43:57 -0500
Received: from smtp-out.google.com ([74.125.121.67]:30567 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab1CLBny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 20:43:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=Ibq89kYlVQnVR5qkywNokNXQWs0kGB+ML4yk966rwEvapAKAYSKcxqY8J4Dfsv0yi
	nXkW27iVGFaVpC0XdP8IQ==
Subject: [PATCH v2 08/12] x86: get_bios_ebda_length()
To: Greg KH <greg@kroah.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
From: Mike Waychison <mikew@google.com>
Cc: Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Date: Fri, 11 Mar 2011 17:43:37 -0800
Message-ID: <20110312014337.6133.19636.stgit@mike.mtv.corp.google.com>
In-Reply-To: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
References: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a wrapper routine that tells us the length of the EBDA if it is
present.  This guy also ensures that the returned length doesn't let the
EBDA run past the 640KiB mark.

Signed-off-by: Mike Waychison <mikew@google.com>
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

