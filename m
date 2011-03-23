Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab1CWTM7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 15:12:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753955Ab1CWTM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 15:12:58 -0400
Subject: generic page.h problem
From: Mark Salter <msalter@redhat.com>
To: arnd@arndb.de
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat, Inc
Date: Wed, 23 Mar 2011 15:12:53 -0400
Message-Id: <1300907573.15255.224.camel@deneb.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm working with a new architecture port (nommu) and was wanting to use
the generic page.h but there is a problem. I'm using CONFIG_FLATMEM with
a non-zero CONFIG_KERNEL_RAM_BASE_ADDRESS. The hardware uses this same
address to access RAM from code and for DMA purposes. The generic page.h
has:

#ifdef CONFIG_KERNEL_RAM_BASE_ADDRESS
#define PAGE_OFFSET		(CONFIG_KERNEL_RAM_BASE_ADDRESS)
#else
#define PAGE_OFFSET		(0)
#endif

#ifndef __ASSEMBLY__

#define __va(x) ((void *)((unsigned long)(x) + PAGE_OFFSET))
#define __pa(x) ((unsigned long) (x) - PAGE_OFFSET)

The problem I have is that __va(x) and __pa(x) should do nothing on
this architecture. If I use the following, then everything seems to
work as it should.


diff --git a/include/asm-generic/page.h b/include/asm-generic/page.h
index 75fec18..4dc4a81 100644
--- a/include/asm-generic/page.h
+++ b/include/asm-generic/page.h
@@ -73,8 +73,8 @@ extern unsigned long memory_end;
 
 #ifndef __ASSEMBLY__
 
-#define __va(x) ((void *)((unsigned long)(x) + PAGE_OFFSET))
-#define __pa(x) ((unsigned long) (x) - PAGE_OFFSET)
+#define __va(x) ((void *)((unsigned long) (x)))
+#define __pa(x) ((unsigned long) (x))
 
 #define virt_to_pfn(kaddr)     (__pa(kaddr) >> PAGE_SHIFT)
 #define pfn_to_virt(pfn)       __va((pfn) << PAGE_SHIFT)


Am I missing something here? The only other arch using the generic
page.h is blackfin, but it uses a zero PAGE_OFFSET, so my patch
would have no effect there.

--Mark


