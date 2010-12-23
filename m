Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab0LWA2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 19:28:23 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54351 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751877Ab0LWA2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 19:28:22 -0500
Date: Wed, 22 Dec 2010 16:27:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: shaohui.zheng@intel.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        haicheng.li@linux.intel.com, lethal@linux-sh.org, ak@linux.intel.com,
        shaohui.zheng@linux.intel.com, rientjes@google.com,
        dave@linux.vnet.ibm.com, gregkh@suse.de,
        Haicheng Li <haicheng.li@intel.com>
Subject: Re: [7/7, v9] NUMA Hotplug Emulator: Implement per-node add_memory
 debugfs interface
Message-Id: <20101222162736.e51d2e18.akpm@linux-foundation.org>
In-Reply-To: <20101210073242.876873390@intel.com>
References: <20101210073119.156388875@intel.com>
	<20101210073242.876873390@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Dec 2010 15:31:26 +0800
shaohui.zheng@intel.com wrote:

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
>
> ...
>
> +#ifdef CONFIG_ARCH_MEMORY_PROBE
> +
> +static ssize_t add_memory_store(struct file *file, const char __user *buf,
> +				size_t count, loff_t *ppos)
> +{
> +	u64 phys_addr = 0;

Even more unneeded initalisation.

Please check the whole patchset for this.  It's bad because it can
sometimes generate more code and because it can sometimes hide bugs by
suppressing used-uninitialsied warnings.

> +	int nid = file->private_data - NULL;

Well that was sneaky.

It would be more conventional to just use the typecast:

	int nid = (long)file->private_data;


> +	int ret;
> +
> +	printk(KERN_INFO "Add a memory section to node: %d.\n", nid);
> +	phys_addr = simple_strtoull(buf, NULL, 0);

checkpatch

> +	ret = add_memory(nid, phys_addr, PAGES_PER_SECTION << PAGE_SHIFT);
> +	if (ret)
> +		count = ret;
> +
> +	return count;
> +}
> +
> +static int add_memory_open(struct inode *inode, struct file *file)
> +{
> +	file->private_data = inode->i_private;

Was this usage of i_private and private_data documented in comments
somewhere?

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
> +	if (!node_debug_root)
> +		return -ENOMEM;

hm, debugfs_create_dir() was poorly designed - it should return an
ERR_PTR() so callers don't need to assume ENOMEM, which may be incorrect.

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

"static int".

> +{
> +	return 0;
> +}
> +#endif /* CONFIG_ARCH_MEMORY_PROBE */
> +
>  static ssize_t add_node_store(struct file *file, const char __user *buf,
>  				size_t count, loff_t *ppos)
>  {
> @@ -963,6 +1038,8 @@
>  		return -ENOMEM;
>  
>  	ret = add_memory(nid, start, size);
> +
> +	debugfs_create_add_memory_entry(nid);
>  	return ret ? ret : count;
>  }
>  
>
> ...
>

