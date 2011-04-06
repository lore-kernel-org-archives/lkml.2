Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab1DFFaH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 01:30:07 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:47145 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab1DFFaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 01:30:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AMpKEIf7+jK60ctFZtXo9uhMBCV57wb1D03PNm2gIaxWbuo3c4jWYDt+7URHlXSgJe
         gmRl0ih3ZhxKLfaI1NoZy55oN0/CUfH5FeUmRGGJnUu6OJBJcAFKuQjjzJYipXm2LHQl
         QrFMXtZwwvHV0Gdpu081YZO9sUaV3roD8agEE=
Message-ID: <4D9BFABD.4070903@gmail.com>
Date: Wed, 06 Apr 2011 13:31:41 +0800
From: Weiping Pan <panweiping3@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jay Vosburgh <fubar@us.ibm.com>
CC: "Andy Gospodarek (supporter:BONDING DRIVER)" <andy@greyhouse.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bonding-tlb: better balance when choosing slaves
References: <1301753395-1205-1-git-send-email-panweiping3@gmail.com> <20427.1301768703@death> <4D9BD1A9.1040402@gmail.com> <3084.1302065172@death>
In-Reply-To: <3084.1302065172@death>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2011 12:46 PM, Jay Vosburgh wrote:
> Weiping Pan<panweiping3@gmail.com>  wrote:
>
>> On 04/03/2011 02:25 AM, Jay Vosburgh wrote:
>>>> tlb_get_least_loaded_slave() always chooses slave from
>>>> bonding->first_slave, that gives the beginnig slaves more chances to be used.
>>>>
>>>> Let tlb_get_least_loaded_slave() chooses slave from a random positon in the
>>>> slave list, make all slaves transmit packets more balanced.
>>> 	If outgoing traffic is not being starved (i.e., connections are
>>> being balanced such that they are stacking up on one slave but
>>> under-utilizing another), then I don't understand what benefit this has.
>>>
>>> 	There is already some degree of randomness, as peers will be
>>> assigned in the order that packets are transmitted to them after each
>>> rebalance.  The busiest peers will tend to be on the earlier slaves, and
>>> vice versa, but I'm not sure this is a bad thing.
>>>
>>> 	Does this have any real gain other than making the rx/tx
>>> statistics for the slaves more equal over time?
>>>
>>> 	I haven't measured it, but I would expect that for small numbers
>>> of peers, having them tend to stay on the same slaves over time is
>>> probably a good thing.
>> modprobe bonding mode=balance-tlb miimon=100
>> ifconfig bond0 192.168.1.2 netmask 255.255.255.0 up
>> ifenslave bond0 eth0
>> ifenslave bond0 eth1
>> ifenslave bond0 eth2
>> ping 192.168.1.100 -A -s 10240
>>
>> I find that bonding will always use eth0 and eth1, it never uses eth2,
>> because tlb_get_least_loaded_slave() always chooses slave from
>> bonding->first_slave, that gives the beginnig slaves more chances to be
>> used.
>>
>> Do you think this is a problem ?
> 	Not for this test case, no.
>
> 	On the other hand, if you run three pings concurrently to three
> different destinations and it still never uses eth2, then that might be
> something to look into.
>
>> Does it has conflicts with the meaning of balance and reblance?
> 	Not really; with only one active flow, there isn't really any
> advantage to moving it around.  The balance and rebalance activity
> becomes more interesting when the traffic volume and number of
> destinations is larger.
>
> 	-J
ok, i agree with you.
thanks
Weiping Pan
>>>> Signed-off-by: Weiping Pan(潘卫平)<panweiping3@gmail.com>
>>>> ---
>>>> drivers/net/bonding/bond_alb.c |   17 +++++++++++++++--
>>>> 1 files changed, 15 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
>>>> index 9bc5de3..9fa64b0 100644
>>>> --- a/drivers/net/bonding/bond_alb.c
>>>> +++ b/drivers/net/bonding/bond_alb.c
>>>> @@ -36,6 +36,7 @@
>>>> #include<linux/if_bonding.h>
>>>> #include<linux/if_vlan.h>
>>>> #include<linux/in.h>
>>>> +#include<linux/random.h>
>>>> #include<net/ipx.h>
>>>> #include<net/arp.h>
>>>> #include<net/ipv6.h>
>>>> @@ -206,15 +207,27 @@ static long long compute_gap(struct slave *slave)
>>>> /* Caller must hold bond lock for read */
>>>> static struct slave *tlb_get_least_loaded_slave(struct bonding *bond)
>>>> {
>>>> -	struct slave *slave, *least_loaded;
>>>> +	struct slave *slave, *least_loaded, *start_slave;
>>>> 	long long max_gap;
>>>> 	int i;
>>>> +	u8 n;
>>>>
>>>> 	least_loaded = NULL;
>>>> +	start_slave = bond->first_slave;
>>>> 	max_gap = LLONG_MIN;
>>>> +
>>>> +	get_random_bytes(&n, 1);
>>>> +
>>>> +	if (bond->slave_cnt == 0)
>>>> +		return NULL;
>>>> +	n = n % bond->slave_cnt;
>>>> +
>>>> +	for (i=0; i<n; ++i) {
>>>> +		start_slave = start_slave->next;
>>>> +	}
>>>>
>>>> 	/* Find the slave with the largest gap */
>>>> -	bond_for_each_slave(bond, slave, i) {
>>>> +	bond_for_each_slave_from(bond, slave, i, start_slave) {
>>>> 		if (SLAVE_IS_OK(slave)) {
>>>> 			long long gap = compute_gap(slave);
>>>>
>>>> -- 
>>>> 1.7.4
> ---
> 	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com

