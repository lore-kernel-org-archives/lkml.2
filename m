Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab0L1He5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 02:34:57 -0500
Received: from smtp-out.google.com ([216.239.44.51]:9620 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab0L1Hez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 02:34:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=HFPyMP3ZK9wSvaGtL8hQccBOBxl/zq9ttfvUaGhIvI1Kr0HakZiovqor6AH8W9TFZP
         hgdC8dbno1AyGWWx1VNg==
Date: Mon, 27 Dec 2010 23:34:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        haicheng.li@linux.intel.com, lethal@linux-sh.org,
        Andi Kleen <ak@linux.intel.com>, dave@linux.vnet.ibm.com,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [3/7, v9] NUMA Hotplug Emulator: Add node hotplug emulation
In-Reply-To: <20101222162723.72075372.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1012272241200.23315@chino.kir.corp.google.com>
References: <20101210073119.156388875@intel.com> <20101210073242.462037866@intel.com> <20101222162723.72075372.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Dec 2010, Andrew Morton wrote:

> > Index: linux-hpe4/mm/memory_hotplug.c
> > ===================================================================
> > --- linux-hpe4.orig/mm/memory_hotplug.c	2010-11-30 12:40:43.757622001 +0800
> > +++ linux-hpe4/mm/memory_hotplug.c	2010-11-30 14:02:33.877622002 +0800
> > @@ -924,3 +924,63 @@
> >  }
> >  #endif /* CONFIG_MEMORY_HOTREMOVE */
> >  EXPORT_SYMBOL_GPL(remove_memory);
> > +
> > +#ifdef CONFIG_DEBUG_FS
> > +#include <linux/debugfs.h>
> > +
> > +static struct dentry *memhp_debug_root;
> > +
> > +static ssize_t add_node_store(struct file *file, const char __user *buf,
> > +				size_t count, loff_t *ppos)
> > +{
> > +	nodemask_t mask;
> 
> NODEMASK_ALLOC()?
> 
> > +	u64 start, size;
> > +	char buffer[64];
> > +	char *p;
> > +	int nid;
> > +	int ret;
> > +
> > +	memset(buffer, 0, sizeof(buffer));
> > +	if (count > sizeof(buffer) - 1)
> > +		count = sizeof(buffer) - 1;
> 
> This will cause the write to return a smaller number than `count': a
> short write.  Some userspace code may then decide to write the
> remainder of the data (whcih is the correct way to use the write()
> syscall).
> 
> Could be a bit dangerous, and perhaps simply declaring an error if too
> much data was written would be a better approach.
> 
> > +	if (copy_from_user(buffer, buf, count))
> > +		return -EFAULT;
> > +
> > +	size = memparse(buffer, &p);
> > +	if (size < (PAGES_PER_SECTION << PAGE_SHIFT))
> 
> PAGES_PER_SECTION has type unsigned long, so the rhs of this comparison
> might overflow on 32-bit, should anyone ever try to use this code on
> 32-bit.
> 
> otoh the compiler might do it as 64-bit because the lhs is 64-bit.  Not
> sure.
> 
> > +		return -EINVAL;
> > +	if (*p != '@')
> > +		return -EINVAL;
> > +
> > +	start = simple_strtoull(p + 1, NULL, 0);
> 
> You disagreed with checkpatch?
> 
> > +	nodes_andnot(mask, node_possible_map, node_online_map);
> > +	nid = first_node(mask);
> > +	if (nid == MAX_NUMNODES)
> > +		return -ENOMEM;
> > +
> > +	ret = add_memory(nid, start, size);
> > +	return ret ? ret : count;
> > +}
> > +
> > +static const struct file_operations add_node_file_ops = {
> > +	.write		= add_node_store,
> > +	.llseek		= generic_file_llseek,
> > +};
> > +
> > +static int __init node_debug_init(void)
> > +{
> > +	if (!memhp_debug_root)
> > +		memhp_debug_root = debugfs_create_dir("mem_hotplug", NULL);
> > +	if (!memhp_debug_root)
> > +		return -ENOMEM;
> > +
> > +	if (!debugfs_create_file("add_node", S_IWUSR, memhp_debug_root,
> > +			NULL, &add_node_file_ops))
> > +		return -ENOMEM;
> > +
> > +	return 0;
> > +}
> > +
> > +module_init(node_debug_init);
> > +#endif /* CONFIG_DEBUG_FS */

Shaohui, I'll reply to this message with an updated version of this patch 
to address Andrew's comments.  You can merge it into your series or Andrew 
can take it seperately (although it doesn't do much good without "x86: add 
numa=possible command line option" unless you have hotpluggable SRAT 
entries and CONFIG_ACPI_NUMA).
