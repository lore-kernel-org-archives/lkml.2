Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab1AFSLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:11:05 -0500
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:26217 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752368Ab1AFSLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:11:04 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: XXhcUjUVM1lXAGvdcVqdv7T.S1LenKffkMjStzaFQFcAf5X
 0P3Wm3B_k2jnE5IxIEE5ExGBZBSYGe1niXkPKX0fEaTBxz53DLl_bVKyHB.7
 rCdTPtUap_NXdD9I6QCVBaVORu50WepfS7CqKm9KxtzacElHCoKUBLgCrDg3
 Z7pqXEKBtYQFKL3.Muq.fVPB6hu.gf_1odGBGkzPRydgAc9RYcFT2dCgQ7V7
 Eyr10XJfFvhqTtzzFUeioiP4WHyZCBzqEJff2cwez9RrK8TRdLO3NfMb2UKY
 SwP_X25bnj.ohZ3XqXEEmiEvZkH2MmHIxbt4p54d2Na7FDmc-
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 6 Jan 2011 12:10:59 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] slub: Fix sysfs circular locking dependency
In-Reply-To: <alpine.DEB.2.00.1101060019140.25879@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1101061107500.8655@router.home>
References: <1294172717-6044-1-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1101041939030.27551@chino.kir.corp.google.com> <alpine.DEB.2.00.1101050943120.13032@router.home> <alpine.DEB.2.00.1101051108520.14761@router.home>
 <AANLkTinft80dXqE-U=YDB23d9=BgXLCxJzgiA_gF4cVL@mail.gmail.com> <AANLkTinCZzJWYGnxXq_Nwv7QSkEV4Tg-te-1y0PCeRRY@mail.gmail.com> <AANLkTinQMahgVrWLxR0J6Zbh-_SPjxVJ-wuZt8B5TNjc@mail.gmail.com> <alpine.DEB.2.00.1101060019140.25879@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.DEB.2.00.1101061107502.8655@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011, David Rientjes wrote:

> > Thanks for testing. David, does Christoph's patch look OK to you?
> >
>
> I think it certainly fixes the problem at hand, but I think we also need
> to do lock_memory_hotplug() for memory hotplug in
> slab_mem_going_online_callback() to make show_slab_objects() consistent
> when being printed during concurrent node hot-add since it sets bits in
> N_NORMAL_MEMORY.  The MEM_OFFLINE callback is already handled at a higher
> level by taking the lock in the hotplug layer, but we need to protect the
> MEM_GOING_ONLINE and MEM_CANCEL_ONLINE callbacks if slub_lock is no longer
> used to protect node arrays (which was admittedly always convenient since
> it's typically associated with an iteration through slab_caches).

Hmm, I would have expected the callbacks all to be done under hotplug
locking.

The MEM_GOING_ONLINE callback is not that critical since a node that is
coming online presumably has only a minimal set of objects necessary for
potential future allocations.

slab_mem_going_online_callback() etc already take the slub_lock since they
have to iterate over the list of slab caches in existence. We could take
the hotplug lock there as well.

Kame-san: Can you enlighten us on hotplug locking? And also check this
patch?


