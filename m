Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934608Ab1EST7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 15:59:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934531Ab1EST7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 15:59:04 -0400
Date: Thu, 19 May 2011 15:58:59 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, axboe@kernel.dk
Cc: dpshah@google.com
Subject: Re: [PATCH 00/13] blk-throttle: lockless bio processing for no
 throttle rule group [V2]
Message-ID: <20110519195859.GF12600@redhat.com>
References: <1305833911-7717-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305833911-7717-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 03:38:18PM -0400, Vivek Goyal wrote:
> Hi,
> 
> This is V2 of the patch. Changes from V1 are.
> 
> - Dropped first patch of the series which has already been merged.
> - Fixed couple of white space warnings.
> 
> Jens, I am sending this series on your both the ids. See if both produce
> warnings.
> 
> Block throttling code takes request queue lock for every incoming bio
> (blk_throtl_bio()). This is true even if there are no throttle rules in
> the group. This is a common case for root cgroup where distributions
> will have throttling support compiled in but a vast majority of users
> will not be specifying throttling rule.
> 
> This patch series tries to make bio processing lockless (no requeust
> queue lock), if there are no rules specified for the group. Once
> a bio is submitted, under rcu_read_lock() we search for the group,
> update the stats and release the rcu lock. request queue lock is taken
> only if there are throttling rules specified in the group.
> 
> I have made some of the dispatch stats per cpu so that these can be updated
> without taking request queue lock.

Also forgot to mention that now throttling path does not take blkg->stat_lock
at all. Throttling updates only 3 stats and all these 3 stats have been
converted to per cpu, hence we got rid of the need of taking blkg->stat_lock
also.

Divyesh, can you have a look at locking changes around stats and see if 
you have any concerns.

Thanks
Vivek
