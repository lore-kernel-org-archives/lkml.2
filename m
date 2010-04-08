Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263Ab0DHGgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 02:36:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:41735 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756382Ab0DHGgh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 02:36:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,168,1270450800"; 
   d="scan'208";a="263319107"
From: "Zhao, Leifu" <leifu.zhao@intel.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Date: Thu, 8 Apr 2010 14:36:15 +0800
Subject: [PATCH] race condition between __purge_vmap_area_lazy() and
 free_unmap_vmap_area_noflush()
Thread-Topic: [PATCH] race condition between __purge_vmap_area_lazy() and
 free_unmap_vmap_area_noflush()
Thread-Index: AcrW5cmHmx1lHoLWTmGpK++oHrm6mw==
Message-ID: <EAEEEBBE07F4F24C89FEF850CF8C77420142A21107@shzsmsx502.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I found a bug in 2.6.28 kernel and got the fix for it, see below bug description, log information and the patch. As I know this bug still exists in at least 2.6.32 kernel. I am new in the kernel development process, can someone tell me what should proceed next?

Bug description:

There is race condition between function __purge_vmap_area_lazy() and free_unmap_vmap_area_noflush() in vmalloc.c of kernel. In function free_unmap_vmap_area_noflush(), if  va->flags is updated and then is preempted to run __purge_vmap_area_lazy() before updating vmap_lazy_nr, then vmap_lazy_nr used in function __purge_vmap_area_lazy() has incorrect value, therefore cause the crash(due to run BUG_ON function). So the updating va->flags and vmap_lazy_nr must execute atomicly, the solution is to use spinlock to protect updating va->flags and vmap_lazy_nr.


Captured log information:

kernel BUG at mm/vmalloc.c:507!
invalid opcode: 0000 [#1] PREEMPT 
last sysfs file: /sys/class/sound/controlC0/dev
Modules linked in: avcap_nxp(P) avcap_synthetic(P) avcap_core(P) pvrsrvkm
alsa_shim(P) snd_usb_audio ]

Pid: 1022, comm: Audio_Timing Tainted: P           (2.6.28 #1) 
EIP: 0060:[<c01537d5>] EFLAGS: 00010297 CPU: 0
EIP is at __purge_vmap_area_lazy+0x1b1/0x1b5
EAX: c4e1e000 EBX: c04e0cec ECX: c4e1fc9c EDX: c04e0d04
ESI: 000001e2 EDI: c4e1fcc4 EBP: c4e1fcc0 ESP: c4e1fc98



Patch:

--- linux-2.6.28/mm/vmalloc.c.orig      2010-04-10 14:16:47.000000000 +0800
+++ linux-2.6.28/mm/vmalloc.c   2010-04-10 14:19:03.000000000 +0800
@@ -467,6 +467,7 @@ static unsigned long lazy_max_pages(void

 static atomic_t vmap_lazy_nr = ATOMIC_INIT(0);

+static DEFINE_SPINLOCK(purge_lock);
 /*
  * Purges all lazily-freed vmap areas.
  *
@@ -480,7 +481,6 @@ static atomic_t vmap_lazy_nr = ATOMIC_IN
 static void __purge_vmap_area_lazy(unsigned long *start, unsigned long *end,
                                        int sync, int force_flush)
 {
-       static DEFINE_SPINLOCK(purge_lock);
        LIST_HEAD(valist);
        struct vmap_area *va;
        int nr = 0;
@@ -556,8 +556,10 @@ static void purge_vmap_area_lazy(void)
  */
 static void free_unmap_vmap_area_noflush(struct vmap_area *va)
 {
+       spin_lock(&purge_lock);
        va->flags |= VM_LAZY_FREE;
        atomic_add((va->va_end - va->va_start) >> PAGE_SHIFT, &vmap_lazy_nr);
+       spin_unlock(&purge_lock);
        if (unlikely(atomic_read(&vmap_lazy_nr) > lazy_max_pages()))
                try_purge_vmap_area_lazy();
 }



Signed-off-by: Leifu Zhao <Leifu.zhao@intel.com>



Best regards,
 
Leifu Zhao

