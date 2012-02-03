Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757884Ab2BCVHD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 16:07:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53713 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753920Ab2BCVHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 16:07:01 -0500
Date: Fri, 3 Feb 2012 16:06:56 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH UPDATED 11/11] blkcg: unify blkg's for blkcg policies
Message-ID: <20120203210656.GB12616@redhat.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <1328131156-13290-12-git-send-email-tj@kernel.org>
 <20120202003730.GC19837@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202003730.GC19837@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 04:37:30PM -0800, Tejun Heo wrote:
> Currently, blkg is per cgroup-queue-policy combination.  This is
> unnatural and leads to various convolutions in partially used
> duplicate fields in blkg, config / stat access, and general management
> of blkgs.
> 
> This patch make blkg's per cgroup-queue and let them serve all
> policies.  blkgs are now created and destroyed by blkcg core proper.
> This will allow further consolidation of common management logic into
> blkcg core and API with better defined semantics and layering.
> 
> As a transitional step to untangle blkg management, elvswitch and
> policy [de]registration, all blkgs except the root blkg are being shot
> down during elvswitch and bypass.  This patch adds blkg_root_update()
> to update root blkg in place on policy change.  This is hacky and racy
> but should be good enough as interim step until we get locking
> simplified and switch over to proper in-place update for all blkgs.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> ---
> I was thinking root blkgs should be updated on policy changes and
> commit message and comments were written that way too but for some
> reason I wrote code which updates on elvswitch, which leads to oops on
> root blkg access after policy changes (ie. insmod cfq-iosched.ko).
> Fixed.  git branch updated accordingly.

Tejun,

Shouldn't we shoot down root group policy data upon elevator switch?
Otherwise once the elevator comes back, it will continue to use old
policy data (old stats, overwrite old weigts etc.).

Thanks
Vivek
