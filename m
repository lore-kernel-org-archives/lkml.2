Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab0KHPGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 10:06:19 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55461 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754835Ab0KHPGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 10:06:18 -0500
Message-ID: <4CD811ED.8010901@fusionio.com>
Date: Mon, 08 Nov 2010 16:06:21 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        "czoccolo@gmail.com" <czoccolo@gmail.com>
Subject: Re: [patch 3/3]cfq-iosched: don't idle if a deep seek queue is slow
References: <1289182045.23014.191.camel@sli10-conroe> <20101108142054.GB16767@redhat.com>
In-Reply-To: <20101108142054.GB16767@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-08 15:20, Vivek Goyal wrote:
> On Mon, Nov 08, 2010 at 10:07:25AM +0800, Shaohua Li wrote:
>> If a deep seek queue slowly deliver requests but disk is much faster, idle
>> for the queue just wastes disk throughput. If the queue delevers all requests
>> before half its slice is used, the patch disable idle for it.
>> In my test, application delivers 32 requests one time, the disk can accept
>> 128 requests at maxium and disk is fast. without the patch, the throughput
>> is just around 30m/s, while with it, the speed is about 80m/s. The disk is
>> a SSD, but is detected as a rotational disk. I can configure it as SSD, but
>> I thought the deep seek queue logic should be fixed too, for example,
>> considering a fast raid.
>>
> 
> Hi Shaohua,
> 
> So looks like you are trying to cut down queue idling in the case when
> device is fast and idling hurts. That's a noble goal, just that detetction
> of this condition only for deep queues does not seem to cover lots of
> cases. Manually one can set slice_idle=0 to handle this situation.
> 
> What about if you have lots of sequential queues (not deep) and they all
> will still idle.
> 
> Secondly, what if driver is just buffering lots of requests in its device
> queue and not necessarily device is processing the reuqests faster.

That is not a valid concern, a driver should never extract more than it
can process (pretty much) immediately.

> So I think it is a good idea to cut down on idling if we can find that
> underlying device is fast and idling on queue might hurt more. But
> discovering this only using deep queues does not sound very appleaing to
> me. This is help only a particular workload which is driving deep queues.
> So if there was a generic mechanism to tackle this, that would be much
> better.

Agree, we could use better metrics for this.

-- 
Jens Axboe

