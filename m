Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab1C2Udb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 16:33:31 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39392 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab1C2Uda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 16:33:30 -0400
Subject: Re: [PATCH 3/3] mm: Extend memory hotplug API to allow memory
 hotplug in virtual machines
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Kiper <dkiper@net-space.pl>, ian.campbell@citrix.com,
        andi.kleen@intel.com, haicheng.li@linux.intel.com,
        fengguang.wu@intel.com, jeremy@goop.org, konrad.wilk@oracle.com,
        dan.magenheimer@oracle.com, v.tolstov@selfip.ru, pasik@iki.fi,
        wdauchy@gmail.com, rientjes@google.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20110329121541.d9a27c2e.akpm@linux-foundation.org>
References: <20110328092507.GD13826@router-fw-old.local.net-space.pl>
	 <20110328153735.d797c5b3.akpm@linux-foundation.org>
	 <20110329185913.GF30387@router-fw-old.local.net-space.pl>
	 <20110329121541.d9a27c2e.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 29 Mar 2011 13:33:14 -0700
Message-ID: <1301430794.21454.638.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 12:15 -0700, Andrew Morton wrote:
> On Tue, 29 Mar 2011 20:59:13 +0200
> Daniel Kiper <dkiper@net-space.pl> wrote:

> > OK. I am looking for simple generic mechanism which allow runtime
> > registration/unregistration of generic or module specific (in that
> > case Xen) page onlining function. Dave Hansen sugested compile time
> > solution (https://lkml.org/lkml/2011/2/8/235), however, it does not
> > fit well in my new project on which I am working on (I am going post
> > details at the end of April).
> 
> Well, without a complete description of what you're trying to do and
> without any indication of what "does not fit well" means, I'm at a bit
> of a loss to suggest anything.

We need (the arch-independent) online_page() to act differently when
we're hotplugging a Xen ballooned page versus a normal memory hotplug
operation.  We've basically run out of pages to take out of the balloon
and we need some more with which to fill it up (thus the hotplug).  But,
pages _in_ the balloon are not currently in use.  We want to hot-add
pages to the system, but keep them unused.

online_page(page)
{
	// add page to counters and max_pfn 
	...
	
	if (xen_doing_hotplug(page))
		put_page_in_balloon(page);
	else
		free_page(page);
}

Daniel also seems to want to avoid incrementing the counters and then
immediately decrementing them in the Xen code.  I'm not sure it matters.

-- Dave

