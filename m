Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759378Ab1LOTMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:12:20 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55772 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab1LOTMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:12:19 -0500
Date: Thu, 15 Dec 2011 11:12:12 -0800
From: Tejun Heo <tj@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: workqueue_set_max_active(wq, 0)?
Message-ID: <20111215191212.GD32002@google.com>
References: <1323424482.3622.8.camel@jlt3.sipsolutions.net>
 <20111209165702.GD12108@google.com>
 <1323963492.23550.1.camel@jlt3.sipsolutions.net>
 <20111215183537.GA32002@google.com>
 <1323974620.1082.7.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323974620.1082.7.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 15, 2011 at 07:43:40PM +0100, Johannes Berg wrote:
> Hm, good point. We can't abstract out all of it -- the freezer API
> doesn't want to wait for it to finish -- but probably a bit of it.
> 
> How do you iterate workqueues? We'd have to do that for the freezer
> part, unless we want to work on CWQs again.

By Locking workqueue_lock and walking workqueues list.  Hmmm...

> Actually I'm not really sure I understand the differences between WQ,
> CWQ and GCWQ...

WQ is workqueue - the part visible to users.

CWQ is cpu workqueue.  Each wq has its own set of cpu workqueues for
all CPUs (there are exceptions but this should be a good enough
explanation).  A WQ is always a set of cwq's.  WQ chooses which CWQ to
use on queue but most of actual processing happens on CWQs.

GCWQ stands for global cpu workqueue - there's one for each CPU.  This
is per-cpu global worker pool used by all workqueues.  Every CWQ on a
CPU shares the GCWQ on that CPU.

The reason why FREEZING currently is on GCWQ is because freezing is a
system wide operation.  If we're gonna implement pause, I think it
should probably be in cwq.

> > I think it would be great if this can be abstracted out so that both
> > the freezer and explicit pausing use the same facility.  They aren't
> > that different after all.
> 
> I'll take a look tomorrow. If you want to beat me to it ... ;-)

Heh heh, [un]fortunately, I'm pretty occupied at the moment.  :P

Thank you.

-- 
tejun
