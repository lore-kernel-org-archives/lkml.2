Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab2IMUOw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 16:14:52 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54375 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051Ab2IMUOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 16:14:48 -0400
Date: Thu, 13 Sep 2012 22:14:44 +0200
From: Simon Baatz <gmbnomis@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Simon Baatz <gmbnomis@gmail.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 09/31] arm64: Cache maintenance routines
Message-ID: <20120913201444.GA11692@schnuecks.de>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <1347035226-18649-10-git-send-email-catalin.marinas@arm.com>
 <20120907193542.GA22806@schnuecks.de>
 <20120912092954.GA21823@arm.com>
 <20120912215553.GA17393@schnuecks.de>
 <20120913123850.GB25131@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913123850.GB25131@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 01:38:50PM +0100, Catalin Marinas wrote:
> On Wed, Sep 12, 2012 at 10:55:54PM +0100, Simon Baatz wrote:
> > On Wed, Sep 12, 2012 at 10:29:54AM +0100, Catalin Marinas wrote:
> ...
> 
> > In case of direct I/O (and probably also in other cases like SG_IO)
> > the block layer will see pages from get_user_pages() directly, i.e.
> > also anonymous pages. Many drivers (especially emulated storage
> > drivers like dm-crypt) use flush_dcache_page() after modifying a
> > page. Although flush_dcache_page() is not even supposed to handle
> > anonymous pages, it flushes the kernel mapping of the page because of
> > this code line and everything is well on aliasing D-caches.
> 
> According to the cachetlb.txt document (though not sure architecture
> ports follow it entirely), flush_dcache_page() deliberately shouldn't
> follow anonymous pages. But it seems that we do it on ARM (maybe as an
> alternative to flush_kernel_dcache_page()).
> 
> > Back to arm64 (and possibly to arm with non-aliasing D-caches?), this
> > also means that the saved D-cache flush in the anonymous page case is
> > not only a slight improvement on clarity, but may avoid a
> > considerable number of D-cache flushes in some I/O situations.  (If
> > it is still correct that there are no problems with the I-cache for
> > this use case.)
> 
> The I-cache would be needed if the kernel modifies an executable user
> page. But I don't see a case for this yet. So with non-aliasing D-cache
> the flush_kernel_dcache_page() can be a nop.

Ok, this is true for anon pages. But, if we really need to do the D/I
flush for user mapped page cache pages in flush_dcache_page() then it
should also be done by flush_kernel_dcache_page().  In general, both
flush_dcache_page() and flush_kernel_dcache_page() need to handle the
case in which the kernel modifies such a page. (This means that in
effect, both functions should be the same in the arm64 case.)

> > If now we could additionally avoid to flush the entire I-cache for
> > every page in direct I/O operations with user mapped page cache
> > pages (e.g. direct I/O read into an mmap region)...
> 
> If the page is already mapped, we don't have a later hook to be able to
> flush the caches, so we do it here. We can avoid the I-cache operation
> only if we are sure that the user would not execute code from such page.
> IOW the direct I/O wouldn't write any instructions.
> 
> The powerpc implementation of flush_dcache_page() doesn't even check for
> the existence of a mapping, it always marks the page as dirty. We can do
> the same on arm64 (only leave the clear_bit part of the condition) as
> long as we know that the kernel wouldn't write new code into a page that
> is already mapped.

Yes, but how do we know?


- Simon
