Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068Ab1FILTx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:19:53 -0400
Received: from hofr.at ([212.69.189.236]:51395 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753768Ab1FILTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:19:46 -0400
Date: Thu, 9 Jun 2011 13:19:42 +0200
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Remy Bohmer <linux@bohmer.net>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Armin Steinhoff <armin@steinhoff.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Bauer <hannes_bauer@aon.at>,
        Monica Puig-Pey <puigpeym@unican.es>,
        Rolando Martins <rolando.martins@gmail.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Changing Kernel thread priorities
Message-ID: <20110609111941.GA5747@opentech.at>
References: <17185480.5304.1307435255996.JavaMail.root@WARSBL214.highway.telekom.at> <alpine.LFD.2.02.1106071033350.11814@ionos> <4DEDF1F2.2080204@steinhoff.de> <1307439469.2322.235.camel@twins> <BANLkTi=KPyds_BWYpXHeUkAg000FGSuJOQ@mail.gmail.com> <20110607233517.GA31794@opentech.at> <BANLkTimYSEo4_3ecdEVaJxdME7n9=2Km8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimYSEo4_3ecdEVaJxdME7n9=2Km8Q@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 Jun 2011, Remy Bohmer wrote:

> Hi,
> 
> >> So, in that case and in many other hotplug cases, you ruin the RT
> >> behaviour of the system just by the
> >> default-50-is-probably-right-assumption of the kernel.
> >> For systems where you have everything under control as a user/system
> >> designer, hotplug can also be under control as well.
> >>
> >
> > I dont't quite see that - the 50 default is well dokumented so you can
> > plan it into the rt design at system level. It simply means that you
> > would need to put your hard-rt tasks in the range of 50<prio<99.
> 
> This is another assumption as well. You assume here that any task
> bound to certain latencies must be above _all_ interrupt handlers, and
> tasks not bound to certain latencies must be set below _all_ interrupt
> handlers.
> In fact, in real life,  the prioritisation will be much more fine
> grained during runtime. One can have a RT task that depends on the
> networking stack, but not on mass-storage. In that case you want to
> move them out of the range of 50.

No implications are made on the "correct" priority - but as there is no
correct priority setting a well defined default and leaving it to the
user is the most resonable solution. The main issue with not changing it
from the current value is simply that it may change behavior of existing
systems that update and that is, if it provides no obvious benifit, not
a good thing to happen.

> The whole idea about threaded interrupts is, is that you can give them
> priorities such that they suit your specific application. It is
> therefore common practice that priorities does not stay at 49/50.
> 
> In real life you may want, for EXAMPLE, this setup:
> * prio 70: high priority motor control loop
> * prio 60: network device irq
> * prio 59: network softirqs
> * prio 55: some realtime task depending on networkingstack
> * prio 54: mass storage irq
> * prio 53: block device softirq
> * prio 52: some realtime task depending on mass-storage
> * prio 50: all remaining irq threads
> * prio 49: all remaining softirqs
> 
> Assume here you do a ifconfig down and ifconfig up, in the current
> kernel behaviour you will see that the irq thread switches from prio
> 60 to 50.
> The irq-thread will become of a lower priority compared to its related
> softirqs due to this reason, which can result in a complete die of
> this network interface... even before it ever came back up again...
> 
> As mentioned before by Thomas, the configuration is a policy issue and
> must be set from user-context. I understand what he means by that and
> I agree, but there still has to be a mechanism to make the kernel
> remember the configuration set by the user to prevent all kinds of
> race conditions. You cannot demand from the user to run after
> executing a shell command like ifconfig or modprobe to run some sort
> of init-script that repairs what the kernel assumed wrong. The wrong
> assumptions the kernel does results in: deadlocks, priority inversion
> issues between irq-threads and softirqs and realtime behaviour impact.

but you equally can not assume that a device comming back on-line always
should have the same priority. i.e. DAQ-card is opened by process A prioX
and then closed to be reopened by procsee B prio Y - the priority of the
DAQ-card IRQ  thread is not related and persistence here is dependant on 
the particular circumstances.

> Even UDEV cannot_fix_this_problem_ since it runs _after_ the kernel
> has set the wrong priorities of the irq threads and the problem it
> imposes already may have occurred.
> 
> Setting the priorities right once is already complicated enough, it
> makes it far more complex if all kinds of race conditions and
> limitations need to be taken into account due to this mentioned
> auto-reset-to-50(-or-1)-assumptions of the kernel...
> True, there must be a safe default for booting, and 49/50 is good
> enough for that.
> 
> So, you might disagree the way our patches to solve this problem are
> implemented, I can buy that, it is just at the level of 'works-for-me'
> . Since this discussion frequently appears back on the mailinglist
> makes clear that this _is_ an issue that is relevant. Instead of
> ignoring or denying this issue, we should figure out what is the
> _best_way_ to solve it.
> I hope to see great and constructive suggestions soon on this list, I
> am very willing to implement it :-)
>

so maybe a comlet set of requirements is needed first rather than ad-hoc
solutions for special cases - Im quite sure the non-persistant case is only
one of a few issues one can find here.

hofrat
