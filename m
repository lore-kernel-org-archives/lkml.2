Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065Ab2J2ROD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:14:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab2J2ROB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:14:01 -0400
Date: Mon, 29 Oct 2012 13:13:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Alasdair G Kergon <agk@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] dm: stay in blk_queue_bypass until queue becomes
 initialized
Message-ID: <20121029171346.GC3308@redhat.com>
References: <50890937.7010809@ce.jp.nec.com>
 <20121026202105.GF24687@redhat.com>
 <508E572C.6000707@ce.jp.nec.com>
 <20121029163845.GB7709@redhat.com>
 <1351529115.24721.40.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351529115.24721.40.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 05:45:15PM +0100, Peter Zijlstra wrote:
> On Mon, 2012-10-29 at 12:38 -0400, Vivek Goyal wrote:
> > Ok, so the question is what's wrong with calling synchronize_rcu() inside
> > a mutex with CONFIG_PREEMPT=y. I don't know. Ccing paul mckenney  and
> > peterz.
> 
> int blkcg_activate_policy(struct request_queue *q,
> 
> {
> 
> 	...
> 
>         preloaded = !radix_tree_preload(GFP_KERNEL);
> 
>         blk_queue_bypass_start(q);
> 
> 
> 
> 
> where:
> 
> int radix_tree_preload(gfp_t gfp_mask)
> {
>         struct radix_tree_preload *rtp;
>         struct radix_tree_node *node;
>         int ret = -ENOMEM;
>         
>         preempt_disable();
> 
> 
> Seems obvious why it explodes..

Oh right. Thanks Peter. So just calling blk_queue_bypass_start() before
radix_tree_preload() should fix it. Junichi, can you please give it
a try.

Thanks
Vivek
