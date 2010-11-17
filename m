Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935620Ab0KQWpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:45:09 -0500
Received: from smtp-out.google.com ([216.239.44.51]:51849 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935568Ab0KQWpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:45:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=OKl+MLts3SZrCmMYgG4s/4RVgXxEX17vLsiEGY2MFaB9Re5jmTicW16uXiuOzS25ad
         EyA8sKfDLDVXJ5Jp8F+w==
Date: Wed, 17 Nov 2010 14:44:55 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: shaohui.zheng@intel.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        haicheng.li@linux.intel.com, lethal@linux-sh.org, ak@linux.intel.com,
        shaohui.zheng@linux.intel.com, Haicheng Li <haicheng.li@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Greg KH <greg@kroah.com>,
        Aaron Durbin <adurbin@google.com>
Subject: Re: [7/8,v3] NUMA Hotplug Emulator: extend memory probe interface
 to support NUMA
In-Reply-To: <1290030945.9173.4211.camel@nimitz>
Message-ID: <alpine.DEB.2.00.1011171434320.22190@chino.kir.corp.google.com>
References: <20101117020759.016741414@intel.com> <20101117021000.916235444@intel.com> <1290019807.9173.3789.camel@nimitz> <alpine.DEB.2.00.1011171312590.10254@chino.kir.corp.google.com> <1290030945.9173.4211.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010, Dave Hansen wrote:

> > Then, export the amount of memory that is actually physically present in 
> > the e820 but was truncated by mem=
> 
> I _think_ that's already effectively done in /sys/firmware/memmap.   
> 

Ok.

It's a little complicated because we don't export each online node's 
physical address range so you have to parse the dmesg to find what nodes 
were allocated at boot and determine how much physically present memory 
you have that's hidden but can be hotplugged using the probe files.

Adding Aaron Durbin <adurbin@google.com> to the cc because he has a patch 
that exports the physical address range of each node in their sysfs 
directories.

> > and allow users to hot-add the memory 
> > via the probe interface.  Add a writeable 'node' file to offlined memory 
> > section directories and allow it to be changed prior to online.
> 
> That would work, in theory.  But, in practice, we allocate the mem_map[]
> at probe time.  So, we've already effectively picked a node at probe.
> That was done because the probe is equivalent to the hardware "add"
> event.  Once the hardware where in the address space the memory is, it
> always also knows the node.
> 
> But, I guess it also wouldn't be horrible if we just hot-removed and
> hot-added an offline section if someone did write to a node file like
> you're suggesting.  It might actually exercise some interesting code
> paths.
> 

Since the pages are offline you should be able to modify the memmap when 
the 'node' file is written and use populate_memnodemap() since that file 
is only writeable in an offline state.
