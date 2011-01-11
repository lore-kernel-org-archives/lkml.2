Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab1AKIVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 03:21:55 -0500
Received: from smtp-out.google.com ([74.125.121.67]:42558 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab1AKIVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 03:21:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=qyYmRyeeUcsl5g88yvSGsxZ1um7cyiaHOwR5Zzf1vd0VvfDxkrUY4uCcZ/CWkBWOz5
         GPGxILCqq+hoGq1w8dVA==
Date: Tue, 11 Jan 2011 00:21:39 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
cc: Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] one more lock on memory hotplug (Re: [PATCH] slub: Fix
 sysfs circular locking dependency
In-Reply-To: <20110111164401.3b1e5d8a.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1101110019080.21910@chino.kir.corp.google.com>
References: <1294172717-6044-1-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1101050943120.13032@router.home> <alpine.DEB.2.00.1101051108520.14761@router.home> <AANLkTinft80dXqE-U=YDB23d9=BgXLCxJzgiA_gF4cVL@mail.gmail.com>
 <AANLkTinCZzJWYGnxXq_Nwv7QSkEV4Tg-te-1y0PCeRRY@mail.gmail.com> <AANLkTinQMahgVrWLxR0J6Zbh-_SPjxVJ-wuZt8B5TNjc@mail.gmail.com> <alpine.DEB.2.00.1101060019140.25879@chino.kir.corp.google.com> <alpine.DEB.2.00.1101061107500.8655@router.home>
 <20110107091106.aaa07abe.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1101070922100.3014@router.home> <alpine.DEB.2.00.1101071227160.31653@chino.kir.corp.google.com> <AANLkTin6N2s1RN6PBX=f0v69Ny-NkEKk_iAgqscuYgMM@mail.gmail.com> <1294475323.5248.74.camel@jaguar>
 <alpine.DEB.2.00.1101101014470.12243@router.home> <alpine.DEB.2.00.1101101230190.11969@chino.kir.corp.google.com> <4D2BFAA9.2050200@kernel.org> <20110111164401.3b1e5d8a.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Jan 2011, KAMEZAWA Hiroyuki wrote:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Now, memory_hotplug_(un)lock() is used for add/remove/offline pages
> for avoiding races with hibernation. But this should be held in
> online_pages(), too. It seems asymmetric.
> 
> There are cases where one has to avoid a race with memory hotplug
> notifier and his own local code, and hotplug v.s. hotplug.
> This will add a generic solution for avoiding races. In other view,
> having lock here has no big impacts. online pages is tend to be
> done by udev script at el against each memory section one by one.
> 
> Then, it's better to have lock here, too.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

I think taking lock_memory_hotplug() could have been added after the 
initialization of the struct memory_notify, but it's not really important.

Acked-by: David Rientjes <rientjes@google.com>

This should be targeted for 2.6.38 to avoid racing with memory hot-remove 
and for the pending patch in the slab tree from Christoph.

> ---
>  include/linux/memory_hotplug.h |    6 ++++++
>  mm/memory_hotplug.c            |    4 ++++
>  2 files changed, 10 insertions(+)
> 
> Index: linux-2.6.37.org/include/linux/memory_hotplug.h
> ===================================================================
> --- linux-2.6.37.org.orig/include/linux/memory_hotplug.h
> +++ linux-2.6.37.org/include/linux/memory_hotplug.h
> @@ -161,6 +161,12 @@ extern void register_page_bootmem_info_n
>  extern void put_page_bootmem(struct page *page);
>  #endif
>  
> +/*
> + * Lock for memory hotplug guarantees 1) all callbacks for memory hotplug
> + * notifier will be called under this. 2) offline/online/add/remove memory
> + * will not run simultaneously.
> + */
> +
>  void lock_memory_hotplug(void);
>  void unlock_memory_hotplug(void);
>  
> Index: linux-2.6.37.org/mm/memory_hotplug.c
> ===================================================================
> --- linux-2.6.37.org.orig/mm/memory_hotplug.c
> +++ linux-2.6.37.org/mm/memory_hotplug.c
> @@ -407,6 +407,7 @@ int online_pages(unsigned long pfn, unsi
>  	int ret;
>  	struct memory_notify arg;
>  
> +	lock_memory_hotplug();
>  	arg.start_pfn = pfn;
>  	arg.nr_pages = nr_pages;
>  	arg.status_change_nid = -1;
> @@ -419,6 +420,7 @@ int online_pages(unsigned long pfn, unsi
>  	ret = notifier_to_errno(ret);
>  	if (ret) {
>  		memory_notify(MEM_CANCEL_ONLINE, &arg);
> +		unlock_memory_hotplug();
>  		return ret;
>  	}
>  	/*
> @@ -443,6 +445,7 @@ int online_pages(unsigned long pfn, unsi
>  		printk(KERN_DEBUG "online_pages %lx at %lx failed\n",
>  			nr_pages, pfn);
>  		memory_notify(MEM_CANCEL_ONLINE, &arg);
> +		unlock_memory_hotplug();
>  		return ret;
>  	}
>  
> @@ -467,6 +470,7 @@ int online_pages(unsigned long pfn, unsi
>  
>  	if (onlined_pages)
>  		memory_notify(MEM_ONLINE, &arg);
> +	unlock_memory_hotplug();
>  
>  	return 0;
>  }
