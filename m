Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620Ab1JYO6Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 10:58:24 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:39580 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1JYO6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 10:58:23 -0400
Message-ID: <1319554699.3056.11.camel@br98xy6r>
Subject: Re: kdump: crash_kexec()-smp_send_stop() race in panic
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, akpm@linux-foundation.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 25 Oct 2011 16:58:19 +0200
In-Reply-To: <m17h3tcm52.fsf@fess.ebiederm.org>
References: <1319468137.3615.16.camel@br98xy6r>
	 <m1ipneifqv.fsf@fess.ebiederm.org>
	 <CAM_iQpVktWsgOFCWoT47dQ1YdSTnnbTZAAKNYEEX=5wWzhHMzg@mail.gmail.com>
	 <m1aa8qfhdk.fsf@fess.ebiederm.org> <1319532245.3056.5.camel@br98xy6r>
	 <m17h3tcm52.fsf@fess.ebiederm.org>
Organization: IBM
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-25 at 05:04 -0700, Eric W. Biederman wrote:
> Michael Holzheu <holzheu@linux.vnet.ibm.com> writes:
> 
> > Hello Eric,
> >
> > On Mon, 2011-10-24 at 10:07 -0700, Eric W. Biederman wrote:
> >
> > [snip]
> >
> >> So my second thought is to introduce another atomic variable
> >> panic_in_progress, visible only in panic.  The cpu that sets
> >> increments panic_in_progress can call smp_send_stop.  The rest of
> >> the cpus can just go into a busy wait.  That should stop nasty
> >> fights about who is going to come out of smp_send_stop first.
> >
> > So this is a spinlock, no? What about the following patch:
> Do we want both panic printks?

Ok, good point. We proably should not change that.

> We really only need the mutual exclusion starting just before
> smp_send_stop so that is where I would be inclined to put it.

I think to fix the race, at least we have the get the lock before we
call crash_kexec(). 

Is the following patch ok for you?
---
 kernel/panic.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -59,6 +59,7 @@ EXPORT_SYMBOL(panic_blink);
  */
 NORET_TYPE void panic(const char * fmt, ...)
 {
+	static DEFINE_SPINLOCK(panic_lock);
 	static char buf[1024];
 	va_list args;
 	long i, i_next = 0;
@@ -82,6 +83,13 @@ NORET_TYPE void panic(const char * fmt,
 #endif
 
 	/*
+	 * Only one CPU is allowed to execute the panic code from here. For
+	 * multiple parallel invocations of panic all other CPUs will wait on
+	 * the panic_lock. They are stopped afterwards by smp_send_stop().
+	 */
+	spin_lock(&panic_lock);
+
+	/*
 	 * If we have crashed and we have a crash kernel loaded let it handle
 	 * everything else.
 	 * Do we want to call this before we try to display a message?


