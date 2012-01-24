Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab2AXPxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 10:53:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37028 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab2AXPxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 10:53:15 -0500
Date: Tue, 24 Jan 2012 07:53:09 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 14/16] blkcg: don't allow or retain configuration of
 missing devices
Message-ID: <20120124155309.GA12906@google.com>
References: <1327360193-24679-1-git-send-email-tj@kernel.org>
 <1327360193-24679-15-git-send-email-tj@kernel.org>
 <20120124154224.GA17291@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124154224.GA17291@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 10:42:24AM -0500, Vivek Goyal wrote:
> On Mon, Jan 23, 2012 at 03:09:51PM -0800, Tejun Heo wrote:
> > +	disk = get_gendisk(dev, &part);
> > +
> > +	if ((!disk || part) && temp) {
> > +		ret = -ENODEV;
> > +		goto out;
> > +	}
> > +
> > +	rcu_read_lock();
> > +
> > +	if (disk && !part) {
> > +		spin_lock_irq(disk->queue->queue_lock);
> > +		blkg = blkg_lookup_create(blkcg, disk->queue, plid);
> > +		spin_unlock_irq(disk->queue->queue_lock);
> 
> If queue is in bypass mode, is group creation and linking allowed when
> somebody is trying to set per device rules. (/me is thinking if there are
> any potential races between elevator switch and rule setting in cgroup).

Yeap, there is.  Nice catch.  blkg_lookup_create() should be testing
blk_queue_bypass() instead of blk_queue_dead() and parse_and_set
should probably retry after a bit.  Will update.

Thanks.

-- 
tejun
