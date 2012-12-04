Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab2LDVQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 16:16:22 -0500
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:54600 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab2LDVQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 16:16:19 -0500
Message-ID: <50BE67C4.3040305@linux.vnet.ibm.com>
Date: Wed, 05 Dec 2012 02:44:44 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, sbw@mit.edu,
        amit.kucheria@linaro.org, rostedt@goodmis.org, rjw@sisk.pl,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 01/10] CPU hotplug: Introduce "stable" cpu online
 mask, for atomic hotplug readers
References: <20121204085149.25919.29920.stgit@srivatsabhat.in.ibm.com> <20121204085324.25919.53090.stgit@srivatsabhat.in.ibm.com> <20121204151734.GB3885@mtj.dyndns.org>
In-Reply-To: <20121204151734.GB3885@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120421-2000-0000-0000-00000A2166F9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 12/04/2012 08:47 PM, Tejun Heo wrote:
> Hello, Srivatsa.
> 
> On Tue, Dec 04, 2012 at 02:23:41PM +0530, Srivatsa S. Bhat wrote:
>>  extern const struct cpumask *const cpu_possible_mask;
>>  extern const struct cpumask *const cpu_online_mask;
>> +extern const struct cpumask *const cpu_online_stable_mask;
>>  extern const struct cpumask *const cpu_present_mask;
>>  extern const struct cpumask *const cpu_active_mask;
> 
> This is a bit nasty.  The distinction between cpu_online_mask and the
> stable one is quite subtle and there's no mechanism to verify the
> right one is in use.  IIUC, the only time cpu_online_mask and
> cpu_online_stable_mask can deviate is during the final stage CPU take
> down, right?

No, actually they deviate in the initial stage itself. We flip the bit
in the stable mask right in the beginning, and then flip the bit in the
online mask slightly later, in __cpu_disable().

...which makes it look stupid to have a separate "stable" mask in the
first place! Hmm...

Thinking in this direction a bit more, I have written a patchset that
doesn't need a separate stable mask, but which works with the existing
cpu_online_mask itself. I'll post it tomorrow after testing and updating
the patch descriptions.

One of the things I'm trying to achieve is to identify 2 types of
hotplug readers: 

1. Readers who care only about synchronizing with the updates to
cpu_online_mask (light-weight readers)

2. Readers who really want full synchronization with the entire CPU
tear-down sequence.

The reason for doing this, instead of assuming every reader to be of
type 2 is that, if we don't make this distinction, we can end up in the
very same latency issues and performance problems that we hit when
using stop_machine(), without even using stop_machine()!

[The readers can be in very hot paths, like interrupt handlers. So if
there is no distinction between light-weight readers and full-readers,
we can potentially slow down the entire machine unnecessarily, effectively
creating the same effect as stop_machine()]

IOW, IMHO, one of the goals of the replacement to stop_machine() should
be that it should not indirectly induce the "stop_machine() effect".

The new patchset that I have written takes care of this requirement
and provides APIs for both types of readers, and also doesn't use
any extra cpu masks. I'll post this patchset tomorrow, after taking a
careful look at it again.

Regards,
Srivatsa S. Bhat

