Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758045Ab2IJQIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 12:08:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757709Ab2IJQIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 12:08:16 -0400
Date: Mon, 10 Sep 2012 19:08:40 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Thomas Lendacky <tahm@linux.vnet.ibm.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Sasha Levin <levinsasha928@gmail.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] virtio-ring: Allocate indirect buffers from cache
 when possible
Message-ID: <20120910160840.GA20247@redhat.com>
References: <1346159043-16446-2-git-send-email-levinsasha928@gmail.com>
 <20120906084526.GE17656@redhat.com>
 <87txvahfv3.fsf@rustcorp.com.au>
 <14037987.hiN6MSGY6z@tomlt1.ibmoffice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14037987.hiN6MSGY6z@tomlt1.ibmoffice.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 10:47:15AM -0500, Thomas Lendacky wrote:
> On Friday, September 07, 2012 09:19:04 AM Rusty Russell wrote:
> 
> > "Michael S. Tsirkin" <mst@redhat.com> writes:
> 
> > > On Thu, Sep 06, 2012 at 05:27:23PM +0930, Rusty Russell wrote:
> 
> > >> "Michael S. Tsirkin" <mst@redhat.com> writes:
> 
> > >> > Yes without checksum net core always linearizes packets, so yes it is
> 
> > >> > screwed.
> 
> > >> > For -net, skb always allocates space for 17 frags + linear part so
> 
> > >> > it seems sane to do same in virtio core, and allocate, for -net,
> 
> > >> > up to max_frags + 1 from cache.
> 
> > >> > We can adjust it: no _SG -> 2 otherwise 18.
> 
> > >>
> 
> > >> But I thought it used individual buffers these days?
> 
> > >
> 
> > > Yes for receive, no for transmit. That's probably why
> 
> > > we should have the threshold per vq, not per device, BTW.
> 
> >
> 
> > Can someone actually run with my histogram patch and see what the real
> 
> > numbers are?
> 
> >
> 
>  
> 
> I ran some TCP_RR and TCP_STREAM sessions, both host-to-guest and
> 
> guest-to-host, with a form of the histogram patch applied against a
> 
> RHEL6.3 kernel. The histogram values were reset after each test.
> 
>  
> 
> Here are the results:
> 
>  
> 
> 60 session TCP_RR from host-to-guest with 256 byte request and 256 byte
> 
> response for 60 seconds:
> 
>  
> 
> Queue histogram for virtio1:
> 
> Size distribution for input (max=7818456):
> 
> 1: 7818456 ################################################################
> 
> Size distribution for output (max=7816698):
> 
> 2: 149
> 
> 3: 7816698 ################################################################

Here, a threshold would help.

> 
> 4: 2
> 
> 5: 1
> 
> Size distribution for control (max=1):
> 
> 0: 0
> 
>  
> 
>  
> 
> 4 session TCP_STREAM from host-to-guest with 4K message size for 60 seconds:
> 
>  
> 
> Queue histogram for virtio1:
> 
> Size distribution for input (max=16050941):
> 
> 1: 16050941 ################################################################
> 
> Size distribution for output (max=1877796):
> 
> 2: 1877796 ################################################################
> 
> 3: 5
> 
> Size distribution for control (max=1):
> 
> 0: 0
> 
>  
> 
> 4 session TCP_STREAM from host-to-guest with 16K message size for 60 seconds:
> 
>  
> 
> Queue histogram for virtio1:
> 
> Size distribution for input (max=16831151):
> 
> 1: 16831151 ################################################################
> 
> Size distribution for output (max=1923965):
> 
> 2: 1923965 ################################################################
> 
> 3: 5
> 
> Size distribution for control (max=1):
> 
> 0: 0
> 

Hmm for virtio net output we do always use 2 s/g, this is because of a
qemu bug. Maybe it's time we fixed this, added a feature bit?
This would fix above without threshold hacks.


> 
> 4 session TCP_STREAM from guest-to-host with 4K message size for 60 seconds:
> 
>  
> 
> Queue histogram for virtio1:
> 
> Size distribution for input (max=1316069):
> 
> 1: 1316069 ################################################################
> 
> Size distribution for output (max=879213):
> 
> 2: 24
> 
> 3: 24097 #
> 
> 4: 23176 #
> 
> 5: 3412
> 
> 6: 4446
> 
> 7: 4663
> 
> 8: 4195
> 
> 9: 3772
> 
> 10: 3388
> 
> 11: 3666
> 
> 12: 2885
> 
> 13: 2759
> 
> 14: 2997
> 
> 15: 3060
> 
> 16: 2651
> 
> 17: 2235
> 
> 18: 92721 ######
> 
> 19: 879213 ################################################################
> 
> Size distribution for control (max=1):
> 
> 0: 0
> 
>  
> 
> 4 session TCP_STREAM from guest-to-host with 16K message size for 60 seconds:
> 
>  
> 
> Queue histogram for virtio1:
> 
> Size distribution for input (max=1428590):
> 
> 1: 1428590 ################################################################
> 
> Size distribution for output (max=957774):
> 
> 2: 20
> 
> 3: 54955 ###
> 
> 4: 34281 ##
> 
> 5: 2967
> 
> 6: 3394
> 
> 7: 9400
> 
> 8: 3061
> 
> 9: 3397
> 
> 10: 3258
> 
> 11: 3275
> 
> 12: 3147
> 
> 13: 2876
> 
> 14: 2747
> 
> 15: 2832
> 
> 16: 2013
> 
> 17: 1670
> 
> 18: 100369 ######
> 
> 19: 957774 ################################################################
> 
> Size distribution for control (max=1):
> 
> 0: 0
> 
>  
> 
> Thanks,
> 
> Tom

In these tests we would have to set threshold pretty high.
I wonder whether the following makes any difference: the idea is to
A. get less false cache sharing by allocating full cache lines
B. better locality by using same cache for multiple sizes

So we get some of the wins of the threshold without bothering
with a cache.

Will try to test but not until later this week.

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 5aa43c3..c184712 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -132,7 +132,8 @@ static int vring_add_indirect(struct vring_virtqueue *vq,
 	unsigned head;
 	int i;
 
-	desc = kmalloc((out + in) * sizeof(struct vring_desc), gfp);
+	desc = kmalloc(L1_CACHE_ALIGN((out + in) * sizeof(struct vring_desc)),
+		       gfp);
 	if (!desc)
 		return -ENOMEM;
 


-- 
MST
