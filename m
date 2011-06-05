Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab1FEKiq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 06:38:46 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:36521 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974Ab1FEKip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 06:38:45 -0400
Subject: Re: Mysterious CFQ crash and RCU
From: Paul Bolle <pebolle@tiscali.nl>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Date: Sun, 05 Jun 2011 12:38:43 +0200
References: <20110519222404.GG12600@redhat.com>
	 <20110521210013.GJ2271@linux.vnet.ibm.com>
	 <20110523152141.GB4019@redhat.com>
	 <20110523153848.GC2310@linux.vnet.ibm.com>
	 <1306401337.27271.3.camel@t41.thuisdomein>
	 <20110603050724.GB2304@linux.vnet.ibm.com>
	 <1307191830.23387.24.camel@t41.thuisdomein>
	 <20110604160326.GA6093@linux.vnet.ibm.com>
	 <1307227686.28359.23.camel@t41.thuisdomein> <4DEB28A1.5090109@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1307270324.25014.14.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-06-05 at 10:39 +0200, Paul Bolle wrote:
> 0) I'd guess not, as the last thing I tried before simply ripping
> io_context.ioc_data out, was:
> 
>         spin_lock_irqsave(&ioc->lock, flags);
>         rcu_read_lock();
>         ioc_data = rcu_dereference(ioc->ioc_data);
>         rcu_read_unlock();
>         if (ioc_data == cic)
>                 rcu_assign_pointer(ioc->ioc_data, NULL);
>         spin_unlock_irqrestore(&ioc->lock, flags);

0) Strike that. It does seem to fix it. I must have done something silly
while doing yet another test of this stuff (perhaps by forgetting to
remove an old, crashing version of the cfq_iosched module before
installing a new version and switching back to cfq).

1) Jens, I suggest I'll send in a small series of patches, along these
lines:
- cleanup: make two functions static in block/cfq-iosched.c
- cleanup: rename io_context.cic_list -> io_context.cic_hlist
           rename io_context.ioc_data -> io_context.last_cic
           change io_context.last_cic from void* to cfq_io_context* 
           rename cfq_io_context.cic_list -> cfq_io_context.cic_node
- cleanup: rename *ret -> *ioc in two functions
- locking: make sure io_context.last_cic is accessed under
           io_context.lock and using the required RCU voodoo

2) Any objections beforehand?


Paul Bolle

