Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760169Ab1D2QcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 12:32:15 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:55849 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753125Ab1D2QcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 12:32:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WHmIwj372hTkll0rQmT6ksUj6qUdtcJNOvtYtPkkj4dPkQxGE9o1IQQ7At8fXSm6TPPheLYbJ06Kf4S9/hlnD7OX3MGOZXOkY+1V0RZQupGyo5mvyIDpRP4qPhOfXhTD;
Date: Fri, 29 Apr 2011 09:32:09 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Thomas Hellstrom <thellstrom@vmware.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Linaro-mm-sig] [RFC] ARM DMA mapping TODO, v1
Message-ID: <20110429093209.1926c732@jbarnes-desktop>
In-Reply-To: <20110429075958.GV17290@n2100.arm.linux.org.uk>
References: <201104212129.17013.arnd@arndb.de>
	<201104281428.56780.arnd@arndb.de>
	<20110428131531.GK17290@n2100.arm.linux.org.uk>
	<201104281629.52863.arnd@arndb.de>
	<20110428143440.GP17290@n2100.arm.linux.org.uk>
	<BANLkTinhm7ar1mf1D-dSMiLtw5hRNY36RA@mail.gmail.com>
	<1304036962.2513.202.camel@pasglop>
	<4DBA5194.7080609@vmware.com>
	<20110429075958.GV17290@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011 08:59:58 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Fri, Apr 29, 2011 at 07:50:12AM +0200, Thomas Hellstrom wrote:
> > However, we should be able to construct a completely generic api around  
> > these operations, and for architectures that don't support them we need  
> > to determine
> >
> > a)  Whether we want to support them anyway (IIRC the problem with PPC is  
> > that the linear kernel map has huge tlb entries that are very  
> > inefficient to break up?)
> 
> That same issue applies to ARM too - you'd need to stop the entire
> machine, rewrite all processes page tables, flush tlbs, and only
> then restart.  Otherwise there's the possibility of ending up with
> conflicting types of TLB entries, and I'm not sure what the effect
> of having two matching TLB entries for the same address would be.

Right, I don't think anyone wants to see this sort of thing happen with
any frequency.  So either a large, uncached region can be set up a boot
time for allocations, or infrequent, large requests and conversions can
be made on demand, with memory being freed back to the main, coherent
pool under pressure.

> > b)  Whether they are needed at all on the particular architecture. The  
> > Intel x86 spec is, (according to AMD), supposed to forbid conflicting  
> > caching attributes, but the Intel graphics guys use them for GEM. PPC  
> > appears not to need it.
> 
> Some versions of the architecture manual say that having multiple
> mappings with differing attributes is unpredictable.

Yes, there's a bit of abuse going on there.  We've received a guarantee
that if the CPU speculates a line into the cache, as long as it's not
modified through the cacheable mapping the CPU won't write it back to
memory; it'll discard the line as needed instead (iirc AMD CPUs will
actually write back clean lines, so GEM wouldn't work the same way
there).

But even with GEM, there is a large performance penalty for having to
allocate a new buffer object the first time.  Even though we don't have
to change mappings by stopping the machine etc, we still have to flush
out everything from the CPU relating to the object (since some lines
may be dirty), and then flush the memory controller buffers before
accessing it through the uncached mapping.  So at least currently,
we're all in the same boat when it comes to new object allocations:
they will be expensive unless you already have some uncached mappings
you can re-use.

-- 
Jesse Barnes, Intel Open Source Technology Center
