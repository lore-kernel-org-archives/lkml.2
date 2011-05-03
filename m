Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab1ECWqZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 18:46:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:22757 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab1ECWqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 18:46:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=u+y8yQPZ06lVwSEBgR4kMikp9eKg9Uj1q131SYLdu6Uy+yQP4pdOlJW67R2DsxAC4J
         4NCGm/1QPWkLf8O664xg==
Date: Tue, 3 May 2011 15:46:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ben Hutchings <ben@decadent.org.uk>
cc: James Bottomley <James.Bottomley@suse.de>,
        Michael Schmitz <schmitzmic@googlemail.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Pekka Enberg <penberg@kernel.org>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@suse.de>
Subject: Re: [Stable-review] [36/55] [PARISC] slub: fix panic with
 DISCONTIGMEM
In-Reply-To: <1304366677.2833.170.camel@localhost>
Message-ID: <alpine.DEB.2.00.1105031544240.27795@chino.kir.corp.google.com>
References: <20110429185656.051229285@clark.kroah.org> <1304366677.2833.170.camel@localhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 May 2011, Ben Hutchings wrote:

> > From: James Bottomley <James.Bottomley@HansenPartnership.com>
> > 
> > commit 4a5fa3590f09999f6db41bc386bce40848fa9f63 upstream.
> > 
> > Slub makes assumptions about page_to_nid() which are violated by
> > DISCONTIGMEM and !NUMA.  This violation results in a panic because
> > page_to_nid() can be non-zero for pages in the discontiguous ranges and
> > this leads to a null return by get_node().  The assertion by the
> > maintainer is that DISCONTIGMEM should only be allowed when NUMA is also
> > defined.  However, at least six architectures: alpha, ia64, m32r, m68k,
> > mips, parisc violate this.  The panic is a regression against slab, so
> > just mark slub broken in the problem configuration to prevent users
> > reporting these panics.
> 
> This stable series also included the patches:
> 
> commit 6a682f634ba9615d3498d1e20a23e9d4fcb39f16
> Author: David Rientjes <rientjes@google.com>
> Date:   Wed Apr 20 19:27:13 2011 -0700
> 
>     set memory ranges in N_NORMAL_MEMORY when onlined
>     
>     commit d9b41e0b54fd7e164daf1e9c539c1070398aa02e upstream.
> 
> commit 8858587af25efc06d5cce42676786b3d7a9160f2
> Author: Michael Schmitz <schmitzmic@googlemail.com>
> Date:   Tue Apr 26 14:51:53 2011 +1200
> 
>     m68k/mm: Set all online nodes in N_NORMAL_MEMORY
>     
>     commit 4aac0b4815ba592052758f4b468f253d383dc9d6 upstream.
> 
> which look like they're supposed to make slub work on these two
> architectures (parisc and m68k).  Do they?  If not, do they fix a
> different problem?
> 

SLUB relies heavily on N_NORMAL_MEMORY, so these two patches fix that 
allocator but the problem is actually not just isolated to that subsystem; 
it fixes an issue with anything that uses N_NORMAL_MEMORY.

The former patch sets the nodes correctly for parisc and Michael's patch 
sets the nodes correctly for m68k, so it's the same fix for two different 
previously-broken architectures.
