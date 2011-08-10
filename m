Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286Ab1HJIqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 04:46:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36850 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab1HJIqY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 04:46:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110810083732.GA1909@minipsycho.brq.redhat.com>
References: <CAMvAeqOA0=FnjB2oPPCEYpkXdKrmqOs+MwAqszV5sTGys_a3mQ@mail.gmail.com>
	<20110810070722.GA2150@minipsycho>
	<CAMvAeqNA9Wcr3bO+Vya4gt2YC47oe=-A8Fxnswdj0ozD5tfZtQ@mail.gmail.com>
	<20110810083732.GA1909@minipsycho.brq.redhat.com>
Date: Wed, 10 Aug 2011 10:46:22 +0200
Message-ID: <CAMvAeqMku7fTmhxELC0VAs8ghJopB=b+dZ3gzrysQwpJL_6HaQ@mail.gmail.com>
Subject: Re: BUG: Bisected Gianfar in bridge not forwarding packets (was:
 3.0-rc1 Bridge not forwarding unicast packages)
From: Michael Guntsche <mguntsche@gmail.com>
To: Jiri Pirko <jpirko@redhat.com>
Cc: shemminger@vyatta.com, sebastian.belden@googlemail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 10:37 AM, Jiri Pirko <jpirko@redhat.com> wrote:
> Wed, Aug 10, 2011 at 09:40:50AM CEST, mguntsche@gmail.com wrote:
>>On Wed, Aug 10, 2011 at 9:07 AM, Jiri Pirko <jpirko@redhat.com> wrote:
>>> Wed, Aug 10, 2011 at 02:50:20AM CEST, mguntsche@gmail.com wrote:
>>>>Good evening/morning,
>>>>
>>>>> I just upgraded my router/bridge combo to 3.1-rc1 from 3.0 for
>>>>> testing. On a first look everything seemed to work fine, but when I
>>>>> tried to connect via openvpn to my internal network (tap0 being bridged
>>>>> with the internal network) I noticed that I was not able to access the
>>>>> server on my internal network. I could access the bridge (which is
>>>>> acting as the openvpn server as well) just fine though.
>>>>> To debug this I ran tcpdump on the openvpn client and started a ping to the
>>>>> internal network. I could see the ARP requests being answered.....
>>>><snip>
>>>>
>>>>After much digging and testing I found the commit that causes the
>>>>problem for me here.
>>>>
>>>>87c288c6e gianfar: do vlan cleanup
>>>>
>>>>Before this commit my bridge works fine. I simplified the test case
>>>>and just tried to access the server from a local wireless device with
>>>>gets also bridged via
>>>>a gianfar nic to the wired lan. Before commit 87c288c6e I can ping the
>>>>device from the internal network afterwards it stops.
>>>>For testing purposes I reverted this commit (plus some others to make
>>>>the code compile) and it started working again.
>>>>The hardware is a routerboard with three onboard nics two of em gianfar.
>>>>The gianfar nics do not support any kind of offloading,
>>>
>>> Thanks for testing/report. I'm not sure I understand your simplified
>>> case :(
>>Sorry if my explanation was confusing but it was late night/morning
>>when I wrote it.
>>
>>The setup is quite easy.
>>
>>WLAN ----->|Bridge|<----- Wired Lan (gianfar nic)
>>
>>Client (in WLAN): 192.168.42.55
>>Bridge: 192.168.42.1
>>Server (on Wired): 192.168.42.127
>>
>>With your patch the Bridge can ping the client and the server, but the
>>client cannot reach the server and vice-versa.
>
> This is very interesting. Can you please find out of packets get lost on
> tx or rx of gianfar? Please try to watch the trafic by tcpdump on bridge
> and on gianfar device.
I can try to do that this afternoon.

>>> Anyway, gianfar supports rx/tx vlan accel. Would you please try to turn
>>> it on/off manually by ethtool to see if it works in some setup?
>>The gianfar chip in this routerboard does NOT support vlan accel it is
>>a TSEC model.
>>ethtool complains that this feature is not supported.
>
> What routerboard is it? Maybe I can get one to see this myself. Thanks.
The model is a Rb600a which is no longer available

> Can you please send me output of following command?
> "cat /sys/class/net/[gianfar devname]/features"
There is no file called features under the gianfar devname

>
> Also, please try with following testing patch:
>
>
> diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
> index 2659daa..2727bb7 100644
> --- a/drivers/net/gianfar.c
> +++ b/drivers/net/gianfar.c
> @@ -2711,8 +2711,8 @@ static int gfar_process_frame(struct net_device *dev, struct sk_buff *skb,
>        skb->protocol = eth_type_trans(skb, dev);
>
>        /* Set vlan tag */
> -       if (fcb->flags & RXFCB_VLN)
> -               __vlan_hwaccel_put_tag(skb, fcb->vlctl);
> +       //if (fcb->flags & RXFCB_VLN)
> +       //      __vlan_hwaccel_put_tag(skb, fcb->vlctl);
>
>        /* Send the packet up the stack */
>        ret = netif_receive_skb(skb);
Will do.

Kind regards,
Michael
