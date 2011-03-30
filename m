Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab1C3O16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:27:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34372 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932470Ab1C3O15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:27:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=epKxdtkhwJaa69tZAREtdr8WQYhPHJy5svoRXYzIXvhp7xTeENBPzDegcvPHwY13Nm
         1085Q+TC+aZLBQztBkt45HlReXk/GV7h0XGLfC5IUfPuAbED+mSWrclVVszaQ22jWcbJ
         GGId+1ViVtDceqpnJts69MCibVwQWPqkqxjRM=
Date: Wed, 30 Mar 2011 16:27:51 +0200
From: Tejun Heo <tj@kernel.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        hch@infradead.org
Subject: Re: block: eliminate ELEVATOR_INSERT_REQUEUE
Message-ID: <20110330142751.GH17523@htj.dyndns.org>
References: <20110326042156.GB28458@redhat.com>
 <20110328082321.GC16530@htj.dyndns.org>
 <20110328221547.GA1118@redhat.com>
 <x49y63yvwum.fsf@segfault.boston.devel.redhat.com>
 <20110329175458.GE24485@redhat.com>
 <20110330074123.GA17523@htj.dyndns.org>
 <20110330075752.GC17523@htj.dyndns.org>
 <4D92E2CD.6000909@kernel.dk>
 <20110330080203.GD17523@htj.dyndns.org>
 <20110330140123.GA28212@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330140123.GA28212@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 10:01:24AM -0400, Mike Snitzer wrote:
> Why can we all of a sudden append the flush to the dispatch queue _but_
> not have any concern about queue draining?  Seems that avoiding use of
> BACK, by using list_add_tail, is enabling that.  Couldn't we have always
> done that?

Yes, we could have.  I was just being lazy and looking for an easy
solution.

> The folding of elv_insert() into __elv_add_request() seems
> irrelevant.

Strictly, it is but they kinda go well together.

> Can we take a step back and be more explicit about the implications of
> having inserted the flush with REQUEUE/FRONT?  Seems to me that having
> _not_ inserted the flush at the end of the dispatch queue is cause for
> potential corruption (preceding data hasn't been issued to the device
> yet).

No, the data ordering is enforced by the filesystem in the new
implementation meaning that by the time FLUSH is issued by the
filesystem, it should have made sure that all requests which must be
written before the FLUSH already had completed.

> And just to be clear: none of this is a concern for stable right?  It is
> just the flush-merge code introduced for 2.6.39 that needs fixing?

I think 2.6.38 needs a -stable fix.  It has the previous version of
the new flush implementation and is using front insertion.

Thanks.

-- 
tejun
