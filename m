Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580Ab0DAB3N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 21:29:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758521Ab0DAB3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 21:29:09 -0400
Date: Wed, 31 Mar 2010 18:26:54 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, Yinghai Lu <yinghai@kernel.org>,
       Rabin Vincent <rabin@rab.in>, lkml <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi, linux-arch@vger.kernel.org
Subject: Re: start_kernel(): bug: interrupts were enabled early
Message-Id: <20100331182654.d36c87ff.akpm@linux-foundation.org>
In-Reply-To: <1270084631.7101.81.camel@pasglop>
References: <20100325194100.GA2364@debian>
	<20100331134048.da4e35a7.akpm@linux-foundation.org>
	<4BB3B4DB.7040904@kernel.org>
	<20100331210145.GB32165@parisc-linux.org>
	<4BB3B8FC.1020608@zytor.com>
	<20100331211754.GC32165@parisc-linux.org>
	<alpine.DEB.2.00.1003311640410.30456@router.home>
	<20100331215411.GB17715@flint.arm.linux.org.uk>
	<4BB3C540.9000405@zytor.com>
	<1270075071.7101.79.camel@pasglop>
	<20100331154955.54176e5e.akpm@linux-foundation.org>
	<1270084631.7101.81.camel@pasglop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Apr 2010 12:17:11 +1100 Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Wed, 2010-03-31 at 15:49 -0700, Andrew Morton wrote:
> > 
> > But these things are all utterly gross.  The bottom line is that
> > radix_tree_init() is manifestly unsuited to being called with local
> > interrupts disabled.  773e3eb7b81e5ba13b5155dfb3bb75b8ce37f8f9 was
> > just a wrong patch. 
> 
> Except that powerpc (and now it seems x86) both want to use radix trees
> for interrupt handling... At least on powerpc, we trick and use a linear
> search until the radix trees are initialized, which we do later during
> boot, but that somewhat sucks.
> 
> I believe sherry picking things like not calling radix_tree_init() is
> going to fix one case today, until we have another one, and another one,
> and etc...
> 
> I suspect we're better off fixing the root of the problem in down/up.
> 

Not by adding overhead to every single down_read()/down_write() just to
fix a once-off startup problem - that's taking laziness way too far.

We'd be better off hacking a kmem_cache_create() special case to avoid
taking the rwsem.  Add SLAB_I_SUCK to `flags' perhaps.

