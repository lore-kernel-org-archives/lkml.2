Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab1FEWvN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 18:51:13 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:60370 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247Ab1FEWvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 18:51:12 -0400
X-ASG-Debug-ID: 1307314269-01de280c1e257c0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DEC085E.3080506@fusionio.com>
Date: Mon, 6 Jun 2011 00:51:10 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Mysterious CFQ crash and RCU
References: <20110519222404.GG12600@redhat.com>	 <20110521210013.GJ2271@linux.vnet.ibm.com>	 <20110523152141.GB4019@redhat.com>	 <20110523153848.GC2310@linux.vnet.ibm.com>	 <1306401337.27271.3.camel@t41.thuisdomein>	 <20110603050724.GB2304@linux.vnet.ibm.com>	 <1307191830.23387.24.camel@t41.thuisdomein>	 <20110604160326.GA6093@linux.vnet.ibm.com>	 <1307227686.28359.23.camel@t41.thuisdomein> <4DEB28A1.5090109@fusionio.com> <1307270324.25014.14.camel@t41.thuisdomein>
X-ASG-Orig-Subj: Re: Mysterious CFQ crash and RCU
In-Reply-To: <1307270324.25014.14.camel@t41.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1307314269
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.65589
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-05 12:38, Paul Bolle wrote:
> On Sun, 2011-06-05 at 10:39 +0200, Paul Bolle wrote:
>> 0) I'd guess not, as the last thing I tried before simply ripping
>> io_context.ioc_data out, was:
>>
>>         spin_lock_irqsave(&ioc->lock, flags);
>>         rcu_read_lock();
>>         ioc_data = rcu_dereference(ioc->ioc_data);
>>         rcu_read_unlock();
>>         if (ioc_data == cic)
>>                 rcu_assign_pointer(ioc->ioc_data, NULL);
>>         spin_unlock_irqrestore(&ioc->lock, flags);

You don't need to nest a rcu_read_lock/unlock() inside that write lock.

> 0) Strike that. It does seem to fix it. I must have done something silly
> while doing yet another test of this stuff (perhaps by forgetting to
> remove an old, crashing version of the cfq_iosched module before
> installing a new version and switching back to cfq).

Good, I thought it should!

> 1) Jens, I suggest I'll send in a small series of patches, along these
> lines:
> - cleanup: make two functions static in block/cfq-iosched.c
> - cleanup: rename io_context.cic_list -> io_context.cic_hlist
>            rename io_context.ioc_data -> io_context.last_cic
>            change io_context.last_cic from void* to cfq_io_context* 
>            rename cfq_io_context.cic_list -> cfq_io_context.cic_node
> - cleanup: rename *ret -> *ioc in two functions
> - locking: make sure io_context.last_cic is accessed under
>            io_context.lock and using the required RCU voodoo
> 
> 2) Any objections beforehand?

I've already applied the fix I sent to you, since it was definitely a
bug. So please send anything around that. Was out today, so not pushed
out until now and just now catching up on the email.

And thanks a ton for being persistent and doing a ton of work trying to
figure out what was wrong. Fixing is the easy part, illuminating where
the problem is or may be is the hard part!

-- 
Jens Axboe

