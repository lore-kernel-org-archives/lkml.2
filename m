Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab1AKIYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 03:24:24 -0500
Received: from smtp-out.google.com ([216.239.44.51]:13185 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab1AKIYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 03:24:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=imFQqcz5rRU4q1P8GEk+Qla4c3FqZUhbVxhu7guij0LtPZntNNjBprM4037w34MW9a
         hZ+j41qGyhsmBxAB+Rsw==
Date: Tue, 11 Jan 2011 00:24:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <cl@linux.com>, Bart Van Assche <bvanassche@acm.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: Fix sysfs circular locking dependency
In-Reply-To: <4D2BFAA9.2050200@kernel.org>
Message-ID: <alpine.DEB.2.00.1101110021470.21910@chino.kir.corp.google.com>
References: <1294172717-6044-1-git-send-email-penberg@kernel.org>  <alpine.DEB.2.00.1101041939030.27551@chino.kir.corp.google.com>  <alpine.DEB.2.00.1101050943120.13032@router.home>  <alpine.DEB.2.00.1101051108520.14761@router.home>
 <AANLkTinft80dXqE-U=YDB23d9=BgXLCxJzgiA_gF4cVL@mail.gmail.com>  <AANLkTinCZzJWYGnxXq_Nwv7QSkEV4Tg-te-1y0PCeRRY@mail.gmail.com>  <AANLkTinQMahgVrWLxR0J6Zbh-_SPjxVJ-wuZt8B5TNjc@mail.gmail.com>  <alpine.DEB.2.00.1101060019140.25879@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1101061107500.8655@router.home>  <20110107091106.aaa07abe.kamezawa.hiroyu@jp.fujitsu.com>  <alpine.DEB.2.00.1101070922100.3014@router.home>  <alpine.DEB.2.00.1101071227160.31653@chino.kir.corp.google.com>  <AANLkTin6N2s1RN6PBX=f0v69Ny-NkEKk_iAgqscuYgMM@mail.gmail.com>
 <1294475323.5248.74.camel@jaguar> <alpine.DEB.2.00.1101101014470.12243@router.home> <alpine.DEB.2.00.1101101230190.11969@chino.kir.corp.google.com> <4D2BFAA9.2050200@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011, Pekka Enberg wrote:

> > > New patch that just covers the slub changes.
> > > 
> > > Subject: slub: Avoid use of slub_lock in show_slab_objects()
> > > 
> > > The purpose of the locking is to prevent removal and additions
> > > of nodes when statistics are gathered for a slab cache. So we
> > > need to avoid racing with memory hotplug functionality.
> > > 
> > > It is enough to take the memory hotplug locks there instead
> > > of the slub_lock.
> > > 
> > > online_pages() currently does not acquire the memory_hotplug
> > > lock. Another patch will be submitted by the memory hotplug
> > > authors to take the memory hotplug lock and describe the
> > > uses of the memory hotplug lock to protect against
> > > adding and removal of nodes from non hotplug data structures.
> > > 
> > > Signed-off-by: Christoph Lameter<cl@linux.com>
> > Acked-by: David Rientjes<rientjes@google.com>
> 
> Is this safe to be applied without the other hotplug parts?
> 

It's safe, but not protecting anything since it can race with memory 
hot-add and cause inconsistent information to be displayed (since we 
iterate over N_NORMAL_MEMORY several times in show_slab_objects() and the 
memory hotplug code modifies it).  I'm hoping Andrew can push Kame's patch 
to add lock_memory_hotplug() to online_pages() either during the merge 
window or during -rc1 (it has good justification -- it can race with 
memory hot-remove) and this can also be pushed during the rc series (to 
fix the lockdep warning).
