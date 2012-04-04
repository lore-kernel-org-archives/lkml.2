Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab2DDHwL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 03:52:11 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49689 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab2DDHwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 03:52:10 -0400
Date: Wed, 4 Apr 2012 10:52:04 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: [PATCHv1] ipv6: Fix RTM_GETROUTE's interpretation of RTA_IIF to
 be consistent with ipv4
Message-ID: <20120404105204.63122c38@pixies.home.jungo.com>
In-Reply-To: <20120401.173032.1881937766187683052.davem@davemloft.net>
References: <20120401170345.5ed75cab@pixies.home.jungo.com>
	<20120401.173032.1881937766187683052.davem@davemloft.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Sun, 01 Apr 2012 17:30:32 -0400 (EDT) David Miller <davem@davemloft.net> wrote:
> > Fix 'inet6_rtm_getroute()' so that RTA_IIF is interpreted as "lookup a
> > route as if a packet was received on the specified interface", similar
> > to IPv4's 'inet_rtm_getroute()' interpretation.
> > 
> > Reported-by: Ami Koren <amikoren@yahoo.com>
> > Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
> 
> Applied, thanks.
> 
> > 1) An alternative: construction of an skb within 'inet6_rtm_getroute()'
> >    and then calling 'ip6_route_input()' with the skb as an argument.
> >    Thus, no need to split common code of 'ip6_route_input()'.
> >    Less elegant IMO.
> 
> Agreed.
> 
> > 2) Better name for the new common function 'ip6_route_input_lookup()'
> >    Will happily accept any better suggestions.
> 
> No, it's fine.
> 
> > 3) In IPv4 the 'ip_route_input()' call within 'inet_rtm_getroute()'is
> >    protected by a 'local_bh_disable()' since dawn of history.
> >    Not sure if similar protection needed within 'inet6_rtm_getroute()'.
> 
> Since all the code paths are shared more than on the ipv4 side, both
> output and input route lookups can be done with and without BH
> disabling.

Thanks for the answers.

Looking at the patch again, I suspect I've missed one thing.

After applying patch, the code getting the 'rt' gets placed prior the
'alloc_skb()' - snip of new code:

	if (iif) {
		// some stuff ...

		rt = (struct rt6_info *)ip6_route_input_lookup(net, dev, &fl6,
							       flags);
	} else {
		fl6.flowi6_oif = oif;

		rt = (struct rt6_info *)ip6_route_output(net, NULL, &fl6);
	}

	skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
	if (!skb) {
		err = -ENOBUFS;
		goto errout;
	}

In case of 'alloc_skb' failure, shouldn't we issue a
'dst_release(&rt->dst)'?

If correct, I'll submit a fix. Should have spotted this earlier.

Regards,
Shmulik
