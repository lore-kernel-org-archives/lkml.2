Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab0KIC2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 21:28:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371Ab0KIC2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 21:28:50 -0500
Date: Mon, 8 Nov 2010 21:28:46 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, lkml <linux-kernel@vger.kernel.org>,
        "czoccolo@gmail.com" <czoccolo@gmail.com>
Subject: Re: [patch 3/3]cfq-iosched: don't idle if a deep seek queue is slow
Message-ID: <20101109022846.GA29847@redhat.com>
References: <1289182045.23014.191.camel@sli10-conroe>
 <20101108142054.GB16767@redhat.com>
 <4CD811ED.8010901@fusionio.com>
 <1289266602.23014.202.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289266602.23014.202.camel@sli10-conroe>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 09:36:42AM +0800, Shaohua Li wrote:
> On Mon, 2010-11-08 at 23:06 +0800, Jens Axboe wrote:
> > On 2010-11-08 15:20, Vivek Goyal wrote:
> > > On Mon, Nov 08, 2010 at 10:07:25AM +0800, Shaohua Li wrote:
> > >> If a deep seek queue slowly deliver requests but disk is much faster, idle
> > >> for the queue just wastes disk throughput. If the queue delevers all requests
> > >> before half its slice is used, the patch disable idle for it.
> > >> In my test, application delivers 32 requests one time, the disk can accept
> > >> 128 requests at maxium and disk is fast. without the patch, the throughput
> > >> is just around 30m/s, while with it, the speed is about 80m/s. The disk is
> > >> a SSD, but is detected as a rotational disk. I can configure it as SSD, but
> > >> I thought the deep seek queue logic should be fixed too, for example,
> > >> considering a fast raid.
> > >>
> > > 
> > > Hi Shaohua,
> > > 
> > > So looks like you are trying to cut down queue idling in the case when
> > > device is fast and idling hurts. That's a noble goal, just that detetction
> > > of this condition only for deep queues does not seem to cover lots of
> > > cases. Manually one can set slice_idle=0 to handle this situation.
> > > 
> > > What about if you have lots of sequential queues (not deep) and they all
> > > will still idle.
> > > 
> > > Secondly, what if driver is just buffering lots of requests in its device
> > > queue and not necessarily device is processing the reuqests faster.
> > 
> > That is not a valid concern, a driver should never extract more than it
> > can process (pretty much) immediately.
> > 
> > > So I think it is a good idea to cut down on idling if we can find that
> > > underlying device is fast and idling on queue might hurt more. But
> > > discovering this only using deep queues does not sound very appleaing to
> > > me. This is help only a particular workload which is driving deep queues.
> > > So if there was a generic mechanism to tackle this, that would be much
> > > better.
> > 
> > Agree, we could use better metrics for this.
> Agree we'd better have a better method to measure device speed, but this
> seems not easy. Even in a fast device, a request might take long time to
> finish when NCQ is enabled. Before we have generic mechanism, we still
> need fix some particular cases.

Do you have a real workload for this case or it is just one of the synthetic
workload simulated using fio?

Vivek
