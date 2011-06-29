Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab1F2MoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 08:44:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51447 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab1F2MoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 08:44:03 -0400
X-Authority-Analysis: v=1.1 cv=PfPQ8rIoTcZsncbPZjVSZ7K0hy8Zc4hmL68r4VPNpKE= c=1 sm=0 a=dHgNFd9a5uoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=20KFwNOVAAAA:8 a=wa7e3sRTIgCxvZWIyXkA:9 a=P7GzIOBTSWTW-Ys6ffwA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 1/2] mm: Remove use of ALLOW_RETRY when RETRY_NOWAIT is
 set
From: Steven Rostedt <rostedt@goodmis.org>
To: Michel Lespinasse <walken@google.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
In-Reply-To: <CANN689E0ckbGBZZfk-BMdyR=_E6eN2oQb5uhij3ARPVCicqGrQ@mail.gmail.com>
References: <20110628164750.281686775@goodmis.org>
	 <20110628165302.706740714@goodmis.org>
	 <CANN689E0ckbGBZZfk-BMdyR=_E6eN2oQb5uhij3ARPVCicqGrQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 29 Jun 2011 08:43:59 -0400
Message-ID: <1309351439.26417.30.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 02:38 -0700, Michel Lespinasse wrote:
> On Tue, Jun 28, 2011 at 9:47 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> >
> > The only user of FAULT_FLAG_RETRY_NOWAIT also sets the
> > FAULT_FLAG_ALLOW_RETRY flag. This makes the check in the
> > __lock_page_or_retry redundant as it checks the RETRY_NOWAIT
> > just after checking ALLOW_RETRY and then returns if it is
> > set.  The FAULT_FLAG_ALLOW_RETRY does not make any other
> > difference in this path.
> >
> > Setting both and then ignoring one is quite confusing,
> > especially since this code has very subtle locking issues
> > when it comes to the mmap_sem.
> >
> > Only set the RETRY_WAIT flag and have that do the necessary
> > work instead of confusing reviewers of this code by setting
> > ALLOW_RETRY and not releasing the mmap_sem.
> >
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -151,8 +151,8 @@ extern pgprot_t protection_map[16];
> >  #define FAULT_FLAG_WRITE       0x01    /* Fault was a write access */
> >  #define FAULT_FLAG_NONLINEAR   0x02    /* Fault was via a nonlinear mapping */
> >  #define FAULT_FLAG_MKWRITE     0x04    /* Fault was mkwrite of existing pte */
> > -#define FAULT_FLAG_ALLOW_RETRY 0x08    /* Retry fault if blocking */
> > -#define FAULT_FLAG_RETRY_NOWAIT        0x10    /* Don't drop mmap_sem and wait when retrying */
> > +#define FAULT_FLAG_ALLOW_RETRY 0x08    /* Retry fault if blocking (drops mmap_sem) */
> > +#define FAULT_FLAG_RETRY_NOWAIT        0x10    /* Wait when retrying (don't drop mmap_sem) */
> 
> You want to say "DONT wait when retrying" here...

Yeah, I thought that was weird in the comment. Heh, rereading the
original comment I see it meant "don't drop nor wait" where I thought it
meant "Don't drop mmap_sem and then wait when retrying". That needs to
be fixed :)

> 
> Also - you argued higher up that having both flags set at once is
> confusing, but I find it equally confusing to pass a flag to specify
> you don't want to wait on retry if the flag that allows retry is not
> set.

Hmm, I understand. The main issue I have with all these flags is the
locking. I really don't care about the semantics for retry and such.
What I care about is this dropping of the mmap_sem. It is very confusing
to understand when it is dropped or not.


>  I think the confusion comes from the way the nowait semantics got
> bolted on the retry code for virtualization, even though (if I
> understand the virtualization use case correctly) they dont actually
> want to retry there, they just want to give up without blocking.

Right.

> 
> 
> Would the following proposal make more sense to you ?
> 
> FAULT_FLAG_ALLOW_ASYNC: allow returning a VM_FAULT_ASYNC error code if
> the page can't be obtained immediately (major fault).
> FAULT_FLAG_ASYNC_WAIT: before returning VM_FAULT_ASYNC, drop the
> mmap_sem and wait for major fault to complete.

Ug, I think that's worse. ASYNC to me is something that you enable and
it will get back to you when done. Think AIO.

How about...

FAULT_FLAG_ALLOW_DROP_MMAP_SEM ?

and it returns VM_FAULT_DROPPED_MMAP_SEM if it drops it.

We could also have another flag:

FAULT_FLAG_NOWAIT_ON_PAGE

and it can return VM_FAULT_NOWAIT_PAGE if it failed to get the page lock
and returned.

This to me documents exactly what is happening, and doesn't confuse
kernel developers when they see handle_mm_fault() called, and then the
code not releasing the mmap_sem.

If I saw in arch/x86/mm/fault.c:

		if (fault & VM_FAULT_DROPPED_MMAP_SEM) {
			/* Clear FAULT_FLAG_ALLOW_DROPPED_MMAP_SEM to avoid any risk
			 * of starvation. */
			flags &= ~FAULT_FLAG_ALLOW_DROPPED_MMAP_SEM;
			goto retry;
		}

There would have never been this confusion about why we are doing:

retry:
		down_read(&mm->mmap_sem);


Without ever doing a up_read(&mm->mmap_sem);

> 
> existing uses of FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_RETRY_NOWAIT
> become FAULT_FLAG_ASYNC
> existing uses of FAULT_FLAG_ALLOW_RETRY alone become FAULT_FLAG_ASYNC
> | FAULT_FLAG_ASYNC_WAIT
> existing uses of VM_FAULT_RETRY become VM_FAULT_ASYNC
> 
> This may also help your documentation proposal since the flags would
> now work together rather than having one be an exception to the other.

I'm thinking they should still be separate. Just because they do things
differently with the mmap_sem.

-- Steve


