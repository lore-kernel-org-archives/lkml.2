Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab2CISDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 13:03:19 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:45449 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753565Ab2CISDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 13:03:17 -0500
Date: Fri, 9 Mar 2012 10:03:12 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com
Subject: Re: [PATCH 5/5] blkcg: remove blkio_group->stats_lock
Message-ID: <20120309180312.GC24890@google.com>
References: <1331232840-16044-1-git-send-email-tj@kernel.org>
 <1331232840-16044-6-git-send-email-tj@kernel.org>
 <20120309171523.GB7746@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120309171523.GB7746@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Vivek.

On Fri, Mar 09, 2012 at 12:15:23PM -0500, Vivek Goyal wrote:
> On Thu, Mar 08, 2012 at 10:54:00AM -0800, Tejun Heo wrote:
> > With recent plug merge updates, all non-percpu stat updates happen
> > under queue_lock making stats_lock unnecessary to synchronize stat
> > updates.  The only synchronization necessary is stat reading, which
> > can be done using u64_stats_sync instead.
> > 
> > This patch removes blkio_group->stats_lock and adds
> > blkio_group_stats->syncp for reader synchronization.
> 
> Good to see stat_lock going away. That lock was confusing as we were doing
> updates under queue_lock anyway. One less lock to think about now.
> 
> This stat code is messy though. All time related stat, maintaining flags,
> dividing stats between read/write, sync/async. I think we are maintaining
> way too much of stat. (/me wished there was a way to get rid of some of
> the stats and make code simpler).

The biggest problem I'm having with the stat code is that it almost
mandates spaghettiness.  This stems both from the limitations of
cgroup files and the implementation.  blkcg needs to declare all
possible files upfront on creating cgroup directories, so it needs to
know all files which may be used by any policy implementation.  This
leads another layer of indirection in blkcg core and when a policy
wants to create a new file (including stat), it has to add it to the
blkcg core and then walk back.  This is inherently nasty.  I'm trying
to see whether cgroup can be updated to allow dynamic file
creation/removal so that policies can manage their own files instead
of having to dump everything into blkcg core.

Thanks.

-- 
tejun
