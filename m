Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab2K2RJH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 12:09:07 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:44274 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734Ab2K2RJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 12:09:05 -0500
Date: Thu, 29 Nov 2012 09:02:41 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel/rcutree.c:2850:13: warning: array subscript is above
 array bounds
Message-ID: <20121129170241.GT2474@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121129134752.GB219@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121129134752.GB219@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112917-2876-0000-0000-0000028EA9A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 02:47:52PM +0100, Markus Trippelsdorf wrote:
> With gcc-4.8 I get:
> 
>   CC      kernel/rcutree.o
>   kernel/rcutree.c: In function ‘rcu_init_one’:
>   kernel/rcutree.c:2850:13: warning: array subscript is above array bounds [-Warray-bounds]
>      rsp->level[i] = rsp->level[i - 1] + rsp->levelcnt[i - 1];
>                   ^
> 2849    for (i = 1; i < rcu_num_lvls; i++)
> 2850           rsp->level[i] = rsp->level[i - 1] + rsp->levelcnt[i - 1];
> 
> At first I thought that the warning was bogus, but rcu_num_lvls isn't static
> and gets modified prior to the for loop.

You are quite correct that rcu_num_lvls does get modified, but there
are checks in rcu_init_geometry() to ensure that it does not increase:

	/*
	 * The boot-time rcu_fanout_leaf parameter is only permitted
	 * to increase the leaf-level fanout, not decrease it.  Of course,
	 * the leaf-level fanout cannot exceed the number of bits in
	 * the rcu_node masks.  Finally, the tree must be able to accommodate
	 * the configured number of CPUs.  Complain and fall back to the
	 * compile-time values if these limits are exceeded.
	 */
	if (rcu_fanout_leaf < CONFIG_RCU_FANOUT_LEAF ||
	    rcu_fanout_leaf > sizeof(unsigned long) * 8 ||
	    n > rcu_capacity[MAX_RCU_LVLS]) {
		WARN_ON(1);
		return;
	}

The value of rcu_num_lvls starts out at RCU_NUM_LVLS, the same as
the dimension of the ->level[] array.  The loop goes only to one less
than rcu_num_lvls, as needed, and rcu_num_lvls is never greater than
RCU_NUM_LVLS, so this should be safe.

So what am I missing here?

							Thanx, Paul

