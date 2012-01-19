Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab2ASPtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 10:49:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756102Ab2ASPtY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 10:49:24 -0500
Date: Thu, 19 Jan 2012 10:49:19 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/12] blkcg: kill the mind-bending blkg->dev
Message-ID: <20120119154919.GA10908@redhat.com>
References: <1326935490-11827-1-git-send-email-tj@kernel.org>
 <1326935490-11827-13-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326935490-11827-13-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 18, 2012 at 05:11:30PM -0800, Tejun Heo wrote:
> blkg->dev is dev_t recording the device number of the block device for
> the associated request_queue.  It is used to identify the associated
> block device when printing out configuration or stats.
> 
> This is redundant to begin with.  A blkg is an association between a
> cgroup and a request_queue and it of course is possible to reach
> request_queue from blkg and synchronization conventions are in place
> for safe q dereferencing, so this shouldn't be necessary from the
> beginning.  Furthermore, it's initialized by sscanf()ing the device
> name of backing_dev_info.  The mind boggles.
> 
> Anyways, if blkg is visible under rcu lock, we *know* that the
> associated request_queue hasn't gone away yet and its bdi is
> registered and alive - blkg can't be created for request_queue which
> hasn't been fully initialized and it can't go away before blkg is
> removed.
> 
> Let stat and conf read functions get device name from
> blkg->q->backing_dev_info.dev and pass it down to printing functions
> and remove blkg->dev.

I think one of the reasons for not using blkg->q->backing_dev_info.dev was
that there were still drivers where multiple gendisks were sharing the
request queue.

Thanks
Vivek
