Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab1IMXXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 19:23:45 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:19370 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab1IMXXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 19:23:44 -0400
Message-ID: <4E6FE5F9.2060604@cavium.com>
Date: Tue, 13 Sep 2011 16:23:37 -0700
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>, grant.likely@secretlab.ca
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 2/3] netdev/of/phy: Add MDIO bus multiplexer support.
References: <1314820906-14004-1-git-send-email-david.daney@cavium.com> <1314820906-14004-3-git-send-email-david.daney@cavium.com> <129FAAB3-C9AD-43F6-A8CB-96548A47C4DC@kernel.crashing.org>
In-Reply-To: <129FAAB3-C9AD-43F6-A8CB-96548A47C4DC@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Sep 2011 23:23:42.0937 (UTC) FILETIME=[2D534C90:01CC726C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2011 04:07 PM, Kumar Gala wrote:
>
>> diff --git a/Documentation/devicetree/bindings/net/mdio-mux.txt b/Documentation/devicetree/bindings/net/mdio-mux.txt
>> new file mode 100644
>> index 0000000..a908312
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/mdio-mux.txt
>> @@ -0,0 +1,132 @@
>> +Common MDIO bus multiplexer/switch properties.
>> +
>> +An MDIO bus multiplexer/switch will have several child busses that are
>> +numbered uniquely in a device dependent manner.  The nodes for an MDIO
>> +bus multiplexer/switch will have one child node for each child bus.
>> +
>> +Required properties:
>> +- parent-bus : phandle to the parent MDIO bus.
>
> Should probably be mdio-parent-bus

Why?  We know it is MDIO.

Serial bus multiplexing is not a concept limited to MDIO.  We would want 
to use "parent-bus" for some I2C multiplexers as well.

>
>> +
>> +Optional properties:
>> +- Other properties specific to the multiplexer/switch hardware.
>> +
>> +Required properties for child nodes:
>> +- #address-cells =<1>;
>> +- #size-cells =<0>;
>> +- cell-index : The sub-bus number.
>
> What does sub-bus number mean?

There are N child buses (or sub-buses) coming out of the multiplexer. 
The cell-index is used as a handle or identifier for each of these.

The concrete example in Patch 3/3 is a multiplexer with four child 
buses.  The happen to have cell-indexes of 0, 1, 2 and 3.

In the GPIO case of patch 3/3, these directly correspond the the state 
of the two GPIO pins controlling the multiplexer.  The driver then uses 
the cell-index property to determine the state of the GPIO to connect 
any given child.

It is possible that the documentation part of the patch could be made 
more clear about this.

>
>> +
>> +
>> +Example :
>
[...]
>> +
>> +int mdio_mux_probe(struct platform_device *pdev,
>> +		   int (*switch_fn)(int cur, int desired, void *data),
>> +		   void *data)
>> +{
>> +	struct device_node *parent_bus_node;
>> +	struct device_node *child_bus_node;
>> +	int r, n, ret_val;
>> +	struct mii_bus *parent_bus;
>> +	struct mdio_mux_parent_bus *pb;
>> +	struct mdio_mux_child_bus *cb;
>> +
>> +	if (!pdev->dev.of_node)
>> +		return -ENODEV;
>> +
>> +	parent_bus_node = of_parse_phandle(pdev->dev.of_node, "parent-bus", 0);
>> +
>> +	if (!parent_bus_node)
>> +		return -ENODEV;
>> +
>> +	parent_bus = of_mdio_find_bus(parent_bus_node);
>
>
> So what happens if the parent bus probe happens after the mux probe?
>

The whole house of cards collapses.

Grant Likely has a patch to deal with this by retrying the probing,  but 
as far as I know, it has not been merged yet.

