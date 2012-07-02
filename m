Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab2GBWwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 18:52:43 -0400
Received: from ozlabs.org ([203.10.76.45]:46343 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab2GBWwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 18:52:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Asias He <asias@redhat.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, dlaor@redhat.com,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] virtio-blk: Add bio-based IO path for virtio-blk
In-Reply-To: <4FF10B31.60609@redhat.com>
References: <1340002390-3950-1-git-send-email-asias@redhat.com>  <1340002390-3950-4-git-send-email-asias@redhat.com>  <87hau9yse7.fsf@rustcorp.com.au> <4FDEE0CB.1030505@redhat.com>  <87zk81x7dp.fsf@rustcorp.com.au> <4FDF0DA7.40604@redhat.com> <1340019575.22848.2.camel@lappy> <4FDFE926.7030309@redhat.com> <87r4svxcjw.fsf@rustcorp.com.au> <4FF10B31.60609@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 02 Jul 2012 16:11:32 +0930
Message-ID: <8762a6y89v.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Jul 2012 10:45:05 +0800, Asias He <asias@redhat.com> wrote:
> On 07/02/2012 07:54 AM, Rusty Russell wrote:
> > Confused.  So, without merging we get 6k exits (per second?)  How many
> > do we get when we use the request-based IO path?
> 
> Sorry for the confusion. The numbers were collected from request-based 
> IO path where we can have the guest block layer merge the requests.
> 
> With the same workload in guest, the guest fires 200K requests to host 
> with merges enabled in guest (echo 0 > /sys/block/vdb/queue/nomerges), 
> while the guest fires 40000K requests to host with merges disabled in 
> guest (echo 2 > /sys/block/vdb/queue/nomerges). This show that the merge 
> in block layer reduces the total number of requests fire to host a lot 
> (40000K / 200K = 20).
> 
> The guest fires 200K requests to host with merges enabled in guest (echo 
> 0 > /sys/block/vdb/queue/nomerges), the host fires 6K interrupts in 
> total for the 200K requests. This show that the ratio of interrupts 
> coalesced (200K / 6K = 33).

OK, got it!  Guest merging cuts requests by a factor of 20.  EVENT_IDX
cuts interrupts by a factor of 33.

> > If your device is slow, then you won't be able to make many requests per
> > second: why worry about exit costs?
> 
> If a device is slow, the merge would merge more requests and reduce the 
> total number of requests to host. This saves exit costs, no?

Sure, our guest merging might save us 100x as many exits as no merging.
But since we're not doing many requests, does it matter?

Ideally we'd merge requests only if the device queue is full.  But that
sounds hard.

> > If your device is fast (eg. ram),
> > you've already shown that your patch is a win, right?
> 
> Yes. Both on ramdisk and fast SSD device (e.g. FusionIO).

Thanks,
Rusty.
