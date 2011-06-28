Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab1F1K4o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 06:56:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37951 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874Ab1F1Kzl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 06:55:41 -0400
Subject: Re: [PATCH v3] futex: Fix regression with read only mappings
From: Peter Zijlstra <peterz@infradead.org>
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
Cc: Darren Hart <dvhart@linux.intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        eric.dumazet@gmail.com, david@rgmadvisors.com,
        linux-kernel@vger.kernel.org, zvonler@rgmadvisors.com,
        hughd@google.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1309213375-31471-1-git-send-email-sbohrer@rgmadvisors.com>
References: <4E08F893.10103@linux.intel.com>
	 <1309213375-31471-1-git-send-email-sbohrer@rgmadvisors.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 28 Jun 2011 12:54:35 +0200
Message-ID: <1309258475.6701.200.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-27 at 17:22 -0500, Shawn Bohrer wrote:
> commit 7485d0d3758e8e6491a5c9468114e74dc050785d (futexes: Remove rw
> parameter from get_futex_key()) in 2.6.33 introduced a user-mode
> regression in that it additionally prevented futex operations on a
> region within a read only memory mapped file.  For example this breaks
> workloads that have one or more reader processes doing a FUTEX_WAIT on a
> futex within a read only shared mapping, and a writer processes that has
> a writable mapping issuing the FUTEX_WAKE.
> 
> This fixes the regression for futex operations that should be valid on
> RO mappings by trying a RO get_user_pages_fast() when the RW
> get_user_pages_fast() fails so as not to slow down the common path of
> writable anonymous maps and bailing when we used the RO path on
> anonymous memory.
> 
> While fixing the regression this patch opens up two possible bad
> scenarios as identified by KOSAKI Motohiro:
> 
> 1) This patch also allows FUTEX_WAIT on RO private mappings which have
> the following corner case.
> 
>   Thread-A: call futex(FUTEX_WAIT, memory-region-A).
>             get_futex_key() return inode based key.
>             sleep on the key
>   Thread-B: call mprotect(PROT_READ|PROT_WRITE, memory-region-A)
>   Thread-B: write memory-region-A.
>             COW happen. This process's memory-region-A become related
>             to new COWed private (ie PageAnon=1) page.
>   Thread-B: call futex(FUETX_WAKE, memory-region-A).
>             get_futex_key() return mm based key.
>             IOW, we fail to wake up Thread-A.
> 
> 2) Current futex code doesn't handle zero page properly.
> 
>   Read mode get_user_pages() can return zero page, but current futex
>   code doesn't handle it at all. Then, zero page makes infinite loop
>   internally.
> 
> This Patch is based on Peter Zijlstra's initial patch with modifications to
> only allow RO mappings for futex operations that need VERIFY_READ access.
> 
> Reported-by: David Oliver <david@rgmadvisors.com>
> Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
