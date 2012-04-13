Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab2DMVb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 17:31:29 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37146 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab2DMVb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 17:31:26 -0400
Date: Fri, 13 Apr 2012 14:31:15 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCH 07/11] blkcg: make request_queue bypassing on allocation
Message-ID: <20120413213115.GI12233@google.com>
References: <1334347895-6268-1-git-send-email-tj@kernel.org>
 <1334347895-6268-8-git-send-email-tj@kernel.org>
 <20120413203205.GI26383@redhat.com>
 <20120413203726.GE12233@google.com>
 <20120413204446.GK26383@redhat.com>
 <20120413204710.GF12233@google.com>
 <20120413205501.GL26383@redhat.com>
 <20120413210548.GG12233@google.com>
 <20120413211640.GH12233@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120413211640.GH12233@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 02:16:40PM -0700, Tejun Heo wrote:
> On Fri, Apr 13, 2012 at 02:05:48PM -0700, Tejun Heo wrote:
> > On Fri, Apr 13, 2012 at 04:55:01PM -0400, Vivek Goyal wrote:
> > > But neither seems to be the case here. So to make sure that blkg_lookup()
> > > under rcu will see the updated value of queue flag (bypass), are we
> > > relying on the fact that caller should see the DEAD flag and not go
> > > ahead with blkg_lookup()?  If yes, atleast it is not obivious.
> > 
> > We're relying on the fact that it doesn't matter anymore because all
> > blkgs will be shoot down in queue cleanup path which goes through rcu
> > free, which is different from deactivating individual policies.  It
> > indeed is subtle.  Umm... this is starting to get ridiculous.  Why the
> > hell was megaraid messing with so many queues anyways?
> 
> I suppose megaraid depends on sequential LUN scan which SCSI
> implements by creating sdev for each LUN, trying to see whether it
> actually exists and then destroys the sdev if not.  Urgh.... so, we
> seem to be stuck with it.
> 
> So, the current code is technically correct although subtle like hell.
> We can RCU defer blk_put_queue() from blk_cleanup_queue() using
> call_rcu() to make clear that RCU grace period is necessary there.
> Any better ideas?

I think I'm just gonna add comments clarifying why explicit
synchronize_rcu() isn't necessary there and the expected behavior (RCU
deferred freeing of any data structures which may be accessed under
RCU read lock) on queue cleanup path.  Doing RCU deferral would
require double bouncing (first through RCU then through workqueue)
because blk_release_queue() requires process context.  :(

Thanks.

-- 
tejun
