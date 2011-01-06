Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab1AFIaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:30:08 -0500
Received: from smtp-out.google.com ([74.125.121.67]:24707 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab1AFIaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:30:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=PHNw664ySArzF+rck9fDsDHGsD/OZ/7DTNfvT09VQwSPPoPvE7+9LtrNyQBvdRLiIQ
         Vz5+cWscYEAzxLP4xeZg==
Date: Thu, 6 Jan 2011 00:29:58 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Bart Van Assche <bvanassche@acm.org>, Christoph Lameter <cl@linux.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] slub: Fix sysfs circular locking dependency
In-Reply-To: <AANLkTinQMahgVrWLxR0J6Zbh-_SPjxVJ-wuZt8B5TNjc@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1101060019140.25879@chino.kir.corp.google.com>
References: <1294172717-6044-1-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1101041939030.27551@chino.kir.corp.google.com> <alpine.DEB.2.00.1101050943120.13032@router.home> <alpine.DEB.2.00.1101051108520.14761@router.home>
 <AANLkTinft80dXqE-U=YDB23d9=BgXLCxJzgiA_gF4cVL@mail.gmail.com> <AANLkTinCZzJWYGnxXq_Nwv7QSkEV4Tg-te-1y0PCeRRY@mail.gmail.com> <AANLkTinQMahgVrWLxR0J6Zbh-_SPjxVJ-wuZt8B5TNjc@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531368966-2142406274-1294302599=:25879"
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531368966-2142406274-1294302599=:25879
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 5 Jan 2011, Pekka Enberg wrote:

> >> > Subject: slub: Avoid use of slub_lock in show_slab_objects()
> >> >
> >> > The purpose of the locking is to prevent removal and additions
> >> > of nodes when statistics are gathered for a slab cache. So we
> >> > need to avoid racing with memory hotplug functionality.
> >> >
> >> > It is enough to take the memory hotplug locks there instead
> >> > of the slub_lock.
> >> >
> >> >
> >> > Signed-off-by: Christoph Lameter <cl@linux.com>
> >> >
> >> > ---
> >> >  mm/slub.c |    4 ++--
> >> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >> >
> >> > Index: linux-2.6/mm/slub.c
> >> > ===================================================================
> >> > --- linux-2.6.orig/mm/slub.c    2011-01-05 09:55:34.000000000 -0600
> >> > +++ linux-2.6/mm/slub.c 2011-01-05 09:56:27.000000000 -0600
> >> > @@ -3821,7 +3821,7 @@ static ssize_t show_slab_objects(struct
> >> >                }
> >> >        }
> >> >
> >> > -       down_read(&slub_lock);
> >> > +       lock_memory_hotplug();
> >> >  #ifdef CONFIG_SLUB_DEBUG
> >> >        if (flags & SO_ALL) {
> >> >                for_each_node_state(node, N_NORMAL_MEMORY) {
> >> > @@ -3862,7 +3862,7 @@ static ssize_t show_slab_objects(struct
> >> >                        x += sprintf(buf + x, " N%d=%lu",
> >> >                                        node, nodes[node]);
> >> >  #endif
> >> > -       up_read(&slub_lock);
> >> > +       unlock_memory_hotplug();
> >> >        kfree(nodes);
> >> >        return x + sprintf(buf + x, "\n");
> >> >  }
> >>
> >> Makes sense. Bart, does this fix the problem for you?
> >
> > The action sequence that had triggered this sequence (invoke
> > kmem_cache_create(); read all files in /sys/kernel/slab; invoke
> > kmem_cache_destroy()) does now pass without triggering lock inversion
> > complaints.
> 
> Thanks for testing. David, does Christoph's patch look OK to you?
> 

I think it certainly fixes the problem at hand, but I think we also need 
to do lock_memory_hotplug() for memory hotplug in 
slab_mem_going_online_callback() to make show_slab_objects() consistent 
when being printed during concurrent node hot-add since it sets bits in 
N_NORMAL_MEMORY.  The MEM_OFFLINE callback is already handled at a higher 
level by taking the lock in the hotplug layer, but we need to protect the 
MEM_GOING_ONLINE and MEM_CANCEL_ONLINE callbacks if slub_lock is no longer 
used to protect node arrays (which was admittedly always convenient since 
it's typically associated with an iteration through slab_caches).
--531368966-2142406274-1294302599=:25879--
