Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934615Ab0KQIRA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 03:17:00 -0500
Received: from smtp-out.google.com ([216.239.44.51]:2127 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934523Ab0KQIQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 03:16:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=wroUXHmnUtOw29xCQADYHhWZhX8AaOYhhZ9GuDiFCgapvmLOJiNqpbxFJKuuyj3wL2
         UAjvVhXohVmySsA3rveQ==
Date: Wed, 17 Nov 2010 00:16:52 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, ak@linux.intel.com, shaohui.zheng@linux.intel.com,
        Dave Hansen <haveblue@us.ibm.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [3/8,v3] NUMA Hotplug Emulator: Userland interface to hotplug-add
 fake offlined nodes.
In-Reply-To: <20101117021000.638336620@intel.com>
Message-ID: <alpine.DEB.2.00.1011170010430.17408@chino.kir.corp.google.com>
References: <20101117020759.016741414@intel.com> <20101117021000.638336620@intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010, shaohui.zheng@intel.com wrote:

> From: Haicheng Li <haicheng.li@intel.com>
> 
> Add a sysfs entry "probe" under /sys/devices/system/node/:
> 
>  - to show all fake offlined nodes:
>     $ cat /sys/devices/system/node/probe
> 
>  - to hotadd a fake offlined node, e.g. nodeid is N:
>     $ echo N > /sys/devices/system/node/probe
> 

This would be much more powerful if we just reserved an amount of memory 
at boot and then allowed users to hot-add a given amount with an 
non-online node id.  Then we can test nodes of various sizes rather than 
being statically committed at boot.

This should be fairly straight-forward by faking 
ACPI_SRAT_MEM_HOT_PLUGGABLE entries, for example.

> Index: linux-hpe4/mm/Kconfig
> ===================================================================
> --- linux-hpe4.orig/mm/Kconfig	2010-11-15 17:13:02.443461606 +0800
> +++ linux-hpe4/mm/Kconfig	2010-11-15 17:21:05.535335091 +0800
> @@ -147,6 +147,21 @@
>  	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
>  	depends on MIGRATION
>  
> +config NUMA_HOTPLUG_EMU
> +	bool "NUMA hotplug emulator"
> +	depends on X86_64 && NUMA && MEMORY_HOTPLUG
> +
> +	---help---
> +
> +config NODE_HOTPLUG_EMU
> +	bool "Node hotplug emulation"
> +	depends on NUMA_HOTPLUG_EMU && MEMORY_HOTPLUG
> +	---help---
> +	  Enable Node hotplug emulation. The machine will be setup with
> +	  hidden virtual nodes when booted with "numa=hide=N*size", where
> +	  N is the number of hidden nodes, size is the memory size per
> +	  hidden node. This is only useful for debugging.
> +

That's clearly wrong, but I don't see why this needs to be a new Kconfig 
option to begin with, can't we enable all of this functionality by default 
under CONFIG_NUMA_EMU && CONFIG_MEMORY_HOTPLUG?
