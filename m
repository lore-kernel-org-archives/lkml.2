Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab2D2IuL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 04:50:11 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:41455 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2D2IuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 04:50:09 -0400
Date: Sun, 29 Apr 2012 17:50:04 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] KVM: MMU: fast path of handling guest page
 fault
Message-Id: <20120429175004.b54d8c095a60d98c8cdbc942@gmail.com>
In-Reply-To: <20120427145213.GB28796@amt.cnet>
References: <4F9776D2.7020506@linux.vnet.ibm.com>
	<4F9777A4.208@linux.vnet.ibm.com>
	<20120426234535.GA5057@amt.cnet>
	<4F9A3445.2060305@linux.vnet.ibm.com>
	<20120427145213.GB28796@amt.cnet>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Apr 2012 11:52:13 -0300
Marcelo Tosatti <mtosatti@redhat.com> wrote:

> Yes but the objective you are aiming for is to read and write sptes
> without mmu_lock. That is, i am not talking about this patch. 
> Please read carefully the two examples i gave (separated by "example)").

The real objective is not still clear.

The ~10% improvement reported before was on macro benchmarks during live
migration.  At least, that optimization was the initial objective.

But at some point, the objective suddenly changed to "lock-less" without
understanding what introduced the original improvement.

Was the problem really mmu_lock contention?

If the path being introduced by this patch is really fast, isn't it
possible to achieve the same improvement still using mmu_lock?


Note: During live migration, the fact that the guest gets faulted is
itself a limitation.  We could easily see noticeable slowdown of a
program even if it runs only between two GET_DIRTY_LOGs.


> The rules for code under mmu_lock should be:
> 
> 1) Spte updates under mmu lock must always be atomic and 
> with locked instructions.
> 2) Spte values must be read once, and appropriate action
> must be taken when writing them back in case their value 
> has changed (remote TLB flush might be required).

Although I am not certain about what will be really needed in the
final form, if this kind of maybe-needed-overhead is going to be
added little by little, I worry about possible regression.

Thanks,
	Takuya
