Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab2AWPuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:50:00 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57495 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab2AWPt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:49:59 -0500
Date: Mon, 23 Jan 2012 07:49:54 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/17] blkcg: shoot down blkio_groups on elevator switch
Message-ID: <20120123154954.GC12652@google.com>
References: <1327202725-3383-1-git-send-email-tj@kernel.org>
 <1327202725-3383-9-git-send-email-tj@kernel.org>
 <20120123152055.GD25986@redhat.com>
 <20120123153648.GE25986@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120123153648.GE25986@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 23, 2012 at 10:36:48AM -0500, Vivek Goyal wrote:
> IIUC, above is racy w.r.t cgroup removal and elevator switch. Assume that
> elevator swtich is taking place and we have queue lock held and we try to
> clear the groups on the queue. Parallely somebody is trying to delete a
> cgroup and has been partially successful in doing so by taking off the
> group from blkcg list (blkiocg_destroy()). 
> 
> Now clear_queue() will complete with one or more groups possibly still
> left on cfqd list because of cgroup deletion race and that can cause
> problmes.

Yeah, the fun of smart-ass locking.  Ultimately, the locking will be
the same locking scheme as ioc's will be used - ie. any modifications
take both locks and there's no limbo state.  Things are so tightly
entangled and I'm finding it very challenging to sequence patches in
the exact order.  I'll see if I can re-sequence locking update before
this but I might just as well declare that there's transitional race
condition in the patch.

There are also a couple other issues that I found yesterday while
updating further patches.

* blkio_list_lock has locking order reversal.  This isn't difficult to
  fix.

* root_group too gets shot down across elv switch.  It needs to be
  reinitialized afterwards.  This one too turns out to be pretty
  tricky to sequence right.

It probably isn't too easy to see the direction at this point, so...

* There will be single blkg per cgroup-request_queue pair regardless
  of the number of policies.  Each blkg carries common part and opaque
  data part for each policy and is managed by blkcg core layer.

* Set of enabled policies will become per-queue property.

Thanks.

-- 
tejun
