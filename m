Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab1C3Paa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 11:30:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51654 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab1C3Pa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 11:30:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=loU6sORURnTg4YTvehFz9NNxGWRbTPZnkKWCzPgQvbRlQy2YK/MIRjndBEm3c+rzWC
         xmNy/N5BLbfrp0s323WZ5S31YKL0yJB1qIjXvbLWcXQTRchb994uXwUj55zzkBq/0p8B
         8KRjugLXtrLEjbIJ3j3QmqqzqlHdQQKqg5+qw=
Date: Wed, 30 Mar 2011 17:30:24 +0200
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Jeff Moyer <jmoyer@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
        hch@infradead.org
Subject: Re: block: eliminate ELEVATOR_INSERT_REQUEUE
Message-ID: <20110330153024.GJ17523@htj.dyndns.org>
References: <20110328221547.GA1118@redhat.com>
 <x49y63yvwum.fsf@segfault.boston.devel.redhat.com>
 <20110329175458.GE24485@redhat.com>
 <20110330074123.GA17523@htj.dyndns.org>
 <20110330075752.GC17523@htj.dyndns.org>
 <4D92E2CD.6000909@kernel.dk>
 <20110330080203.GD17523@htj.dyndns.org>
 <20110330140123.GA28212@redhat.com>
 <20110330142751.GH17523@htj.dyndns.org>
 <20110330152248.GC1291@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330152248.GC1291@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 11:22:48AM -0400, Vivek Goyal wrote:
> So wee need this as stable fix because FLUSH request can get ahead of
> REQUEUED requests and it can break some drivers?

Yes, I think so.  All we need is just replacing elv_insert() calls in
blk-flush.c with list_add_tail().  Something like the following.  I'll
test it and send a proper patch later.  Thanks.

diff --git a/block/blk-flush.c b/block/blk-flush.c
index b27d020..51a45a5 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -132,7 +132,7 @@ static struct request *queue_next_fseq(struct request_queue *q)
 		BUG();
 	}
 
-	elv_insert(q, rq, ELEVATOR_INSERT_REQUEUE);
+	list_add_tail(&rq->queuelist, &q->queue_head);
 	return rq;
 }
 

-- 
tejun
