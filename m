Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab1FHTuK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 15:50:10 -0400
Received: from www.linutronix.de ([62.245.132.108]:49485 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab1FHTuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:50:07 -0400
Date: Wed, 8 Jun 2011 21:49:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Remy Bohmer <linux@bohmer.net>
cc: Nicholas Mc Guire <der.herr@hofr.at>,
        Peter Zijlstra <peterz@infradead.org>,
        Armin Steinhoff <armin@steinhoff.de>,
        Johannes Bauer <hannes_bauer@aon.at>,
        Monica Puig-Pey <puigpeym@unican.es>,
        Rolando Martins <rolando.martins@gmail.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Changing Kernel thread priorities
In-Reply-To: <BANLkTimYSEo4_3ecdEVaJxdME7n9=2Km8Q@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1106082044040.11814@ionos>
References: <17185480.5304.1307435255996.JavaMail.root@WARSBL214.highway.telekom.at> <alpine.LFD.2.02.1106071033350.11814@ionos> <4DEDF1F2.2080204@steinhoff.de> <1307439469.2322.235.camel@twins> <BANLkTi=KPyds_BWYpXHeUkAg000FGSuJOQ@mail.gmail.com>
 <20110607233517.GA31794@opentech.at> <BANLkTimYSEo4_3ecdEVaJxdME7n9=2Km8Q@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jun 2011, Remy Bohmer wrote:
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

Not really. If that's the case it needs to be investigated and
fixed.

> As mentioned before by Thomas, the configuration is a policy issue and
> must be set from user-context. I understand what he means by that and
> I agree, but there still has to be a mechanism to make the kernel
> remember the configuration set by the user to prevent all kinds of
> race conditions. You cannot demand from the user to run after

Which race conditions?

> executing a shell command like ifconfig or modprobe to run some sort
> of init-script that repairs what the kernel assumed wrong. The wrong
> assumptions the kernel does results in: deadlocks, priority inversion
> issues between irq-threads and softirqs and realtime behaviour impact.

If you do an ifdown/up then your prio 55 task is totally irrelevant
until the interface is back to full operation again, which includes
setting the priority right.

There is another gotcha with your approach. It only ever works when
the interrupt descriptors are static and not dynamically
allocated/freed. If they are fully dynamic then you have no
possibility to store the prio information after a full teardown of a
device.

So moving the base priority down to 1 or 2 is probably the most
sensible solution to avoid that a newly brought up interrupt thread
interferes with anything in the rt domain and it's not rocket science
to adjust the priority in a ifup.post or with an udev rule.

Thanks,

	tglx
