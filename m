Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab1EEVBC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 17:01:02 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50246 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751560Ab1EEVA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 17:00:59 -0400
Date: Thu, 5 May 2011 14:00:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Ying Han <yinghan@google.com>,
        Chris Mason <chris.mason@oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org,
        Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: memcg: fix fatal livelock in kswapd
Message-Id: <20110505140000.e4f315b5.akpm@linux-foundation.org>
In-Reply-To: <1304431865.2576.3.camel@mulgrave.site>
References: <1304366849.15370.27.camel@mulgrave.site>
	<20110502224838.GB10278@cmpxchg.org>
	<BANLkTikDyL9-XLpwyLwUQNuUfkBwbUBcZg@mail.gmail.com>
	<1304380698.15370.36.camel@mulgrave.site>
	<20110503063817.GD10278@cmpxchg.org>
	<1304431865.2576.3.camel@mulgrave.site>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The trail seems to have cooled off here, but it's pretty urgent.

Having re-read the threads I find it notable that James hit a kswapd
softlockup with "non-PREEMPT CGROUP but disabled GROUP_MEM_RES_CTLR". 
This suggests that the problem isn't with memcg.  Or at least, we
should fix this kswapd lockup before worrying about memcg.

And I'm not sure that we should be assuming that there's something
wrong in shrink_slab().  We know that kswapd has gone berserk, and that
it will frequently call shrink_slab() when in that mode.  But this may
be because the top-level balance_pgdat() loop isn't terminating for
reasons unrelated to shrink_slab().

