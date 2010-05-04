Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab0EDNFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 09:05:10 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:37847 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab0EDNFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 09:05:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=VDAZB+pq/g56uBvIgl5hJV8gn8getJnydBdWzWFJrKP8sD3mcJ8hKfobLOn/FLEcpI
         BrzlB61bE/LwPwaz3WaVEv2WrgStO+OCg/HEuk6AtwIcVyvsAReneL7GpLOyenJc4RQ5
         uhZ/4mXCHV0QA1EJtU9w0AYj9DoIco6EdbNNY=
Date: Tue, 4 May 2010 22:05:00 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: avi@redhat.com, mtosatti@redhat.com, agraf@suse.de,
       yoshikawa.takuya@oss.ntt.co.jp, fernando@oss.ntt.co.jp,
       kvm@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm-ia64@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       arnd@arndb.de, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH resend 8/12] asm-generic: bitops: introduce le bit
 offset macro
Message-Id: <20100504220500.7695cd66.takuya.yoshikawa@gmail.com>
In-Reply-To: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com>
References: <20100504215645.6448af8f.takuya.yoshikawa@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although we can use *_le_bit() helpers to treat bitmaps le arranged,
having le bit offset calculation as a seperate macro gives us more freedom.

For example, KVM has le arranged dirty bitmaps for VGA, live-migration
and they are used in user space too. To avoid bitmap copies between kernel
and user space, we want to update the bitmaps in user space directly.
To achive this, le bit offset with *_user() functions help us a lot.

So let us use the le bit offset calculation part by defining it as a new
macro: generic_le_bit_offset() .

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
CC: Arnd Bergmann <arnd@arndb.de>
---
 include/asm-generic/bitops/le.h |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/bitops/le.h b/include/asm-generic/bitops/le.h
index 80e3bf1..ee445fb 100644
--- a/include/asm-generic/bitops/le.h
+++ b/include/asm-generic/bitops/le.h
@@ -9,6 +9,8 @@
 
 #if defined(__LITTLE_ENDIAN)
 
+#define generic_le_bit_offset(nr)	(nr)
+
 #define generic_test_le_bit(nr, addr) test_bit(nr, addr)
 #define generic___set_le_bit(nr, addr) __set_bit(nr, addr)
 #define generic___clear_le_bit(nr, addr) __clear_bit(nr, addr)
@@ -25,6 +27,8 @@
 
 #elif defined(__BIG_ENDIAN)
 
+#define generic_le_bit_offset(nr)	((nr) ^ BITOP_LE_SWIZZLE)
+
 #define generic_test_le_bit(nr, addr) \
 	test_bit((nr) ^ BITOP_LE_SWIZZLE, (addr))
 #define generic___set_le_bit(nr, addr) \
-- 
1.7.0.4

