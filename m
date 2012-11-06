Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab2KFN4S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 08:56:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47718 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab2KFN4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 08:56:13 -0500
Message-ID: <5099170B.3020406@canonical.com>
Date: Tue, 06 Nov 2012 07:56:27 -0600
From: Chris J Arges <chris.j.arges@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jay Vosburgh <fubar@us.ibm.com>
CC: Andy Gospodarek <andy@greyhouse.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next] bonding: extend bond_arp_send_all to bridge
 devices
References: <1352154649-21089-1-git-send-email-chris.j.arges@canonical.com> <26061.1352155545@death.nxdomain>
In-Reply-To: <26061.1352155545@death.nxdomain>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2012 04:45 PM, Jay Vosburgh wrote:
> Chris J Arges <chris.j.arges@canonical.com> wrote:
> 
>> ARP monitoring does not work when we have a network in the
>> following configuration:
>>
>> eth0----+ +----bond0.100----br0-100---{+virtual machines
>>          | |
>>          +----bond0----+----br0---(fixed IP)->--{LAN arp_ip_target}
>>          | |
>> eth1----+ +----bond0.200----br0-200---{+virtual machines
>>
>> This patch extends bond_arp_send_all to check if a device
>> is also in a bridge.
>>
>> This is related to the following issues:
>> http://launchpad.net/bugs/736226
>> http://bugzilla.kernel.org/show_bug.cgi?id=31822
>>
>> Thanks to help from Andy Gospodarek <andy@greyhouse.net>.
>>
>> Signed-off-by: Chris J Arges <chris.j.arges@canonical.com>
> 
> 	What has changed that you're up to version 3 now?

Had (user) issues with git send-email, and wanted to send a clean patch.
Sorry about that.
> 
>> drivers/net/bonding/bond_main.c |   12 ++++++++++++
>> 1 file changed, 12 insertions(+)
>>
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>> index b2530b0..cb791f6 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -2708,6 +2708,18 @@ static void bond_arp_send_all(struct bonding *bond, struct slave *slave)
>> 			continue;
>> 		}
>>
>> +		/*
>> +		 * Check if the target is part of a bridge.
>> +		 */
> 
> 		/* Comment should be formatted like this.
> 		 */
> 
>> +		if (rt->dst.dev->priv_flags & IFF_EBRIDGE) {
>> +			/* Confirm addr is part of the bridge */
>> +			addr = bond_confirm_addr(rt->dst.dev, targets[i], 0);
>> +
>> +			/* Send ARP request */
> 
> 	I think this comment is unnecessary.
> 
> 	-J
> 
>> +			bond_arp_send(slave->dev, ARPOP_REQUEST, targets[i], addr, 0);
>> +			continue;
>> +		}
>> +

Great, sending v4 soon with these changes.
--chris j arges

>> 		if (net_ratelimit()) {
>> 			pr_warning("%s: no path to arp_ip_target %pI4 via rt.dev %s\n",
>> 				   bond->dev->name, &targets[i],
>> -- 
>> 1.7.9.5
>>
> 
> ---
> 	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com
> 

