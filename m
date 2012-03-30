Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924Ab2C3FGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 01:06:31 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:52809 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab2C3FGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 01:06:25 -0400
Date: Thu, 29 Mar 2012 22:05:44 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>, spender@grsecurity.net,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-doc@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>, Darren Hart <dvhart@linux.intel.com>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Linux Containers <containers@lists.linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Gene Cooperman <gene@ccs.neu.edu>
Subject: Re: [PATCH v2] futex: mark get_robust_list as deprecated
Message-ID: <20120330050544.GA32299@count0.beaverton.ibm.com>
References: <20120323190855.GA27213@www.outflux.net>
 <m1fwczvuph.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1fwczvuph.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12033005-6148-0000-0000-000004A8EE0D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 03:06:02PM -0700, Eric W. Biederman wrote:
> Kees Cook <keescook@chromium.org> writes:
> 
> > Notify get_robust_list users that the syscall is going away.
> 
> Has anyone asked the question if the folks working on checkpoint/restart
> are going to need this.
> 
> This seems like important information to know if you want to checkpoint
> a process.

I have no idea if the CRIU and DMTCP folks care about this. I've added
some folks related to those projects to the Cc list.

> 
> Eric
> 
> > Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> > v2:
> >  - add note to feature-removal-schedule.txt.
> > ---
> >  Documentation/feature-removal-schedule.txt |   10 ++++++++++
> >  kernel/futex.c                             |    2 ++
> >  kernel/futex_compat.c                      |    2 ++
> >  3 files changed, 14 insertions(+), 0 deletions(-)
> >
> > diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> > index 4bfd982..e3bf119 100644
> > --- a/Documentation/feature-removal-schedule.txt
> > +++ b/Documentation/feature-removal-schedule.txt
> > @@ -543,3 +543,13 @@ When:	3.5
> >  Why:	The old kmap_atomic() with two arguments is deprecated, we only
> >  	keep it for backward compatibility for few cycles and then drop it.
> >  Who:	Cong Wang <amwang@redhat.com>
> > +
> > +----------------------------
> > +
> > +What:	get_robust_list syscall
> > +When:	2013
> > +Why:	There appear to be no production users of the get_robust_list syscall,
> > +	and it runs the risk of leaking address locations, allowing the bypass
> > +	of ASLR. It was only ever intended for debugging, so it should be
> > +	removed.

So I've looked in glibc, gdb, and DMTCP. The description of the intended
use of get_robust_list() is accurate. However the benefit of ASLR is
less clear when it comes to the robust list. In glibc the robust list is
only used from NPTL. The robust list head is in struct pthread which can be
obtained from pthread_self() anyway. Thus I think ASLR doesn't really help
obfuscate the robust futex list unless the program is using robust futexes
without the aid of glibc.

Cheers,
	-Matt Helsley

