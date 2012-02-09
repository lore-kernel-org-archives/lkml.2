Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab2BIEQY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 23:16:24 -0500
Received: from nm13.access.bullet.mail.mud.yahoo.com ([66.94.237.214]:45339
	"HELO nm13.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755430Ab2BIEQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 23:16:23 -0500
X-Yahoo-Newman-Id: 54653.95303.bm@omp1005.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: SuTMptAVM1kwVIuzchbRCaWdw_VU_itULu0ZFjmtXNOfmIP
 rKEFBSCO8J2myJQeY1sGI22qO3hsjL_vJqKGbuYhkDZOSTdcQUjVlMkKH4h6
 O3bcTLUVm3.k_BB1usJGN5OfGQBqjNZfK26lad6pm4inbVPE_xOzWM988glb
 3NNgUrw0GdDGsmBQoMYIYb5J4Aqf7wWPDT9pCDWSyKpK9_RHM3GZPshYSEg0
 69th9RpezSGfUAQAJzH_lUpq.KUbFJFa01TLvifof131_bL1G.3EalHUzN6r
 84WsVHWkapAhRNrs3WRte.vSfKSDUXYB4CFRL635eu9B6BT6PdbuzogUBVK6
 tVX3UWSLthTZO9yKCqRc8Khsvh2YYoFarapmE1aWHeXNynSVC3gNfbCkKgwJ
 WJEhJmA--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4F334897.5010405@att.net>
Date: Wed, 08 Feb 2012 22:16:23 -0600
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111222 Thunderbird/8.0
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org
Subject: mm/slab.c: remove effectively dead code from kmem_cache_create
X-Enigmail-Version: 1.3.3
Content-Type: multipart/mixed;
 boundary="------------000908060605010601000501"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000908060605010601000501
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

I was examining slab.c when I noticed that there is code that will never
be executed, but that the compiler probably wouldn't determine as such. 
It turns out to be the case.  The below instructions (from a "disas /m 
kmem_cache_create" in gdb) will never be executed (or will have no
effect) since CONFIG_DEBUG_SLAB is not set and line 2301 (BUG_ON(flags &
~CREATE_MASK);) will oops us if we're using the flags in question.

2329            /*
2330             * Redzoning and user store require word alignment or
possibly larger.
2331             * Note this will be overridden by architecture or
caller mandated
2332             * alignment if either is greater than BYTES_PER_WORD.
2333             */
2334            if (flags & SLAB_STORE_USER)
2335                    ralign = BYTES_PER_WORD;
   0x00000000000038ae <+350>:   testq  $0x10000,0x20(%rsp)
   0x00000000000038b7 <+359>:   mov    $0x8,%eax
   0x00000000000038bc <+364>:   cmovne %rax,%r13

2336
2337            if (flags & SLAB_RED_ZONE) {
   0x00000000000038c0 <+368>:   testq  $0x400,0x20(%rsp)
   0x00000000000038c9 <+377>:   jne    0x3ba8 <kmem_cache_create+1112>

2338                    ralign = REDZONE_ALIGN;
   0x0000000000003bae <+1118>:  mov    $0x8,%r13d

2339                    /* If redzoning, ensure that the second redzone
is suitably
2340                     * aligned, by adjusting the object size
accordingly. */
2341                    size += REDZONE_ALIGN - 1;
   0x0000000000003ba8 <+1112>:  addq   $0x7,0x18(%rsp)

2342                    size &= ~(REDZONE_ALIGN - 1);
   0x0000000000003bb4 <+1124>:  andq   $0xfffffffffffffff8,0x18(%rsp)
   0x0000000000003bba <+1130>:  jmpq   0x38d7 <kmem_cache_create+391>
   0x0000000000003bbf <+1135>:  nop

2343            }
2344
2345            /* 2) arch mandated alignment */
2346            if (ralign < ARCH_SLAB_MINALIGN) {
   0x00000000000038d7 <+391>:   cmp    0x28(%rsp),%r13
   0x00000000000038e8 <+408>:   cmovb  0x28(%rsp),%r13

2347                    ralign = ARCH_SLAB_MINALIGN;
   0x00000000000038cf <+383>:   cmp    $0x7,%r13
   0x00000000000038d3 <+387>:   cmovbe %rax,%r13

2348            }
2349            /* 3) caller mandated alignment */
2350            if (ralign < align) {
2351                    ralign = align;
2352            }
2353            /* disable debug if necessary */
2354            if (ralign > __alignof__(unsigned long long))
2355                    flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
   0x00000000000038dc <+396>:   mov    0x20(%rsp),%rax
   0x00000000000038ee <+414>:   and    $0xfffffffffffefbff,%rax
   0x00000000000038f4 <+420>:   cmp    $0x9,%r13
   0x00000000000038f8 <+424>:   cmovb  0x20(%rsp),%rax
   0x0000000000003907 <+439>:   mov    %rax,0x20(%rsp)

2356            /*
2357             * 4) Store it.
2358             */
2359            align = ralign;

There's another little block that I can't illustrate since
CONFIG_PAGE_POISONING doesn't get enabled on my arch, but I've added it
into the patch as well.

Of note, in situations like this where I have a pre-process macro (i.e.,
DEBUG) that's defined to either zero or non-zero, my personal coding
style is to just use it directly in the the if() and let the optomizer
compile it out (as opposed to a #if/#endif block) but I was trying to
copy the coding style already in use.




--------------000908060605010601000501
Content-Type: text/x-patch;
 name="0001-compile-out-effectively-dead-code-from-kmem_cache_cr.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-compile-out-effectively-dead-code-from-kmem_cache_cr.pa";
 filename*1="tch"

>From 9dfd9dec7a1d67265df88d75e55734d4ac049441 Mon Sep 17 00:00:00 2001
From: Daniel Santos <daniel.santos@pobox.com>
Date: Wed, 8 Feb 2012 21:26:49 -0600
Subject: compile out effectively dead code from kmem_cache_create
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.7.3.4"

This is a multi-part message in MIME format.
--------------1.7.3.4
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit

---
 mm/slab.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)


--------------1.7.3.4
Content-Type: text/x-patch; name="0001-compile-out-effectively-dead-code-from-kmem_cache_cr.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="0001-compile-out-effectively-dead-code-from-kmem_cache_cr.patch"

diff --git a/mm/slab.c b/mm/slab.c
index f0bd785..1840a4a 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2326,6 +2326,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 		ralign = BYTES_PER_WORD;
 	}
 
+#if DEBUG
 	/*
 	 * Redzoning and user store require word alignment or possibly larger.
 	 * Note this will be overridden by architecture or caller mandated
@@ -2341,6 +2342,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 		size += REDZONE_ALIGN - 1;
 		size &= ~(REDZONE_ALIGN - 1);
 	}
+#endif
 
 	/* 2) arch mandated alignment */
 	if (ralign < ARCH_SLAB_MINALIGN) {
@@ -2350,9 +2352,13 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 	if (ralign < align) {
 		ralign = align;
 	}
+
+#if DEBUG
 	/* disable debug if necessary */
 	if (ralign > __alignof__(unsigned long long))
 		flags &= ~(SLAB_RED_ZONE | SLAB_STORE_USER);
+#endif
+
 	/*
 	 * 4) Store it.
 	 */
@@ -2442,7 +2448,7 @@ kmem_cache_create (const char *name, size_t size, size_t align,
 		slab_size =
 		    cachep->num * sizeof(kmem_bufctl_t) + sizeof(struct slab);
 
-#ifdef CONFIG_PAGE_POISONING
+#if DEBUG && defined(CONFIG_PAGE_POISONING)
 		/* If we're going to use the generic kernel_map_pages()
 		 * poisoning, then it's going to smash the contents of
 		 * the redzone and userword anyhow, so switch them off.

--------------1.7.3.4--



--------------000908060605010601000501--
