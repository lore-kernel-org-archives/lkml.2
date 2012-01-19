Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab2ASQqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 11:46:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323Ab2ASQqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:46:46 -0500
Date: Thu, 19 Jan 2012 11:46:41 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] blkcg: kill the mind-bending blkg->dev
Message-ID: <20120119164641.GA15561@redhat.com>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
 <1326935490-11827-13-git-send-email-tj@kernel.org>
 <20120119154919.GA10908@redhat.com>
 <20120119163056.GH5198@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120119163056.GH5198@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 08:30:56AM -0800, Tejun Heo wrote:
> Hello,
> 
> On Thu, Jan 19, 2012 at 10:49:19AM -0500, Vivek Goyal wrote:
> > > Let stat and conf read functions get device name from
> > > blkg->q->backing_dev_info.dev and pass it down to printing functions
> > > and remove blkg->dev.
> > 
> > I think one of the reasons for not using blkg->q->backing_dev_info.dev was
> > that there were still drivers where multiple gendisks were sharing the
> > request queue.
> 
> Hmmm... is that relevant?  The configurations / stats are per
> cgroup-request_queue pair.  How does multiple genhd's sharing a queue
> make any difference?  Also, the fill_dev_details functions were using
> the same q->backing_dev_info to fill it in, so it's not like it was
> using anything different.

You are right. Looks like it should not make any difference. Also looks
like bdi->dev points to first disk on the queue and ignores later ones.

int bdi_register(struct backing_dev_info *bdi, struct device *parent,
                const char *fmt, ...)
{       
        if (bdi->dev)   /* The driver needs to use separate queues per
device */
                return 0;
}

So if a queue is being shared by multiple disks, then any throttling rule
on the device will practically trated a rule on the queue and will be
effective on all the devices cumulatively. So sounds fine.

Thanks
Vivek
