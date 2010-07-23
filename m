Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab0GWGDA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 02:03:00 -0400
Received: from claw.goop.org ([74.207.240.146]:34260 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab0GWGC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 02:02:58 -0400
Message-ID: <4C493084.1050207@goop.org>
Date: Thu, 22 Jul 2010 23:02:44 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] support multiple .discard.* sections to avoid section type
 conflicts
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gcc 4.4.4 will complain if you use a .discard section for both text and
data ("causes a section type conflict").  Add support for ".discard.*"
sections, and use .discard.text for a dummy function in the x86
RESERVE_BRK() macro.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 86b1506..ef292c7 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -82,7 +82,7 @@ void *extend_brk(size_t size, size_t align);
  * executable.)
  */
 #define RESERVE_BRK(name,sz)						\
-	static void __section(.discard) __used				\
+	static void __section(.discard.text) __used			\
 	__brk_reservation_fn_##name##__(void) {				\
 		asm volatile (						\
 			".pushsection .brk_reservation,\"aw\",@nobits;" \
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 48c5299..ae6b88e 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -643,6 +643,7 @@
 	EXIT_DATA							\
 	EXIT_CALL							\
 	*(.discard)							\
+	*(.discard.*)							\
 	}
 
 /**


