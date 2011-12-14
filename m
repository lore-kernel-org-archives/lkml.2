Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab1LNB33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 20:29:29 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58930 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab1LNB30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 20:29:26 -0500
Date: Tue, 13 Dec 2011 17:29:22 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohua Li <shaohua.li@intel.com>
cc: "Shi, Alex" <alex.shi@intel.com>, Christoph Lameter <cl@linux.com>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] slub: set a criteria for slub node partial adding
In-Reply-To: <1323657793.22361.383.camel@sli10-conroe>
Message-ID: <alpine.DEB.2.00.1112131726140.8593@chino.kir.corp.google.com>
References: <1322814189-17318-1-git-send-email-alex.shi@intel.com> <alpine.DEB.2.00.1112020842280.10975@router.home> <1323076965.16790.670.camel@debian> <alpine.DEB.2.00.1112061259210.28251@chino.kir.corp.google.com> <1323234673.22361.372.camel@sli10-conroe>
 <alpine.DEB.2.00.1112062319010.21785@chino.kir.corp.google.com> <1323657793.22361.383.camel@sli10-conroe>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011, Shaohua Li wrote:

> With the per-cpu partial list, I didn't see any workload which is still
> suffering from the list lock, so I suppose both the trashing approach
> and pick 25% used slab approach don't help.

This doesn't necessarily have anything to do with contention on list_lock, 
it has to do with the fact that ~99% of allocations come from the slowpath 
since the cpu slab only has one free object when it is activated, that's 
what the statistics indicated for kmalloc-256 and kmalloc-2k.  That's what 
I called "slab thrashing": the continual deactivation of the cpu slab and 
picking from the partial list that would only have one or two free objects 
causing the vast majority of allocations to require the slowpath.
