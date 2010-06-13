Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803Ab0FMUld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 16:41:33 -0400
Received: from mirapoint3.brutele.be ([212.68.199.148]:62585 "EHLO
	mirapoint3.brutele.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab0FMUlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 16:41:32 -0400
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Sun, 13 Jun 2010 16:41:32 EDT
Message-ID: <4C15410D.4080107@tvcablenet.be>
Date: Sun, 13 Jun 2010 22:35:25 +0200
From: =?ISO-8859-1?Q?Fran=E7ois_Valenduc?= 
	<francois.valenduc@tvcablenet.be>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100529 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: chris2553@googlemail.com
Subject: Re: Noticeable slow-down in 2.6.35-rc3
References: <AANLkTimDUf0N6b5PBy2wTGeAWEIY-lUvQPHQ7D7Gyrq4@mail.gmail.com>
In-Reply-To: <AANLkTimDUf0N6b5PBy2wTGeAWEIY-lUvQPHQ7D7Gyrq4@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Junkmail-Status: score=10/50, host=mirapoint3.brutele.be
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A0B0206.4C15410E.0108,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 13/06/10 22:15, Chris Clayton a écrit :
> Hi,
> 
> Please cc me on any reply because I'm not subscribed to linux-kernel
> or linux-net
> 
> I've noticed a slowdown in 2.6.35-rc3. It shows up in a few places:
> 
> 1. When my desktop (KDE 3.5.10) is starting up, the "Initialising
> system services" phase takes about 45 seconds as opposed to the normal
> 4 or 5 seconds., Similarly, whilst the basic KDE panel draws as
> normal, the icons and other gadgets that it normally contains take
> about 15 seconds to appear.
> 
> 2. In firefox (3.6.3), there is a short (a second or two), but
> noticeable, delay when a menu or sub-menu label is clicked on before
> the {sub-,}menu appears. Normally the response id almost instant.
> 
> There are some similarities with Gene Heskett's report at
> http://marc.info/?l=linux-kernel&m=127635846208957
> 
> I've bisected it and arrived at:
> 
> 597a264b1a9c7e36d1728f677c66c5c1f7e3b837 is the first bad commit
> commit 597a264b1a9c7e36d1728f677c66c5c1f7e3b837
> Author: John Fastabend <john.r.fastabend@intel.com>
> Date:   Thu Jun 3 09:30:11 2010 +0000
> 
>     net: deliver skbs on inactive slaves to exact matches
> 
>     Currently, the accelerated receive path for VLAN's will
>     drop packets if the real device is an inactive slave and
>     is not one of the special pkts tested for in
>     skb_bond_should_drop().  This behavior is different then
>     the non-accelerated path and for pkts over a bonded vlan.
> 
>     For example,
> 
>     vlanx -> bond0 -> ethx
> 
>     will be dropped in the vlan path and not delivered to any
>     packet handlers at all.  However,
> 
>     bond0 -> vlanx -> ethx
> 
>     and
> 
>     bond0 -> ethx
> 
>     will be delivered to handlers that match the exact dev,
>     because the VLAN path checks the real_dev which is not a
>     slave and netif_recv_skb() doesn't drop frames but only
>     delivers them to exact matches.
> 
>     This patch adds a sk_buff flag which is used for tagging
>     skbs that would previously been dropped and allows the
>     skb to continue to skb_netif_recv().  Here we add
>     logic to check for the deliver_no_wcard flag and if it
>     is set only deliver to handlers that match exactly.  This
>     makes both paths above consistent and gives pkt handlers
>     a way to identify skbs that come from inactive slaves.
>     Without this patch in some configurations skbs will be
>     delivered to handlers with exact matches and in others
>     be dropped out right in the vlan path.
> 
>     I have tested the following 4 configurations in failover modes
>     and load balancing modes.
> 
>     # bond0 -> ethx
> 
>     # vlanx -> bond0 -> ethx
> 
>     # bond0 -> vlanx -> ethx
> 
>     # bond0 -> ethx
>                 |
>       vlanx -> --
> 
>     Signed-off-by: John Fastabend <john.r.fastabend@intel.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> :040000 040000 f272ab5b895c46b3166d321a2da759c2a6e08ae0
> 467d28aad962f3506bc8820241d7417fb93e507f M      include
> :040000 040000 b4c5eb03a781b5ca016459ae19ebe2175d119eda
> 9c0ce9f12b43aecd9fee9ed816e11841b7b81fd8 M      net
> 
> The bisect log:
> 
> # bad: [7e27d6e778cd87b6f2415515d7127eba53fe5d02] Linux 2.6.35-rc3
> # good: [e44a21b7268a022c7749f521c06214145bd161e4] Linux 2.6.35-rc2
> git bisect start 'v2.6.35-rc3' 'v2.6.35-rc2'
> # good: [6db40cf047a8723095caf79f5569d21b388d7b31] pipe: fix check in
> "set size" fcntl
> git bisect good 6db40cf047a8723095caf79f5569d21b388d7b31
> # good: [63c70a0d7b59bac08bd14cd24c36f76aafc25de6] Merge branch
> 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client
> git bisect good 63c70a0d7b59bac08bd14cd24c36f76aafc25de6
> # good: [6f902af400b2499c80865c62a06fbbd15cf804fd] Btrfs: The file
> argument for fsync() is never null
> git bisect good 6f902af400b2499c80865c62a06fbbd15cf804fd
> # good: [7ae1277a5202109a31d8f81ac99d4a53278dab84] Merge branch
> 'pm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6
> git bisect good 7ae1277a5202109a31d8f81ac99d4a53278dab84
> # good: [00d9d6a185de89edc0649ca4ead58f0283dfcbac] ipv6: fix ICMP6_MIB_OUTERRORS
> git bisect good 00d9d6a185de89edc0649ca4ead58f0283dfcbac
> # bad: [349124a00754129a5f1e43efa84733e364bf3749] net8139: fix a race
> at the end of NAPI
> git bisect bad 349124a00754129a5f1e43efa84733e364bf3749
> # bad: [ae638c47dc040b8def16d05dc6acdd527628f231] pkt_sched:
> gen_estimator: add a new lock
> git bisect bad ae638c47dc040b8def16d05dc6acdd527628f231
> # bad: [597a264b1a9c7e36d1728f677c66c5c1f7e3b837] net: deliver skbs on
> inactive slaves to exact matches
> git bisect bad 597a264b1a9c7e36d1728f677c66c5c1f7e3b837
> 
> Reversing the identified patch gives a kernel without the slowdowns.
> 
> bzip'd .config is attached.
> 
> Happy to test fixes or provide additional diagnostics, but for the
> latter I'll need clear instructions - I'm not that familiar with the
> net tools.
> 
> Chris

This commit also makes nfsd hangs at startup on my computer (see
https://bugzilla.kernel.org/show_bug.cgi?id=16195). This problem doesn't
occur if it's reverted.

François Valenduc
