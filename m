Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab2GDAV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 20:21:26 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:59870 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab2GDAVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 20:21:22 -0400
Message-ID: <4FF38C2A.9080301@us.ibm.com>
Date: Tue, 03 Jul 2012 17:19:54 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/3][RFC] Potential fix for leapsecond caused futex issue
 (v3)
References: <1341281766-22722-1-git-send-email-johnstul@us.ibm.com> <4FF28CB1.7020304@us.ibm.com> <4FF30F48.3030702@redhat.com>
In-Reply-To: <4FF30F48.3030702@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12070400-4242-0000-0000-0000023522E0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03/2012 08:27 AM, Prarit Bhargava wrote:
> Thanks John -- I moved to using this for testing and hit the following
> softlockup when running latest + your patchset:
>
> [ 1084.433362] BUG: soft lockup - CPU#17 stuck for 22s! [leap-a-day:1275]^M
[snip]
> [ 1084.531860] RIP: 0010:[<ffffffff810b3d57>]  [<ffffffff810b3d57>]
> smp_call_function_many+0x1f7/0x260^M
[snip]
> [ 1084.663723] Call Trace:^M
> [ 1084.666466]  [<ffffffff8107e960>] ? hrtimer_wakeup+0x30/0x30^M
> [ 1084.672784]  [<ffffffff8107e960>] ? hrtimer_wakeup+0x30/0x30^M
> [ 1084.679107]  [<ffffffff810b3f12>] smp_call_function+0x22/0x30^M
> [ 1084.685530]  [<ffffffff810b3f78>] on_each_cpu+0x28/0x70^M
> [ 1084.691371]  [<ffffffff8107ec1c>] do_clock_was_set+0x1c/0x30^M
> [ 1084.697691]  [<ffffffff8107f005>] clock_was_set+0x55/0x60^M
> [ 1084.703732]  [<ffffffff810a6a23>] do_settimeofday+0xd3/0xe0^M
> [ 1084.709971]  [<ffffffff8105f4e5>] do_sys_settimeofday+0xb5/0x110^M
> [ 1084.716677]  [<ffffffff8105f5c3>] sys_settimeofday+0x83/0xb0^M
> [ 1084.723012]  [<ffffffff8160f129>] system_call_fastpath+0x16/0x1b^M
> [ 1084.729782] Code: f7 ff 15 95 89 b6 00 80 7d bf 00 0f 84 9c fe ff ff 41 f6 47
> 20 01 0f 84 91 fe ff ff 0f 1f 84 00 00 00 00 00 f3 90 41 f6 47 20 01 <75> f7 e9
> 7b fe ff ff 66 90 4c 89 e2 4c 89 ee 89 df e8 53 8b 21 ^M
>
> I'm taking a look now ... I'm not sure I believe the hrtimer_wakeup() calls on
> the stack.
I worked with Prarit and Thomas today to try to chase this down.

Prarit was also seeing "BUG at kernel/timer.c:1091!" problems, and once 
he sent me his config I was able to reproduce the problem. Thomas 
suggested enabling debugobjects and that quickly pointed out the 
think-o: I had mistook __hrtimer_init() as the hrtimer subsystem 
initialization, rather then what gets to initialize every hrtimer. So 
when in my patch I initialized the clock_was_set_timer there, we end up 
potentially re-initializing that timer while it is enqueued, which can 
cause the cpu its enqueued on to lockup with irqs off, which then gums 
up the smp_call_function().

The obvious fix is to initialize the clock_was_set_timer when we define it.

Thanks for Prarit for testing and noticing the problem and Thomas for 
suggesting how to isolate it!

I'm going to continue testing for a bit longer and then will send out 
the revised patchset. Hopefully I can collect some acks tomorrow and 
hopefully try to get it merged later Thursday  (I'd like for Prarit to 
get a chance to test the patch thurs before pushing it).

thanks
-john

