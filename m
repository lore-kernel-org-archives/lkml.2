Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab1AaHVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 02:21:31 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:58873 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750912Ab1AaHVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 02:21:30 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18QRZ4ygoQQzQ7YLXbpYECDA416QVrcnNprzosVx2
	/e6AdPoYw5JTRu
Subject: Re: call_function_many: fix list delete vs add race
From: Mike Galbraith <efault@gmx.de>
To: Milton Miller <miltonm@bga.com>
Cc: Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
        Anton Blanchard <anton@samba.org>, xiaoguangrong@cn.fujitsu.com,
        mingo@elte.hu, jaxboe@fusionio.com, npiggin@gmail.com,
        rusty@rustcorp.com.au, torvalds@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, benh@kernel.crashing.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <smp-call-function-list-race-fix@mdm.bga.com>
References: <20110112150740.77dde58c@kryten>
	 <1295288253.30950.280.camel@laptop>
	 <smp-call-function-peter-reply@mdm.bga.com>
	 <smp-call-function-move-writes@mdm.bga.com>
	 <1296145360.15234.234.camel@laptop>
	 <smp-call-function-list-race@mdm.bga.com>
	 <smp-call-function-list-race-fix@mdm.bga.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 08:21:22 +0100
Message-ID: <1296458482.7889.175.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 18:20 -0600, Milton Miller wrote:
> Peter pointed out there was nothing preventing the list_del_rcu in
> smp_call_function_interrupt from running before the list_add_rcu in
> smp_call_function_many.   Fix this by not setting refs until we have put
> the entry on the list.  We can use the lock acquire and release instead
> of a wmb.

Wondering if a final sanity check makes sense.  I've got a perma-spin
bug where comment apparently happened.  Another CPU's diddle the mask
IPI may make this CPU do horrible things to itself as it's setting up to
IPI others with that mask.

---
 kernel/smp.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.38.git/kernel/smp.c
===================================================================
--- linux-2.6.38.git.orig/kernel/smp.c
+++ linux-2.6.38.git/kernel/smp.c
@@ -490,6 +490,9 @@ void smp_call_function_many(const struct
 	cpumask_and(data->cpumask, mask, cpu_online_mask);
 	cpumask_clear_cpu(this_cpu, data->cpumask);
 
+	/* Did you pass me a mask that can be changed/emptied under me? */
+	BUG_ON(cpumask_empty(data->cpumask));
+
 	/*
 	 * We reuse the call function data without waiting for any grace
 	 * period after some other cpu removes it from the global queue.



