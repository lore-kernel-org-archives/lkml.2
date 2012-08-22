Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab2HVKac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 06:30:32 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57883 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755035Ab2HVKa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 06:30:28 -0400
Date: Wed, 22 Aug 2012 11:29:53 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 17/31] arm64: System calls handling
Message-ID: <20120822102953.GA24136@arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <201208212014.01837.arnd@arndb.de>
 <20120821220145.GA27934@arm.com>
 <201208220756.31149.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201208220756.31149.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 08:56:30AM +0100, Arnd Bergmann wrote:
> On Tuesday 21 August 2012, Catalin Marinas wrote:
> > As I understand, sys_mmap_pgoff can be used instead of sys_mmap2 on new
> > 32-bit architectures. But on 64-bit architectures we don't have
> > sys_mmap2, only sys_mmap with the difference that the last argument is
> > the offset in bytes (and multiple of PAGE_SIZE) rather than in pages. So
> > unless we change the meaning of this last argument for sys_mmap, we
> > cannot just define it to sys_mmap_pgoff.
> > 
> > Since the other 64-bit architectures seem to have a sys_mmap wrapper
> > that does this:
> > 
> >         sys_mmap_pgoff(..., off >> PAGE_SHIFT);
> > 
> > I think AArch64 should also use the same sys_mmap convention. We can
> > make this wrapper generic.
> 
> But the wrapper can just as well be part of glibc, which already has
> one. There is no reason for the kernel to export two generic interfaces
> for mmap when one of them only works on 64 bit and the other one is
> good for both 32 and 64 bit.

The kernel only exports a single interface for 64-bit, that's
sys_mmap(). For compat we only export sys_mmap2() (which, of course,
would not work for 64-bit).

The generic prototypes for sys_mmap and sys_mmap2 are different with
regards to the last argument: off_t vs unsigned long. While in practice
it's the same size, off_t is used throughout the kernel as offset in
bytes rather than pages (hence the prototype change in sys_mmap2 and
sys_mmap_pgoff).

But what's more important - moving this wrapper to glibc causes issues
with the page size. We support both 4KB and 64KB pages on 64-bit systems
(the latter without compat support). The kernel is in a better position
to do the shift by a compile-time constant. Glibc would need to enquire
the actual page size to do the shift before calling sys_mmap_pgoff. If
we assume in glibc that the shift is always 12, we need another wrapper
in the kernel anyway for 64KB page configuration. So passing the offset
in bytes worked best for us.

> All the other 64 bit architectures (besides tile) were added to the
> kernel before we had sys_mmap_pgoff.

So there is no new 64-bit architecture that defines sys_mmap to
sys_mmap_pgoff. I don't think that AArch64 should introduce this, given
the restrictions I mentioned above. sys_mmap2/sys_mmap_pgoff are a way
to extend the file offset beyond 32-bit but that's not needed on a
64-bit system.

-- 
Catalin
