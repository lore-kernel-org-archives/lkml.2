Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761210Ab2BNVZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 16:25:06 -0500
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:25516 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760867Ab2BNVZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 16:25:03 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: SWa8JYAVM1lDEffGJkBcRzzEiy7u1CkXoaB61hRwycSjn9M
 t0s4xOCxTa9gRwPCyQjQ6JhpGp2KJ3DmIk.EDbIk2_d1n2Ab7NEyHGplPaLX
 ioDgWD8OfbdBJNvE6kDvYh6gSW7IFAIxbg9odBLBCvp1FyJ8kOAyQWu5zLeW
 AFTnr1tz5rExEXIqXyHwOilorMFboFEkwi5zKtZ.8jFNgR__JGR4NyHqu3DS
 LTIp_56ZahKeE3cotTRuxr6iouvqgxOYO2jyZAvrnEMJO5h3kOz8hn2aU3HH
 nnVpavXeN1TtwA7ZtWtPo1QzYwU14S0aRWxc_M9HEbljmLW8ZewqWZBhcB51
 URrKK4y4eB0pWAU2hc3R25OuYMmXgYLmqyKXSnBWWRT7yhbFhSLMrubahHnp
 u
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 14 Feb 2012 15:24:58 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Nick Bowler <nbowler@elliptictech.com>
cc: Xi Wang <xi.wang@gmail.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Juhl <jj@chaosbits.net>, Jens Axboe <axboe@kernel.dk>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, David Rientjes <rientjes@google.com>
Subject: Re: Uninline kcalloc
In-Reply-To: <20120214205032.GA631@elliptictech.com>
Message-ID: <alpine.DEB.2.00.1202141513210.29019@router.home>
References: <alpine.DEB.2.00.1202130958470.23562@router.home> <20120213194446.GD26353@mwanda> <alpine.DEB.2.00.1202131424020.25908@router.home> <20120214072017.GF26353@mwanda> <alpine.DEB.2.00.1202140858080.20013@router.home> <8F83835C-366C-46AC-A50A-3F680B7D2D83@gmail.com>
 <alpine.DEB.2.00.1202141032410.22250@router.home> <ADCFB33D-7284-4D3F-8280-545AF82EC744@gmail.com> <alpine.DEB.2.00.1202141329360.24883@router.home> <alpine.DEB.2.00.1202141336060.24883@router.home> <20120214205032.GA631@elliptictech.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Feb 2012, Nick Bowler wrote:

> On 2012-02-14 13:37 -0600, Christoph Lameter wrote:
> > This patch still preserves kcalloc. But note that if kcalloc returns NULL
> > then multiple conditions may have caused it. One is that the array is
> > simply too large. The other may be that such an allocation is not possible
> > due to fragmentation.
> [...]
> > +static inline long calculate_array_size(size_t n, size_t size)
> > +{
> > +	if (size != 0 && n > ULONG_MAX / size)
> > +
> > +		return 0;
>
> This isn't right.  The above tests whether or not the result of the
> multiplication will not be representable in an 'unsigned long'...

Yes and so does the current kcalloc.

> > +	return n * size;
>
> but then the result is assigned to a (signed) long, which may overflow
> if it's greater than LONG_MAX.

That can happen? But you are right its better to use the size_t as the
result of the argument. There is a gooh of long / size_t confusion
already. This useless function should not be in the kernel.


> > +}
> [...]
> >  void *kcalloc(size_t n, size_t size, gfp_t flags)
> >  {
> > -	if (size != 0 && n > ULONG_MAX / size)
> > -		return NULL;
> > -	return __kmalloc(n * size, flags | __GFP_ZERO);
> > +	size_t s = calculate_array_size(n, size);
> > +
> > +	if (s)
> > +		return kzalloc(s, flags);
> > +
> > +	return NULL;
> >  }
>
> This hunk changes the behaviour of kcalloc if either of the two size parameters
> is 0.

You want ZERO_PTR returns?

NULL is one permissible return value of calloc() if size == 0. So we are
now deviating from user space conventions.



Subject: Introduce calculate_array_size

calculate_array_size calculates the size of an array while
checking for errors. Returns 0 if the size is too large.

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 include/linux/slab.h |   15 +++++++++++++++
 mm/util.c            |    7 +++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/slab.h
===================================================================
--- linux-2.6.orig/include/linux/slab.h	2012-02-14 15:16:53.000000000 -0600
+++ linux-2.6/include/linux/slab.h	2012-02-14 15:21:39.000000000 -0600
@@ -242,6 +242,21 @@ size_t ksize(const void *);
  */
 void *kcalloc(size_t n, size_t size, gfp_t flags);

+/*
+ * calculate_array_size - Calculate an array size given the size of a
+ * particular element with checking for overflow.
+ *
+ * Return 0 if there is an overflow.
+ */
+static inline size_t calculate_array_size(size_t n, size_t size)
+{
+	if (n > ULONG_MAX / size)
+
+		return 0;
+
+	return n * size;
+}
+
 #if !defined(CONFIG_NUMA) && !defined(CONFIG_SLOB)
 /**
  * kmalloc_node - allocate memory from a specific node
Index: linux-2.6/mm/util.c
===================================================================
--- linux-2.6.orig/mm/util.c	2012-02-14 15:16:53.000000000 -0600
+++ linux-2.6/mm/util.c	2012-02-14 15:21:05.000000000 -0600
@@ -83,9 +83,12 @@ EXPORT_SYMBOL(kmemdup);
  */
 void *kcalloc(size_t n, size_t size, gfp_t flags)
 {
-	if (size != 0 && n > ULONG_MAX / size)
+	size_t s = calculate_array_size(n, size);
+
+	if (size && !s)
 		return NULL;
-	return __kmalloc(n * size, flags | __GFP_ZERO);
+
+	return kzalloc(s, flags);
 }
 EXPORT_SYMBOL(kcalloc);

