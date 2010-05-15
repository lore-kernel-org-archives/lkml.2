Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab0EONRF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 09:17:05 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59991 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab0EONRD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 09:17:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=P4EoWUR9VEfTrpTFdLqULrQWi9puLgqtYIrnU9F3dDeiHTDH3P9UZPb+0XYW3nv6aT
         AZPiMqr3r8lGF0MUFN0WncdDvC5WcLia5PVVmgMPr4cNrTK2hp20SFZsoBWLVcF1b9Aj
         gRrYtcChUUFJgQZtuPmDP5PoU4zqJbI59fJj4=
MIME-Version: 1.0
In-Reply-To: <20100513114544.GC2169@shaohui>
References: <20100513114544.GC2169@shaohui>
Date: Sat, 15 May 2010 18:47:00 +0530
Message-ID: <AANLkTikZiRw2w9hveCxA2XQp8SYs-4rYpH4BdZOns2CS@mail.gmail.com>
Subject: Re: [RFC,2/7] NUMA Hotplug emulator
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: akpm@linux-foundation.org, linux-mm@kvack.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, Lee Schermerhorn <lee.schermerhorn@hp.com>,
       linux-kernel@vger.kernel.org, ak@linux.intel.co, fengguang.wu@intel.com,
       haicheng.li@linux.intel.com, shaohui.zheng@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 13, 2010 at 5:15 PM, Shaohui Zheng <shaohui.zheng@intel.com> wrote:
> x86: infrastructure of NUMA hotplug emulation
>
> NUMA hotplug emulator introduces a new node state N_HIDDEN to
> identify the fake offlined node. It firstly hides RAM via E820
> table and then emulates fake offlined nodes with the hidden RAM.
>
> After system bootup, user is able to hotplug-add these offlined
> nodes, which is just similar to a real hardware hotplug behavior.
>
> Using boot option "numa=hide=N*size" to fake offlined nodes:
>        - N is the number of hidden nodes
>        - size is the memory size (in MB) per hidden node.
>
> OPEN: Kernel might use part of hidden memory region as RAM buffer,
>      now emulator directly hide 128M extra space to workaround
>      this issue.  Any better way to avoid this conflict?
>
> Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
> Signed-off-by: Shaohui Zheng <shaohui.zheng@intel.com>
> ---
> diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
> index 8948f47..3e0d94d 100644
> --- a/arch/x86/mm/numa_64.c
> +++ b/arch/x86/mm/numa_64.c
> @@ -307,6 +307,87 @@ void __init numa_init_array(void)
>        }
>  }
>
> +#ifdef CONFIG_NODE_HOTPLUG_EMU
> +static char *hp_cmdline __initdata;
> +static struct bootnode *hidden_nodes;
> +static u64 hp_start, hp_end;
> +static long hidden_num, hp_size;
> +
> +int hotadd_hidden_nodes(int nid)
> +{
> +       int ret;
> +
> +       if (!node_hidden(nid))
> +               return -EINVAL;
> +
> +       ret = add_memory(nid, hidden_nodes[nid].start,
> +                        hidden_nodes[nid].end - hidden_nodes[nid].start);
> +       if (!ret) {
> +               node_clear_hidden(nid);
> +               return 0;
> +       } else {
> +               return -EEXIST;
> +       }
> +}
> +
> +static void __init numa_hide_nodes(void)
> +{
> +       char *c;
> +       int ret;
> +
> +       c = strchr(hp_cmdline, '*');
> +       if (!c)
> +               return;
> +       else
> +               *c = '\0';
> +       ret = strict_strtol(hp_cmdline, 0, &hidden_num);
> +       if (ret == -EINVAL)
> +               return;
> +       ret = strict_strtol(c + 1, 0, &hp_size);
> +       if (ret == -EINVAL)
> +               return;
> +       hp_size <<= 20;
> +
> +       hp_start = e820_hide_mem(hidden_num * hp_size);
> +       if (hp_start <= 0) {
> +               printk(KERN_ERR "Hide too much memory, disable node hotplug emualtion.");
> +               hidden_num = 0;
> +               return;
> +       }
> +
> +       hp_end = hp_start + hidden_num * hp_size;
> +
> +       /* leave 128M space for possible RAM buffer usage later
> +        * any other better way to avoid this conflict?
> +        */
> +       e820_hide_mem(128*1024*1024);
> +}
> +
> +static void __init numa_hotplug_emulation(void)
> +{
> +       int i, num_nodes = 0;
> +
> +       for_each_online_node(i)
> +               if (i > num_nodes)
> +                       num_nodes = i;
> +
> +       i = num_nodes + hidden_num;
> +       if (!hidden_nodes) {
> +               hidden_nodes = alloc_bootmem(sizeof(struct bootnode) * i);
> +               memset(hidden_nodes, 0, sizeof(struct bootnode) * i);
> +       }
> +
> +       if (hidden_num)

if (hidden_num) is not required, as next line's for statement is also
doing the same thing.

Thanks,
--
Jaswinder Singh.

> +               for (i = 0; i < hidden_num; i++) {
> +                       int nid = num_nodes + i + 1;
> +                       node_set(nid, node_possible_map);
> +                       hidden_nodes[nid].start = hp_start + hp_size * i;
> +                       hidden_nodes[nid].end = hp_start + hp_size * (i+1);
> +                       node_set_hidden(nid);
> +               }
> +}
> +#endif /* CONFIG_NODE_HOTPLUG_EMU */
> +
>  #ifdef CONFIG_NUMA_EMU
>  /* Numa emulation */
>  static struct bootnode nodes[MAX_NUMNODES] __initdata;
> @@ -661,7 +742,7 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
>
>  #ifdef CONFIG_NUMA_EMU
>        if (cmdline && !numa_emulation(start_pfn, last_pfn, acpi, k8))
> -               return;
> +               goto done;
>        nodes_clear(node_possible_map);
>        nodes_clear(node_online_map);
>  #endif
> @@ -669,14 +750,14 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
>  #ifdef CONFIG_ACPI_NUMA
>        if (!numa_off && acpi && !acpi_scan_nodes(start_pfn << PAGE_SHIFT,
>                                                  last_pfn << PAGE_SHIFT))
> -               return;
> +               goto done;
>        nodes_clear(node_possible_map);
>        nodes_clear(node_online_map);
>  #endif
>
>  #ifdef CONFIG_K8_NUMA
>        if (!numa_off && k8 && !k8_scan_nodes())
> -               return;
> +               goto done;
>        nodes_clear(node_possible_map);
>        nodes_clear(node_online_map);
>  #endif
> @@ -696,6 +777,12 @@ void __init initmem_init(unsigned long start_pfn, unsigned long last_pfn,
>                numa_set_node(i, 0);
>        e820_register_active_regions(0, start_pfn, last_pfn);
>        setup_node_bootmem(0, start_pfn << PAGE_SHIFT, last_pfn << PAGE_SHIFT);
> +done:
> +#ifdef CONFIG_NODE_HOTPLUG_EMU
> +       if (hidden_num)
> +               numa_hotplug_emulation();
> +#endif
> +       return;
>  }
>
>  unsigned long __init numa_free_all_bootmem(void)
> @@ -723,6 +810,12 @@ static __init int numa_setup(char *opt)
>        if (!strncmp(opt, "fake=", 5))
>                cmdline = opt + 5;
>  #endif
> +#ifdef CONFIG_NODE_HOTPLUG_EMU
> +       if (!strncmp(opt, "hide=", 5)) {
> +               hp_cmdline = opt + 5;
> +               numa_hide_nodes();
> +       }
> +#endif
>  #ifdef CONFIG_ACPI_NUMA
>        if (!strncmp(opt, "noacpi", 6))
>                acpi_numa = -1;
> diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
> index dba35e4..ba0f82d 100644
> --- a/include/linux/nodemask.h
> +++ b/include/linux/nodemask.h
> @@ -371,6 +371,10 @@ static inline void __nodes_fold(nodemask_t *dstp, const nodemask_t *origp,
>  */
>  enum node_states {
>        N_POSSIBLE,             /* The node could become online at some point */
> +#ifdef CONFIG_NODE_HOTPLUG_EMU
> +       N_HIDDEN,               /* The node is hidden at booting time, could be
> +                                * onlined in run time */
> +#endif
>        N_ONLINE,               /* The node is online */
>        N_NORMAL_MEMORY,        /* The node has regular memory */
>  #ifdef CONFIG_HIGHMEM
> @@ -470,6 +474,13 @@ static inline int num_node_state(enum node_states state)
>  #define node_online(node)      node_state((node), N_ONLINE)
>  #define node_possible(node)    node_state((node), N_POSSIBLE)
>
> +#ifdef CONFIG_NODE_HOTPLUG_EMU
> +#define node_set_hidden(node)     node_set_state((node), N_HIDDEN)
> +#define node_clear_hidden(node)           node_clear_state((node), N_HIDDEN)
> +#define node_hidden(node)      node_state((node), N_HIDDEN)
> +extern int hotadd_hidden_nodes(int nid);
> +#endif
> +
>  #define for_each_node(node)       for_each_node_state(node, N_POSSIBLE)
>  #define for_each_online_node(node) for_each_node_state(node, N_ONLINE)
>
> --
> Thanks & Regards,
> Shaohui
>
>
