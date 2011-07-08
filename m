Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab1GHO7I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 10:59:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52417 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022Ab1GHO7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 10:59:05 -0400
Subject: Re: [PATCH 4/4] futex: warning corrections
From: Vitaliy Ivanov <vitalivanov@gmail.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>
In-Reply-To: <4E15F5BC.6050801@linux.intel.com>
References: <1309821688.4527.10.camel@vitaliy-Vostro-1400>
	 <4E1494A8.7070109@linux.intel.com>
	 <1309986669.27362.3.camel@vitaliy-Vostro-1400>
	 <4E14E1C6.1010202@linux.intel.com>
	 <CAGTPOqefJup5Nn0r3z+UYCh-dqPKz0cwDwL2znTRKzLuBSUtZQ@mail.gmail.com>
	 <4E15F5BC.6050801@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jul 2011 18:00:59 +0300
Message-ID: <1310137259.26209.65.camel@vivanov>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-07 at 11:06 -0700, Darren Hart wrote:
> 
> On 07/07/2011 05:39 AM, Vitaliy Ivanov wrote:
> >>> From 8eeaa5a97697bcc606aea23d32028aea7b271a96 Mon Sep 17 00:00:00 2001
> >>> From: Vitaliy Ivanov <vitalivanov@gmail.com>
> >>> Date: Thu, 7 Jul 2011 00:05:05 +0300
> >>> Subject: [PATCH] futex: uninitialized warning corrections
> >>> MIME-Version: 1.0
> >>> Content-Type: text/plain; charset=UTF-8
> >>> Content-Transfer-Encoding: 8bit
> >>>
> >>> kernel/futex.c: In function ‘fixup_pi_state_owner.clone.17’:
> >>> kernel/futex.c:1582:6: warning: ‘curval’ may be used uninitialized in this function
> >>> kernel/futex.c: In function ‘handle_futex_death’:
> >>> kernel/futex.c:2486:6: warning: ‘nval’ may be used uninitialized in this function
> >>> kernel/futex.c: In function ‘do_futex’:
> >>> kernel/futex.c:863:11: warning: ‘curval’ may be used uninitialized in this function
> >>> kernel/futex.c:828:6: note: ‘curval’ was declared here
> >>> kernel/futex.c:898:5: warning: ‘oldval’ may be used uninitialized in this function
> >>> kernel/futex.c:890:6: note: ‘oldval’ was declared here
> >>>
> >>> Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
> >>
> >> Please include a blurb in the commit message as to why you used
> >> uninitialized_var() rather than just assigning it. This will save people
> >> the time of wondering why, and me the time of nacking "it's simpler to
> >> just initialize to zero" patches :-)
> >>
> >> Acked-by: Darren Hart <dvhart@linux.intel.com>
> > 
> > Darren,
> > 
> > Thanks for your comments. I think the description is pretty obvious
> > here as I don't think any of these variables are affected by cmpxchg.
> 
> Not so. Consider the following:
> 
> 	u32 curval;
> 	if (cmpxchg_futex_value_locked(&curval, uaddr, uval, newval))
> 		ret = -EFAULT;
> 	else if (curval != uval)
> 		ret = -EINVAL;
> 
> the cmpxchg here assigns curval to newval if *uaddr==uval or to *uaddr
> otherwise. This is where curval gets assigned so that it can then be
> read in the following if block. gcc didn't recognize this as an
> assignment and is why it complained about it being used uninitialized.
> 
> 
> > There is simple assignment at the end. Seems like compiler simply
> > doesn't follow all the return cases.
> 
> No, the compiler complained about the test of the value, this doesn't
> have anything to do with the return cases.

Here is what we have:

------------
static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
				struct task_struct *newowner)
{
u32 curval;
...
retry:
	if (get_futex_value_locked(&uval, uaddr))
		goto handle_fault;

	while (1) {
		newval = (uval & FUTEX_OWNER_DIED) | newtid;

		if (cmpxchg_futex_value_locked(&curval, uaddr, uval, newval))
			goto handle_fault;
		if (curval == uval)
			break;
		uval = curval;
	}
...
}

------------
static int cmpxchg_futex_value_locked(u32 *curval, u32 __user *uaddr,
				      u32 uval, u32 newval)
{
	int ret;

	pagefault_disable();
	ret = futex_atomic_cmpxchg_inatomic(curval, uaddr, uval, newval);
	pagefault_enable();

	return ret;
}
------------

And for x86:

static inline int futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
						u32 oldval, u32 newval)
{
	int ret = 0;

#if defined(CONFIG_X86_32) && !defined(CONFIG_X86_BSWAP)
	/* Real i386 machines have no cmpxchg instruction */
	if (boot_cpu_data.x86 == 3)
		return -ENOSYS;
#endif

	if (!access_ok(VERIFY_WRITE, uaddr, sizeof(u32)))
		return -EFAULT;

	asm volatile("1:\t" LOCK_PREFIX "cmpxchgl %4, %2\n"
		     "2:\t.section .fixup, \"ax\"\n"
		     "3:\tmov     %3, %0\n"
		     "\tjmp     2b\n"
		     "\t.previous\n"
		     _ASM_EXTABLE(1b, 3b)
		     : "+r" (ret), "=a" (oldval), "+m" (*uaddr)
		     : "i" (-EFAULT), "r" (newval), "1" (oldval)
		     : "memory"
	);

	*uval = oldval;     <------------- uval is being changed here only. it's not modified by asm cmpxchgl.
	return ret;
}


Am I missing something?

- Vitaliy

