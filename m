Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab1FHRu3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 13:50:29 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56191 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab1FHRu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 13:50:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=FLj/dGhWAJ57bt5v6yzsiyOwy7WFYk3gMFvCxo2/mk6bpofhFqe2pbmGlUDOMLDsFD
         CP4g9S/Z5tUmbWnQITfrj5gcy15WHCuSIj232fZEXDcvKj7XnEcswyhSvsIS28MV3VMy
         A8XLwcAh60X+YaOuaPPUWqvO6c57PT0aFimzk=
MIME-Version: 1.0
In-Reply-To: <20110607233517.GA31794@opentech.at>
References: <17185480.5304.1307435255996.JavaMail.root@WARSBL214.highway.telekom.at>
	<alpine.LFD.2.02.1106071033350.11814@ionos>
	<4DEDF1F2.2080204@steinhoff.de>
	<1307439469.2322.235.camel@twins>
	<BANLkTi=KPyds_BWYpXHeUkAg000FGSuJOQ@mail.gmail.com>
	<20110607233517.GA31794@opentech.at>
Date: Wed, 8 Jun 2011 19:50:24 +0200
X-Google-Sender-Auth: 0GkPmTYfm-x12i4aCsHE4JcwGBc
Message-ID: <BANLkTimYSEo4_3ecdEVaJxdME7n9=2Km8Q@mail.gmail.com>
Subject: Re: Changing Kernel thread priorities
From: Remy Bohmer <linux@bohmer.net>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Armin Steinhoff <armin@steinhoff.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Bauer <hannes_bauer@aon.at>,
        Monica Puig-Pey <puigpeym@unican.es>,
        Rolando Martins <rolando.martins@gmail.com>,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> So, in that case and in many other hotplug cases, you ruin the RT
>> behaviour of the system just by the
>> default-50-is-probably-right-assumption of the kernel.
>> For systems where you have everything under control as a user/system
>> designer, hotplug can also be under control as well.
>>
>
> I dont't quite see that - the 50 default is well dokumented so you can
> plan it into the rt design at system level. It simply means that you
> would need to put your hard-rt tasks in the range of 50<prio<99.

This is another assumption as well. You assume here that any task
bound to certain latencies must be above _all_ interrupt handlers, and
tasks not bound to certain latencies must be set below _all_ interrupt
handlers.
In fact, in real life,  the prioritisation will be much more fine
grained during runtime. One can have a RT task that depends on the
networking stack, but not on mass-storage. In that case you want to
move them out of the range of 50.
The whole idea about threaded interrupts is, is that you can give them
priorities such that they suit your specific application. It is
therefore common practice that priorities does not stay at 49/50.

In real life you may want, for EXAMPLE, this setup:
* prio 70: high priority motor control loop
* prio 60: network device irq
* prio 59: network softirqs
* prio 55: some realtime task depending on networkingstack
* prio 54: mass storage irq
* prio 53: block device softirq
* prio 52: some realtime task depending on mass-storage
* prio 50: all remaining irq threads
* prio 49: all remaining softirqs

Assume here you do a ifconfig down and ifconfig up, in the current
kernel behaviour you will see that the irq thread switches from prio
60 to 50.
The irq-thread will become of a lower priority compared to its related
softirqs due to this reason, which can result in a complete die of
this network interface... even before it ever came back up again...

As mentioned before by Thomas, the configuration is a policy issue and
must be set from user-context. I understand what he means by that and
I agree, but there still has to be a mechanism to make the kernel
remember the configuration set by the user to prevent all kinds of
race conditions. You cannot demand from the user to run after
executing a shell command like ifconfig or modprobe to run some sort
of init-script that repairs what the kernel assumed wrong. The wrong
assumptions the kernel does results in: deadlocks, priority inversion
issues between irq-threads and softirqs and realtime behaviour impact.
Even UDEV cannot_fix_this_problem_ since it runs _after_ the kernel
has set the wrong priorities of the irq threads and the problem it
imposes already may have occurred.

Setting the priorities right once is already complicated enough, it
makes it far more complex if all kinds of race conditions and
limitations need to be taken into account due to this mentioned
auto-reset-to-50(-or-1)-assumptions of the kernel...
True, there must be a safe default for booting, and 49/50 is good
enough for that.

So, you might disagree the way our patches to solve this problem are
implemented, I can buy that, it is just at the level of 'works-for-me'
. Since this discussion frequently appears back on the mailinglist
makes clear that this _is_ an issue that is relevant. Instead of
ignoring or denying this issue, we should figure out what is the
_best_way_ to solve it.
I hope to see great and constructive suggestions soon on this list, I
am very willing to implement it :-)

Kind regards,

Remy
