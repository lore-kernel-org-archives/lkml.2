Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1AFUrP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:47:15 -0500
Received: from smtp-out.google.com ([216.239.44.51]:10608 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab1AFUrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:47:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=al5XsVb+Iv48UiNhhLrWaeqipR/yPaQpsV8V+I++iIpTQqOaZ+y74TZzKq3WYJh78c
         sQJXmzm9OouaTqFkt05w==
Date: Thu, 6 Jan 2011 12:47:08 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Pekka Enberg <penberg@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] slub: Fix sysfs circular locking dependency
In-Reply-To: <alpine.DEB.2.00.1101061107500.8655@router.home>
Message-ID: <alpine.DEB.2.00.1101061239520.30820@chino.kir.corp.google.com>
References: <1294172717-6044-1-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1101041939030.27551@chino.kir.corp.google.com> <alpine.DEB.2.00.1101050943120.13032@router.home> <alpine.DEB.2.00.1101051108520.14761@router.home>
 <AANLkTinft80dXqE-U=YDB23d9=BgXLCxJzgiA_gF4cVL@mail.gmail.com> <AANLkTinCZzJWYGnxXq_Nwv7QSkEV4Tg-te-1y0PCeRRY@mail.gmail.com> <AANLkTinQMahgVrWLxR0J6Zbh-_SPjxVJ-wuZt8B5TNjc@mail.gmail.com> <alpine.DEB.2.00.1101060019140.25879@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1101061107500.8655@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jan 2011, Christoph Lameter wrote:

> slab_mem_going_online_callback() etc already take the slub_lock since they
> have to iterate over the list of slab caches in existence. We could take
> the hotplug lock there as well.
> 
> Kame-san: Can you enlighten us on hotplug locking? And also check this
> patch?
> 

Yeah, I was going to suggest doing the lock_memory_hotplug() before taking 
slub_lock in the callback, but I really think it should be done in 
online_pages().  Since the offline case is already handled, this would 
expand the semantics of lock_memory_hotplug() to serialize the access of 
data structures that can change in a memory hotplug notifier callback 
without locking at the lower level.
