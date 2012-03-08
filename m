Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759141Ab2CHXa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 18:30:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759068Ab2CHXaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 18:30:55 -0500
Date: Thu, 8 Mar 2012 15:30:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>,
        Will Drewry <wad@chromium.org>, Elly Jones <ellyjones@chromium.org>,
        Milan Broz <mbroz@redhat.com>, Olof Johansson <olofj@chromium.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: workqueues and percpu (was: [PATCH] dm: remake of the verity
 target)
Message-Id: <20120308153048.4a80de34.akpm@linux-foundation.org>
In-Reply-To: <20120308231521.GA2968@htj.dyndns.org>
References: <1330648393-20692-1-git-send-email-msb@chromium.org>
	<Pine.LNX.4.64.1203031340340.10937@file.rdu.redhat.com>
	<20120306215947.GB27051@google.com>
	<Pine.LNX.4.64.1203081656590.31821@file.rdu.redhat.com>
	<20120308143909.bfc4cb4d.akpm@linux-foundation.org>
	<20120308231521.GA2968@htj.dyndns.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2012 15:15:21 -0800
Tejun Heo <tj@kernel.org> wrote:

> > I'm not sure what we can do about it really, apart from blocking unplug
> > until all the target CPU's workqueues have been cleared.  And/or refusing
> > to unplug a CPU until all pinned-to-that-cpu kernel threads have been
> > shut down or pinned elsewhere (which is the same thing, only more
> > general).
> > 
> > Tejun, is this new behaviour?  I do recall that a long time ago we
> > wrestled with unplug-vs-worker-threads and I ended up OK with the
> > result, but I forget what it was.  IIRC Rusty was involved.
> 
> Unfortunately, yes, this is a new behavior.  Before, we could have
> unbound delays during unplug from work items.  Now, we have CPU
> affinity assumption breakage.

Ow, didn't know that.

>  The behavior change was primarily to
> allow long running work items to use regular workqueues without
> worrying about inducing delay across cpu hotplug operations, which is
> important as it's also used on suspend / hibernation, especially on
> mobile platforms.

Well..  why did we want to support these long-running work items? 
They're abusive, aren't they?  Where are they?

> During the cmwq conversion, I ended up auditing a lot of (I think I
> went through most of them) workqueue users and IIRC there weren't too
> many which required stable affinity.
> 
> > That being said, I don't think it's worth compromising the DM code
> > because of this workqueue wart: lots of other code has the same wart,
> > and we should find a centralised fix for it.
> 
> Probably the best way to solve this is introducing pinned attribute to
> workqueues and have them drained automatically on cpu hotplug events.
> It'll require auditing workqueue users but I guess we'll just have to
> do it given that we need to actually distinguish the ones need to be
> pinned.

That will make future use of workqueues more complex and people will
screw it up.

>  Or maybe we can use explicit queue_work_on() to distinguish
> the ones which require pinning.
> 
> Another approach would be requiring all workqueues to be drained on
> cpu offlining and requiring any work item which may stall to use
> unbound wq.  IMHO, picking out the ones which may stall would be much
> less obvious than the ones which require cpu pinning.

I'd be surprised if it's *that* hard to find and fix the long-running
work items.  Hopefully most of them are already using
create_freezable_workqueue() or create_singlethread_workqueue().

I wonder if there's some debug code we can put in workqueue.c to detect
when a pinned work item takes "too long".

