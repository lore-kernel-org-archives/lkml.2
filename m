Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814Ab1HJL7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 07:59:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118Ab1HJL7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 07:59:53 -0400
Date: Wed, 10 Aug 2011 13:59:50 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: Michael Guntsche <mguntsche@gmail.com>
Cc: shemminger@vyatta.com, sebastian.belden@googlemail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net
Subject: Re: BUG: Bisected Gianfar in bridge not forwarding packets (was:
 3.0-rc1 Bridge not forwarding unicast packages)
Message-ID: <20110810115949.GD1909@minipsycho.brq.redhat.com>
References: <CAMvAeqOA0=FnjB2oPPCEYpkXdKrmqOs+MwAqszV5sTGys_a3mQ@mail.gmail.com>
 <20110810090014.GB1909@minipsycho.brq.redhat.com>
 <CAMvAeqO2bLaPwmdW+c+7hz-ec=-tF6Z0EFBv=FA7+rU_QZ_wDA@mail.gmail.com>
 <CAMvAeqM-oH1UzxEp9PgO6ZP-AKtqosuMg5za25_X8DpPJMDX2w@mail.gmail.com>
 <20110810111947.GC1909@minipsycho.brq.redhat.com>
 <CAMvAeqOZ9OoV5KxTbn0+sPxJ=AkSrb__31GShVshDkX6NUXgNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMvAeqOZ9OoV5KxTbn0+sPxJ=AkSrb__31GShVshDkX6NUXgNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wed, Aug 10, 2011 at 01:51:54PM CEST, mguntsche@gmail.com wrote:
>On Wed, Aug 10, 2011 at 1:19 PM, Jiri Pirko <jpirko@redhat.com> wrote:
>> Wed, Aug 10, 2011 at 12:30:16PM CEST, mguntsche@gmail.com wrote:
>>>On Wed, Aug 10, 2011 at 11:59 AM, Michael Guntsche <mguntsche@gmail.com> wrote:
>>><snip>
>>>>>>Offload parameters for lan_wire:
>>>>>>rx-checksumming: off
>>>>>>tx-checksumming: off
>>>>>>scatter-gather: off
>>>>>>tcp-segmentation-offload: off
>>>>>>udp-fragmentation-offload: off
>>>>>>generic-segmentation-offload: off
>>>>>>generic-receive-offload: on
>>>>>>large-receive-offload: off
>>>>>>rx-vlan-offload: off
>>>>>>tx-vlan-offload: off
>>>>>>ntuple-filters: off
>>>>>>receive-hashing: off
>>>>>>
>>>>>>The Bridge device on the other hand....
>>>>>>
>>>>>>Offload parameters for lan:
>>>>>>rx-checksumming: on
>>>>>>tx-checksumming: on
>>>>>>scatter-gather: off
>>>>>>tcp-segmentation-offload: off
>>>>>>udp-fragmentation-offload: off
>>>>>>generic-segmentation-offload: off
>>>>>>generic-receive-offload: on
>>>>>>large-receive-offload: off
>>>>>>rx-vlan-offload: off
>>>>>>tx-vlan-offload: on
>>>>>  ^^^^^^^^^^^^^^^^^^^ is this gfar?
>>>> No the "Lan" nic is the bridge itself. The gfar in question is lan_wire.
>>>>
>>>> /Michael
>>>>
>>>
>>>Ok I would have saved hours of bisecting if I had just used the -e
>>>switch with tcpdump from the beginning.
>>>Jiri first of all the patch makes the connection work again. I can
>>>ping the client on the wlan from the server and vice-versa. Taking a
>>>look at the tcpdump (WITH -e) makes it obvious why it fails with the
>>>non patched version...
>>>
>>>This is a capture from the gfar lan port on the bridge with no patch applied
>>>12:13:24.011492 00:13:d4:4f:a2:dc (oui Unknown) > b4:07:f9:70:b7:c1
>>>(oui Unknown), ethertype 802.1Q (0x8100), length 102: vlan 19, p 0,
>>>ethertype IPv4, gibson.comsick.at > 192.168.42.55: ICMP echo request,
>>>id 23567, seq 74, length 64
>>>
>>>As you can see we get a VLAN package????
>>
>> Ugh, this is what I expected. Patch to fix:
>>
>> Subject: [patch net-2.6] gianfar: prevent buggy hw rx vlan tagging
>>
>> On some buggy chips, "vlan tag present" flag is set which causes packet
>> loss. Fix this by checking if rx vlan accel is enabled in features.
>>
>> Reported-by: Michael Guntsche <mguntsche@gmail.com>
>> Signed-off-by: Jiri Pirko <jpirko@redhat.com>
>> ---
>>  drivers/net/gianfar.c |    9 +++++++--
>>  1 files changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
>> index 2659daa..31d5c57 100644
>> --- a/drivers/net/gianfar.c
>> +++ b/drivers/net/gianfar.c
>> @@ -2710,8 +2710,13 @@ static int gfar_process_frame(struct net_device *dev, struct sk_buff *skb,
>>        /* Tell the skb what kind of packet this is */
>>        skb->protocol = eth_type_trans(skb, dev);
>>
>> -       /* Set vlan tag */
>> -       if (fcb->flags & RXFCB_VLN)
>> +       /*
>> +        * There's need to check for NETIF_F_HW_VLAN_RX here.
>> +        * Even if vlan rx accel is disabled, on some chips
>> +        * RXFCB_VLN is pseudo randomly set.
>> +        */
>> +       if (dev->features & NETIF_F_HW_VLAN_RX &&
>> +           fcb->flags & RXFCB_VLN)
>>                __vlan_hwaccel_put_tag(skb, fcb->vlctl);
>>
>>        /* Send the packet up the stack */
>> --
>> 1.7.6
>>
>>
>
>Jiri, there seems to be another bug lingering in the bridge code,
>which might cause this problem in the first place but I am not really
>sure. I looked at the ethtool output some more and I noticed that some
>features were enabled on the Bridge which should be off.
>
>With 3.1-rc1
>Offload parameters for lan (This is the bridge interface itself):
>rx-checksumming: on                  <---- ON
>tx-checksumming: on                  <---- ON
>scatter-gather: off
>tcp-segmentation-offload: off
>udp-fragmentation-offload: off
>generic-segmentation-offload: off
>generic-receive-offload: on
>large-receive-offload: off
>rx-vlan-offload: off
>tx-vlan-offload: on                         <---- ON
>
>I booted an older kernel on the same hardware (2.6.39) and the output differs.
>
>Offload parameters for lan:
>rx-checksumming: off
>tx-checksumming: off
>scatter-gather: off
>tcp-segmentation-offload: off
>udp-fragmentation-offload: off
>generic-segmentation-offload: off
>generic-receive-offload: off
>large-receive-offload: off
>rx-vlan-offload: off
>tx-vlan-offload: off
>ntuple-filters: off
>receive-hashing: off
>
>As you can see all the values are OFF which is correct, since no
>attached interface supports these features.
>Is it possible that this is tripping up the now changed gianfar code somehow?
>What I am trying to say. Could it be that your patch is hiding a
>problem that is now surfacing with a change in the bridge code?

Well this seems unrelated. The problem is that gianfar hw is indicating
it received vlan tagged packet even in case it did not.

>
>I am thinking about this commit:
>c4d27ef95:  bridge: convert br_features_recompute() to ndo_fix_features
>
>Of course this could also be a totally separate bug as well.
>
>Any thoughts, Dave, Stephen?
>
>Kind regards,
>Michael Guntsche
