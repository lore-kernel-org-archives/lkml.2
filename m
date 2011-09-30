Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab1I3QJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 12:09:44 -0400
Received: from claw.goop.org ([74.207.240.146]:45553 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511Ab1I3QJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 12:09:42 -0400
Message-ID: <4E85E9C4.1090606@goop.org>
Date: Fri, 30 Sep 2011 09:09:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>, Jason Baron <jbaron@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH RFC 0/8] jump-label: allow early jump_label_enable()
References: <cover.1317338254.git.jeremy.fitzhardinge@citrix.com>  <1317343975.4588.36.camel@gandalf.stny.rr.com> <4E854859.4020105@goop.org> <1317396484.4588.52.camel@gandalf.stny.rr.com>
In-Reply-To: <1317396484.4588.52.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2011 08:28 AM, Steven Rostedt wrote:
> On Thu, 2011-09-29 at 21:40 -0700, Jeremy Fitzhardinge wrote:
>> On 09/29/2011 05:52 PM, Steven Rostedt wrote:
>>> On Thu, 2011-09-29 at 16:26 -0700, Jeremy Fitzhardinge wrote:
>>>> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>>>
>>>> One big question which arises is whether the _early() function is
>>>> necessary at all.  All the stop_machine/mutex/etc stuff that
>>>> arch_jump_label_transform() ends up doing is redundant pre-SMP, but it
>>>> shouldn't hurt.  Maybe we can just drop the _early function?  It works
>>>> on x86, at least, because jump_label_enable() works, which uses the full
>>>> form.  And dropping it would reduce this to a very much smaller series.
>>> It does slow down the boot process, which is not a good thing when
>>> everyone is pushing for the fastest restarts.
>> Would it really though?  stop_machine() doesn't do very much when there
>> are no other cpus.
>>
>> Not that I measured or anything, but there was no obvious big lag at boot.
> Just bringing up the point, but without measurements, its all hand
> waving. It may not be a big deal, and simpler code is always better if
> it doesn't harm anything else.

I think the simplest thing is to make stop_machine() well-defined in a
pre-smp environment, where it just directly calls the callback:

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index ba5070c..b6ad9b3 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -485,6 +485,11 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
 					    .num_threads = num_online_cpus(),
 					    .active_cpus = cpus };
 
+	if (smdata.num_threads == 1) {
+		(*fn)(data);
+		return 0;
+	}
+
 	/* Set the initial state and stop all online cpus. */
 	set_state(&smdata, STOPMACHINE_PREPARE);
 	return stop_cpus(cpu_online_mask, stop_machine_cpu_stop, &smdata);

so that its guaranteed safe to use at any point.

    J
