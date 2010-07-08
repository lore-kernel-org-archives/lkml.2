Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092Ab0GHN4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 09:56:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756052Ab0GHN4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 09:56:37 -0400
Date: Thu, 8 Jul 2010 09:56:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
       Nauman Rafique <nauman@google.com>, Divyesh Shah <dpshah@google.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [RFC/RFT PATCH] cfq-iosched: Implement cfq group idling
Message-ID: <20100708135625.GD5093@redhat.com>
References: <20100707230521.GB7842@redhat.com>
 <x4939vuf5y6.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x4939vuf5y6.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 08, 2010 at 09:39:45AM -0400, Jeff Moyer wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > Currently we idle on sequential queues and allow dispatch from a single
> > queue and that can become a bottleneck on higher end storage. For example
> > on my HP EVA, I can run multiple sequential streams and achieve top BW
> > of around 350 MB/s. But with CFQ, dispatching from single queue does not
> > keep the array busy (limits to 150-180 MB/s with 4 or 8 processes).
> >
> > One approach to solve this issue is simply use slice_idle = 0. But this
> > also takes away the any service differentiation between groups.
> 
> That also takes away service differentiation between queues.  If you
> want to maintain that at all, then this is really just pushing the
> problem to another layer.
> 

Yes it does take away the io priority with-in group. But I think that's
the trade-off and that's not default. So those who don't require ioprio
stuff working with-in group and those who know that they have got
faster storage will set slice_idle=0. For rest of the SATA users default
is still slice_idle=8.

So I am just creating a path so that high end storage users don't suffer.
Previously they could easily switch to deadline. But because they also
want to use IO control feature and deadline does not support that, we
need to create some paths in CFQ so that it gives deadline like
performance but also provides IO control facility.

Because storage behavior varies so much, typically idling works very well
on single SATA disks and with software RAIDs of SATA disks. But in my
testing deadline is outerforming CFQ on HBA based hardware RAID and
storage arrays. Now ideal thing to address this situation would be some
kind of auto tuning where CFQ realizes the capability of LUN it is
operating on and changes behavior automatically.

But getting auto-tuning is hard, I am trying to address the issue with
the help of tunable in a static manner. So if an admin knows the storage
configuration, he can change the tunables statically. Once a realibale
auto tuning infrastructure is in, we can get rid of these static paths.

Thanks
Vivek

> This is the crux of my issues with CFQ.  It works really well for SATA
> disks.  Once you try running it on enterprise storage, it falls flat.
> Is it a design goal of CFQ to get it to run well on enterprise storage?
> 
> Jens?
> 
> Cheers,
> Jeff
