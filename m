Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab1BWSkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 13:40:35 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:8981 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab1BWSkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 13:40:33 -0500
Message-ID: <4D6554A0.5010407@caviumnetworks.com>
Date: Wed, 23 Feb 2011 10:40:32 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 06/10] MIPS: Octeon: Initialize and fixup device tree.
References: <1298408274-20856-1-git-send-email-ddaney@caviumnetworks.com> <1298408274-20856-7-git-send-email-ddaney@caviumnetworks.com> <20110223174120.GG14597@angua.secretlab.ca>
In-Reply-To: <20110223174120.GG14597@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Feb 2011 18:40:32.0957 (UTC) FILETIME=[271096D0:01CBD389]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2011 09:41 AM, Grant Likely wrote:
> On Tue, Feb 22, 2011 at 12:57:50PM -0800, David Daney wrote:
>> Signed-off-by: David Daney<ddaney@caviumnetworks.com>
>> ---
>>   arch/mips/Kconfig                         |    2 +
>>   arch/mips/cavium-octeon/octeon-platform.c |  280 +++++++++++++++++++++++++++++
>>   arch/mips/cavium-octeon/setup.c           |   17 ++
>>   3 files changed, 299 insertions(+), 0 deletions(-)
>
> I've got an odd feeling of foreboding about this patch.  It makes me
> nervous, but I can't articulate why yet.  Gut-wise I'd rather see the
> device tree pruned/fixed up before it gets unflattened,

I chose to work on the unflattened form because there were already 
functions to do it.  I didn't see anything that would make manipulating 
the flattened form easy.

I agree that working on the unflattened form would be best.  At a minium 
the /proc/device-tree structure would better reflect reality.

What do you think about adding some helper functions to drivers/of/fdt.c 
for the manipulation of the flattened form?

> or for the
> kernel to have a separate .dtb linked in for each legacy platform.

I think there are too many variants to make this viable.

>  I
> need to think about this some more....
>
> I've made some comments below anyway.

And I will respond.  Although if I end up modifying the flattened form, 
it will all change.

>
[...]
>> +
>> +static int __init set_phy_addr_prop(struct device_node *n, int phy)
>> +{
>> +	u32 *vp;
>> +	struct property *old_p;
>> +	struct property *p = kzalloc(sizeof(struct device_node) + sizeof(u32), GFP_KERNEL);
>> +	if (!p)
>> +		return -ENOMEM;
>> +	/* The value will immediatly follow the node in memory. */
>> +	vp = (u32 *)(&p[1]);
>
> This is unsafe (I was on the losing end of an argument when I tried to
> do exactly the same thing).  If you want to allocate 2 things with one
> appended to the other, then you need to define a structure
> with the two element in it and allocate the size of that structure.

Weird.  alloc_netdev() does this, so it is not unheard of.

>
>> +	p->name = "reg";
>> +	p->length = sizeof(u32);
>> +	p->value = vp;
>> +
>> +	*vp = cpu_to_be32((u32)phy);
>
> phy is already an integer.  Why the cast?
>

An oversight.

>> +
>> +	old_p = of_find_property(n, "reg", NULL);
>> +	if (old_p)
>> +		prom_remove_property(n, old_p);
>> +	return prom_add_property(n, p);
>
> Would it not be more efficient to change the value in the existing reg
> property instead of doing this allocation song-and-dance?
>

I think I did it this way to try to get /proc/device-tree to reflect the 
new value.

>> +}
>> +
>> +static int __init set_mac_addr_prop(struct device_node *n, u64 mac)
>> +{
>> +	u8 *vp;
>> +	struct property *old_p;
>> +	struct property *p = kzalloc(sizeof(struct device_node) + 6, GFP_KERNEL);
>> +	if (!p)
>> +		return -ENOMEM;
>> +	/* The value will immediatly follow the node in memory. */
>> +	vp = (u8 *)(&p[1]);
>> +	p->name = "local-mac-address";
>> +	p->length = 6;
>> +	p->value = vp;
>> +
>> +	vp[0] = (mac>>  40)&  0xff;
>> +	vp[1] = (mac>>  32)&  0xff;
>> +	vp[2] = (mac>>  24)&  0xff;
>> +	vp[3] = (mac>>  16)&  0xff;
>> +	vp[4] = (mac>>  8)&  0xff;
>> +	vp[5] = mac&  0xff;
>> +
>> +	old_p = of_find_property(n, "local-mac-address", NULL);
>> +	if (old_p)
>> +		prom_remove_property(n, old_p);
>> +	return prom_add_property(n, p);
>
> Same comments apply to this function.
>
>> +}
>> +
>> +static struct device_node * __init octeon_of_get_child(const struct device_node *parent,
>> +						       int reg_val)
>> +{
>> +	struct device_node *node = NULL;
>> +	int size;
>> +	const __be32 *addr;
>> +
>> +	for (;;) {
>> +		node = of_get_next_child(parent, node);
>
> Use for_each_child_of_node() here.

OK.

>
>> +		if (!node)
>> +			break;
>> +		addr = of_get_property(node, "reg",&size);
>> +		if (addr&&  (be32_to_cpu(*addr) == reg_val))
>
> be32_to_cpup(addr)
>

Right.

>> +			break;
>> +	}
>> +	return node;
>> +}
>> +
>> +int __init octeon_prune_device_tree(void)
>> +{
>> +	int i, p, max_port;
>> +	const char *node_path;
>> +	char name_buffer[20];
>> +	struct device_node *aliases;
>> +	struct device_node *pip;
>> +	struct device_node *iface;
>> +	struct device_node *eth;
>> +	struct device_node *node;
>> +
>> +	aliases = of_find_node_by_path("/aliases");
>> +	if (!aliases) {
>> +		pr_err("Error: No /aliases node in device tree.");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (OCTEON_IS_MODEL(OCTEON_CN52XX) || OCTEON_IS_MODEL(OCTEON_CN63XX))
>> +		max_port = 2;
>> +	else if (OCTEON_IS_MODEL(OCTEON_CN56XX))
>> +		max_port = 1;
>> +	else
>> +		max_port = 0;
>> +
>> +	for (i = 0; i<  2; i++) {
>> +		struct device_node *mgmt;
>> +		snprintf(name_buffer, sizeof(name_buffer),
>> +			 "ethernet-mgmt%d", i);
>> +		node_path = of_get_property(aliases, name_buffer, NULL);
>> +		if (node_path) {
>> +			mgmt = of_find_node_by_path(node_path);
>
> of_find_node_by_path() needs to be fixed to also accept alias values
> so that a string that starts with a '/' is a full path, but no leading
> '/' means start with an alias.  This code will lose a level of
> indentation if you can make that change to the common code.
>

I will consider making that change.

>> +			if (!mgmt)
>> +				continue;
>> +			if (i>= max_port) {
>> +				pr_notice("Deleting mgmt%d\n", i);
>> +				node = of_parse_phandle(mgmt, "phy-handle", 0);
>> +				if (node) {
>> +					of_detach_node(node);
>> +					of_node_put(node);
>> +				}
>> +				of_node_put(node);
>> +
>> +				of_detach_node(mgmt);
>> +				of_node_put(mgmt);
>> +			}
>> +			of_node_put(mgmt);
>> +		}
>> +	}
>> +
>> +	node_path = of_get_property(aliases, "pip", NULL);
>> +	if (node_path&&  (pip = of_find_node_by_path(node_path))) {
>> +		for (i = 0; i<  4; i++) {
>> +			cvmx_helper_interface_enumerate(i);
>> +			iface = octeon_of_get_child(pip, i);
>> +			if (!iface)
>> +				continue;
>> +			for (p = 0; p<  4; p++) {
>> +				eth = octeon_of_get_child(iface, p);
>> +				if (!eth)
>> +					continue;
>> +				node = of_parse_phandle(eth, "phy-handle", 0);
>> +				if (p<  cvmx_helper_ports_on_interface(i)) {
>> +					int phy = cvmx_helper_board_get_mii_address(16 * i + p);
>> +					if (node&&  phy<  0) {
>> +						struct property *p = of_find_property(eth, "phy-handle", NULL);
>> +						of_detach_node(node);
>> +						of_node_put(node);
>> +						prom_remove_property(eth, p);
>> +					}
>
> There is a lot of nesting here; could this be refactored?

Perhaps.  It really is a three deep nesting though.


>
>> +				} else {
[...]

>> +}
>> +arch_initcall(octeon_fix_device_tree);
>
> Calling this from an initcall really makes me nervous.  I'm worried
> about ordering issues.  Why can this code not be part of the prune
> routine above?
>

Again, done to try to make /proc/device-tree reflect reality.

Thanks for looking at it.  I will generate another version of the patches.

David Daney
