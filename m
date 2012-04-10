Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580Ab2DJLki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 07:40:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49870 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab2DJLkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 07:40:37 -0400
Date: Tue, 10 Apr 2012 20:40:31 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
Message-Id: <20120410204031.ffb5b976225ac9fe6dae474e@gmail.com>
In-Reply-To: <4F840DD2.3090101@redhat.com>
References: <4F742951.7080003@linux.vnet.ibm.com>
	<4F82E04E.6000900@redhat.com>
	<20120409175829.GB21894@amt.cnet>
	<4F8329D3.7000605@gmail.com>
	<20120409194614.GB23053@amt.cnet>
	<4F840DD2.3090101@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2012 13:39:14 +0300
Avi Kivity <avi@redhat.com> wrote:

> On 04/09/2012 10:46 PM, Marcelo Tosatti wrote:
> > Perhaps the mmu_lock hold times by get_dirty are a large component here?
> > If that can be alleviated, not only RO->RW faults benefit.
> >
> >
> 
> Currently the longest holder in normal use is probably reading the dirty
> log and write protecting the shadow page tables.
> 
> We could fix that by switching to O(1) write protection
> (write-protecting PML4Es instead of PTEs).  It would be interesting to
> combine O(1) write protection with lockless write-enabling.
> 

As Marcelo suggested during reviewing srcu-less dirty logging, we can
mitigate the get_dirty's mmu_lock hold time problem cleanly, locally in
get_dirty_log(), by using cond_resched_lock() -- although we need to
introduce cond_rescheck_lock_cb() to conditionally flush TLB.

I have already started that work.

Actually I introduced rmap based get_dirty for that kind of fine-grained
contention control.

I think we should do our best not to affect mmu so much just for the
limited time of live migration.

	Takuya
