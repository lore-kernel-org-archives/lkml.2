Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934456Ab1ESSdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 14:33:20 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:57238 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934397Ab1ESSdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 14:33:15 -0400
X-ASG-Debug-ID: 1305829993-01de28096b4f990001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DD56266.7090209@fusionio.com>
Date: Thu, 19 May 2011 20:33:10 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dpshah@google.com" <dpshah@google.com>
Subject: Re: [RFC PATCH 00/14] blk-throttle: lockless bio processing for no
  throttle rule group
References: <1305746006-5837-1-git-send-email-vgoyal@redhat.com>
X-ASG-Orig-Subj: Re: [RFC PATCH 00/14] blk-throttle: lockless bio processing for no
  throttle rule group
In-Reply-To: <1305746006-5837-1-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1305829993
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64214
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-18 21:13, Vivek Goyal wrote:
> Hi,
> 
> Block throttling code takes request queue lock for every incoming bio
> (blk_throtl_bio()). This is true even if there are no throttle rules in
> the group. This is a common case for root cgroup where distributions
> will have throttling support compiled in but a vast majority of users
> will not be specifying throttling rule.
> 
> This patch series tries to make bio processing lockless (no requeust
> queue lock), if there are no rules specified for the group. Once
> a bio is submitted, under rcu_read_lock() we search for the group, 
> update the stats and release the rcu lock. request queue lock is taken
> only if there are throttling rules specified in the group.
> 
> I have made some of the dispatch stats per cpu so that these can be updated
> without taking request queue lock.
> 
> On my system for a simple dd as follows, request queue lock acquisition
> count has gone down by 11% roughly.
> 
> dd if=/mnt/zerofile-1G of=/dev/null bs=4K iflag=direct
> 
> lockstat output vanilla kernel
> -----------------------------
> class name			acquisitions	holdtime-total
> 
> &(&q->__queue_lock)->rlock:	2360944		1850183.07
> 
> lockstat output with patched kernel
> -----------------------------------
> class name			acquisitions	holdtime-total
> &(&q->__queue_lock)->rlock:	2098599		1430478.79
> 
> 
> I did test on a 4 cpu system doing IO to one SSD. I did not see any
> significant improvement in throughput. I suspect that I never saturated
> the cpus hence I don't see the improvement in throughput. I will see
> if I can get more testing done on this and see if I notice IO throughput
> improvement.
> 
> Jens, first patch of the series is already in your for-linus branch. I
> was waiting for it to be pushed to Linus and then I can drop that first
> patch.

Vivek, I get weird things in these patches. In fact I always get on your
patches. = are =3D, =20 some places, and line breaks. Can I ask you to
try and resend it to axboe@kernel.dk just to see if it's the company MTA
screwing things up, or if it's something at your end?

-- 
Jens Axboe

