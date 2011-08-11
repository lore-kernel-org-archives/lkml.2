Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564Ab1HKOJy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:09:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033Ab1HKOJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:09:51 -0400
Date: Thu, 11 Aug 2011 10:09:36 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Kyungmin Park <kmpark@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "jh80.chung@samsung.com" <jh80.chung@samsung.com>,
        "shli@kernel.org" <shli@kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Subject: Re: [RFC PATCH v2] Add new elevator ops for request hint
Message-ID: <20110811140936.GD8552@redhat.com>
References: <20110811004216.GA24810@july>
 <20110811133302.GC8552@redhat.com>
 <4E43DBFB.6020105@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E43DBFB.6020105@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 03:41:15PM +0200, Jens Axboe wrote:
> On 2011-08-11 15:33, Vivek Goyal wrote:
> > On Thu, Aug 11, 2011 at 09:42:16AM +0900, Kyungmin Park wrote:
> >> Hi Jens
> >>
> >> Now eMMC device requires the upper layer information to improve the data
> >> performance and reliability.
> >>
> >> . Context ID
> >> Using the context information, it can sort out the data internally and improve the performance.
> >> The main problem is that it's needed to define "What's the context". 
> >> Actually I expect cfq queue has own unique ID but it doesn't so decide to use the pid instead
> >>
> > 
> > Hi,
> > 
> > Can you please give little more details about the optimization you will
> > do with this pid information?
> 
> It is provided in one of the other email threads for this patch.

Ok, thanks. I just read the other mail thread.

So the idea is that when multiple requests from multiple processes are
in flight in driver, then using context information (pid in this case),
driver can potentially do more efficient scheduling of these requests.

CFQ kind of already does that atleast for sync-idle queues as driver will
see requests only from one context for extended period of time. So this
optimization is primarily useful for random reads and writer queues where
we do not idle. (Well if rotational=0, then we don't idle on even on 
sync-idle so not sure if these mmc chips set rotational=0 or not).

> 
> > Also what happens in the case of noop and deadline which don't maintain
> > per process queues and can't provide this information.
> 
> It'll still work, it isn't really tied to the CFQ way of diviying things
> up.

IIUC, for noop and deadline no optimizatoin will take place as no context
information is available and things will default back to status quo? Atleast
this patch implements hook only for CFQ. 

> 
> >> First I expect the REQ_META but current ext4 doesn't pass the WRITE_META. only use the READ_META. so it needs to investigate it.
> > 
> > So are you planning to later fix file systems to appropriately mark meta
> > data requests?
> 
> One thing that occured to me is that equating META to HOT is not
> necessarily a good idea. Meta data isn't necessarily more "hot" than
> regular data, it all depends on how it's being used. So I think it would
> be a lot more appropriate to pass down this information specifically,
> instead of overloading REQ_META.

I think so. I guess it depends on what "HOT" means and filesystem should
understand REQ_HOT and flag bio/req appropriately.

But if this optimization is especially targeted at meta data, then using
REQ_META will make sense too.

Whatever flag it is (HOT, META), I am wondering why IO scheduler need to
come into the picture for this information. This is kind of between 
filesystem and driver. As driver should see all the request flags, it
should just be able to check for presence of flag and not call into
elevator/IO scheduler.

On a side note, if we are willing to keep pid/iocontext information in
struct request, then this optimization should work with noop/deadline too.
 
Thanks
Vivek
