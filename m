Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab1GDIXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 04:23:15 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:54755 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab1GDIXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 04:23:13 -0400
Date: Mon, 4 Jul 2011 10:23:07 +0200
From: Andrea Righi <andrea@betterlinux.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ACPI: fix acpi_power_off lockdep splat
Message-ID: <20110704082307.GA1239@thinkpad>
References: <1309684450-24549-1-git-send-email-andrea@betterlinux.com>
 <201107032259.05722.rjw@sisk.pl>
 <201107040011.32254.rjw@sisk.pl>
 <201107040028.23569.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107040028.23569.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 04, 2011 at 12:28:23AM +0200, Rafael J. Wysocki wrote:
> On Monday, July 04, 2011, Rafael J. Wysocki wrote:
> > On Sunday, July 03, 2011, Rafael J. Wysocki wrote:
> > > On Sunday, July 03, 2011, Andrea Righi wrote:
> > > > Implement acpi_os_create_lock() as a C-preprocessor macro to suppress
> > > > lockdep false positive.
> > > > 
> > > > When lockdep is enabled the spin_lock_init macro stringifies it's
> > > > argument and uses that as a name for the lock in the debugging.
> > > > 
> > > > By executing spin_lock_init in a macro the key changes from "lock" for
> > > > all locks to the actual argument of acpi_os_create_lock()
> > > > ("&acpi_gbl_global_lock_pending_lock", "&acpi_gbl_gpe_lock" or
> > > > "&acpi_gbl_hardware_lock" for now).
> > > > 
> > > > This fixes:
> > > > https://bugzilla.kernel.org/show_bug.cgi?id=38152
> > > > 
> > > > ChangeLog (v1 -> v2):
> > > >  - avoid to call spin_lock_init multiple times on the same lock
> > > >  - rewrite patch description (thanks to Florian for providing a better
> > > >    description of the patch)
> > > > 
> > > > Reported-by: Borislav Petkov <bp@alien8.de>
> > > > CC: Florian Mickler <florian@mickler.org>
> > > > Signed-off-by: Andrea Righi <andrea@betterlinux.com>
> > > > ---
> > > >  drivers/acpi/osl.c      |    3 +--
> > > >  include/acpi/acpiosxf.h |   12 +++++++++++-
> > > >  2 files changed, 12 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> > > > index 52ca964..4c985d3 100644
> > > > --- a/drivers/acpi/osl.c
> > > > +++ b/drivers/acpi/osl.c
> > > > @@ -1336,14 +1336,13 @@ EXPORT_SYMBOL(acpi_resources_are_enforced);
> > > >   * Create and initialize a spinlock.
> > > >   */
> > > >  acpi_status
> > > > -acpi_os_create_lock(acpi_spinlock *out_handle)
> > > > +__acpi_os_create_lock(acpi_spinlock *out_handle)
> > > >  {
> > > 
> > > I would rename this to acpi_os_allocate_lock() or acpi_os_alloc_lock(),
> > > so that it doesn't suggest the lock is initialized by this function.
> > > 
> > > Hmm.  There's one more thing we need to take into account here.  Namely,
> > > include/acpi/acpiosxf.h is used by other OSes, so we shouldn't put
> > > Linux-specific stuff into it.
> > > 
> > > I'm not sure how to work around that at the moment.
> > 
> > OK, the patch below builds for me and seems to work even, although I haven't
> > tested it with lockdep on.
> 
> Below is a cleaned-up version, still untested with lockdep on.

Tested. Works fine for me.

Thanks!
-Andrea
