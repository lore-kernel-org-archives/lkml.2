Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936107Ab0GPJCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 05:02:47 -0400
Received: from smtp-out.google.com ([74.125.121.35]:59532 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936026Ab0GPJCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 05:02:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=FZQJtdktJkuHHEZEUHDxLFuPVWHVGyTax8f0KXesdA7O7HKVsfmibpzBLhpvWlolg
	KRQhe31qAbOgqC/GjdxdA==
Date: Fri, 16 Jul 2010 02:02:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [S+Q2 00/19] SLUB with queueing (V2) beats SLAB netperf TCP_RR
In-Reply-To: <4C4016FD.9080207@cs.helsinki.fi>
Message-ID: <alpine.DEB.2.00.1007160158540.18388@chino.kir.corp.google.com>
References: <20100709190706.938177313@quilx.com> <alpine.DEB.2.00.1007141650110.29110@chino.kir.corp.google.com> <4C4016FD.9080207@cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jul 2010, Pekka Enberg wrote:

> > I'd also consider patch 7 for 2.6.35-rc6 (and -stable).
> 
> It's an obvious bug fix but is it triggered in practice? Is there a bugzilla
> report for that?
> 

Let's ask Benjamin who initially reported the problem with arch_initcall 
whether or not this is rc (and stable) material.

For reference, we're talking about the sysfs_slab_remove() check on 
slab_state to prevent the WARN in the kobject code you hit with its fix 
below:


From: Christoph Lameter <cl@linux-foundation.org>

slub: Allow removal of slab caches during boot

If a slab cache is removed before we have setup sysfs then simply skip over
the sysfs handling.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Roland Dreier <rdreier@cisco.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---
 mm/slub.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2010-07-06 15:13:48.000000000 -0500
+++ linux-2.6/mm/slub.c	2010-07-06 15:15:27.000000000 -0500
@@ -4507,6 +4507,13 @@ static int sysfs_slab_add(struct kmem_ca
 
 static void sysfs_slab_remove(struct kmem_cache *s)
 {
+	if (slab_state < SYSFS)
+		/*
+		 * Sysfs has not been setup yet so no need to remove the
+		 * cache from sysfs.
+		 */
+		return;
+
 	kobject_uevent(&s->kobj, KOBJ_REMOVE);
 	kobject_del(&s->kobj);
 	kobject_put(&s->kobj);
