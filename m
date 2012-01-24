Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab2AXQcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 11:32:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51761 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755403Ab2AXQca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 11:32:30 -0500
Date: Tue, 24 Jan 2012 11:32:24 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 14/16] blkcg: don't allow or retain configuration of
 missing devices
Message-ID: <20120124163224.GB17291@redhat.com>
References: <1327360193-24679-1-git-send-email-tj@kernel.org>
 <1327360193-24679-15-git-send-email-tj@kernel.org>
 <20120124154224.GA17291@redhat.com>
 <20120124155309.GA12906@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124155309.GA12906@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 07:53:09AM -0800, Tejun Heo wrote:
> On Tue, Jan 24, 2012 at 10:42:24AM -0500, Vivek Goyal wrote:
> > On Mon, Jan 23, 2012 at 03:09:51PM -0800, Tejun Heo wrote:
> > > +	disk = get_gendisk(dev, &part);
> > > +
> > > +	if ((!disk || part) && temp) {
> > > +		ret = -ENODEV;
> > > +		goto out;
> > > +	}
> > > +
> > > +	rcu_read_lock();
> > > +
> > > +	if (disk && !part) {
> > > +		spin_lock_irq(disk->queue->queue_lock);
> > > +		blkg = blkg_lookup_create(blkcg, disk->queue, plid);
> > > +		spin_unlock_irq(disk->queue->queue_lock);
> > 
> > If queue is in bypass mode, is group creation and linking allowed when
> > somebody is trying to set per device rules. (/me is thinking if there are
> > any potential races between elevator switch and rule setting in cgroup).
> 
> Yeap, there is.  Nice catch.  blkg_lookup_create() should be testing
> blk_queue_bypass() instead of blk_queue_dead() and parse_and_set
> should probably retry after a bit.  Will update.

So now group creation fails if queue is in bypass mode. So a per device
rule setting will fail both for cfq and throttling logic while device
is still around. So a user is supposed to retry? How would a user know 
that elevator switch is happening and he should retry and till when should
he retry.

Thanks
Vivek
