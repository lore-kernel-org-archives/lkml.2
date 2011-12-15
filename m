Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759443Ab1LOT0F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:26:05 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:36458 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759387Ab1LOT0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:26:03 -0500
Subject: Re: workqueue_set_max_active(wq, 0)?
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20111215191212.GD32002@google.com> (sfid-20111215_201251_422219_444A9248)
References: <1323424482.3622.8.camel@jlt3.sipsolutions.net>
	 <20111209165702.GD12108@google.com>
	 <1323963492.23550.1.camel@jlt3.sipsolutions.net>
	 <20111215183537.GA32002@google.com>
	 <1323974620.1082.7.camel@jlt3.sipsolutions.net>
	 <20111215191212.GD32002@google.com> (sfid-20111215_201251_422219_444A9248)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 20:26:01 +0100
Message-ID: <1323977161.1082.12.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-15 at 11:12 -0800, Tejun Heo wrote:

> > Hm, good point. We can't abstract out all of it -- the freezer API
> > doesn't want to wait for it to finish -- but probably a bit of it.
> > 
> > How do you iterate workqueues? We'd have to do that for the freezer
> > part, unless we want to work on CWQs again.
> 
> By Locking workqueue_lock and walking workqueues list.  Hmmm...

Ah. So fundamentally, the freeze code does:

 * set each gcwq frozen
 * set max_active=0 for each CWQ in each WQ

but it interleaves the two loops. I guess this would have to be
untangled if we want to share it so it sets all gcwq frozen and then
iterates the workqueues and their CWQs. Locking seems a bit hairy
though, why does the current code keep the GCWQ lock over CWQ changes? I
guess that's so nothing can work on the CWQ?

> > Actually I'm not really sure I understand the differences between WQ,
> > CWQ and GCWQ...
> 
[snip explanation]

thanks.

> The reason why FREEZING currently is on GCWQ is because freezing is a
> system wide operation.  If we're gonna implement pause, I think it
> should probably be in cwq.

Ok, makes sense too.

I think I'm going to do something simpler first though, the locking
scares me a bit. I'll do something for my single-threaded max-active=1
workqueue first directly in mac80211 to try out the idea ...

johannes

