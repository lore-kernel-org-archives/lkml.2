Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721Ab2HUWCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 18:02:23 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33500 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758697Ab2HUWCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 18:02:20 -0400
Date: Tue, 21 Aug 2012 23:01:45 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 17/31] arm64: System calls handling
Message-ID: <20120821220145.GA27934@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <201208151422.16335.arnd@arndb.de>
 <20120821175122.GI12708@arm.com>
 <201208212014.01837.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208212014.01837.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 09:14:01PM +0100, Arnd Bergmann wrote:
> On Tuesday 21 August 2012, Catalin Marinas wrote:
> > > > +asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
> > > > +                    unsigned long prot, unsigned long flags,
> > > > +                    unsigned long fd, off_t off)
> > > > +{
> > > > +   if (offset_in_page(off) != 0)
> > > > +           return -EINVAL;
> > > > +
> > > > +   return sys_mmap_pgoff(addr, len, prot, flags, fd, off >> PAGE_SHIFT);
> > > > +}
> > > 
> > > I think
> > > 
> > > #define sys_mmap sys_mmap_pgoff 
> > 
> > There are slightly different semantics with the last argument of
> > sys_mmap() which takes a byte offset. The sys_mmap_pgoff() function
> > takes the offset shifted by PAGE_SHIFT (which is the same as sys_mmap2).
> > 
> > Looking at the other architectures, it makes sense to use a generic
> > sys_mmap() implementation similar to the one above (or the ia-64, seems
> > to be the most complete).
> 
> Why that? The generic sys_mmap_pgoff was specifically added so new architectures
> could just use that instead of having their own wrappers, see f8b72560.

As I understand, sys_mmap_pgoff can be used instead of sys_mmap2 on new
32-bit architectures. But on 64-bit architectures we don't have
sys_mmap2, only sys_mmap with the difference that the last argument is
the offset in bytes (and multiple of PAGE_SIZE) rather than in pages. So
unless we change the meaning of this last argument for sys_mmap, we
cannot just define it to sys_mmap_pgoff.

Since the other 64-bit architectures seem to have a sys_mmap wrapper
that does this:

	sys_mmap_pgoff(..., off >> PAGE_SHIFT);

I think AArch64 should also use the same sys_mmap convention. We can
make this wrapper generic.

-- 
Catalin
