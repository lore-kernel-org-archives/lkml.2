Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab0ISQi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 12:38:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:38750 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab0ISQiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 12:38:25 -0400
X-Authority-Analysis: v=1.1 cv=QPMnOuvfoRK4nyqTv0NRvva4Xk0fUUuJArrqv1I9dZo= c=1 sm=0 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=JbmLpqPY44Zk42c_IaYA:9 a=4RQkHHPpQfmaEGvsMLrA2JvZ034A:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: raw_spinlock_t rules
From: Steven Rostedt <rostedt@goodmis.org>
To: Avi Kivity <avi@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4C960B78.4010804@redhat.com>
References: <4C960B78.4010804@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sun, 19 Sep 2010 12:38:22 -0400
Message-ID: <1284914302.23787.2749.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-09-19 at 15:09 +0200, Avi Kivity wrote:
> Some time ago, the i8259 emulation code in kvm was changed to use 
> raw_spinlock_t, as it was called in a preempt_disable() and 
> local_irq_disable() context, which doesn't work with preemptible 
> spinlocks used with CONFIG_PREEMPT_RT.
> 
> In Linux 2.6.37, the spinlock will no longer be taken in these contexts, 
> so I'd like to change it to a normal spinlock_t.  However, it is still 
> taken in a spin_lock_irq() context.
> 
> Is it okay to do this change?  I figured since spin_lock_irq() is part 
> of the spinlock infrastructure it might to the right thing.
> 

In PREEMPT_RT all interrupts (besides the timer) is converted to a
thread. The spin_lock_irq() will not disable interrupts in PREEMPT_RT,
because it is not needed (irqs are threaded and wont cause a deadlock if
they share the same spin_locks).

Note, spin_locks used by the timer will must be raw_spin_lock(), and
threaded context must disable interrupts for real before using it.

-- Steve


