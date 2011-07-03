Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab1GCIfj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 04:35:39 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:54223 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab1GCIfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 04:35:37 -0400
Date: Sun, 3 Jul 2011 10:35:32 +0200
From: Andrea Righi <andrea@betterlinux.com>
To: Florian Mickler <florian@mickler.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Maciej Rutecki <maciej.rutecki@gmail.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: fix acpi_power_off lockdep splat
Message-ID: <20110703083532.GA2653@thinkpad>
References: <1309620681-25173-1-git-send-email-andrea@betterlinux.com>
 <201107030858.41459.rjw@sisk.pl>
 <20110703102137.302ac415@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110703102137.302ac415@schatten.dmk.lab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 03, 2011 at 10:21:37AM +0200, Florian Mickler wrote:
> On Sun, 3 Jul 2011 08:58:41 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Saturday, July 02, 2011, Andrea Righi wrote:
> > > Implement acpi_os_create_lock() as a C-preprocessor macro to assign
> > > unique lock_class_key to dynamically allocated locks and suppress wrong
> > > lockdep warnings.
> > > 
> > > This fixes:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=38152
> > > 
> > > Reported-by: Borislav Petkov <bp@alien8.de>
> > > Signed-off-by: Andrea Righi <andrea@betterlinux.com>
> > 
> > So, how exactly does it work?
> 
> The spin_lock_init macro stringifies it's argument and uses that as a
> name for the lock in the debugging.

Correct.

> 
> By re-executing spin_lock_init (have not checked if that harms
> anything, but it should be ok) in the _macro_ the key changes from
> "lock" for all three locks to the actual argument
> "&acpi_gbl_global_lock_pending_lock", "&acpi_gbl_gpe_lock" or
> "&acpi_gbl_hardware_lock". 

We can simply move spin_lock_init() out of __acpi_os_create_lock(), so
that we have a single spin_lock_init() in the acpi_os_create_lock macro.

I'll post another patch soon (and I'll also add your description on
how it works).

Thanks!
-Andrea

> 
> Regards,
> Flo
> 
> > > ---
> > >  drivers/acpi/osl.c      |    2 +-
> > >  include/acpi/acpiosxf.h |   12 +++++++++++-
> > >  2 files changed, 12 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> > > index 52ca964..2a67602 100644
> > > --- a/drivers/acpi/osl.c
> > > +++ b/drivers/acpi/osl.c
> > > @@ -1336,7 +1336,7 @@ EXPORT_SYMBOL(acpi_resources_are_enforced);
> > >   * Create and initialize a spinlock.
> > >   */
> > >  acpi_status
> > > -acpi_os_create_lock(acpi_spinlock *out_handle)
> > > +__acpi_os_create_lock(acpi_spinlock *out_handle)
> > >  {
> > >  	spinlock_t *lock;
> > >  
> > > diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
> > > index a756bc8..4a0385d 100644
> > > --- a/include/acpi/acpiosxf.h
> > > +++ b/include/acpi/acpiosxf.h
> > > @@ -99,7 +99,17 @@ acpi_os_table_override(struct acpi_table_header *existing_table,
> > >   * Spinlock primitives
> > >   */
> > >  acpi_status
> > > -acpi_os_create_lock(acpi_spinlock *out_handle);
> > > +__acpi_os_create_lock(acpi_spinlock *out_handle);
> > > +
> > > +#define acpi_os_create_lock(__handle)			\
> > > +({							\
> > > +	acpi_status ret;				\
> > > +							\
> > > +	ret = __acpi_os_create_lock(__handle);		\
> > > +	if (ret == AE_OK)				\
> > > +		spin_lock_init(*(__handle));		\
> > 
> > It seems that spin_lock_init() has already been done on *__handle, right?
> > 
> > > +	ret;						\
> > > +})
> > >  
> > >  void acpi_os_delete_lock(acpi_spinlock handle);
> > 
> > Rafael
