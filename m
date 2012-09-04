Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab2IDTNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 15:13:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51506 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757617Ab2IDTNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 15:13:10 -0400
Date: Tue, 4 Sep 2012 12:13:11 -0700
From: Tejun Heo <tj@kernel.org>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V2] block/throttle: Add IO throttled information in
 blkio.throttle.
Message-ID: <20120904191311.GA6180@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1346390109-3169-1-git-send-email-tm@tao.ma>
 <20120901010540.GA19535@dhcp-172-17-108-109.mtv.corp.google.com>
 <50421493.1020703@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50421493.1020703@tao.ma>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tao Ma.

On Sat, Sep 01, 2012 at 09:58:43PM +0800, Tao Ma wrote:
> Vivek and I have talked about its usage in my first try. See the thread
> here. https://lkml.org/lkml/2012/5/22/81
> And I am OK to say it again here. In our case, we use flashcache as a
> block device and the bad thing is that flashcache is a bio-based dm
> target and we can't use block io controller here to control the weight
> of different cgroups. So io throttle is chosen. But as io throttle can
> only set a hard upper limit for different instances, it makes the
> control not flexible enough. Say with io controller, if there is no
> requests form the cgroup with weight 1000, a cgroup with 500 can use the
> whole bandwidth of the underlying device. But if we set 1000 iops for
> cgroup A and 500 iops for cgroup B in io throttle, cgroup B can't exceed
> its limit even if cgroup A has no request pending. So if we can export
> the io_queued information out to the system admin, they can write some
> daemon and in the above case, increase the upper limit of cgroup B to
> some number say 1000. It helps us to utilize the device more
> efficiently. Does it make sense to you?

Somewhat, in a pretty twisted way. :P

> > Adding throttle.io_queued could be a bit more consistent?
>
> sorry, I don't know what is your meaning here. You mean some codes like
> 	blkg_rwstat_add(&stats_cpu->throttle.io_queude, rw, 1)?

So, there already is io_dispatched, so if you have io_queued, you can
read the two and calculate the difference from userland (reading
io_queued first would probably be better to avoid triggering the
throttled condition spuriously).  That way, you don't have to worry
about synchronizing stats across cpus and it's a simple addition of a
stat conter.

Thanks.

-- 
tejun
