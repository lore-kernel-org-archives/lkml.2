Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab1AEPvH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 10:51:07 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:44955 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750699Ab1AEPvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 10:51:06 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 9kgrzW4VM1mu_BCixCIrd4doairuRC74ifgILIRuDmE_ia5
 WcxF98iWaMQNPkyT0qYFQOcVYD2YV_xl7tTN._iLB18xd2icCUY8AAmek9UU
 cHGnXhRbSGbWjLTmD3_.Ou98Ll69v.IX2z3K_c86UAHL5lpmct6edhMUa3_9
 AuAgC_T76cj.hl_R024NdsBVWZNeDeSoB.tEzqYRElEp04C1rSgcpDIdS9gd
 WNgu657iseZEMIQjKK6LcX3IwVBsdLPKmLgxq3dM1RPQPmIZ8zpyrI_mm7Hi
 h8NjWPAheO1LQgrQ24w8iRHVzex3p9RWFiuo70wxrBJylJjo-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 5 Jan 2011 09:51:02 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Bart Van Assche <bart.vanassche@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] slub: Fix sysfs circular locking dependency
In-Reply-To: <alpine.DEB.2.00.1101041939030.27551@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1101050943120.13032@router.home>
References: <1294172717-6044-1-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1101041939030.27551@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Jan 2011, David Rientjes wrote:

> slub_lock protects slab_state following kmem_cache_init() if caches are
> created/destroyed prior to the sysfs slab initcall setting the global
> variable, so couldn't this leak the kobject if its initialization and add
> was deferred on kmem_cache_create() and added by slab_sysfs_init()?

Potentially.

Also note that the same lock inversion occurs in kmem_cache_create().
slub lock is taken and then sysfs operations are performed.

The problem is that slub_lock has multiple roles:

1. Protect the list of slab caches and the slab_state (thats why its
   mainly used in kmem_cache_destroy and kmem_cache_create)

2. Protect against removal and adding of new cpus and nodes
   (show_slab_objects)


If we could create another lock that protects against new cpus / nodes
being added and removed then we could take that lock in
show_slab_objects() instead.

IMHO the lock order must have the slub_lock at the top.

The other lock that would prevent adding/removal of nodes / cpu can be
taken in show_slab_objects and in the corresponding hotplug functions. We
do not need to take the lock at all in show_slab_objects cpu and memory
hotplug are not enabled. Maybe there is a hotplug specific lock that can
be used instead?


