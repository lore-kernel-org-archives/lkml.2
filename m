Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab2IDNek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 09:34:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958Ab2IDNei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 09:34:38 -0400
Date: Tue, 4 Sep 2012 16:35:43 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kvm@vger.kernel.org, rusty@rustcorp.com.au, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        target-devel <target-devel@vger.kernel.org>
Subject: Re: [PATCH 5/5] virtio-scsi: introduce multiqueue support
Message-ID: <20120904133543.GF9805@redhat.com>
References: <1346154857-12487-1-git-send-email-pbonzini@redhat.com>
 <1346154857-12487-6-git-send-email-pbonzini@redhat.com>
 <1346725294.4162.79.camel@haakon2.linux-iscsi.org>
 <5045A3B4.2030101@redhat.com>
 <20120904084628.GA8437@redhat.com>
 <5045D6FF.5020801@redhat.com>
 <20120904110905.GA9119@redhat.com>
 <5045E387.4030103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5045E387.4030103@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 01:18:31PM +0200, Paolo Bonzini wrote:
> Il 04/09/2012 13:09, Michael S. Tsirkin ha scritto:
> >> >     queuecommand on CPU #0         queuecommand #2 on CPU #1
> >> >   --------------------------------------------------------------
> >> >     atomic_inc_return(...) == 1
> >> >                                    atomic_inc_return(...) == 2
> >> >                                    virtscsi_queuecommand to queue #1
> >> >     tgt->req_vq = queue #0
> >> >     virtscsi_queuecommand to queue #0
> >> > 
> >> > then two requests are issued to different queues without a quiescent
> >> > point in the middle.
> > What happens then? Does this break correctness?
> 
> Yes, requests to the same target should be processed in FIFO order, or
> you have things like a flush issued before the write it was supposed to
> flush.  This is why I can only change the queue when there is no request
> pending.
> 
> Paolo

I see.  I guess you can rewrite this as:
atomic_inc
if (atomic_read() == 1)
which is a bit cheaper, and make the fact
that you do not need increment and return to be atomic,
explicit.

Another simple idea: store last processor id in target,
if it is unchanged no need to play with req_vq
and take spinlock.

Also - some kind of comment explaining why a similar race can not happen
with this lock in place would be nice: I see why this specific race can
not trigger but since lock is dropped later before you submit command, I
have hard time convincing myself what exactly gurantees that vq is never
switched before or even while command is submitted.




-- 
MST
