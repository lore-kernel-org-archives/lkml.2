Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754883Ab2K2Orn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 09:47:43 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:46195 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab2K2Orl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 09:47:41 -0500
MIME-Version: 1.0
In-Reply-To: <20121129110717.GA9711@redhat.com>
References: <1353993325.14050.49.camel@ThinkPad-T5421.cn.ibm.com>
	<CAFTL4hx0fc_Jo8wkuRZedW4DVEeQceiHMrWVqTqB5k065Wsg8Q@mail.gmail.com>
	<1354090704.3054.13.camel@ThinkPad-T5421.cn.ibm.com>
	<CAFTL4hxPSp1fs4=2g0yFs0d5nFisfUsfDAA9bHWcu+-+tO_ySw@mail.gmail.com>
	<20121128135345.GG928@redhat.com>
	<CAFTL4hxoFBLNQCABBpJRBgV-r-Mg5GSq7HbPfWJRraSvtviz4A@mail.gmail.com>
	<20121129110717.GA9711@redhat.com>
Date: Thu, 29 Nov 2012 15:47:39 +0100
Message-ID: <CAFTL4hyHW3uJHvzxz1o4agtGbicFAP1DuUsifbOrp1Q3ODRBMA@mail.gmail.com>
Subject: Re: [RFC PATCH v2] Add rcu user eqs exception hooks for async page fault
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>,
        linux-next list <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com,
        sasha.levin@oracle.com, avi@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/29 Gleb Natapov <gleb@redhat.com>:
> On Wed, Nov 28, 2012 at 03:25:07PM +0100, Frederic Weisbecker wrote:
>> 2012/11/28 Gleb Natapov <gleb@redhat.com>:
>> > On Wed, Nov 28, 2012 at 01:55:42PM +0100, Frederic Weisbecker wrote:
>> >> Yes but if rcu_irq_*() calls are fine to be called there, and I
>> >> believe they are because exception_enter() exits the user mode, we
>> >> should start to protect there right now instead of waiting for a
>> >> potential future warning of illegal RCU use.
>> >>
>> > Async page not present is not much different from regular page fault
>> > exception when it happens not on idle task (regular #PF cannot happen
>> > on idle task), but code have a special handling for idle task. So why
>> > do you think rcu_irq_*() is required here, but not in page fault
>> > handler?
>>
>> Because we are not supposed to fault in idle, at least I hope there
>> are no case around. Except on cases like here with KVM I guess but we
>> have that special async handler for that.
>>
> As far as I understand rcu_irq_enter() should be called before entering
> the mode in which read-side critical sections can occur, but async page
> fault does not uses RCU in case of faulting in idle. Actually, looking
> closer, it may call kfree() if page ready notification arrives ahead
> of not present notification (with todays KVM it cannot happen) and we
> have to assume that kfree() uses rcu read even if it currently does not.
> So may be it is possible to move rcu_irq_*() calls to be around unlikely
> kfree() call only.

Please, let's protect kvm_async_pf_task_wait() entirely. This is less
complicated and we don't need to audit the code and its evolution. And
that is a complicated code enough already. We just need to do:

exception_enter();
rcu_irq_enter()
kvm_async_pf_task_wait() {
     rcu_irq_exit();
     native_safe_halt();
     rcu_irq_enter();
}
rcu_irq_exit()
exception_exit();

To me it looks like the safest and simplest solution.
rcu_irq_exit()
