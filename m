Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab1JYOzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 10:55:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243Ab1JYOzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 10:55:48 -0400
Date: Tue, 25 Oct 2011 10:54:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: holzheu@linux.vnet.ibm.com,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: kdump: crash_kexec()-smp_send_stop() race in panic
Message-ID: <20111025145440.GF23292@redhat.com>
References: <1319468137.3615.16.camel@br98xy6r>
 <m1ipneifqv.fsf@fess.ebiederm.org>
 <CAM_iQpVktWsgOFCWoT47dQ1YdSTnnbTZAAKNYEEX=5wWzhHMzg@mail.gmail.com>
 <m1aa8qfhdk.fsf@fess.ebiederm.org>
 <1319532245.3056.5.camel@br98xy6r>
 <m17h3tcm52.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m17h3tcm52.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 05:04:57AM -0700, Eric W. Biederman wrote:
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
> 

I guess having printk() from from both the panics would be nice.

> We really only need the mutual exclusion starting just before
> smp_send_stop so that is where I would be inclined to put it.
> 

How about something just before crash_kexec()? I think there is not
much point two cpus trying to execute crash_kexec() together.

Thanks
Vivek


> But yeah something like the below should work.
> 
> Eric
> 
> 
> > ---
> >  kernel/panic.c |    7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > --- a/kernel/panic.c
> > +++ b/kernel/panic.c
> > @@ -59,6 +59,7 @@ EXPORT_SYMBOL(panic_blink);
> >   */
> >  NORET_TYPE void panic(const char * fmt, ...)
> >  {
> > +	static DEFINE_SPINLOCK(panic_lock);
> >  	static char buf[1024];
> >  	va_list args;
> >  	long i, i_next = 0;
> > @@ -68,8 +69,12 @@ NORET_TYPE void panic(const char * fmt,
> >  	 * It's possible to come here directly from a panic-assertion and
> >  	 * not have preempt disabled. Some functions called from here want
> >  	 * preempt to be disabled. No point enabling it later though...
> > +	 *
> > +	 * Only one CPU is allowed to execute the panic code. For multiple
> > +	 * parallel invocations of panic all other CPUs will wait on the
> > +	 * panic_lock. They are stopped afterwards by smp_send_stop().
> >  	 */
> > -	preempt_disable();
> > +	spin_lock(&panic_lock);
> >  
> >  	console_verbose();
> >  	bust_spinlocks(1);
