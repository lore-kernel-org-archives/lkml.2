Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935136Ab1IOVhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 17:37:36 -0400
Received: from claw.goop.org ([74.207.240.146]:40619 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935035Ab1IOVhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 17:37:35 -0400
Message-ID: <4E727017.4030001@goop.org>
Date: Thu, 15 Sep 2011 14:37:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/6] xen: don't call vmalloc_sync_all() when mapping foreign
 pages
References: <1316090411-22608-1-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1316090411-22608-1-git-send-email-david.vrabel@citrix.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2011 05:40 AM, David Vrabel wrote:
> This set of pages avoids the need to call vmalloc_sync_all() when
> mapping foreign pages.  Two new functions are adding for mapping
> foreign pages onto RAM pages instead of vmalloc space.
>
> This does waste a page of RAM for each mapped page.  In the future a
> ballooned page could be used instead (once the API for getting a
> ballooned page with the right GFP flags is available).

You can allocate a pfn, free ("balloon out") the underlying mfn, and
replace it with a granted page; it doesn't need any particular new
infrastructure.

But that said, if you want to allocate virtual addresses for mapping
granted pages, then alloc_vm_area() is the right thing to use.  You need
to make sure you touch the pages from within the kernel before passing
those addresses to a hypercall to make sure the mappings are established
within the current task (possibly within a no-preempt region to
guarantee that nothing odd happens).  Or alternatively, you could switch
the current pagetable to init_mm for the hypercall (if it isn't already)
- since that's the reference pagetable - assuming you're not passing
usermode virtual addresses to the hypercall.

This series is relying on regular ram mappings are already synced to all
tasks, but I'm not sure that's necessarily guaranteed (for example, if
you hotplug new memory into the domain, the new pages won't be mapped
into every mm unless they're synced).

    J
