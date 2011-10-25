Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab1JYP2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 11:28:48 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:41814 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab1JYP2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 11:28:47 -0400
Message-ID: <1319556523.3056.16.camel@br98xy6r>
Subject: Re: kdump: crash_kexec()-smp_send_stop() race in panic
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>
Date: Tue, 25 Oct 2011 17:28:43 +0200
In-Reply-To: <20111025150830.GG23292@redhat.com>
References: <1319468137.3615.16.camel@br98xy6r>
	 <m1ipneifqv.fsf@fess.ebiederm.org>
	 <CAM_iQpVktWsgOFCWoT47dQ1YdSTnnbTZAAKNYEEX=5wWzhHMzg@mail.gmail.com>
	 <m1aa8qfhdk.fsf@fess.ebiederm.org> <1319532245.3056.5.camel@br98xy6r>
	 <m17h3tcm52.fsf@fess.ebiederm.org> <1319554699.3056.11.camel@br98xy6r>
	 <20111025150830.GG23292@redhat.com>
Organization: IBM
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-25 at 11:08 -0400, Vivek Goyal wrote:
> On Tue, Oct 25, 2011 at 04:58:19PM +0200, Michael Holzheu wrote:
> > On Tue, 2011-10-25 at 05:04 -0700, Eric W. Biederman wrote:
> > > Michael Holzheu <holzheu@linux.vnet.ibm.com> writes:
[snip]
> > 
> > Is the following patch ok for you?
> > ---
> >  kernel/panic.c |    8 ++++++++
> >  1 file changed, 8 insertions(+)
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
> > @@ -82,6 +83,13 @@ NORET_TYPE void panic(const char * fmt,
> >  #endif
> >  
> >  	/*
> > +	 * Only one CPU is allowed to execute the panic code from here. For
> > +	 * multiple parallel invocations of panic all other CPUs will wait on
> > +	 * the panic_lock. They are stopped afterwards by smp_send_stop().
> > +	 */
> > +	spin_lock(&panic_lock);
> 
> Why leave irqs enabled?
>
> Atleast for x86, Don Zickus had a patch to use NMI in smp_send_stop(). So
> that should work even if interrupts are disabled. (I think that patch is
> not merged yet).
> 
> So are other architectures a concern? If yes, then may be in future we
> can make it an arch call which can also choose to disable interrupts.

For s390 we could disable the interrupts here. smp_send_stop() works
also when IRQs are disabled. But as you said - who knows if that is true
on all architectures...

Michael

