Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463Ab0GVOBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 10:01:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37526 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab0GVOA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 10:00:59 -0400
Date: Thu, 22 Jul 2010 10:00:44 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, nauman@google.com,
        dpshah@google.com, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
        czoccolo@gmail.com
Subject: Re: [RFC PATCH] cfq-iosced: Implement IOPS mode and group_idle
 tunable V3
Message-ID: <20100722140044.GA28684@redhat.com>
References: <1279739181-24482-1-git-send-email-vgoyal@redhat.com>
 <20100722055602.GA18566@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722055602.GA18566@infradead.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 01:56:02AM -0400, Christoph Hellwig wrote:
> On Wed, Jul 21, 2010 at 03:06:18PM -0400, Vivek Goyal wrote:
> > On high end storage (I got on HP EVA storage array with 12 SATA disks in 
> > RAID 5),
> 
> That's actually quite low end storage for a server these days :)
> 

Yes it is. Just that this is the best I got access to. :-)

> > So this is not the default mode. This new tunable group_idle, allows one to
> > set slice_idle=0 to disable some of the CFQ features and and use primarily
> > group service differentation feature.
> 
> While this is better than before needing a sysfs tweak to get any
> performance out of any kind of server class hardware still is pretty
> horrible.  And slice_idle=0 is not exactly the most obvious paramter
> I would look for either.    So having some way to automatically disable
> this mode based on hardware characteristics would be really useful,

An IO scheduler able to change its behavior based on unerlying storage
property is the ideal and most convenient thing. For that we will need
some kind of auto tuning features in CFQ where we monitor for the ongoing
IO (for sequentiality, for block size) and then try to make some
predictions about the storage property.

Auto tuning is little hard to implement. So I thought that in first step we
can make sure things work reasonably well with the help of tunables and
then look into auto tuning the stuff.

I was actually thinking of writting a user space utility which can do
some specific IO patterns to the disk/lun and setup some IO scheduler
tunables automatically.

> and if that's not possible at least make sure it's very obviously
> document and easily found using web searches.

Sure. I think I will create a new file Documentation/block/cfq-iosched.txt
and document this new mode there. Becuase this mode primarily is useful
for group scheduling, I will also add some info in
Documentation/cgroups/blkio-controller.txt.

> 
> Btw, what effect does slice_idle=0 with your patches have to single SATA
> disk and single SSD setups?

I am not expecting any major effect of IOPS mode on a non-group setup on 
any kind of storage.

IOW, currently if one sets slice_idle=0 in CFQ, then we kind of become almost
like deadline (with some differences here and there). Notion of ioprio
almost disappears except that in some cases you can still see some
service differentation among queues of different prio level.

With this patchset, one would swtich to IOPS mode with slice_idle=0. We
will still show a deadlinish behavior. The only difference will be that
there will be no service differentation among ioprio levels.

I am not bothering about fixing it currently because in slice_idle=0 mode,
notion of ioprio is so weak and unpredictable that I think it is not worth
fixing it at this point of time. If somebody is looking for service
differentation with slice_idle=0, using cgroups might turn out to be a
better bet.

In summary, in non cgroup setup, wth slice_idle=0, one should not see
significant change with this patchset on any kind of storage. With
slice_idle=0, CFQ stops idling and achieves much better throughput and
even in IOPS mode it will continue doing that.

The difference is primarily visible for cgroup users where we get better
accounting done in IOPS mode and are able to provide service differentation
among groups in a more predictable manner.

Thanks
Vivek
