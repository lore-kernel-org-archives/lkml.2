Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab0GIPMR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 11:12:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab0GIPMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 11:12:16 -0400
Date: Fri, 9 Jul 2010 17:12:11 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: mmu notifier calls in apply_to_page_range()
Message-ID: <20100709151211.GE13493@random.random>
References: <4C373AEC.6000502@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C373AEC.6000502@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 08:06:20AM -0700, Jeremy Fitzhardinge wrote:
> I just noticed that the original mmu notifier change (cddb8a5c14a) adds
> calls to mmu_notifier_invalidate_range_start/end to
> apply_to_page_range().  This doesn't seem correct to me, since
> apply_to_page_range can perform arbitrary operations to the range of
> pages, not just invalidation of the pages.  It seems to me that the
> appropriate mmu notifiers should be called either around the call to
> apply_to_page_range(), or from within the callback function.
> 
> Andrea, what's the rationale for mmu_notifier_invalidate_range_start/end
> here?

As long as the secondary mappings are teardown in range_start and
allowed to be established again only after range_end, all
modifications will be picked up by the secondary mmu. Imagine
secondary mmu like a tlb, that you only invalidate, then it'll be
refilled later (after range_end).

The exception is set_pte_at_notify that is called by ksm to establish
a readonly secondary pte in KVM, KVM only calls
get_user_pages(write=1) (never write=0 even for reads) so until that
is optimized set_pte_at_notify allows guest to access readonly data
without breaking the cow. set_pte_at_notify invokes a change_pte
method, if not implemented it'll just fallback to the invalidate_page
method that is backwards compatible, so no mmu notifier user is
required to call change_pte (especially if the secondary page fault -
kind of secondary tlb-miss software handler invokes get_user_pages
with write=0 for reads, ->change_pte can only eliminate one minor
fault so no big deal).
