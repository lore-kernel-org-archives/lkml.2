Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab0L1Ufz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 15:35:55 -0500
Received: from smtp-out.google.com ([74.125.121.67]:12605 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618Ab0L1Ufy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 15:35:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=k+htoeyghMlHWpifOL3eM93xehxJ7vor2WR3L3ttxuhzwqY0/LElcMHZysuuyMNeM8
         oSNdw3B9Oz3RP6Mw85kg==
Date: Tue, 28 Dec 2010 12:35:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        eric.dumazet@gmail.com, yinghai@kernel.org, brgerst@gmail.com,
        gorcunov@gmail.com, Pekka Enberg <penberg@kernel.org>,
        shaohui.zheng@intel.com
Subject: Re: [PATCH 13/16] x86: Unify cpu/apicid <-> NUMA node mapping between
 32 and 64bit
In-Reply-To: <1293536929-31683-14-git-send-email-tj@kernel.org>
Message-ID: <alpine.DEB.2.00.1012281231070.8883@chino.kir.corp.google.com>
References: <1293536929-31683-1-git-send-email-tj@kernel.org> <1293536929-31683-14-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Dec 2010, Tejun Heo wrote:

> diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
> index a35cb9d..1af9c6e 100644
> --- a/arch/x86/mm/srat_64.c
> +++ b/arch/x86/mm/srat_64.c
> @@ -79,7 +79,7 @@ static __init void bad_srat(void)
>  	printk(KERN_ERR "SRAT: SRAT not used.\n");
>  	acpi_numa = -1;
>  	for (i = 0; i < MAX_LOCAL_APIC; i++)
> -		apicid_to_node[i] = NUMA_NO_NODE;
> +		set_apicid_to_node(i, NUMA_NO_NODE);
>  	for (i = 0; i < MAX_NUMNODES; i++) {
>  		nodes[i].start = nodes[i].end = 0;
>  		nodes_add[i].start = nodes_add[i].end = 0;
> @@ -134,7 +134,7 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
>  	}
>  
>  	apic_id = pa->apic_id;
> -	apicid_to_node[apic_id] = node;
> +	set_apicid_to_node(apic_id, node);
>  	node_set(node, cpu_nodes_parsed);
>  	acpi_numa = 1;
>  	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u\n",
> @@ -168,7 +168,7 @@ acpi_numa_processor_affinity_init(struct acpi_srat_cpu_affinity *pa)
>  		apic_id = (pa->apic_id << 8) | pa->local_sapic_eid;
>  	else
>  		apic_id = pa->apic_id;
> -	apicid_to_node[apic_id] = node;
> +	set_apicid_to_node(apic_id, node);
>  	node_set(node, cpu_nodes_parsed);
>  	acpi_numa = 1;
>  	printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u\n",
> @@ -512,13 +512,13 @@ void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes)
>  		 * node, it must now point to the fake node ID.
>  		 */
>  		for (j = 0; j < MAX_LOCAL_APIC; j++)
> -			if (apicid_to_node[j] == nid &&
> +			if (__apicid_to_node[j] == nid &&
>  			    fake_apicid_to_node[j] == NUMA_NO_NODE)
>  				fake_apicid_to_node[j] = i;
>  	}
>  	for (i = 0; i < num_nodes; i++)
>  		__acpi_map_pxm_to_node(fake_node_to_pxm_map[i], i);
> -	memcpy(apicid_to_node, fake_apicid_to_node, sizeof(apicid_to_node));
> +	memcpy(__apicid_to_node, fake_apicid_to_node, sizeof(__apicid_to_node));
>  
>  	nodes_clear(nodes_parsed);
>  	for (i = 0; i < num_nodes; i++)

This is going to conflict with a387e95a ("") in x86/numa, so you'll need 
the following hunk for acpi_fake_nodes().  I'm not sure why this patchset 
is being based on x86/apic-cleanup rather than x86/numa?

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -511,7 +511,7 @@ void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nodes
                 * node, it must now point to the fake node ID.
                 */
                for (j = 0; j < MAX_LOCAL_APIC; j++)
-                       if (apicid_to_node[j] == nid &&
+                       if (__apicid_to_node[j] == nid &&
                            fake_apicid_to_node[j] == NUMA_NO_NODE)
                                fake_apicid_to_node[j] = i;
        }
@@ -522,13 +522,13 @@ void __init acpi_fake_nodes(const struct bootnode *fake_nodes, int num_nod
         * value.
         */
        for (i = 0; i < MAX_LOCAL_APIC; i++)
-               if (apicid_to_node[i] != NUMA_NO_NODE &&
+               if (__apicid_to_node[i] != NUMA_NO_NODE &&
                    fake_apicid_to_node[i] == NUMA_NO_NODE)
                        fake_apicid_to_node[i] = 0;
 
        for (i = 0; i < num_nodes; i++)
                __acpi_map_pxm_to_node(fake_node_to_pxm_map[i], i);
-       memcpy(apicid_to_node, fake_apicid_to_node, sizeof(apicid_to_node));
+       memcpy(__apicid_to_node, fake_apicid_to_node, sizeof(__apicid_to_node));
 
        nodes_clear(nodes_parsed);
        for (i = 0; i < num_nodes; i++)
