Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935671Ab0KQXAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:00:39 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:50860 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932840Ab0KQXAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:00:37 -0500
Subject: Re: [7/8,v3] NUMA Hotplug Emulator: extend memory probe interface
 to support NUMA
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: shaohui.zheng@intel.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        haicheng.li@linux.intel.com, lethal@linux-sh.org, ak@linux.intel.com,
        shaohui.zheng@linux.intel.com, Haicheng Li <haicheng.li@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Greg KH <greg@kroah.com>,
        Aaron Durbin <adurbin@google.com>
In-Reply-To: <alpine.DEB.2.00.1011171434320.22190@chino.kir.corp.google.com>
References: <20101117020759.016741414@intel.com>
	 <20101117021000.916235444@intel.com> <1290019807.9173.3789.camel@nimitz>
	 <alpine.DEB.2.00.1011171312590.10254@chino.kir.corp.google.com>
	 <1290030945.9173.4211.camel@nimitz>
	 <alpine.DEB.2.00.1011171434320.22190@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Wed, 17 Nov 2010 15:00:30 -0800
Message-ID: <1290034830.9173.4363.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 14:44 -0800, David Rientjes wrote:
> > That would work, in theory.  But, in practice, we allocate the mem_map[]
> > at probe time.  So, we've already effectively picked a node at probe.
> > That was done because the probe is equivalent to the hardware "add"
> > event.  Once the hardware where in the address space the memory is, it
> > always also knows the node.
> > 
> > But, I guess it also wouldn't be horrible if we just hot-removed and
> > hot-added an offline section if someone did write to a node file like
> > you're suggesting.  It might actually exercise some interesting code
> > paths.
> 
> Since the pages are offline you should be able to modify the memmap when 
> the 'node' file is written and use populate_memnodemap() since that file 
> is only writeable in an offline state.

It's not just the mem_map[], though.  When a section is sitting
"offline", it's pretty much all ready to go, except that its pages
aren't in the allocators.  But, all of the other mm structures have
already been modified to make room for the pages.  Zones have been added
or modified, pgdats resized, 'struct page's initialized.

Changing the node implies changing _all_ of those, which requires
unrolling most of what happened when the "echo $foo > probe" operation
happened in the first place.

This is all _doable_, but it's not trivial.  

-- Dave

