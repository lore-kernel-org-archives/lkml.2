Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760981Ab2BNUpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 15:45:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250Ab2BNUpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 15:45:20 -0500
Date: Tue, 14 Feb 2012 12:45:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: Xi Wang <xi.wang@gmail.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>
Subject: Re: Uninline kcalloc
Message-Id: <20120214124518.f42bc03e.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1202141329360.24883@router.home>
References: <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com>
	<4F33C7D7.1060801@kernel.dk>
	<32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com>
	<4F33CEAE.60400@gmail.com>
	<alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net>
	<20120209150652.5b1d19dc.akpm@linux-foundation.org>
	<FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com>
	<alpine.DEB.2.00.1202130958470.23562@router.home>
	<20120213194446.GD26353@mwanda>
	<alpine.DEB.2.00.1202131424020.25908@router.home>
	<20120214072017.GF26353@mwanda>
	<alpine.DEB.2.00.1202140858080.20013@router.home>
	<8F83835C-366C-46AC-A50A-3F680B7D2D83@gmail.com>
	<alpine.DEB.2.00.1202141032410.22250@router.home>
	<ADCFB33D-7284-4D3F-8280-545AF82EC744@gmail.com>
	<alpine.DEB.2.00.1202141329360.24883@router.home>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012 13:33:40 -0600 (CST)
Christoph Lameter <cl@linux.com> wrote:

> Subject: Uninline kcalloc
> 
> kcalloc is not used in performance critical ways. So it does not need to
> be inline. If we would add diagnostics to track the overflow occurrences
> then such code would be replicated at all call sites in the kernel.

Uninlining kcalloc() seems reasonable.  But if we're going to uninline
kcalloc() then we also should uninline kmalloc_array().

And yes, it's still called kmalloc_array() in my tree.  I've been
following this discussion for N days waiting for a reason for changing
the original patch and I ain't seen one yet.


From: Xi Wang <xi.wang@gmail.com>
Subject: slab: introduce kmalloc_array()

Introduce a kmalloc_array() wrapper that performs integer overflow
checking without zeroing the memory.

Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Xi Wang <xi.wang@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/slab.h |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN include/linux/slab.h~slab-introduce-kmalloc_array include/linux/slab.h
--- a/include/linux/slab.h~slab-introduce-kmalloc_array
+++ a/include/linux/slab.h
@@ -190,7 +190,7 @@ size_t ksize(const void *);
 #endif
 
 /**
- * kcalloc - allocate memory for an array. The memory is set to zero.
+ * kmalloc_array - allocate memory for an array.
  * @n: number of elements.
  * @size: element size.
  * @flags: the type of memory to allocate.
@@ -240,11 +240,22 @@ size_t ksize(const void *);
  * for general use, and so are not documented here. For a full list of
  * potential flags, always refer to linux/gfp.h.
  */
-static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
+static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
 {
 	if (size != 0 && n > ULONG_MAX / size)
 		return NULL;
-	return __kmalloc(n * size, flags | __GFP_ZERO);
+	return __kmalloc(n * size, flags);
+}
+
+/**
+ * kcalloc - allocate memory for an array. The memory is set to zero.
+ * @n: number of elements.
+ * @size: element size.
+ * @flags: the type of memory to allocate (see kmalloc).
+ */
+static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
+{
+	return kmalloc_array(n, size, flags | __GFP_ZERO);
 }
 
 #if !defined(CONFIG_NUMA) && !defined(CONFIG_SLOB)
_

