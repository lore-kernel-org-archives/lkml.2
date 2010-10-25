Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab0JYBwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 21:52:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59197 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752332Ab0JYBwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 21:52:17 -0400
Date: Sun, 24 Oct 2010 18:52:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Mike Frysinger <vapier@gentoo.org>, Luca Barbieri <luca@luca-barbieri.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/atomic64_test: do not build on non-atomic64 systems
Message-Id: <20101024185208.6a7e0648.akpm@linux-foundation.org>
In-Reply-To: <adavd4ro94d.fsf@cisco.com>
References: <1287250035-30404-1-git-send-email-vapier@gentoo.org>
	<20101021150250.f6499506.akpm@linux-foundation.org>
	<201010211823.38287.vapier@gentoo.org>
	<20101021155528.b3d6d027.akpm@linux-foundation.org>
	<AANLkTim6AFDw_1V9rtF4e_2tmgctbKHziQa-1e3=q7og@mail.gmail.com>
	<20101021162410.5c0d6720.akpm@linux-foundation.org>
	<AANLkTikGbK7=eW9L4A62Rin-E3usq4Ke_dPoCdStDyEw@mail.gmail.com>
	<20101022133138.6d82f79a.akpm@linux-foundation.org>
	<adavd4ro94d.fsf@cisco.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Oct 2010 09:20:34 -0700 Roland Dreier <rdreier@cisco.com> wrote:

>  > That's only part of the problem.  The following won't build also:
> 
>  > drivers/infiniband/hw
> 
> Interesting... I hadn't looked at that usage before.  Both drivers that
> seem to use atomic64 already depend on 64BIT in Kconfig, so I suspect
> the intersection of 64BIT and !ATOMIC64 is empty?
> 
> But eg drivers/infiniband/hw/qib/qib_rc.c does essentially:
> 
> 	atomic64_t *maddr;
> 	u64 sdata = <something>
> 	...
> 	maddr = (atomic64_t *) qp->r_sge.sge.vaddr;
> 	atomic64_add_return(sdata, maddr)
> 
> is it legit to cast some random address to atomic64_t and expect it to
> work across archs that implement atomic64?

Not really.  If someone implements atomic64 on 32-bit they may 
do it by putting a spinlock in the atomic64_t.  Or they might use
hashed spinlocks, in which case that'll work.

Probably hashed spinlocks, given the (realtively new) convention that
the all-zeroes pattern is a legit way of initialising an atomic_t.

