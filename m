Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab2BBU70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:59:26 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38230 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385Ab2BBU7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:59:24 -0500
Date: Thu, 2 Feb 2012 12:59:20 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] blkcg: unify blkgs for different policies
Message-ID: <20120202205920.GK19837@google.com>
References: <1328131156-13290-1-git-send-email-tj@kernel.org>
 <20120202192958.GA1723@redhat.com>
 <20120202203609.GI19837@google.com>
 <20120202204342.GB30258@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120202204342.GB30258@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Feb 02, 2012 at 03:43:42PM -0500, Vivek Goyal wrote:
> What about bio based drivers? They might have their own internal locking
> and not relying on queue lock. And conceptually, we first throttle the
> bio, update the stats and then call into driver. So are you planning
> to move blk_throtl_bio() call into request function of individual driver
> to avoid taking queue lock twice.
> 
> In fact even for request based drivers, if bio is being merged onto
> existing request on plug, we will not take any queue lock. So I am not
> sure how would you avoid extra queue lock for this case.

For request based drivers, it isn't an issue.  If tracking info across
plug merging is necessary, just record the states in the plug
structure.  The whole purpose of per-task plugging is exactly that -
buffering state before going through request_lock after all.

For ->make_request_fn() drivers, I'm not sure yet and will have to
look through different bio based drivers before deciding.  At the
worst, we might require them to call stat update function under queue
lock or maybe provide fuzzier update or a way to opt out of per-blkg
stats.  Let's see.

Thanks.

-- 
tejun
