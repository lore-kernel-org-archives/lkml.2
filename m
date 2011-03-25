Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab1CYJIQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 05:08:16 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59843 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab1CYJIP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 05:08:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=dsN0S/CeHxxFd0MEn9w+tSqDfkuCG8XiKCdVMySRQOuQuzxpiNEwwOahiHShlt5K29
         +dh4HVf9ScpzTGi5pRd555tw9tTPPWiLGnbGlu3H0rIby7B6UNIG/8JX46y6mEOq6b8P
         gGt5R22RckTwTet7RdhlMR7zR6V2dQBYSpZWE=
MIME-Version: 1.0
Date: Fri, 25 Mar 2011 14:38:13 +0530
Message-ID: <AANLkTimkh2QLvupu+62NGrKfqRb_gC7KLCAKkEoS9N9N@mail.gmail.com>
Subject: flush_kernel_vmap_range() invalidate_kernel_vmap_range() API not
 exists for MIPS
From: naveen yadav <yad.naveen@gmail.com>
To: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

We are working on 2.6.35.9 linux kernel on MIPS 34kce core and our
cache is VIVT having cache aliasing .
When I check the implementation on ARM I can check the implemenation
exists , but there is not similar implementation exists on MIPS.
These API's are used by XFS module:

static inline void flush_kernel_vmap_range(void *vaddr, int size)
static inline void invalidate_kernel_vmap_range(void *vaddr, int size)
static inline void flush_kernel_dcache_page(struct page *page)


I can check implementation on ARM at
http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.34.y.git;a=commit;h=252a9afff76097667429b583e8b5b170b47665a4
 and
----------------------------------------------------------------------------------------------------------------------------
--- a/arch/arm/include/asm/cacheflush.h+++ b/arch/arm/include/asm/cacheflush.h
@@ -432,6 +432,16
 @@ static inline void __flush_icache_all(void)
  : "r" (0)); #endif }
+static inline void flush_kernel_vmap_range(void *addr, int size)
+{
+       if ((cache_is_vivt() || cache_is_vipt_aliasing()))
+         __cpuc_flush_dcache_area(addr, (size_t)size);
+}
+static inline void invalidate_kernel_vmap_range(void *addr, int size)
+{
+       if ((cache_is_vivt() || cache_is_vipt_aliasing()))
+         __cpuc_flush_dcache_area(addr, (size_t)size);
+}
-------------------------------------------------------------------------------------------------------------------------------------


http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.34.y.git;a=blobdiff;f=arch/arm/include/asm/cacheflush.h;h=1a711ea8418b6045c581a576caa3f85496ee2673;hp=bb7d695f3900f70d635a3597cd19d7cb68c0d732;hb=73be1591579084a8103a7005dd3172f3e9dd7362;hpb=44b7532b8b464f606053562400719c9c21276037

======================================================
+#define ARCH_HAS_FLUSH_KERNEL_DCACHE_PAGE
+static inline void flush_kernel_dcache_page(struct page *page)
+{
+       /* highmem pages are always flushed upon kunmap already */
+       if ((cache_is_vivt() || cache_is_vipt_aliasing()) && !PageHighMem(page))
+               __cpuc_flush_dcache_page(page_address(page));
+}
+
==========================================================


Is there any similar API exists for MIPS.  I want to use for XFS these API's

thanks
