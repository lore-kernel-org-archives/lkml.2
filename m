Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab2J2Qpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:45:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55721 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804Ab2J2Qpi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:45:38 -0400
Message-ID: <1351529115.24721.40.camel@twins>
Subject: Re: [PATCH 2/2] dm: stay in blk_queue_bypass until queue becomes
 initialized
From: Peter Zijlstra <peterz@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Alasdair G Kergon <agk@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 29 Oct 2012 17:45:15 +0100
In-Reply-To: <20121029163845.GB7709@redhat.com>
References: <50890937.7010809@ce.jp.nec.com>
	 <20121026202105.GF24687@redhat.com> <508E572C.6000707@ce.jp.nec.com>
	 <20121029163845.GB7709@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 12:38 -0400, Vivek Goyal wrote:
> Ok, so the question is what's wrong with calling synchronize_rcu() inside
> a mutex with CONFIG_PREEMPT=y. I don't know. Ccing paul mckenney  and
> peterz.

int blkcg_activate_policy(struct request_queue *q,

{

	...

        preloaded = !radix_tree_preload(GFP_KERNEL);

        blk_queue_bypass_start(q);




where:

int radix_tree_preload(gfp_t gfp_mask)
{
        struct radix_tree_preload *rtp;
        struct radix_tree_node *node;
        int ret = -ENOMEM;
        
        preempt_disable();


Seems obvious why it explodes..
