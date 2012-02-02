Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933548Ab2BBWLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 17:11:21 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:45065 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab2BBWLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 17:11:19 -0500
Date: Thu, 2 Feb 2012 14:11:14 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/11] blkcg: move refcnt to blkcg core
Message-ID: <20120202221114.GA5865@google.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <1328131156-13290-7-git-send-email-tj@kernel.org>
 <20120202220714.GE1723@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202220714.GE1723@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Feb 02, 2012 at 05:07:14PM -0500, Vivek Goyal wrote:
> On Wed, Feb 01, 2012 at 01:19:11PM -0800, Tejun Heo wrote:
> > Currently, blkcg policy implementations manage blkg refcnt duplicating
> > mostly identical code in both policies.  This patch moves refcnt to
> > blkg and let blkcg core handle refcnt and freeing of blkgs.
> > 
> > * cfq blkgs now also get freed via RCU.
> 
> This can lead to situation where cfq root group (policy data) is still
> around (yet to be freed after rcu perioed) but cfq has gone away
> (cfq_exit_queue() followed by cfq_exit()). Does it matter? If some future
> code is accessing cfqg under rcu, it can become a problem.

If RCU is being used, the scope of access allowed under it should be
defined strictly.  It's basically adding another layer of locking and
like any other locking, if the boundary isn't clearly defined, it's
gonna cause a problem.  For blkcg, from the current usage, it's enough
to guarantee access to blkg proper including policy specific data and
under that scope, it doesn't matter whether request or cgroup goes
away.

Thanks.

-- 
tejun
