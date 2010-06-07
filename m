Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab0FGKA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 06:00:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42163
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751588Ab0FGKA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 06:00:58 -0400
Date: Mon, 07 Jun 2010 03:01:08 -0700 (PDT)
Message-Id: <20100607.030108.235696592.davem@davemloft.net>
To: amwang@redhat.com
Cc: andy@greyhouse.net, fubar@us.ibm.com, fbl@sysclose.org,
       linux-kernel@vger.kernel.org, mpm@selenic.com, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, gospo@redhat.com,
       nhorman@tuxdriver.com, jmoyer@redhat.com,
       shemminger@linux-foundation.org, bonding-devel@lists.sourceforge.net
Subject: Re: [v5 Patch 1/3] netpoll: add generic support for bridge and
 bonding devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C0CC29D.9070507@redhat.com>
References: <4C062CBD.7090906@redhat.com>
	<20100604191841.GM7497@gospo.rdu.redhat.com>
	<4C0CC29D.9070507@redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <amwang@redhat.com>
Date: Mon, 07 Jun 2010 17:57:49 +0800

> Hmm, I still feel like this way is ugly, although it may work.
> I guess David doesn't like it either.

Of course I don't like it. :-)

I suspect the locking scheme will need to be changed.

Besides, if we're going to hack this up and do write lock attempts in
the read locking paths, there is no point in using a rwlock any more.
And I'm personally in disfavor of all rwlock usage anyways (it dirties
the cacheline for readers just as equally for writers, and if the
critically protected code path is short enough, that shared cache
line atomic operation will be the predominant cost).

So I'd say, 1) make this a spinlock and 2) try to use RCU for the
read path.

That would fix everything.
