Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab2ICLso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 07:48:44 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41585 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754327Ab2ICLsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 07:48:42 -0400
Date: Mon, 3 Sep 2012 12:48:31 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH v2 17/31] arm64: System calls handling
Message-ID: <20120903114831.GA3313@mbp>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <201208220756.31149.arnd@arndb.de>
 <20120822102953.GA24136@arm.com>
 <201208221227.14274.arnd@arndb.de>
 <20120822171309.GC2582@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822171309.GC2582@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Wed, Aug 22, 2012 at 06:13:10PM +0100, Catalin Marinas wrote:
> On Wed, Aug 22, 2012 at 01:27:14PM +0100, Arnd Bergmann wrote:
> > On Wednesday 22 August 2012, Catalin Marinas wrote:
> > > But what's more important - moving this wrapper to glibc causes issues
> > > with the page size. We support both 4KB and 64KB pages on 64-bit systems
> > > (the latter without compat support). The kernel is in a better position
> > > to do the shift by a compile-time constant. Glibc would need to enquire
> > > the actual page size to do the shift before calling sys_mmap_pgoff. If
> > > we assume in glibc that the shift is always 12, we need another wrapper
> > > in the kernel anyway for 64KB page configuration. So passing the offset
> > > in bytes worked best for us.
> > 
> > Right, the kernel interface should really be independent of the page
> > size, as sys_mmap2 normally is, and sys_mmap2 is not provided here.
> 
> sys_mmap2 is indeed independent of the page size on most architectures
> assuming that the last argument represents the offset in units of 4096.
> The cris and ia64 seem to differ (one being 8K, the other variable).
> 
> sys_mmap is also independent of the page size.
> 
> But using sys_mmap2 for a 64-bit architecture, especially when the page
> size is not always 4K, does not bring any advantages. We end up doing a
> shift by 12 in glibc and another shift by (PAGE_SHIFT - 12) in the
> kernel wrapper. Unless I missed your point, I don't see the reason for
> using sys_mmap2 on a 64-bit architecture, apart from it being newer (and
> compat support should not have any relevance, we have different syscall
> tables anyway).

I forgot about this at the KS and we haven't got to a clear conclusion.

Do we (1) stick with the sys_mmap() for 64-bit systems and avoid offset
conversion in both glibc and kernel or (2) use sys_mmap2() with a 12
shift in glibc and (PAGE_SHIFT - 12) in the kernel wrapper?

I personally prefer (1) as it doesn't require a kernel wrapper and we
avoid the double shifting. A reason for (2) would be if we ever need
file offsets greater than 16EB.

-- 
Catalin
