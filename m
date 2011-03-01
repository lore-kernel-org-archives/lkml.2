Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab1CAOUP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 09:20:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1368 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369Ab1CAOUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 09:20:13 -0500
Date: Tue, 1 Mar 2011 09:20:02 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Justin TerAvest <teravest@google.com>
Cc: Chad Talbott <ctalbott@google.com>, Nauman Rafique <nauman@google.com>,
        Divyesh Shah <dpshah@google.com>, lkml <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: RFC: default group_isolation to 1, remove option
Message-ID: <20110301142002.GB25699@redhat.com>
References: <AANLkTinXa4Zjg0zGbPQRZQi2QW_-0y+PBzQwcdjPLVKZ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinXa4Zjg0zGbPQRZQi2QW_-0y+PBzQwcdjPLVKZ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28, 2011 at 04:19:43PM -0800, Justin TerAvest wrote:
> Hi Vivek,
> 
> I'd like to propose removing the group_isolation setting and changing
> the default to 1. Do we know if anyone is using group_isolation=0 to get
> easy group separation between sequential readers and random readers?

CCing Corrado.

I like the idea of setting group_isolation = 1 to default. So far I have
not found anybody trying to use group_isolation=0 and every time I had
to say can you try setting group_isolation to 1 if you are not seeing
service differentiation.

I think I would not mind removing it completely altogether also. This will
also remove some code from CFQ. The reason we introduced group_isolation
because by default we idle on sync-noidle tree and on fast devices idling on
every syn-noidle tree can be very harmful for throughput, especially on faster
storage like storage arrays.

One of the soutions for that problem can be that run with slice idle
enabled on SATA disks and run with slice_idle=0 and possibly group_idle=0
also on faster storage. Setting idling to 0 will increase throughput but
at the same time reduce the isolation significantly. But I guess this
is the performance vs isolation trade off.

> 
> Allowing group_isolation complicates implementing per-cgroup request
> descriptor pools when a queue is moved to the root group. Specifically,
> if we have pools per-cgroup, we would be forced to use request
> descriptors from the pool for the "original" cgroup, while the requests
> are actually being serviced by the root cgroup.

I think creating per group request pool will complicate the implementation
further. (we have done that once in the past). Jens once mentioned that
he liked number of requests per iocontext limit better than overall queue
limit. So if we implement per iocontext limit, it will get rid of need 
of doing anything extra for group infrastructure.

Jens, do you think per iocontext per queue limit on request descriptors make
sense and we can get rid of per queue overall limit? 

Thanks
Vivek
