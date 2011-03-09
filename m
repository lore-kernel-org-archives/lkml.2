Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab1CIPIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 10:08:42 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:53243 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab1CIPIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 10:08:40 -0500
Date: Wed, 9 Mar 2011 16:08:39 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Michel Lespinasse <walken@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Darren Hart <darren@dvhart.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        David Howells <dhowells@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Michal Simek <monstr@monstr.eu>, Ralf Baechle <ralf@linux-mips.org>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] futex: cmpxchg_futex_value_locked API change
Message-ID: <20110309160839.283e241a@mschwide.boeblingen.de.ibm.com>
In-Reply-To: <20110309112550.GA3050@google.com>
References: <20110307021127.GB31188@google.com>
	<alpine.LFD.2.00.1103082114270.2787@localhost6.localdomain6>
	<20110309112550.GA3050@google.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Mar 2011 03:25:50 -0800
Michel Lespinasse <walken@google.com> wrote:

> On Tue, Mar 08, 2011 at 09:17:11PM +0100, Thomas Gleixner wrote:
> > On Sun, 6 Mar 2011, Michel Lespinasse wrote:
> > > The cmpxchg_futex_value_locked API was funny in that it returned either
> > > the original, user-exposed futex value OR an error code such as -EFAULT.
> > > This was confusing at best, and could be a source of livelocks in places
> > > that retry the cmpxchg_futex_value_locked after trying to fix the issue
> > > by running fault_in_user_writeable().
> > > 
> > > This change makes the cmpxchg_futex_value_locked API more similar to the
> > > get_futex_value_locked one, returning an error code and updating the
> > > original value through a reference argument.
> > 
> > Ack.
> > 
> > >  static inline int
> > > -futex_atomic_cmpxchg_inatomic(int __user *uaddr, int oldval, int newval)
> > > +futex_atomic_cmpxchg_inatomic(int *uval, int __user *uaddr,
> > > +			      int oldval, int newval)
> > 
> > Can we please change the arguments to u32 while at it? The futex core
> > code uses u32 all over the place so those inlines should do the same.
> 
> All right. Attaching updated version of the diff. I also fixed the s390
> issue reported by Martin Schwidefsky.

The inline assmeblies look good now but I get this compile error on s390:

  CC      arch/s390/lib/uaccess_pt.o
arch/s390/lib/uaccess_pt.c:373: error: conflicting types for 'futex_atomic_cmpxchg_pt'
arch/s390/lib/uaccess.h:21: note: previous declaration of 'futex_atomic_cmpxchg_pt' was here
arch/s390/lib/uaccess_pt.c:403: warning: initialization from incompatible pointer type
make[1]: *** [arch/s390/lib/uaccess_pt.o] Error 1

The trouble is this part of the patch:

-int futex_atomic_cmpxchg_pt(int __user *uaddr, int oldval, int newval)
+int futex_atomic_cmpxchg_pt(int *uval, int __user *uaddr,
+                           int oldval, int newval)

You need to change these "int"s to "u32"s.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

