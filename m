Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab0EGHTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 03:19:23 -0400
Received: from mga05.intel.com ([192.55.52.89]:8519 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753568Ab0EGHTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 03:19:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,347,1270450800"; 
   d="scan'208";a="565014382"
Message-ID: <4BE3BEE6.9080106@linux.intel.com>
Date: Fri, 07 May 2010 15:19:02 +0800
From: minskey guo <chaohong_guo@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: linux-mm@kvack.org, "Kleen, Andi" <andi.kleen@intel.com>,
       akpm@linux-foundation.org
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] permit to online CPUs before local memory comes online
References: <1272344264.28378.3.camel@minskey-desktop>
In-Reply-To: <1272344264.28378.3.camel@minskey-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you please help me review this patch and give me
some inputs ? such as,  is it  acceptable to do that,
I mean, online CPUs  of  a NUMA node without local
memory

The patch is against upstream vanilla kernel.

I mis-spelled the mail address of linux-mm when I sent
the email for the first time,  please forgive me
if you receive two copies.


thanks,
-minskey


On 04/27/2010 12:57 PM, minskey wrote:
>
>
> This patch enables users to online CPUs even if the CPUs belongs to
> a numa node which doesn't have onlined local memory.
>
> The zonlists(pg_data_t.node_zonelists[]) of a numa node are created
> either in system boot/init period, or at the time of local memory
> online.  For a numa node without onlined local memory, its zonelists
> are not initialized at present. As a result, any memory allocation
> operations executed by CPUs within this node will fail. In fact, an
> out-of-memory error is triggered when attempt to online CPUs before
> memory comes to online.
>
> This patch tries to create zonelists for such numa nodes, so that
> the memory allocation for this node can be fallback'ed to other
> nodes.
>
> Signed-off-by: minskey guo<chaohong.guo@intel.com>
> ---
>   include/linux/memory_hotplug.h |    1 +
>   kernel/cpu.c                   |   26 ++++++++++++++++++++++++++
>   mm/memory_hotplug.c            |   25 +++++++++++++++++++++++++
>   3 files changed, 52 insertions(+), 0 deletions(-)
>
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index 35b07b7..864035f 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -202,6 +202,7 @@ static inline int is_mem_section_removable(unsigned long pfn,
>   }
>   #endif /* CONFIG_MEMORY_HOTREMOVE */
>
> +extern int mem_online_node(int nid);
>   extern int add_memory(int nid, u64 start, u64 size);
>   extern int arch_add_memory(int nid, u64 start, u64 size);
>   extern int remove_memory(u64 start, u64 size);
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index f8cced2..c31b9cb 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -335,6 +335,12 @@ out_notify:
>   int __cpuinit cpu_up(unsigned int cpu)
>   {
>   	int err = 0;
> +
> +#ifdef	CONFIG_MEMORY_HOTPLUG
> +	int nid;
> +	pg_data_t	*pgdat;
> +#endif
> +
>   	if (!cpu_possible(cpu)) {
>   		printk(KERN_ERR "can't online cpu %d because it is not "
>   			"configured as may-hotadd at boot time\n", cpu);
> @@ -345,6 +351,26 @@ int __cpuinit cpu_up(unsigned int cpu)
>   		return -EINVAL;
>   	}
>
> +#ifdef	CONFIG_MEMORY_HOTPLUG
> +	nid = cpu_to_node(cpu);
> +	if (!node_online(nid)) {
> +		err = mem_online_node(nid);
> +		if (err)
> +			return err;
> +	}
> +
> +	pgdat = NODE_DATA(nid);
> +	if (!pgdat) {
> +		printk(KERN_ERR
> +			"Can't online cpu %d due to NULL pgdat\n", cpu);
> +		return -ENOMEM;
> +	}
> +
> +	if (pgdat->node_zonelists->_zonerefs->zone == NULL) {
> +		build_all_zonelists();
> +	}
> +#endif
> +
>   	cpu_maps_update_begin();
>
>   	if (cpu_hotplug_disabled) {
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index be211a5..2d24bef 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -482,6 +482,31 @@ static void rollback_node_hotadd(int nid, pg_data_t *pgdat)
>   }
>
>
> +/*
> + * called by cpu_up() to online a node without onlined memory.
> + */
> +int mem_online_node(int nid)
> +{
> +	pg_data_t	*pgdat;
> +	int	ret;
> +
> +	lock_system_sleep();
> +	pgdat = hotadd_new_pgdat(nid, 0);
> +	if (pgdat) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +	node_set_online(nid);
> +	ret = register_one_node(nid);
> +	BUG_ON(ret);
> +
> +out:
> +	unlock_system_sleep();
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(mem_online_node);
> +
> +
>   /* we are OK calling __meminit stuff here - we have CONFIG_MEMORY_HOTPLUG */
>   int __ref add_memory(int nid, u64 start, u64 size)
>   {

