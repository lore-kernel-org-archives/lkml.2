Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab1FDWsN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 18:48:13 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:57290 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab1FDWsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 18:48:10 -0400
Subject: Re: Mysterious CFQ crash and RCU
From: Paul Bolle <pebolle@tiscali.nl>
To: paulmck@linux.vnet.ibm.com, Jens Axboe <jaxboe@fusionio.com>,
        Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Date: Sun, 05 Jun 2011 00:48:05 +0200
In-Reply-To: <20110604160326.GA6093@linux.vnet.ibm.com>
References: <20110519222404.GG12600@redhat.com>
	 <20110521210013.GJ2271@linux.vnet.ibm.com>
	 <20110523152141.GB4019@redhat.com>
	 <20110523153848.GC2310@linux.vnet.ibm.com>
	 <1306401337.27271.3.camel@t41.thuisdomein>
	 <20110603050724.GB2304@linux.vnet.ibm.com>
	 <1307191830.23387.24.camel@t41.thuisdomein>
	 <20110604160326.GA6093@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1307227686.28359.23.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-06-04 at 09:03 -0700, Paul E. McKenney wrote:
> More like "based on these diagnostics, I see no evidence of the RCU
> implementation misbehaving."  Which is of course different than "I can
> prove that the RCU implementation is not misbehaving".  That said, the
> fact that you are running on a single CPU makes it hard for me to see
> any latitude for RCU-implementation misbehavior.
> 
> Clearly something is wrong somewhere.

Yes.

> Given the fact that on a single-CPU
> system, synchronize_rcu() is a no-op, and given that you weren't able
> to reproduce with CONFIG_TREE_PREEMPT_RCU=y, my guess is that there is
> a synchronize_rcu() that occasionally (illegally) gets executed within
> an RCU read-side critical section.

I think I finally found it!

The culprit seems to be io_context.ioc_data (not the most clear of
names!). It seems to be a single entry "last-hit cache" of an hlist
called cic_list. (There are three, subtly different, cic_lists in the
CFQ code!) It is not entirely clear, but that last-hit cache can get out
of sync with the hlist it is supposed to cache. My guess it that every
now and then a member of the hlist gets deleted while it's still in that
(single entry) cache. If it then gets retrieved from that cache it
already points to poisoned memory. For some strange reason this only
results in an Oops if one or more debugging options are set (as are set
in the Fedora Rawhide non-stable kernels that I ran into this). I have
no clue whatsoever, why that is ...

Anyhow, after ripping out ioc_data this bug seems to have disappeared!
Jens, Vivek, could you please have a look at this? In the mean time I
hope to pinpoint this issue and draft a small patch to really solve it
(ie, not by simply ripping out ioc_data).


Paul Bolle

