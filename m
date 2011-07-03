Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab1GCIVp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 04:21:45 -0400
Received: from ist.d-labs.de ([213.239.218.44]:43772 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753305Ab1GCIVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 04:21:41 -0400
Date: Sun, 3 Jul 2011 10:21:37 +0200
From: Florian Mickler <florian@mickler.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrea Righi <andrea@betterlinux.com>, Len Brown <lenb@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Maciej Rutecki <maciej.rutecki@gmail.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: fix acpi_power_off lockdep splat
Message-ID: <20110703102137.302ac415@schatten.dmk.lab>
In-Reply-To: <201107030858.41459.rjw@sisk.pl>
References: <1309620681-25173-1-git-send-email-andrea@betterlinux.com>
	<201107030858.41459.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jul 2011 08:58:41 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> On Saturday, July 02, 2011, Andrea Righi wrote:
> > Implement acpi_os_create_lock() as a C-preprocessor macro to assign
> > unique lock_class_key to dynamically allocated locks and suppress wrong
> > lockdep warnings.
> > 
> > This fixes:
> > https://bugzilla.kernel.org/show_bug.cgi?id=38152
> > 
> > Reported-by: Borislav Petkov <bp@alien8.de>
> > Signed-off-by: Andrea Righi <andrea@betterlinux.com>
> 
> So, how exactly does it work?

The spin_lock_init macro stringifies it's argument and uses that as a
name for the lock in the debugging.

By re-executing spin_lock_init (have not checked if that harms
anything, but it should be ok) in the _macro_ the key changes from
"lock" for all three locks to the actual argument
"&acpi_gbl_global_lock_pending_lock", "&acpi_gbl_gpe_lock" or
"&acpi_gbl_hardware_lock". 

Regards,
Flo

> > ---
> >  drivers/acpi/osl.c      |    2 +-
> >  include/acpi/acpiosxf.h |   12 +++++++++++-
> >  2 files changed, 12 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> > index 52ca964..2a67602 100644
> > --- a/drivers/acpi/osl.c
> > +++ b/drivers/acpi/osl.c
> > @@ -1336,7 +1336,7 @@ EXPORT_SYMBOL(acpi_resources_are_enforced);
> >   * Create and initialize a spinlock.
> >   */
> >  acpi_status
> > -acpi_os_create_lock(acpi_spinlock *out_handle)
> > +__acpi_os_create_lock(acpi_spinlock *out_handle)
> >  {
> >  	spinlock_t *lock;
> >  
> > diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
> > index a756bc8..4a0385d 100644
> > --- a/include/acpi/acpiosxf.h
> > +++ b/include/acpi/acpiosxf.h
> > @@ -99,7 +99,17 @@ acpi_os_table_override(struct acpi_table_header *existing_table,
> >   * Spinlock primitives
> >   */
> >  acpi_status
> > -acpi_os_create_lock(acpi_spinlock *out_handle);
> > +__acpi_os_create_lock(acpi_spinlock *out_handle);
> > +
> > +#define acpi_os_create_lock(__handle)			\
> > +({							\
> > +	acpi_status ret;				\
> > +							\
> > +	ret = __acpi_os_create_lock(__handle);		\
> > +	if (ret == AE_OK)				\
> > +		spin_lock_init(*(__handle));		\
> 
> It seems that spin_lock_init() has already been done on *__handle, right?
> 
> > +	ret;						\
> > +})
> >  
> >  void acpi_os_delete_lock(acpi_spinlock handle);
> 
> Rafael
