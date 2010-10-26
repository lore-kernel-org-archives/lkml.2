Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab0JZIHg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 04:07:36 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:38860 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab0JZIHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 04:07:33 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Subject: Re: mem-hotplug + ksm make lockdep warning
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
In-Reply-To: <alpine.LSU.2.00.1010252248210.2939@sister.anvils>
References: <20101025193711.917F.A69D9226@jp.fujitsu.com> <alpine.LSU.2.00.1010252248210.2939@sister.anvils>
Message-Id: <20101026163218.B7BF.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 26 Oct 2010 17:07:29 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 25 Oct 2010, KOSAKI Motohiro wrote:
> > Hi Hugh,
> > 
> > commit 62b61f611e(ksm: memory hotremove migration only) makes following
> > lockdep warnings. Is this intentional?
> 
> No, certainly not intentional: thanks for finding this.  Looking back,
> I think the machine I tested memory hotplug versus KSM upon was not
> the machine I habitually ran lockdep on, I bet I forgot to try it.
> 
> > 
> > More detail: current lockdep hieralcy is here.
> 
> And especial thanks for taking the trouble to present it in a way
> that I find much easier to understand than lockdep's pronouncements.
> 
> > 
> > memory_notify
> > 	offline_pages
> > 		lock_system_sleep();
> > 			mutex_lock(&pm_mutex);
> > 		memory_notify(MEM_GOING_OFFLINE)
> > 			__blocking_notifier_call_chain
> > 				down_read(memory_chain.rwsem)
> > 				ksm_memory_callback()
> > 					mutex_lock(&ksm_thread_mutex);  // memory_chain.rmsem -> ksm_thread_mutex order
> > 				up_read(memory_chain.rwsem)
> > 		memory_notify(MEM_OFFLINE)
> > 			__blocking_notifier_call_chain
> > 				down_read(memory_chain.rwsem)		// ksm_thread_mutex -> memory_chain.rmsem order
> > 				ksm_memory_callback()
> > 					mutex_unlock(&ksm_thread_mutex);
> > 				up_read(memory_chain.rwsem)
> > 		unlock_system_sleep();
> > 			mutex_unlock(&pm_mutex);
> > 
> > So, I think pm_mutex protect ABBA deadlock. but it exist only when
> > CONFIG_HIBERNATION=y. IOW, this code is not correct generically. Am I
> > missing something?
> 
> I do remember taking great comfort from lock_system_sleep() i.e. pm_mutex
> when I did the ksm_memory_callback(); but I think that comfort was more
> along the lines of it making obvious that taking a mutex was okay there,
> than it providing any safety.  I think I was unconscious of the issue you
> raise, perhaps didn't even notice rwsem in __blocking_notifier_call_chain.
> 
> But is it really a problem, given that it's down_read(rwsem) in each case?
> Yes, but I had to look up akpm's comment on msync in ChangeLog-2.6.11 to
> remember why:
> 
> 	And yes, the ranking of down_read() versus down() does matter:
> 	
> 		Task A			Task B		Task C
> 	
> 		down_read(rwsem)
> 					down(sem)
> 							down_write(rwsem)
> 		down(sem)
> 					down_read(rwsem)
> 	
> 	C's down_write() will cause B's down_read to block.
> 	B holds `sem', so A will never release `rwsem'.

Yeah, in other word, my raised issue is neccessary following three actor.

A. do memory unplug
B. ditto
C. register new blocking notifier chain

Thus, I don't think this issue is occur so frquently. (Who want to unplug memory
concurrently?) But even though, some arch don't have hibernation support at all
and we need to fix it, maybe.


> 
> Am I mistaken, or is get_any_page() in mm/memory-failure.c also relying
> on lock_system_sleep() to do real locking, even without CONFIG_HIBERNATION?

I think get_any_page() also need to fix. ;)
Andi, please double check.

> If it is, then I think we should solve both problems by making it lock
> unconditionally: though neither "lock_system_sleep" nor "pm_mutex" is an
> appropriate name then... maybe "lock_memory_hotplug", but still using a
> pm_mutex declared outside of CONFIG_PM?  Seems a bit weird.

I agree with making lock_memory_hotplug.

> And some kind of lockdep annotation needed for ksm_memory_callback(),
> to help it understand how the outer mutex makes the inner inversion safe?
> Or does lockdep manage that without help?

I don't know lockdep internal at all. I can only say CONFIG_HIBERNATION=y
still makes this lockdep splat. iow, lockdep can't handle this inner 
inversion safe issue automatically.



> I think I'm not going to find time to do the patch for a while,
> so please go ahead if you can.

I also need to attend KS. So, If you can accept to waiting until middle of 
next month, I'll do.

Thanks.


