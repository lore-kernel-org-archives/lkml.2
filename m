Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab1HHRb2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 13:31:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308Ab1HHRb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 13:31:26 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>, msnitzer@redhat.com
Subject: Re: [patch] blk-flush: fix flush policy calculation
References: <x49d3go98ku.fsf@segfault.boston.devel.redhat.com>
	<CANejiEXK7NSJo-0vshyX6RSqmRbHmyxAw8_wFQEwvTXrEQF3fg@mail.gmail.com>
	<x4939hju2zh.fsf@segfault.boston.devel.redhat.com>
	<20110804102039.GD2731@htj.dyndns.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 08 Aug 2011 13:31:22 -0400
In-Reply-To: <20110804102039.GD2731@htj.dyndns.org> (Tejun Heo's message of
	"Thu, 4 Aug 2011 12:20:39 +0200")
Message-ID: <x49bovzizdh.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> On Tue, Aug 02, 2011 at 01:39:46PM -0400, Jeff Moyer wrote:
>> OK, sorry for top-posting here, but I chased the problem down further.
>> 
>> Commit ae1b1539622fb46e51b4d13b3f9e5f4c713f86ae, block: reimplement
>> FLUSH/FUA to support merge, introduced a regression when running any
>> sort of fsyncing workload using dm-multipath and certain storage (in our
>> case, an HP EVA).  It turns out that dm-multipath always advertised
>> flush+fua support, and passed commands on down the stack, where they
>> used to get stripped off.  The above commit, unfortunately, changed that
>> behavior:
> ...
>> So, the flush machinery was bypassed in such cases (q->flush_flags == 0
>> && rq->cmd_flags & (REQ_FLUSH|REQ_FUA)).
>> 
>> Now, however, we don't get into the flush machinery at all (which is why
>> my initial patch didn't help this situation).  Instead,
>> __elv_next_request just hands a request with flush and fua bits set to
>> the scsi_request_fn, even though the underlying request_queue does not
>> support flush or fua.
>> 
>> So, where do we fix this?  We could just accept Mike's patch to not send
>> such requests down from dm-mpath, but that seems short-sighted.  We
>> could reinstate some checks in __elv_next_request.  Or, we could put the
>> checks into blk_insert_cloned_request.
>
> Ah, okay, what changed there was where a request is passed into flush
> machinery.  Before, it was while the request was being dispatched from
> elevator to device.  After, it's de-composed when the request enters
> elevator.  The bug is that there are paths which insert new requests
> to elevator but didn't check for REQ_FLUSH|FUA.
>
> I think it would be cleaner to add a wrapper around
> __elv_add_request() which checks for REQ_FLUSH|FUA and enforce
> REQ_INSERT_FLUSH if the request needs it.  Note that this should only
> happen when a request enters the queue for the first time but not on
> requeues - that was the reason why the decision wasn't made inside
> __elv_add_request().

OK, we can do a wrapper, but it probably wouldn't be too horrific to
just fix up blk_insert_cloned_request.

Now, the next issue is that flush requests issued from the dm target
down through the stack have no bio associated with them, so we blow up
on the BUG_ON(!req->bio || req->bio != req->biotail).

Cheers,
Jeff
