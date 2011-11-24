Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab1KXNZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 08:25:05 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:62610 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754055Ab1KXNZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 08:25:02 -0500
Date: Thu, 24 Nov 2011 14:24:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        Tim Hockin <thockin@hockin.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ben Blum <bblum@andrew.cmu.edu>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <paul@paulmenage.org>,
        Tejun Heo <tj@kernel.org>,
        Containers <containers@lists.linux-foundation.org>,
        Cgroups <cgroups@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH -mm] cgroup: Fix task counter common ancestor logic
Message-ID: <20111124132442.GA18579@somewhere.redhat.com>
References: <1320765670-14181-1-git-send-email-fweisbec@gmail.com>
 <20111108135111.6a74f1d2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111108135111.6a74f1d2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 01:51:11PM -0800, Andrew Morton wrote:
> On Tue,  8 Nov 2011 16:21:10 +0100
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > To solve this, keep the original cgroup of each thread in the thread
> > group cached in the flex array and pass it to can_attach_task()/attach_task()
> > and cancel_attach_task() so that the correct common ancestor between the old
> > and new cgroup can be safely retrieved for each task.
> 
> OK, thanks.
> 
> We need to work out what to do with this patchset.  ie: should we merge
> it.  I'm not sure that the case has been made?
> 
> Let's please drag this thing onto the table and poke at it for a while.
> Probably everyone has forgotten everything so we'll need to start
> again, sorry.  Perhaps you can (re)start proceedings by telling us why
> it's useful to our users and why we should merge it?

Right, so the main purpose is to have a suitable forkbomb protection
in the lxc containers. It seems that these days, using NR_PROC rlimit is
the prime choice to protect against forkbombs. But we can't use this for
containers because if they run under the same user, they can starve each
others by generating high number of processes. So we need the limit on
number of processes to be per container.

The basic requirement is to be able to run untrustee process inside a
container while protecting against attacks from there without impacting
the rest of the system.

I'm adding in Cc some Lxc people who could perhaps provide more details
and testify we really need this.

> Some mental notes:
> 
> Tim says it would be useful for the things he's doing but doesn't
> appear to have confirmed/tested that.

Yeah, I'm waiting for more details from him. Tim?

> Kay has said that it would not be useful for his plumber's wishlist
> item, which is a shame.

Indeed. I mean it would work but this cgroup subsystem is too much overhead
to be used by an init process (and then all other processes).

> I seem to recall complaining that it doesn't address the forkbomb issue
> for non-cgroups setups, so the forkbomb issue remains unaddressed.

Right. Now if we can find a generic solution to protect against all forkbombs,
something deterministic that can react soon enough so that it doesn't impact
the rest of system, in order to avoid running into some DDOS, then we will
consider it.

Thanks.
