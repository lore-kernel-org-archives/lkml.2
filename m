Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab0JNXap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 19:30:45 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58486 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab0JNXao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 19:30:44 -0400
Date: Thu, 14 Oct 2010 16:30:41 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] blk: fix a wrong accounting of hd_struct->in_flight
Message-ID: <20101014233041.GJ2447@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4CB40281.1020403@jp.fujitsu.com>
 <20101014150742.F9EC.A69D9226@jp.fujitsu.com>
 <4CB6FB30.1000502@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB6FB30.1000502@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 02:44:32PM +0200, Jens Axboe wrote:
> On 2010-10-14 08:07, KOSAKI Motohiro wrote:
> >> @@ -1268,7 +1270,17 @@ static int __make_request(struct request
> >>  		 * not touch req->buffer either...
> >>  		 */
> >>  		req->buffer = bio_data(bio);
> >> +		src_part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
> >>  		req->__sector = bio->bi_sector;
> >> +		dst_part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
> > 
> > I think this is wrong. disk_map_sector_rcu() require
> > rcu read lock held (see function comment). all other call site take 
> > part_stat_lock() before disk_map_sector_rcu() call.
> 
> It's called under the queue lock with irqs disabled, which implies a
> rcu critical section.

Having irqs disabled does imply an rcu_read_lock_sched() or an
rcu_read_lock_bh(), but not an rcu_read_lock(), especially if
CONFIG_PREEMPT_RCU.

So an explicit rcu_read_lock() does seem to be needed here.

							Thanx, Paul
