Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab0H3XYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 19:24:23 -0400
Received: from mailhub4.stratus.com ([134.111.1.17]:60902 "EHLO
	mailhub4.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161Ab0H3XYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 19:24:22 -0400
Date: Mon, 30 Aug 2010 19:21:47 -0400
From: Bandan Das <bandan.das@stratus.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, NetDev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH net-next-2.6] net/ipv4: push IP options to CB in
 ip_fragment
Message-ID: <20100830232147.GB10754@stratus.com>
References: <20100830200917.GA10754@stratus.com>
 <1283204118.2405.32.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1283204118.2405.32.camel@edumazet-laptop>
Company: Stratus Technologies
X-Disclaimer: This email will auto delete in 5 days, nah.. I am kidding!
User-Agent: Mutt/1.5.20 (2009-08-17)
X-OriginalArrivalTime: 30 Aug 2010 23:21:47.0784 (UTC) FILETIME=[1E211880:01CB489A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On  0, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le lundi 30 août 2010 à 16:09 -0400, Bandan Das a écrit :
> > The bridge layer can overwrite the IPCB using the
> > BR_INPUT_SKB_CB macro. In br_nf_dev_queue_xmit, 
> > if we recieve a packet greater in size than the bridge 
> > device MTU, we call ip_fragment which in turn will lead to 
> > icmp_send calling ip_options_echo if the DF flag is set. 
> > ip_options_echo will then incorrectly try to parse the IPCB as 
> > IP options resulting in a buffer overflow. 
> > This change refills the CB area back with IP 
> > options before ip_fragment calls icmp_send. If we fail parsing, 
> > we zero out the IPCB area to guarantee that the stack does 
> > not get corrupted.
> > 
> > Test setup that can exhibit this behavior:
> > <Remote Machine>--<Host Machine>--<Bridge>--<Tun/Tap>--<KVM Guest>
> >   1500 mtu          576 mtu        576 mtu   576 mtu    1500 mtu
> > 
> > Example of crash :
> > Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: ffffffff8146dff3
> > Pid: 3173, comm: qemu-kvm Not tainted 2.6.32-63.el6.x86_64 #1
> > Call Trace:
> > Message from <IRQ>  syslogd@kvm at  [<ffffffff814c8285>] panic+0x78/0x137
> > Aug 30 14:09:50  [<ffffffff8146dff3>] ? icmp_send+0x743/0x780
> > 
> > Signed-off-by: Bandan Das <bandan.das@stratus.com>
> > ---
> >  net/ipv4/ip_output.c |   11 +++++++++++
> >  1 files changed, 11 insertions(+), 0 deletions(-)
> > 
> > diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
> > index e427620..5fef4a9 100644
> > --- a/net/ipv4/ip_output.c
> > +++ b/net/ipv4/ip_output.c
> > @@ -445,6 +445,7 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
> >  	struct iphdr *iph;
> >  	int ptr;
> >  	struct net_device *dev;
> > +	struct ip_options *opt;
> >  	struct sk_buff *skb2;
> >  	unsigned int mtu, hlen, left, len, ll_rs;
> >  	int offset;
> > @@ -462,6 +463,16 @@ int ip_fragment(struct sk_buff *skb, int (*output)(struct sk_buff *))
> >  
> >  	if (unlikely((iph->frag_off & htons(IP_DF)) && !skb->local_df)) {
> >  		IP_INC_STATS(dev_net(dev), IPSTATS_MIB_FRAGFAILS);
> > +
> > +		/* Refill CB with IP options */
> > +		opt = &(IPCB(skb)->opt);
> > +		opt->optlen = iph->ihl*4 - sizeof(struct iphdr);
> > +		if (ip_options_compile(dev_net(dev), opt, skb)) {
> > +			IP_INC_STATS(dev_net(dev), IPSTATS_MIB_INHDRERRORS);
> > +			/* If we fail, zero out IPCB and continue */
> > +			memset(IPCB(skb), 0, sizeof(struct inet_skb_parm));
> > +		}
> > +
> >  		icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
> >  			  htonl(ip_skb_dst_mtu(skb)));
> >  		kfree_skb(skb);
> 
> 
> I wonder if we want this.
> 
> Maybe setting skb->local_df = 1 in bridge should be enough ?
> 
> 
Thanks Eric for looking at this. Indeed, setting local_df to 1 seems to be enough! I will
respin and post a different patch.

-- 
Bandan Das
