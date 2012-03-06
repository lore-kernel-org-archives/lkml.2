Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030624Ab2CFPXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 10:23:25 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:63759 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030372Ab2CFPXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 10:23:23 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of takuya.yoshikawa@gmail.com designates 10.182.216.41 as permitted sender) smtp.mail=takuya.yoshikawa@gmail.com; dkim=pass header.i=takuya.yoshikawa@gmail.com
Date: Wed, 7 Mar 2012 00:23:17 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>, avi@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4 changelog-v2] KVM: Switch to srcu-less
 get_dirty_log()
Message-Id: <20120307002317.d8682de9c6ccd6af8ccac467@gmail.com>
In-Reply-To: <20120306150104.GA3041@amt.cnet>
References: <20120301193007.04b2db8e.yoshikawa.takuya@oss.ntt.co.jp>
	<20120301193316.96682d60.yoshikawa.takuya@oss.ntt.co.jp>
	<20120303142148.2689454b30dc86d84c4a19f5@gmail.com>
	<20120306111540.GA29914@amt.cnet>
	<20120306234317.2817d2071038d11ab3831c82@gmail.com>
	<20120306150104.GA3041@amt.cnet>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcelo Tosatti <mtosatti@redhat.com> wrote:

> > If we do not mind scanning the bitmap twice, we can decouple the
> > xchg loop and write protection, but it will be a bit slower, and in
> > any case we need to hold mmu_lock until TLB is flushed.
> 
> Why is it necessary to scan twice? Simply continuing to the next set 
> of pages, after dropping the lock, should be enough.

We cannot drop the lock.
Do you mean doing TLB flush each time before dropping the lock?

> The potential problem i am referring to is:
> 
> - kvm.git next + srcu-less series
> average(ns)    stdev     ns/page    pages    improvement(%)
> 
> 8497356.4    16441.0        32.4     256K     -29
> 
> So 8ms for 1GB. Assuming it increases linearly, it would take 
> 400ms for get_dirty on a 50GB slot (most of that time spent 
> with mmu_lock held). Is this correct?

Partly yes: my method mainly depends on the number of dirty pages,
not slot size.

But it is not a new problem: traversing all shadow pages for that
also takes linearly increasing time.

If that 1GB dirty memory is in a 50GB slot, my method will alleviate
the latency really a lot compared to the current way.  I do not want
to imagine checking every shadow page in such a huge slot.

Checking pages found in the dirty bitmap only should be better.

	Takuya
