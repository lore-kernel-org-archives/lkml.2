Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab1K3QMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 11:12:09 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46218 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab1K3QMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 11:12:06 -0500
Message-ID: <1322669511.3985.8.camel@lappy>
Subject: Re: [PATCH] virtio-ring: Use threshold for switching to indirect
 descriptors
From: Sasha Levin <levinsasha928@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        markmc@redhat.com
Date: Wed, 30 Nov 2011 18:11:51 +0200
In-Reply-To: <4ED4F30F.8000603@redhat.com>
References: <1322559196-11139-1-git-send-email-levinsasha928@gmail.com>
	 <20111129125622.GB19157@redhat.com> <1322573688.4395.11.camel@lappy>
	 <20111129135406.GB30966@redhat.com> <1322576464.7003.6.camel@lappy>
	 <20111129145451.GD30966@redhat.com> <4ED4F30F.8000603@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 16:58 +0200, Avi Kivity wrote:
> On 11/29/2011 04:54 PM, Michael S. Tsirkin wrote:
> > > 
> > > Which is actually strange, weren't indirect buffers introduced to make
> > > the performance *better*? From what I see it's pretty much the
> > > same/worse for virtio-blk.
> >
> > I know they were introduced to allow adding very large bufs.
> > See 9fa29b9df32ba4db055f3977933cd0c1b8fe67cd
> > Mark, you wrote the patch, could you tell us which workloads
> > benefit the most from indirect bufs?
> >
> 
> Indirects are really for block devices with many spindles, since there
> the limiting factor is the number of requests in flight.  Network
> interfaces are limited by bandwidth, it's better to increase the ring
> size and use direct buffers there (so the ring size more or less
> corresponds to the buffer size).
> 

I did some testing of indirect descriptors under different workloads.

All tests were on a 2 vcpu guest with vhost on. Simple TCP_STREAM using
netperf.

Indirect desc off:
guest -> host, 1 stream: ~4600mb/s
host -> guest, 1 stream: ~5900mb/s
guest -> host, 8 streams: ~620mb/s (on average)
host -> guest, 8 stream: ~600mb/s (on average)

Indirect desc on:
guest -> host, 1 stream: ~4900mb/s
host -> guest, 1 stream: ~5400mb/s
guest -> host, 8 streams: ~620mb/s (on average)
host -> guest, 8 stream: ~600mb/s (on average)

Which means that for one stream, guest to host gets faster while host to
guest gets slower when indirect descriptors are on.

-- 

Sasha.

