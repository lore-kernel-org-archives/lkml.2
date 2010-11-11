Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab0KKVSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 16:18:10 -0500
Received: from smtp-out.google.com ([216.239.44.51]:6306 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757143Ab0KKVSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 16:18:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=xF7XLmXZ3dwJ3Jft72CpcrA2+eNz946NKoN++5GYzmHuMn0Wv/07wxSWHmZgakC2XT
         0FIkLIaXikzt2SFTbdJw==
Date: Thu, 11 Nov 2010 13:18:02 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Artur Baruchi <mail.baruchi@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: mem_map array on NUMA
In-Reply-To: <AANLkTinPX0by5GMTUbbEkb_WeayfY0hBzjYxrZM7asaY@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1011111259340.25829@chino.kir.corp.google.com>
References: <AANLkTinPX0by5GMTUbbEkb_WeayfY0hBzjYxrZM7asaY@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010, Artur Baruchi wrote:

> Hi.
> 
> Im developing a module that get some information about memory pages.
> This module worked fine on non-NUMA machine, I was able to walk
> through the memory using the mem_map array. But, when I tried to
> compile this module in a NUMA machine, the mem_map is not beeing
> exported and I cannot use it.
> 

You're no longer using flatmem in that case.

> Does anybody knows what can be used to substitute the mem_map array in
> a NUMA machine ? Im using the kernel 2.6.35, and the
> comments/documentations for newer kernels seems to be outdated.
> 

It depends on what pages you want to iterate through: pageblock, zone, 
node, or the entire system.  You didn't say what information you're trying 
to obtain, so it's difficult to know whether you want to only look at 
pages within a certain zone or node, pageblocks that are migratable, pages 
mapped by a certain task, etc.

For pages bound to a certain mm or vma, I'd recommend using the 
walk_page_range() interface.  For zone iterations, do:

	struct zone *zone;

	for_each_populated_zone(zone) {
		spin_lock(&zone->lock);
		for (pfn = zone->zone_start_pfn;
		     pfn < zone->zone_start_pfn + zone->spanned_pages; pfn++) {
			if (pfn_valid(pfn)) {
				struct page *page = pfn_to_page(pfn);
	
				/* do something with page */
			}
		}
		spin_unlock(&zone->lock);
	}

Or you could iterate through node_zonelists for only a specified node of 
interest.
