Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab1HLPhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 11:37:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753557Ab1HLPhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 11:37:05 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, msnitzer@redhat.com, vgoyal@redhat.com,
        shaohua <shli@kernel.org>
Subject: Re: [patch] block: fix flush machinery for stacking drivers with differring flush flags
References: <x49ty9pqood.fsf@segfault.boston.devel.redhat.com>
	<20110812125935.GA4254@htj.dyndns.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 12 Aug 2011 11:36:46 -0400
In-Reply-To: <20110812125935.GA4254@htj.dyndns.org> (Tejun Heo's message of
	"Fri, 12 Aug 2011 14:59:35 +0200")
Message-ID: <x49fwl6prox.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

>> -#define REQ_CLONE_MASK		REQ_COMMON_MASK
>> +/*
>> + * Cloned requests are inserted into the elevator via blk_insert_cloned_request.
>> + * Because the flush flags exported by the request-based dm target may in
>> + * theory be different from the flush flags of the underlying request_queue,
>> + * we need to pass along information regarding whether a particular request
>> + * is part of a flush sequence.  This is primarily used to complete I/Os early
>> + * that would otherwise not be necessary (such as an empty flush for a request
>> + * queue that does not support flush).  In such a case, the end_io path for
>> + * the request would try to account the I/O instead of ignoring it, resulting
>> + * in a null pointer dereference.
>> + */
>> +#define REQ_CLONE_MASK		(REQ_COMMON_MASK | REQ_FLUSH_SEQ)
>
> I'm probably missing something, but why do we still need to copy
> REQ_FLUSH_SEQ?  Why doesn't the following work?
>
> * dm driver always advertises REQ_FLUSH|FUA like other stacking
>   drivers.
>
> * blk-flush for the dm, decomposes flushes to FLUSH + FUA write and
>   send it down.
>
> * dm driver clones the requests and send them down to each member
>   queue.
>
> * blk-flush on member queue, handles FLUSH as FLUSH and decomposes FUA
>   write as necessary.
>
> What am I missing?  Why does end_io path still matter when it goes
> through blk-flush on the member device too?

You're missing the I/O completion of an empty flush trying to do I/O
accounting, and oopsing, as shown in the stack trace I provided before.

We could avoid passing REQ_FLUSH_SEQ, and then set it when completing an
empty flush, but I thought that was even worse.  Or, maybe we could
clear REQ_IO_STAT when completing such requests.

-Jeff
