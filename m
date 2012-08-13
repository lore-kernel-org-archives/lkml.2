Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab2HMDcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 23:32:48 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50941 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab2HMDcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 23:32:47 -0400
Date: Sun, 12 Aug 2012 23:32:44 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Cyril Chemparathy <cyril@ti.com>
cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 03/22] ARM: use late patch framework for phys-virt
 patching
In-Reply-To: <5027E90E.2000604@ti.com>
Message-ID: <alpine.LFD.2.02.1208122320310.5231@xanadu.home>
References: <1344648306-15619-1-git-send-email-cyril@ti.com> <1344648306-15619-4-git-send-email-cyril@ti.com> <alpine.LFD.2.02.1208112238270.5231@xanadu.home> <5027E90E.2000604@ti.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2012, Cyril Chemparathy wrote:

> On 08/11/12 23:03, Nicolas Pitre wrote:
> > On Fri, 10 Aug 2012, Cyril Chemparathy wrote:
> > 
> > > -extern unsigned long __pv_phys_offset;
> > > -#define PHYS_OFFSET __pv_phys_offset
> [...]
> > > +#define PHYS_OFFSET	__virt_to_phys(PAGE_OFFSET)
> > 
> > What was wrong with the former PHYS_OFFSET = __pv_phys_offset ?
> > 
> > If you really want to have it optimized at run time, you could simply
> > use your new stub to patch a mov instruction instead of going through
> > __virt_to_phys which uses and add on top of a constant.
> > 
> 
> The intent was to optimize out the load(s) on references to PHYS_OFFSET, but
> is it worth it?  If so, we could go with a patched mov (or two) with the
> necessary endian fixups.  If not, we could revert to __pv_phys_offset loads as
> before.

If you want to do better than the load, then you'd better go all the way 
with the patched move.

> > You also should remove the MODULE_ARCH_VERMAGIC_P2V definitions now that
> > the corresponding code is no longer there.
> > 
> 
> Hmm...
> 
> "rt-patch" needs to be in vermagic to prevent modules built against the new
> code from being loaded on older kernels that used the traditional patch code.

Right.

> "p2v" needs to be in there as well, because it should be possible to build
> without PATCH_PHYS_VIRT, but with RUNTIME_PATCH as and when there are other
> users for this.

That doesn't matter if there are other users.  As soon as there is a 
.init.runtime_patch_table that needs to be processed then "rt-patch" 
flags it.  Whether this is used for PATCH_PHYS_VIRT or other purposes is 
irrelevant.

However there isn't any pv_table anymore, so "p2v" should go as there is 
no more code to process those tables if they're ever encountered.


Nicolas
