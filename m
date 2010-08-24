Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab0HXNQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 09:16:10 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:59871 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab0HXNQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 09:16:08 -0400
Subject: Re: workqueue destruction BUG_ON
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4C73C425.20503@kernel.org>
References: <1282640156.3695.5.camel@jlt3.sipsolutions.net>
	 <4C739DC6.1040309@kernel.org>
	 <1282646268.3695.9.camel@jlt3.sipsolutions.net>
	 <4C73BC96.6000003@kernel.org>
	 <1282655414.3695.25.camel@jlt3.sipsolutions.net>
	 <4C73C425.20503@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 15:17:45 +0200
Message-ID: <1282655865.3695.27.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 15:07 +0200, Tejun Heo wrote:

> > [  500.874185] ------------[ cut here ]------------
> > [  500.875212] kernel BUG at kernel/workqueue.c:2849!
> 
> Are you sure you're running the patched kernel?  With the patch
> applied, the BUG_ON() wouldn't be on line 2849 (on both rc1 and 2).

Yes:

void destroy_workqueue(struct workqueue_struct *wq)
{
        unsigned int cpu;
   
        wq->flags |= WQ_DYING;
        flush_workqueue(wq);
  
        /*
         * wq list is used to freeze wq, remove from list after
         * flushing is complete in case freeze races us.
         */
        spin_lock(&workqueue_lock);
        list_del(&wq->list);
        spin_unlock(&workqueue_lock);

        /* sanity check */
        for_each_cwq_cpu(cpu, wq) {
                struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
                int i;

                for (i = 0; i < WORK_NR_COLORS; i++)
                        BUG_ON(cwq->nr_in_flight[i]);
2849:           BUG_ON(cwq->nr_active);
                BUG_ON(!list_empty(&cwq->delayed_works));


Applying the patch reported some offset, but the kernel is just rc1 +
wireless stuff.

johannes

