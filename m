Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab2BHWZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 17:25:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663Ab2BHWZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 17:25:15 -0500
Date: Wed, 8 Feb 2012 14:25:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: integer overflows in kernel/relay.c
Message-Id: <20120208142513.4db2493a.akpm@linux-foundation.org>
In-Reply-To: <4F323388.7040902@kernel.dk>
References: <20120207141155.GA16184@elgon.mountain>
	<4F323388.7040902@kernel.dk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Feb 2012 09:34:16 +0100
Jens Axboe <axboe@kernel.dk> wrote:

> On 02/07/2012 03:11 PM, Dan Carpenter wrote:
> > My static checker is warning about integer overflows in kernel/relay.c
> > 
> > relay_create_buf()
> >    170  
> >    171          buf->padding = kmalloc(chan->n_subbufs * sizeof(size_t *), GFP_KERNEL);
> >                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > This can only overflow on 32bit systems.
> 
> Correct

This is a relatively common problem.  Converting a kzalloc() call to
kcalloc() fixes it.  But we do not have a non-zeroing version of
kcalloc().

Please, someone complete this patch and send it to me!


--- a/include/linux/slab.h~a
+++ a/include/linux/slab.h
@@ -240,11 +240,16 @@ size_t ksize(const void *);
  * for general use, and so are not documented here. For a full list of
  * potential flags, always refer to linux/gfp.h.
  */
-static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
+static inline void *wtf_do_i_call_this(size_t n, size_t size, gfp_t flags)
 {
 	if (size != 0 && n > ULONG_MAX / size)
 		return NULL;
-	return __kmalloc(n * size, flags | __GFP_ZERO);
+	return __kmalloc(n * size, flags);
+}
+
+static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
+{
+	return wtf_do_i_call_this(n, size, flags | __GFP_ZERO);
 }
 
 #if !defined(CONFIG_NUMA) && !defined(CONFIG_SLOB)
_

