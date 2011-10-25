Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab1JYPIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 11:08:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243Ab1JYPIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 11:08:50 -0400
Date: Tue, 25 Oct 2011 11:08:30 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>
Subject: Re: kdump: crash_kexec()-smp_send_stop() race in panic
Message-ID: <20111025150830.GG23292@redhat.com>
References: <1319468137.3615.16.camel@br98xy6r>
 <m1ipneifqv.fsf@fess.ebiederm.org>
 <CAM_iQpVktWsgOFCWoT47dQ1YdSTnnbTZAAKNYEEX=5wWzhHMzg@mail.gmail.com>
 <m1aa8qfhdk.fsf@fess.ebiederm.org>
 <1319532245.3056.5.camel@br98xy6r>
 <m17h3tcm52.fsf@fess.ebiederm.org>
 <1319554699.3056.11.camel@br98xy6r>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319554699.3056.11.camel@br98xy6r>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 04:58:19PM +0200, Michael Holzheu wrote:
> On Tue, 2011-10-25 at 05:04 -0700, Eric W. Biederman wrote:
> > Michael Holzheu <holzheu@linux.vnet.ibm.com> writes:
> > 
> > > Hello Eric,
> > >
> > > On Mon, 2011-10-24 at 10:07 -0700, Eric W. Biederman wrote:
> > >
> > > [snip]
> > >
> > >> So my second thought is to introduce another atomic variable
> > >> panic_in_progress, visible only in panic.  The cpu that sets
> > >> increments panic_in_progress can call smp_send_stop.  The rest of
> > >> the cpus can just go into a busy wait.  That should stop nasty
> > >> fights about who is going to come out of smp_send_stop first.
> > >
> > > So this is a spinlock, no? What about the following patch:
> > Do we want both panic printks?
> 
> Ok, good point. We proably should not change that.
> 
> > We really only need the mutual exclusion starting just before
> > smp_send_stop so that is where I would be inclined to put it.
> 
> I think to fix the race, at least we have the get the lock before we
> call crash_kexec(). 
> 
> Is the following patch ok for you?
> ---
>  kernel/panic.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -59,6 +59,7 @@ EXPORT_SYMBOL(panic_blink);
>   */
>  NORET_TYPE void panic(const char * fmt, ...)
>  {
> +	static DEFINE_SPINLOCK(panic_lock);
>  	static char buf[1024];
>  	va_list args;
>  	long i, i_next = 0;
> @@ -82,6 +83,13 @@ NORET_TYPE void panic(const char * fmt,
>  #endif
>  
>  	/*
> +	 * Only one CPU is allowed to execute the panic code from here. For
> +	 * multiple parallel invocations of panic all other CPUs will wait on
> +	 * the panic_lock. They are stopped afterwards by smp_send_stop().
> +	 */
> +	spin_lock(&panic_lock);

Why leave irqs enabled?

Atleast for x86, Don Zickus had a patch to use NMI in smp_send_stop(). So
that should work even if interrupts are disabled. (I think that patch is
not merged yet).

So are other architectures a concern? If yes, then may be in future we
can make it an arch call which can also choose to disable interrupts.

CCing Don also. This lock also brings in the serialization required for
panic notifier list and kmsg_dump() infrastructure.

Thanks
Vivek
