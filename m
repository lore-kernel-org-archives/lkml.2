Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933980Ab1ESSof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:44:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933814Ab1ESSod (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:44:33 -0400
Date: Thu, 19 May 2011 14:44:31 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dpshah@google.com" <dpshah@google.com>
Subject: Re: [RFC PATCH 00/14] blk-throttle: lockless bio processing for no
 throttle rule group
Message-ID: <20110519184431.GE12600@redhat.com>
References: <1305746006-5837-1-git-send-email-vgoyal@redhat.com>
 <4DD56266.7090209@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD56266.7090209@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 08:33:10PM +0200, Jens Axboe wrote:
> On 2011-05-18 21:13, Vivek Goyal wrote:
> > Hi,
> > 
> > Block throttling code takes request queue lock for every incoming bio
> > (blk_throtl_bio()). This is true even if there are no throttle rules in
> > the group. This is a common case for root cgroup where distributions
> > will have throttling support compiled in but a vast majority of users
> > will not be specifying throttling rule.
> > 
> > This patch series tries to make bio processing lockless (no requeust
> > queue lock), if there are no rules specified for the group. Once
> > a bio is submitted, under rcu_read_lock() we search for the group, 
> > update the stats and release the rcu lock. request queue lock is taken
> > only if there are throttling rules specified in the group.
> > 
> > I have made some of the dispatch stats per cpu so that these can be updated
> > without taking request queue lock.
> > 
> > On my system for a simple dd as follows, request queue lock acquisition
> > count has gone down by 11% roughly.
> > 
> > dd if=/mnt/zerofile-1G of=/dev/null bs=4K iflag=direct
> > 
> > lockstat output vanilla kernel
> > -----------------------------
> > class name			acquisitions	holdtime-total
> > 
> > &(&q->__queue_lock)->rlock:	2360944		1850183.07
> > 
> > lockstat output with patched kernel
> > -----------------------------------
> > class name			acquisitions	holdtime-total
> > &(&q->__queue_lock)->rlock:	2098599		1430478.79
> > 
> > 
> > I did test on a 4 cpu system doing IO to one SSD. I did not see any
> > significant improvement in throughput. I suspect that I never saturated
> > the cpus hence I don't see the improvement in throughput. I will see
> > if I can get more testing done on this and see if I notice IO throughput
> > improvement.
> > 
> > Jens, first patch of the series is already in your for-linus branch. I
> > was waiting for it to be pushed to Linus and then I can drop that first
> > patch.
> 
> Vivek, I get weird things in these patches. In fact I always get on your
> patches. = are =3D, =20 some places, and line breaks. Can I ask you to
> try and resend it to axboe@kernel.dk just to see if it's the company MTA
> screwing things up, or if it's something at your end?

Sure, I am resending the series to your axboe@kernel.dk id. If you still
see the problem there, then I need to look into my setup.

I had cced the patches to myself. So took the mailbox of  the series
and did "git am <patch-series>" and it gave two warnings about space
before tab indent.

/home/vgoyal/main/git/linux-2.6/.git/rebase-apply/patch:16: space before
tab in indent.
 	struct backing_dev_info *bdi = &td->queue->backing_dev_info;
/home/vgoyal/main/git/linux-2.6/.git/rebase-apply/patch:17: space before
tab in indent.
 	unsigned int major, minor;
warning: 2 lines add whitespace errors.

Apart from that nothing else appeared. I will fix above two warnings and
resend the series and this time on your axboe@kernel.dk id.

Thanks
Vivek
