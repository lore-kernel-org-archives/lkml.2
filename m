Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab2G3Bmg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 21:42:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab2G3Bme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 21:42:34 -0400
Message-ID: <1343612521.1642.2.camel@cr0>
Subject: Re: [PATCH 2/7] netpoll: make __netpoll_cleanup non-block
From: Cong Wang <amwang@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        Patrick McHardy <kaber@trash.net>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Jiri Pirko <jiri@resnulli.us>, Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
Date: Mon, 30 Jul 2012 09:42:01 +0800
In-Reply-To: <20120727184031.GB20938@hmsreliant.think-freely.org>
References: <1343403484-29347-1-git-send-email-amwang@redhat.com>
	 <1343403484-29347-3-git-send-email-amwang@redhat.com>
	 <20120727184031.GB20938@hmsreliant.think-freely.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-07-27 at 14:40 -0400, Neil Horman wrote:
> Here, and above I see you using an rcu_head to defer cleanup, until after all
> pointer uses are dropped, but I don't see any modification of code points that
> dereference any struct netpoll pointers to include
> rcu_read_lock()/rcu_read_unlock().  Without those using rcu to defer cleanup is
> pointless, as the rcu code won't know when its safe to run.  You're no better
> off that you would be just calling __netpoll_cleanup directly.

Hi, Neil,

Actually they are protected by rcu_read_lock_bh() which is implied by
local_irq_disable(), see:

commit f0f9deae9e7c421fa0c1c627beb8e174325e1ba7
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Fri Sep 17 16:55:03 2010 -0700

    netpoll: Disable IRQ around RCU dereference in netpoll_rx
    
    We cannot use rcu_dereference_bh safely in netpoll_rx as we may
    be called with IRQs disabled.  We could however simply disable
    IRQs as that too causes BH to be disabled and is safe in either
    case.
    
    Thanks to John Linville for discovering this bug and providing
    a patch.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
    Signed-off-by: David S. Miller <davem@davemloft.net>


Thanks.


