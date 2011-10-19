Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab1JSRTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 13:19:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755851Ab1JSRTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 13:19:23 -0400
Date: Wed, 19 Oct 2011 13:19:17 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com
Subject: Re: [PATCH 07/10] block: reorganize throtl_get_tg() and
 blk_throtl_bio()
Message-ID: <20111019171917.GA4026@redhat.com>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
 <1318998384-22525-8-git-send-email-tj@kernel.org>
 <20111019145622.GE1140@redhat.com>
 <20111019170625.GD25124@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019170625.GD25124@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 10:06:25AM -0700, Tejun Heo wrote:
> Hello,
> 
> On Wed, Oct 19, 2011 at 10:56:22AM -0400, Vivek Goyal wrote:
> > A driver could call blk_cleanup_queue(), mark the queue DEAD and then
> > free the driver provided spin lock. So once queue is DEAD one could
> > not rely on queue lock still being there. That's the reason I did
> > not try to take queue lock again if queue is marked DEAD.
> >
> > Now I see the change that blk_cleanup_queue will start poiting to
> > internal queue lock (Thought it is racy). This will atleast make
> > sure that some spinlock is around. So now this change should be
> > fine.
> 
> The problem with the current code is that all those are not properly
> synchronized.  Drivers shouldn't destroy lock or any other stuff until
> blk_cleanup_queue() is complete and once queue cleanup is done block
> layer shouldn't call out to driver.

If queue lock is provided by driver then block layer has no choice but
to call into driver even after cleanup(). (As after shutdown(), till
release() is called, you will need spin lock to check whether queue is
dead or not).
 
> 
> Currently, the code has different opportunistic checks which can catch
> most of those cases but unfortunatly I think it just makes the bugs
> more obscure.
> 
> That said, we probably should be switching to internal lock once
> clenaup is complete.

So even switching to internal lock is racy. Christoph suggeted to break down
this sharing of queue lock and driver lock and suggested always use
internal queue lock and modify drivers to use their own lock and manage it.
It makes sense though it might be lot of work to fix drivers.

Thanks
Vivek
