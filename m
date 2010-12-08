Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab0LHVbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 16:31:13 -0500
Received: from smtp-out.google.com ([216.239.44.51]:22063 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab0LHVbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 16:31:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=qrZlfb8Jzth1AFdEePJWhG9QF+tSzkJWlvFhSAXH82ai0oMZfj6C/pz4ApR8NuIKPI
         sqW8bU/NCSNBwvDtmDJg==
Date: Wed, 8 Dec 2010 13:31:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Shaohui Zheng <shaohui.zheng@intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, haicheng.li@linux.intel.com,
        lethal@linux-sh.org, Andi Kleen <ak@linux.intel.com>,
        dave@linux.vnet.ibm.com, Greg Kroah-Hartman <gregkh@suse.de>,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [7/7,v8] NUMA Hotplug Emulator: Implement per-node add_memory
 debugfs interface
In-Reply-To: <20101207010140.298657680@intel.com>
Message-ID: <alpine.DEB.2.00.1012081325280.15658@chino.kir.corp.google.com>
References: <20101207010033.280301752@intel.com> <20101207010140.298657680@intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Dec 2010, shaohui.zheng@intel.com wrote:

> From:  Shaohui Zheng <shaohui.zheng@intel.com>
> 
> Add add_memory interface to support to memory hotplug emulation for each online
> node under debugfs. The reserved memory can be added into desired node with
> this interface.
> 
> The layout on debugfs:
> 	mem_hotplug/node0/add_memory
> 	mem_hotplug/node1/add_memory
> 	mem_hotplug/node2/add_memory
> 	...
> 
> Add a memory section(128M) to node 3(boots with mem=1024m)
> 
> 	echo 0x40000000 > mem_hotplug/node3/add_memory
> 
> And more we make it friendly, it is possible to add memory to do
> 
> 	echo 1024m > mem_hotplug/node3/add_memory
> 

I don't think you should be using memparse() to support this type of 
interface, the standard way of writing memory locations is by writing 
address in hex as the first example does.  The idea is to not try to make 
things simpler by introducing multiple ways of doing the same thing but 
rather to standardize on a single interface.

> CC: David Rientjes <rientjes@google.com>
> CC: Dave Hansen <dave@linux.vnet.ibm.com>
> Signed-off-by: Haicheng Li <haicheng.li@intel.com>
> Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
> ---
> Index: linux-hpe4/mm/memory_hotplug.c
> ===================================================================
> --- linux-hpe4.orig/mm/memory_hotplug.c	2010-12-02 12:35:31.557622002 +0800
> +++ linux-hpe4/mm/memory_hotplug.c	2010-12-06 07:30:36.067622001 +0800
> @@ -930,6 +930,80 @@
>  
>  static struct dentry *memhp_debug_root;
>  
> +#ifdef CONFIG_ARCH_MEMORY_PROBE
> +
> +static ssize_t add_memory_store(struct file *file, const char __user *buf,
> +				size_t count, loff_t *ppos)
> +{
> +	u64 phys_addr = 0;
> +	int nid = file->private_data - NULL;
> +	int ret;
> +
> +	phys_addr = simple_strtoull(buf, NULL, 0);

This isn't doing anything.

> +	printk(KERN_INFO "Add a memory section to node: %d.\n", nid);
> +	phys_addr = memparse(buf, NULL);
> +	ret = add_memory(nid, phys_addr, PAGES_PER_SECTION << PAGE_SHIFT);

Does the add_memory() call handle memoryless nodes such that they 
appropriately transition to N_HIGH_MEMORY when memory is added?

> +
> +	if (ret)
> +		count = ret;
> +
> +	return count;
> +}
> +
> +static int add_memory_open(struct inode *inode, struct file *file)
> +{
> +	file->private_data = inode->i_private;
> +	return 0;
> +}
> +
> +static const struct file_operations add_memory_file_ops = {
> +	.open		= add_memory_open,
> +	.write		= add_memory_store,
> +	.llseek		= generic_file_llseek,
> +};
> +
> +/*
> + * Create add_memory debugfs entry under specified node
> + */
> +static int debugfs_create_add_memory_entry(int nid)
> +{
> +	char buf[32];
> +	static struct dentry *node_debug_root;
> +
> +	snprintf(buf, sizeof(buf), "node%d", nid);
> +	node_debug_root = debugfs_create_dir(buf, memhp_debug_root);

This can fail, and if it does then the subsequent debugfs_create_file() 
will be added to root while we don't want, so this needs error handling.

> +
> +	/* the nid information was represented by the offset of pointer(NULL+nid) */
> +	if (!debugfs_create_file("add_memory", S_IWUSR, node_debug_root,
> +			NULL + nid, &add_memory_file_ops))
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +static int __init memory_debug_init(void)
> +{
> +	int nid;
> +
> +	if (!memhp_debug_root)
> +		memhp_debug_root = debugfs_create_dir("mem_hotplug", NULL);
> +	if (!memhp_debug_root)
> +		return -ENOMEM;
> +
> +	for_each_online_node(nid)
> +		 debugfs_create_add_memory_entry(nid);
> +
> +	return 0;
> +}
> +
> +module_init(memory_debug_init);
> +#else
> +static debugfs_create_add_memory_entry(int nid)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_ARCH_MEMORY_PROBE */
> +
>  static ssize_t add_node_store(struct file *file, const char __user *buf,
>  				size_t count, loff_t *ppos)
>  {
> @@ -960,6 +1034,8 @@
>  		return -ENOMEM;
>  
>  	ret = add_memory(nid, start, size);
> +
> +	debugfs_create_add_memory_entry(nid);
>  	return ret ? ret : count;
>  }
>  
> Index: linux-hpe4/Documentation/memory-hotplug.txt
> ===================================================================
> --- linux-hpe4.orig/Documentation/memory-hotplug.txt	2010-12-02 12:35:31.557622002 +0800
> +++ linux-hpe4/Documentation/memory-hotplug.txt	2010-12-06 07:39:36.007622000 +0800
> @@ -19,6 +19,7 @@
>    4.1 Hardware(Firmware) Support
>    4.2 Notify memory hot-add event by hand
>    4.3 Node hotplug emulation
> +  4.4 Memory hotplug emulation
>  5. Logical Memory hot-add phase
>    5.1. State of memory
>    5.2. How to online memory
> @@ -239,6 +240,29 @@
>  Once the new node has been added, it is possible to online the memory by
>  toggling the "state" of its memory section(s) as described in section 5.1.
>  
> +4.4 Memory hotplug emulation
> +------------
> +With debugfs, it is possible to test memory hotplug with software method, we
> +can add memory section to desired node with add_memory interface. It is a much
> +more powerful interface than "probe" described in section 4.2.
> +
> +There is an add_memory interface for each online node at the debugfs mount
> +point.
> +	mem_hotplug/node0/add_memory
> +	mem_hotplug/node1/add_memory
> +	mem_hotplug/node2/add_memory
> +	...
> +
> +Add a memory section(128M) to node 3(boots with mem=1024m)
> +
> +	echo 0x40000000 > mem_hotplug/node3/add_memory
> +
> +And more we make it friendly, it is possible to add memory to do
> +
> +	echo 1024m > mem_hotplug/node3/add_memory
> +
> +Once the new memory section has been added, it is possible to online the memory
> +by toggling the "state" described in section 5.1.
>  
>  ------------------------------
>  5. Logical Memory hot-add phase
> 
> -- 
> Thanks & Regards,
> Shaohui
> 
> 
> 
