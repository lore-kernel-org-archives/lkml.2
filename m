Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab2ACUP2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 15:15:28 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:52689 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab2ACUPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 15:15:24 -0500
Message-ID: <4F0361D7.3000602@pandora.be>
Date: Tue, 03 Jan 2012 21:15:19 +0100
From: Bart De Schuymer <bdschuym@pandora.be>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Stephen Hemminger <shemminger@vyatta.com>, davem@davemloft.net,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: Fix br_nf_pre_routing() in conjunction with
 bridge-nf-call-ip(6)tables=0
References: <4F025A07.2000304@nod.at> <1325597164-13459-1-git-send-email-richard@nod.at> <1325597164-13459-2-git-send-email-richard@nod.at> <20120103081521.2fec3a29@nehalam.linuxnetplumber.net> <4F033E11.5060707@nod.at>
In-Reply-To: <4F033E11.5060707@nod.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 120103-0, 03/01/2012), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 3/01/2012 18:42, Richard Weinberger schreef:
> Am 03.01.2012 17:15, schrieb Stephen Hemminger:
>> On Tue,  3 Jan 2012 14:26:04 +0100
>> Richard Weinberger<richard@nod.at>  wrote:
>>
>>> If net.bridge.bridge-nf-call-iptables or net.bridge.bridge-nf-call-ip6tables
>>> are set to zero xt_physdev has no effect because skb->nf_bridge has not been set up.
>>>
>>> Signed-off-by: Richard Weinberger<richard@nod.at>
>> I am not sure if this is a valid configuration. The setting of sysctl is saying
>> "don't do iptables on bridge (since I won't be using it)" and then you are later
>> doing iptables and expecting the settings as if the iptables setup was being
>> done.
> I don't think so.
>
> Also rules like this one are broken:
> iptables -A INPUT -i bridge0 -m physdev --physdev-in eth0 -j ...
>
> No firewalling is done on the bridge, xt_physdev is only using some meta
> information.
>
> At least a big fat warning would be nice that xt_physdev does not work
> if bridge-nf-call-iptables=0.
> It took me some time to figure out why my firewall rule set gone nuts on
> RHEL6...

The documentation is probably not explicit enough, but I would keep the 
behavior as it is now. Setting bridge-nf-call-iptables to 0 makes 
iptables behave as if bridge-netfilter was not enabled at compilation.
Anyway, your patch is almost certainly flawed since the fact that 
skb->nf_bridge can be NULL is used as part of the logic in 
br_netfilter.c: it indicates that bridge-nf-call-iptables was 0 when the 
packet was first processed by bridge-netfilter and should therefore not 
be given to iptables in any other netfilter hook.

cheers,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be

