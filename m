Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab0FNOE2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:04:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab0FNOE1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:04:27 -0400
Date: Mon, 14 Jun 2010 16:59:12 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: virtualization@lists.linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>, Jiri Pirko <jpirko@redhat.com>,
       Shirley Ma <xma@us.ibm.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: potential race in virtio ring?
Message-ID: <20100614135912.GA25015@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
I was going over the vring code and noticed, that
the ring has this check:

irqreturn_t vring_interrupt(int irq, void *_vq)
{
        struct vring_virtqueue *vq = to_vvq(_vq);
        
        if (!more_used(vq)) {
                pr_debug("virtqueue interrupt with no work for %p\n", vq);
                return IRQ_NONE;


static inline bool more_used(const struct vring_virtqueue *vq)
{               
        return vq->last_used_idx != vq->vring.used->idx;
}               

My concern is that with virtio net, more_used is called
on a CPU different from the one that polls the vq.
This might mean that last_used_idx value might be stale.
Could this lead to a missed interrupt?

Thanks,

-- 
MST
