Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab1DYVIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 17:08:52 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:39331 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751200Ab1DYVIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 17:08:51 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: WCcOGWsVM1mCvvXTcNklSGjI.6nTE.W2f35EX.8WZZvsMvo
 S4lUMOHRQKnCaWx2YJeZmUJ728FrjFP7h5neLUSiddql9R49ZhF5rRs2_Ycr
 PmzJhYUZqRcaUekpE7.ejfyTLJ6saPWOS4SbnSTznukQ8X4tDDbTcU.kpL3u
 M8kaSWNZr5QVmKi7tVq1ATRHpscbcdVO5Asz5PXL4_S6wfBMh33JvPE4mOdk
 pD_ITmtvRj7vX2llTuGRh87YYZvNEEihOQ6r7MeWCT_I23Yhgz287UWs6bOf
 0ebm2_6rGbweBHE_g514_fmVY7OdsB5DakN6T6S23mNNBhCj2D1cGGuOwvZe
 UYcU7ChujpNJbMU26rG0q21RM
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 25 Apr 2011 16:08:48 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH 2/2] slub: Don't share struct kmem_cache for shared
 caches
In-Reply-To: <BANLkTinMC9HTjTKtGeJjG-6Gnz2w4FZvyw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1104251601150.13560@router.home>
References: <1303753608-19248-1-git-send-email-penberg@kernel.org> <1303753608-19248-2-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1104251407090.9646@router.home> <BANLkTinMC9HTjTKtGeJjG-6Gnz2w4FZvyw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Apr 2011, Pekka Enberg wrote:

> On Mon, 25 Apr 2011, Pekka Enberg wrote:
> >> This patch changes the slab cache sharing in SLUB to only share 'struct
> >> kmem_cpu_cache' which contains the actual list of slabs and object freelists.
> >> We no longer share 'struct kmem_cache' between merged caches so /proc/slabinfo
> >> statistics work as expected:
>
> On Mon, Apr 25, 2011 at 10:09 PM, Christoph Lameter <cl@linux.com> wrote:
> > I am a bit confused. Struct kmem_cache contains per slab
> > allocation information and all pages have pointers to struct kmem_cache.
> >
> > So we have pages now on the kmem_cache_cpu list with varying kmem_cache
> > pointers? How do we figure out which cache a page belongs to? It seems
> > that a page from one cache can be freed to the freelists of another.
>
> We share the freelist so it goes to the same freelist. However, I
> completely forgot about page to struct kmem_cache mapping so stats
> won't work properly.

How are the freelist shared? You would need to share kmem_cache_node too
to make this work but then you dont have counters per slab anymore.

The counters are in kmem_cache_cpu and kmem_cache_node. So why a
kmem_cache structure for separate stats?

> On Mon, Apr 25, 2011 at 10:09 PM, Christoph Lameter <cl@linux.com> wrote:
> > Does this even run right with the debugging enabled?
>
> It boots OK to minimal userspace under KVM with slub_debug. But no, I
> didn't test it properly yet.

Run a validation of all objects please. That should check the slab headers
for correct pointers back.

Also by having multiple kmem_cache * for a single kmem_cache_cpu/node
structure you end up with an elevated cacheline footprint.

