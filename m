Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab1KBH0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 03:26:01 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49251
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751450Ab1KBHZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 03:25:59 -0400
Date: Wed, 2 Nov 2011 03:25:44 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Chris Wright <chrisw@sous-sol.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] virtio: support unlocked queue kick
Message-ID: <20111102072544.GA6967@infradead.org>
References: <20111005195403.407628164@bombadil.infradead.org>
 <20111005195529.964397366@bombadil.infradead.org>
 <87r52qgaf3.fsf@rustcorp.com.au>
 <20111006131828.GC19023@redhat.com>
 <20111101144045.GA15433@redhat.com>
 <87ty6ntdmf.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ty6ntdmf.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 01:49:36PM +1030, Rusty Russell wrote:
> I thought it was still a WIP?

The whole series - yes.  This patch (and the serial number rewrite): no
- these are pretty much rock solid.

> Since the problem is contention on the lock inside the block layer, the
> simplest solution is to have a separate lock to protect the virtqueue.

As long as we still use a ->request_fn based driver that is not going
to buy us anything, in fact it's going to make things worse.
->request_fn based drivers always have the queue lock held over the
invocation of ->request_fn anyway, and then need it around the call
to __blk_end_request_all.  So you might minimally reduce contention
time, but skyrocket the number of lock acquisations when separating
them without changes to the block layer.

With the ->make_request_fn based driver vlkb->lock does't protect
anything but the virtuequeue anyway, but not having to take it
over the wakeup there is a) done easily and b) neatly fits the model.

