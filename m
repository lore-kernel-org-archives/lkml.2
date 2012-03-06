Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030868Ab2CFPbg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 10:31:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030447Ab2CFPbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 10:31:35 -0500
Date: Tue, 6 Mar 2012 12:28:50 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>, avi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 changelog-v2] KVM: Switch to srcu-less get_dirty_log()
Message-ID: <20120306152850.GB3353@amt.cnet>
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp>
 <20120301193316.96682d60.yoshikawa.takuya@oss.ntt.co.jp>
 <20120303142148.2689454b30dc86d84c4a19f5@gmail.com>
 <20120306111540.GA29914@amt.cnet>
 <20120306234317.2817d2071038d11ab3831c82@gmail.com>
 <20120306150104.GA3041@amt.cnet>
 <20120307002317.d8682de9c6ccd6af8ccac467@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307002317.d8682de9c6ccd6af8ccac467@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 12:23:17AM +0900, Takuya Yoshikawa wrote:
> Marcelo Tosatti <mtosatti@redhat.com> wrote:
> 
> > > If we do not mind scanning the bitmap twice, we can decouple the
> > > xchg loop and write protection, but it will be a bit slower, and in
> > > any case we need to hold mmu_lock until TLB is flushed.
> > 
> > Why is it necessary to scan twice? Simply continuing to the next set 
> > of pages, after dropping the lock, should be enough.
> 
> We cannot drop the lock.
> Do you mean doing TLB flush each time before dropping the lock?

Yes, only if there is contention (see cond_resched_lock).

> > The potential problem i am referring to is:
> > 
> > - kvm.git next + srcu-less series
> > average(ns)    stdev     ns/page    pages    improvement(%)
> > 
> > 8497356.4    16441.0        32.4     256K     -29
> > 
> > So 8ms for 1GB. Assuming it increases linearly, it would take 
> > 400ms for get_dirty on a 50GB slot (most of that time spent 
> > with mmu_lock held). Is this correct?
> 
> Partly yes: my method mainly depends on the number of dirty pages,
> not slot size.
> 
> But it is not a new problem: traversing all shadow pages for that
> also takes linearly increasing time.

It was not necessary to read the bitmap under mmu_lock previously.

> If that 1GB dirty memory is in a 50GB slot, my method will alleviate
> the latency really a lot compared to the current way.  I do not want
> to imagine checking every shadow page in such a huge slot.
> 
> Checking pages found in the dirty bitmap only should be better.
> 
> 	Takuya
