Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab1CHN0t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 08:26:49 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55189 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab1CHN0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 08:26:47 -0500
Date: Tue, 8 Mar 2011 08:26:32 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Jay Vosburgh <fubar@us.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org
Subject: Re: [Patch] bonding: fix netpoll in active-backup mode
Message-ID: <20110308132632.GA19072@hmsreliant.think-freely.org>
References: <1299507114-12144-1-git-send-email-amwang@redhat.com>
 <20110307185038.GA31788@hmsreliant.think-freely.org>
 <4D75AD50.7060400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D75AD50.7060400@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.6 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 12:15:12PM +0800, Cong Wang wrote:
> 于 2011年03月08日 02:50, Neil Horman 写道:
> >On Mon, Mar 07, 2011 at 10:11:50PM +0800, Amerigo Wang wrote:
> >>netconsole doesn't work in active-backup mode, because we don't do anything
> >>for nic failover in active-backup mode. This patch fixes the problem by:
> >>
> >>1) make slave_enable_netpoll() and slave_disable_netpoll() callable in softirq
> >>    context, that is, moving code after synchronize_rcu_bh() into call_rcu_bh()
> >>    callback function, teaching kzalloc() to use GFP_ATOMIC.
> >>
> >>2) disable netpoll on old slave and enable netpoll on the new slave.
> >>
> >>Tested by ifdown the current active slave and ifup it again for several times,
> >>netconsole works well.
> >>
> >>Signed-off-by: WANG Cong<amwang@redhat.com>
> >>
> >I may be missing soething but this seems way over-complicated to me.  I presume
> >the problem is that in active backup mode a failover results in the new active
> >slave not having netpoll setup on it?  If thats the case, why not just setup
> >netpoll on all slaves when ndo_netpoll_setup is called on the bonding interface?
> >I don't see anything immeidately catastrophic that would happen as a result.
> 
> 
> But we still need to clean up the netpoll on the failing slave, which still
> needs to call slave_disable_netpoll() in monitor code, I see no big differences
> with the solution I take.
> 
Why?  I understand you want to free up that memory, but I don't see any special
state codified in that structure that can't wait until you disable netpoll on
the bond as a whole.  Save yourself the time and trouble, enable netpoll on both
slaves when its enabled on the bond, and tear it down when its torn down on the
bond. Do worry about doing anything during a failover.

Neil
> 
> >And then you wouldn't have to worry about disabling/enabling anything on a
> >failover (or during a panic for that matter).  As for the rcu bits?  Why are
> >they needed?  One would presume that wouldn't (or at least shouldn't) be able to
> >teardown our netpoll setup until such time as all the pending frames for that
> >netpoll client have been transmitted.  If we're not blocknig on that RCU isn't
> >really going to help.  Seems like the proper fix is take a reference to the
> >appropriate npinfo struct in netpoll_send_skb, and drop it from the skbs
> >destructor or some such.
> 
> I saw a "scheduling while in atomic" warning without touching the rcu bits.
> 
> Thanks!
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
