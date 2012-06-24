Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab2FXIhb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 04:37:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56218 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab2FXIh3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 04:37:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120623174830.GA5617@localhost>
References: <20120623101251.GA10162@localhost>
	<20120623170147.GI2516@linux.vnet.ibm.com>
	<20120623174830.GA5617@localhost>
Date: Sun, 24 Jun 2012 16:37:28 +0800
Message-ID: <CAM_iQpW-vtnHUOBoROueui-FCrw9zB4U3vwy=PnEOLXP713WWw@mail.gmail.com>
Subject: Re: BUG: tracer_alloc_buffers returned with preemption imbalance
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2012 at 1:48 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>> >  static inline int rcu_blocking_is_gp(void)
>> >  {
>> >         might_sleep();  /* Check for RCU read-side critical section. */
>> > +       preempt_disable();
>> >         return num_online_cpus() <= 1;
>> > +       preempt_enable();
>> >  }
>>
>> Thank you!  I have no idea how a preempt_disable() causes that badness
>> to happen, but this commit is not yet critically important, so I will
>> drop it.
>
> preempt_enable() becomes dead code because of the return statement?
> I wonder why gcc didn't issue a warning (or I failed to catch it)...
>

gcc has an option -Wunreachable-code, but we don't enable it
when building kernel, nor it will be enabled with -Wall. If we enable it,
we will have many false-positives as we have lots of debugging code
which is not reachable unless we enable some debugging option.

However, when I test it manually with the following code:

~% cat /tmp/unreachable.c
int main(void)
{
	int a = 0;
	a++;
	return ++a;
	a++;
}
~% gcc -Wunreachable-code -O0 -c /tmp/unreachable.c

gcc still doesn't give me any warning for the last line of the code,
gcc optimizes it out silently, I am wondering if this is a gcc bug.
