Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750746Ab2BTFQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 00:16:47 -0500
Received: from claw.goop.org ([74.207.240.146]:35736 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878Ab2BTFQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 00:16:44 -0500
Message-ID: <4F41D72E.7000605@goop.org>
Date: Sun, 19 Feb 2012 21:16:30 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, John Stultz <johnstul@us.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 1/1] linux headers: header file(s) changes to enable spinlock
 use jumplabel
References: <20120217082527.15283.72980.sendpatchset@oc5400248562.ibm.com> <4F403268.7040804@goop.org> <20120219092456.GB10038@redhat.com>
In-Reply-To: <20120219092456.GB10038@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2012 01:24 AM, Gleb Natapov wrote:
> On Sat, Feb 18, 2012 at 03:21:12PM -0800, Jeremy Fitzhardinge wrote:
>> On 02/17/2012 12:25 AM, Raghavendra K T wrote:
>>> From:  Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>>>
>>> Changelog:
>>>   Reordering in header files and adding declarations to enable
>>>  spinlock header to use jump label technique.
>>>     
>>> Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
>>> ---
>>>  I was re-basing Jermey patches (https://lkml.org/lkml/2011/10/12/496), while working
>>> on paravirtualized ticket spinlock (3.3.-rc3).
>>>
>>> Currently <jump_label.h> includes <workqueue.h> (commit: b202952075f62603bea9bfb6ebc6b0420db11949)
>>>
>>>  So we get following error when we try to include jump_label.h from
>>> arch/x86/include/asm/spinlock.h because of cyclic dependency
>>> <spinlock.h> -> <jumplabe.h> -> <workque.h> -> ... <seqlock.h> -> <spinlock.h>
>> What about splitting the jump_label_key_deferred stuff into a separate
>> jump_label_deferred.h, and just include that where it's needed?
>>
> Andrew Jones did exactly that (CCed). But does pvlock have to use jump
> label? I looked at the code and it is used like paravirt patching. Meaning
> it is patched only once on a boot up when XEN is detected. May be use
> paravirt patching instead of jump label? What if jump label will want
> to use spinlock for some reason in the future (it uses mutex currently)?

The point of the pv ticketlocks is to avoid any pvop calls on the
lock/unlock fastpath, relegating them to only the slow path. 
Unfortunately, the pv unlock case can't be identical with the non-pv
unlock, and jump_labels are lighter weight and more efficient than pvops.

It doesn't matter if jump_labels start using spinlocks; all we need the
jump_label machinery to do is patch the jump sites in the code so that
one of two execution paths can be selected.  Since all the ticketlock
jump_label patching happens before SMP is enabled, there's no problem
with changing a lock while a cpu is executing the code.

    J
