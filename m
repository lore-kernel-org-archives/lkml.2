Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1GDXbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 19:31:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:54865 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab1GDXbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 19:31:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrea Righi <andrea@betterlinux.com>, Len Brown <lenb@kernel.org>
Subject: [PATCH] ACPI: Fix lockdep false positives in acpi_power_off()
Date: Tue, 5 Jul 2011 01:32:11 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1309684450-24549-1-git-send-email-andrea@betterlinux.com> <201107040028.23569.rjw@sisk.pl> <20110704082307.GA1239@thinkpad>
In-Reply-To: <20110704082307.GA1239@thinkpad>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107050132.11996.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 04, 2011, Andrea Righi wrote:
> On Mon, Jul 04, 2011 at 12:28:23AM +0200, Rafael J. Wysocki wrote:
> > On Monday, July 04, 2011, Rafael J. Wysocki wrote:
> > > On Sunday, July 03, 2011, Rafael J. Wysocki wrote:
> > > > On Sunday, July 03, 2011, Andrea Righi wrote:
> > > > > Implement acpi_os_create_lock() as a C-preprocessor macro to suppress
> > > > > lockdep false positive.
> > > > > 
> > > > > When lockdep is enabled the spin_lock_init macro stringifies it's
> > > > > argument and uses that as a name for the lock in the debugging.
> > > > > 
> > > > > By executing spin_lock_init in a macro the key changes from "lock" for
> > > > > all locks to the actual argument of acpi_os_create_lock()
> > > > > ("&acpi_gbl_global_lock_pending_lock", "&acpi_gbl_gpe_lock" or
> > > > > "&acpi_gbl_hardware_lock" for now).
> > > > > 
> > > > > This fixes:
> > > > > https://bugzilla.kernel.org/show_bug.cgi?id=38152
> > > > > 
> > > > > ChangeLog (v1 -> v2):
> > > > >  - avoid to call spin_lock_init multiple times on the same lock
> > > > >  - rewrite patch description (thanks to Florian for providing a better
> > > > >    description of the patch)
> > > > > 
> > > > > Reported-by: Borislav Petkov <bp@alien8.de>
> > > > > CC: Florian Mickler <florian@mickler.org>
> > > > > Signed-off-by: Andrea Righi <andrea@betterlinux.com>
> > > > > ---
> > > > >  drivers/acpi/osl.c      |    3 +--
> > > > >  include/acpi/acpiosxf.h |   12 +++++++++++-
> > > > >  2 files changed, 12 insertions(+), 3 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> > > > > index 52ca964..4c985d3 100644
> > > > > --- a/drivers/acpi/osl.c
> > > > > +++ b/drivers/acpi/osl.c
> > > > > @@ -1336,14 +1336,13 @@ EXPORT_SYMBOL(acpi_resources_are_enforced);
> > > > >   * Create and initialize a spinlock.
> > > > >   */
> > > > >  acpi_status
> > > > > -acpi_os_create_lock(acpi_spinlock *out_handle)
> > > > > +__acpi_os_create_lock(acpi_spinlock *out_handle)
> > > > >  {
> > > > 
> > > > I would rename this to acpi_os_allocate_lock() or acpi_os_alloc_lock(),
> > > > so that it doesn't suggest the lock is initialized by this function.
> > > > 
> > > > Hmm.  There's one more thing we need to take into account here.  Namely,
> > > > include/acpi/acpiosxf.h is used by other OSes, so we shouldn't put
> > > > Linux-specific stuff into it.
> > > > 
> > > > I'm not sure how to work around that at the moment.
> > > 
> > > OK, the patch below builds for me and seems to work even, although I haven't
> > > tested it with lockdep on.
> > 
> > Below is a cleaned-up version, still untested with lockdep on.
> 
> Tested. Works fine for me.

OK, below is an official version.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: ACPI: Fix lockdep false positives in acpi_power_off()

All ACPICA locks are allocated and initialized by the same function,
acpi_os_create_lock(), with the help of a local variable called
"lock".  Thus, when lockdep is enabled, it uses "lock" as the
name of all those locks and regards them as instances of the same
lock, which causes it to report possible locking problems with them
when there aren't any.

To work around this problem, define acpi_os_create_lock() as a macro
and make it pass its argument to spin_lock_init(), so that lockdep
uses it as the name of the new lock.  Define this macron in a
Linux-specific file to minimize the resulting modifications of
the OS-independent ACPICA parts.

This change is based on an earlier patch from Andrea Righi and it
addresses a regression from 2.6.39 tracked as
https://bugzilla.kernel.org/show_bug.cgi?id=38152

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Reported-by: Borislav Petkov <bp@alien8.de>
Tested-by: Andrea Righi <andrea@betterlinux.com>
---
 drivers/acpi/osl.c              |   17 -----------------
 include/acpi/acpiosxf.h         |    3 +++
 include/acpi/platform/aclinux.h |   18 ++++++++++++++++++
 3 files changed, 21 insertions(+), 17 deletions(-)

Index: linux-2.6/drivers/acpi/osl.c
===================================================================
--- linux-2.6.orig/drivers/acpi/osl.c
+++ linux-2.6/drivers/acpi/osl.c
@@ -1333,23 +1333,6 @@ int acpi_resources_are_enforced(void)
 EXPORT_SYMBOL(acpi_resources_are_enforced);
 
 /*
- * Create and initialize a spinlock.
- */
-acpi_status
-acpi_os_create_lock(acpi_spinlock *out_handle)
-{
-	spinlock_t *lock;
-
-	lock = ACPI_ALLOCATE(sizeof(spinlock_t));
-	if (!lock)
-		return AE_NO_MEMORY;
-	spin_lock_init(lock);
-	*out_handle = lock;
-
-	return AE_OK;
-}
-
-/*
  * Deallocate the memory for a spinlock.
  */
 void acpi_os_delete_lock(acpi_spinlock handle)
Index: linux-2.6/include/acpi/acpiosxf.h
===================================================================
--- linux-2.6.orig/include/acpi/acpiosxf.h
+++ linux-2.6/include/acpi/acpiosxf.h
@@ -98,8 +98,11 @@ acpi_os_table_override(struct acpi_table
 /*
  * Spinlock primitives
  */
+
+#ifndef acpi_os_create_lock
 acpi_status
 acpi_os_create_lock(acpi_spinlock *out_handle);
+#endif
 
 void acpi_os_delete_lock(acpi_spinlock handle);
 
Index: linux-2.6/include/acpi/platform/aclinux.h
===================================================================
--- linux-2.6.orig/include/acpi/platform/aclinux.h
+++ linux-2.6/include/acpi/platform/aclinux.h
@@ -159,6 +159,24 @@ static inline void *acpi_os_acquire_obje
 	} while (0)
 #endif
 
+/*
+ * When lockdep is enabled, the spin_lock_init() macro stringifies it's
+ * argument and uses that as a name for the lock in debugging.
+ * By executing spin_lock_init() in a macro the key changes from "lock" for
+ * all locks to the name of the argument of acpi_os_create_lock(), which
+ * prevents lockdep from reporting false positives for ACPICA locks.
+ */
+#define acpi_os_create_lock(__handle)				\
+({								\
+	spinlock_t *lock = ACPI_ALLOCATE(sizeof(*lock));	\
+								\
+	if (lock) {						\
+		*(__handle) = lock;				\
+		spin_lock_init(*(__handle));			\
+	}							\
+	lock ? AE_OK : AE_NO_MEMORY;				\
+})
+
 #endif /* __KERNEL__ */
 
 #endif /* __ACLINUX_H__ */
