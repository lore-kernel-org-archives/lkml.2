Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805Ab0GIQXE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 12:23:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab0GIQXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 12:23:02 -0400
Date: Fri, 9 Jul 2010 18:22:55 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: mmu notifier calls in apply_to_page_range()
Message-ID: <20100709162255.GA5741@random.random>
References: <4C373AEC.6000502@goop.org>
 <20100709151211.GE13493@random.random>
 <4C37458B.8040408@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C37458B.8040408@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 08:51:39AM -0700, Jeremy Fitzhardinge wrote:
> Yes, but apply_to_page_range isn't necessarily making changes which
> requires that teardown/refill.  The most common user is vmalloc, which
> is just using a side-effect of apply_to_page_range to make sure that all
> the intermediate levels of the pagetable are allocated over the
> vmalloced range.  I think all the other users of it are within Xen code.
> In particular, we're using it in the gntdev driver, which also uses mmu
> notifiers to keep grant mappings in sync with process mappings, so the
> recursive mmu notifier call is causing problems.
> 
> It seems to me that apply_to_page_range should be agnostic to its use,
> and its up to its callers to do any appropriate mmu notifier work. 
> Would you be happy with a patch to remove those calls?

mmu notifier only relevant for userland mappings, not kernel
mappings. I don't know about the xen use, but for vmalloc certainly it
can't be a problem to remove those two mmu notifier invalidates.

Only bit that is worrysome is the mm == &init_mm
pte_alloc_kernel|pte_alloc_map_lock. That seems to imply it may also
be used to mangle over userland. But apparently all users are passing
&init_mm as expected. I guess if you remove the mm parameter and you
default to &init_mm definitely there will be no risk in removing the
mmu notifier range_start/end invalidates.
