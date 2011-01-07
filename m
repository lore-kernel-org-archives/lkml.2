Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1AGARG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:17:06 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:44850 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab1AGARF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:17:05 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 7 Jan 2011 09:11:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] slub: Fix sysfs circular locking dependency
Message-Id: <20110107091106.aaa07abe.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1101061107500.8655@router.home>
References: <1294172717-6044-1-git-send-email-penberg@kernel.org>
	<alpine.DEB.2.00.1101041939030.27551@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1101050943120.13032@router.home>
	<alpine.DEB.2.00.1101051108520.14761@router.home>
	<AANLkTinft80dXqE-U=YDB23d9=BgXLCxJzgiA_gF4cVL@mail.gmail.com>
	<AANLkTinCZzJWYGnxXq_Nwv7QSkEV4Tg-te-1y0PCeRRY@mail.gmail.com>
	<AANLkTinQMahgVrWLxR0J6Zbh-_SPjxVJ-wuZt8B5TNjc@mail.gmail.com>
	<alpine.DEB.2.00.1101060019140.25879@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1101061107500.8655@router.home>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011 12:10:59 -0600 (CST)
Christoph Lameter <cl@linux.com> wrote:

> On Thu, 6 Jan 2011, David Rientjes wrote:
> 
> > > Thanks for testing. David, does Christoph's patch look OK to you?
> > >
> >
> > I think it certainly fixes the problem at hand, but I think we also need
> > to do lock_memory_hotplug() for memory hotplug in
> > slab_mem_going_online_callback() to make show_slab_objects() consistent
> > when being printed during concurrent node hot-add since it sets bits in
> > N_NORMAL_MEMORY.  The MEM_OFFLINE callback is already handled at a higher
> > level by taking the lock in the hotplug layer, but we need to protect the
> > MEM_GOING_ONLINE and MEM_CANCEL_ONLINE callbacks if slub_lock is no longer
> > used to protect node arrays (which was admittedly always convenient since
> > it's typically associated with an iteration through slab_caches).
> 
> Hmm, I would have expected the callbacks all to be done under hotplug
> locking.
> 
> The MEM_GOING_ONLINE callback is not that critical since a node that is
> coming online presumably has only a minimal set of objects necessary for
> potential future allocations.
> 
> slab_mem_going_online_callback() etc already take the slub_lock since they
> have to iterate over the list of slab caches in existence. We could take
> the hotplug lock there as well.
> 
> Kame-san: Can you enlighten us on hotplug locking? And also check this
> patch?
> 

IIRC, lock_memory_hotplug() is a new lock in 2.6.37 added by Kosaki

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=20d6c96b5f1cad5c5da4641945ec17a1d9a1afc8

as bugfix.

This lock is for avoiding race with hwpoison and memory hotplug and original
lock (before replacement) was for avoiding race with hibernation. online_pages()
was out of lock because it just makes PG_reserved page to be free page, not racy
with hibernation.

But, nice catch. I think MEM_GOING_ONLINE, MEM_ONLINE should be done under
lock_memory_hotplug. So, could you update your patch and modify online_pages() ?

IIUC, online_pages() is an user interface function and there will be no downside
to insert lock there. online_pages() should be serialized.

Thanks,
-Kame





