Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949Ab1ILOX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:23:28 -0400
Received: from mail-ey0-f175.google.com ([209.85.215.175]:48282 "EHLO
	mail-ey0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012Ab1ILOX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:23:27 -0400
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Sep 2011 10:23:27 EDT
Date: Mon, 12 Sep 2011 10:15:20 -0400
From: Benjamin Poirier <benjamin.poirier@gmail.com>
To: David Howells <dhowells@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Documentation/memory-barriers.txt
Message-ID: <20110912141520.GA18647@synalogic.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David, Paul,

Thank you for this great piece on memory barriers. I think it made a
complex topic approachable. I have two questions:
1)
I had a hard time understanding the second part of the example in the
section "Sleep and wake-up functions".

> 	set_current_state(TASK_INTERRUPTIBLE);
> 	if (event_indicated)
> 		break;
> 	__set_current_state(TASK_RUNNING);
> 	do_something(my_data);

I understand the need for memory barriers, but I don't understand what
the code is trying to achieve.
Where are the for (;;) loop and the schedule() call gone to?

> 	set_current_state(TASK_INTERRUPTIBLE);
> 	if (event_indicated) {
> 		smp_rmb();
> 		do_something(my_data);
> 	}

Isn't a break; missing here? How come do_something() has moved inside
the condition?

I'm thinking these final example code bits should look like this
(without and with the smp_rmb), no?:

for (;;) {
	set_current_state(TASK_INTERRUPTIBLE);
	if (event_indicated) {
		smp_rmb();
		do_something(my_data);
		break;
	}
	schedule();
}
__set_current_state(TASK_RUNNING);

2)
On a more general note, why is there a read_barrier_depends() but not a
write_barrier_depends()?

l=7
"write_barrier_depends()"
g=&l

---

l=g
read_barrier_depends()
t=*l

Most processors do not reorder dependent loads but do reorder loads
after loads. I'm guessing there's no processor that does not reorder
dependent stores but that does reorder stores after stores. So there's
no point in having write_barrier_depends(), it would always be defined
to wmb()?

Thanks,
-Ben
