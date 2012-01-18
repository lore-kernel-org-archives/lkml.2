Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995Ab2ARQYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 11:24:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45922 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941Ab2ARQYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 11:24:44 -0500
Message-ID: <4F16F245.9000708@kernel.dk>
Date: Wed, 18 Jan 2012 17:24:37 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, Shaohua Li <shaohua.li@intel.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Kernel crash in icq_free_icq_rcu
References: <20120117214834.GD26207@google.com> <20120117220715.GB23527@redhat.com> <CANejiEUfAxR-DFH+eRQUbmc1jKHSkcBP1RxuRQ-9JKLU=1Ds0w@mail.gmail.com> <20120118010323.GA32160@htj.dyndns.org> <CANejiEUopG3MgUsvGMbkdHKrgBT_c+bir1bApt8p86kQn42huQ@mail.gmail.com> <20120118011112.GB32160@htj.dyndns.org> <1326850253.22361.619.camel@sli10-conroe> <1326866602.22361.624.camel@sli10-conroe> <20120118135126.GB30204@redhat.com> <20120118142005.GC30204@redhat.com> <20120118160957.GB30664@google.com>
In-Reply-To: <20120118160957.GB30664@google.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-01-18 17:09, Tejun Heo wrote:
> On Wed, Jan 18, 2012 at 09:20:05AM -0500, Vivek Goyal wrote:
>>> Not allocating icq if request is never going to go to elevator as elevator
>>> switch was happening makes sense to me.
>>>
>>> I tried this patch. It went little further and crashed at a different
>>> place. I think this seems to be separate merging issue Tejun is trying
>>> to track down.
>>
>> Applied Tejun's debug patch to return early and not call into elevator
>> for checking whether merge is allowed or not. Things seems to be stable
>> now for me.
> 
> Yeah, plug merge is calling into elevator code without any
> synchronization, so it's bound to be broken.  Given plugging is
> per-task, I don't think we really need to query elevator about merging
> bio's.  The request is not on elevator and plugging is part of issuing
> mechanism, not scheduling, after all.  Jens, what do you think?

Hmmm. We can bypass asking the elevator, as long as we query the
restrictions. Does the below, by itself, resolve the crash? If yes, let
me cook up a patch splitting the elv and blk rq merging logic.

diff --git a/block/elevator.c b/block/elevator.c
index 91e18f8..c2f319a 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -105,8 +105,10 @@ int elv_rq_merge_ok(struct request *rq, struct bio *bio)
 	if (bio_integrity(bio) != blk_integrity_rq(rq))
 		return 0;
 
+#if 0
 	if (!elv_iosched_allow_merge(rq, bio))
 		return 0;
+#endif
 
 	return 1;
 }

-- 
Jens Axboe

