Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab2H2PhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 11:37:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753918Ab2H2PhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 11:37:19 -0400
Date: Wed, 29 Aug 2012 18:38:33 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, avi@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH v2 2/2] virtio-ring: Allocate indirect buffers from cache
 when possible
Message-ID: <20120829153833.GE7407@redhat.com>
References: <1346159043-16446-1-git-send-email-levinsasha928@gmail.com>
 <1346159043-16446-2-git-send-email-levinsasha928@gmail.com>
 <20120828132032.GB2039@redhat.com>
 <503CC904.3050207@gmail.com>
 <20120829110748.GB5970@redhat.com>
 <503E2F27.5060904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503E2F27.5060904@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 05:03:03PM +0200, Sasha Levin wrote:
> On 08/29/2012 01:07 PM, Michael S. Tsirkin wrote:
> > On Tue, Aug 28, 2012 at 03:35:00PM +0200, Sasha Levin wrote:
> >> On 08/28/2012 03:20 PM, Michael S. Tsirkin wrote:
> >>> On Tue, Aug 28, 2012 at 03:04:03PM +0200, Sasha Levin wrote:
> >>>> Currently if VIRTIO_RING_F_INDIRECT_DESC is enabled we will
> >>>> use indirect descriptors and allocate them using a simple
> >>>> kmalloc().
> >>>>
> >>>> This patch adds a cache which will allow indirect buffers under
> >>>> a configurable size to be allocated from that cache instead.
> >>>>
> >>>> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> >>>
> >>> I imagine this helps performance? Any numbers?
> >>
> >> I ran benchmarks on the original RFC, I've re-tested it now and got similar
> >> numbers to the original ones (virtio-net using vhost-net, thresh=16):
> >>
> >> Before:
> >> 	Recv   Send    Send
> >> 	Socket Socket  Message  Elapsed
> >> 	Size   Size    Size     Time     Throughput
> >> 	bytes  bytes   bytes    secs.    10^6bits/sec
> >>
> >> 	 87380  16384  16384    10.00    4512.12
> >>
> >> After:
> >> 	Recv   Send    Send
> >> 	Socket Socket  Message  Elapsed
> >> 	Size   Size    Size     Time     Throughput
> >> 	bytes  bytes   bytes    secs.    10^6bits/sec
> >>
> >> 	 87380  16384  16384    10.00    5399.18
> >>
> >>
> >> Thanks,
> >> Sasha
> > 
> > This is with both patches 1 + 2?
> > Sorry could you please also test what happens if you apply
> > - just patch 1
> > - just patch 2
> > 
> > Thanks!
> 
> Sure thing!
> 
> I've also re-ran it on a IBM server type host instead of my laptop. Here are the
> results:
> 
> Vanilla kernel:
> 
> MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.33.1
> () port 0 AF_INET
> enable_enobufs failed: getprotobyname
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
> 
>  87380  16384  16384    10.00    7922.72
> 
> Patch 1, with threshold=16:
> 
> MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.33.1
> () port 0 AF_INET
> enable_enobufs failed: getprotobyname
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
> 
>  87380  16384  16384    10.00    8415.07
> 
> Patch 2:
> 
> MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.33.1
> () port 0 AF_INET
> enable_enobufs failed: getprotobyname
> Recv   Send    Send
> Socket Socket  Message  Elapsed
> Size   Size    Size     Time     Throughput
> bytes  bytes   bytes    secs.    10^6bits/sec
> 
>  87380  16384  16384    10.00    8931.05
> 
> 
> Note that these are simple tests with netperf listening on one end and a simple
> 'netperf -H [host]' within the guest. If there are other tests which may be
> interesting please let me know.
> 
> 
> Thanks,
> Sasha


And which parameter did you use for patch 2?

