Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759739Ab2BNTdr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 14:33:47 -0500
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:44964 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752487Ab2BNTdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 14:33:44 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: jDAXa0AVM1nAHUegIzTtVoWhcrl9qg.Lz5LVuMi96PQI0GC
 UWF66QdeWRDH5uOxR.OjVtp784FA2n3KmPQ18BUIpTWTpJPbReFr8I3IITvH
 k9KstzuAvsKuJxxdTw3VguwWwIZ9MZjVrknKaLdkJzlt6YbE_FjZc9m249hk
 oGgzGrVHA2HWZzJATVmxDmU4aabdxqthhz3H4Jr6787uRWtQp2HWeFztLrPs
 1wzoHNnIFaRHubNMgrrI05JQMxDuulrBwBFB1K.WZtckRBQq9UOScmFWY1Uj
 IIlYQEJUdnqNrbyG9zWBq5GgSspfFnwQKy0G15LLVHIuPuLdvpT7B51AlxyM
 ZOXvB3pCVXxy234tKXzOZa2xBWYST2hFloDBfr2ZeO5nBDZCiCznqPnWQCEB
 mRMHZxpvaRh7ycLfUYibj1dM4PQTpbHQlkgEr
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 14 Feb 2012 13:33:40 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Xi Wang <xi.wang@gmail.com>
cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>
Subject: Uninline kcalloc
In-Reply-To: <ADCFB33D-7284-4D3F-8280-545AF82EC744@gmail.com>
Message-ID: <alpine.DEB.2.00.1202141329360.24883@router.home>
References: <CAOJsxLG0Lq7XZQWPxU=ut3Eec6UiRpwhsxU-k5Ooi7H1EBKT2A@mail.gmail.com> <4F33C7D7.1060801@kernel.dk> <32FA0BD0-7C0D-4ED4-B375-4736FC70AC05@gmail.com> <4F33CEAE.60400@gmail.com> <alpine.LNX.2.00.1202092346300.32491@swampdragon.chaosbits.net>
 <20120209150652.5b1d19dc.akpm@linux-foundation.org> <FE5A0944-E520-4D3F-987E-A357411DD60B@gmail.com> <alpine.DEB.2.00.1202130958470.23562@router.home> <20120213194446.GD26353@mwanda> <alpine.DEB.2.00.1202131424020.25908@router.home> <20120214072017.GF26353@mwanda>
 <alpine.DEB.2.00.1202140858080.20013@router.home> <8F83835C-366C-46AC-A50A-3F680B7D2D83@gmail.com> <alpine.DEB.2.00.1202141032410.22250@router.home> <ADCFB33D-7284-4D3F-8280-545AF82EC744@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012, Xi Wang wrote:

> On Feb 14, 2012, at 11:34 AM, Christoph Lameter wrote:
> > You can if you check the results later. A zero size return would be an
> > indication of an error. No need to pass it on to kmalloc.
>
> Maybe I misunderstood something here.  How do you not pass it to
> kmalloc() with kmalloc(SAFE_ARRAY_SIZE(n, size), ...)?

Ok two patches to address this. First one

Subject: Uninline kcalloc

kcalloc is not used in performance critical ways. So it does not need to
be inline. If we would add diagnostics to track the overflow occurrences
then such code would be replicated at all call sites in the kernel.

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 include/linux/slab.h |    7 +------
 mm/util.c            |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 6 deletions(-)

Index: linux-2.6/include/linux/slab.h
===================================================================
--- linux-2.6.orig/include/linux/slab.h	2012-02-14 09:56:08.000000000 -0600
+++ linux-2.6/include/linux/slab.h	2012-02-14 13:32:43.000000000 -0600
@@ -240,12 +240,7 @@ size_t ksize(const void *);
  * for general use, and so are not documented here. For a full list of
  * potential flags, always refer to linux/gfp.h.
  */
-static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
-{
-	if (size != 0 && n > ULONG_MAX / size)
-		return NULL;
-	return __kmalloc(n * size, flags | __GFP_ZERO);
-}
+void *kcalloc(size_t n, size_t size, gfp_t flags);

 #if !defined(CONFIG_NUMA) && !defined(CONFIG_SLOB)
 /**
Index: linux-2.6/mm/util.c
===================================================================
--- linux-2.6.orig/mm/util.c	2012-02-14 09:56:08.000000000 -0600
+++ linux-2.6/mm/util.c	2012-02-14 13:32:54.000000000 -0600
@@ -75,6 +75,21 @@ void *kmemdup(const void *src, size_t le
 EXPORT_SYMBOL(kmemdup);

 /**
+ * kcalloc - allocate memory for an array. The memory is set to zero.
+ *
+ * @n: number of elements.
+ * @size: element size.
+ * @flags: the type of memory to allocate.
+ */
+void *kcalloc(size_t n, size_t size, gfp_t flags)
+{
+	if (size != 0 && n > ULONG_MAX / size)
+		return NULL;
+	return __kmalloc(n * size, flags | __GFP_ZERO);
+}
+EXPORT_SYMBOL(kcalloc);
+
+/**
  * memdup_user - duplicate memory region from user space
  *
  * @src: source address in user space
