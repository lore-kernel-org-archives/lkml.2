Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab1GCWLA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 18:11:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51800 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741Ab1GCWK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 18:10:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrea Righi <andrea@betterlinux.com>
Subject: Re: [PATCH v2] ACPI: fix acpi_power_off lockdep splat
Date: Mon, 4 Jul 2011 00:11:31 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1309684450-24549-1-git-send-email-andrea@betterlinux.com> <201107032259.05722.rjw@sisk.pl>
In-Reply-To: <201107032259.05722.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201107040011.32254.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, July 03, 2011, Rafael J. Wysocki wrote:
> On Sunday, July 03, 2011, Andrea Righi wrote:
> > Implement acpi_os_create_lock() as a C-preprocessor macro to suppress
> > lockdep false positive.
> > 
> > When lockdep is enabled the spin_lock_init macro stringifies it's
> > argument and uses that as a name for the lock in the debugging.
> > 
> > By executing spin_lock_init in a macro the key changes from "lock" for
> > all locks to the actual argument of acpi_os_create_lock()
> > ("&acpi_gbl_global_lock_pending_lock", "&acpi_gbl_gpe_lock" or
> > "&acpi_gbl_hardware_lock" for now).
> > 
> > This fixes:
> > https://bugzilla.kernel.org/show_bug.cgi?id=38152
> > 
> > ChangeLog (v1 -> v2):
> >  - avoid to call spin_lock_init multiple times on the same lock
> >  - rewrite patch description (thanks to Florian for providing a better
> >    description of the patch)
> > 
> > Reported-by: Borislav Petkov <bp@alien8.de>
> > CC: Florian Mickler <florian@mickler.org>
> > Signed-off-by: Andrea Righi <andrea@betterlinux.com>
> > ---
> >  drivers/acpi/osl.c      |    3 +--
> >  include/acpi/acpiosxf.h |   12 +++++++++++-
> >  2 files changed, 12 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
> > index 52ca964..4c985d3 100644
> > --- a/drivers/acpi/osl.c
> > +++ b/drivers/acpi/osl.c
> > @@ -1336,14 +1336,13 @@ EXPORT_SYMBOL(acpi_resources_are_enforced);
> >   * Create and initialize a spinlock.
> >   */
> >  acpi_status
> > -acpi_os_create_lock(acpi_spinlock *out_handle)
> > +__acpi_os_create_lock(acpi_spinlock *out_handle)
> >  {
> 
> I would rename this to acpi_os_allocate_lock() or acpi_os_alloc_lock(),
> so that it doesn't suggest the lock is initialized by this function.
> 
> Hmm.  There's one more thing we need to take into account here.  Namely,
> include/acpi/acpiosxf.h is used by other OSes, so we shouldn't put
> Linux-specific stuff into it.
> 
> I'm not sure how to work around that at the moment.

OK, the patch below builds for me and seems to work even, although I haven't
tested it with lockdep on.

Thanks,
Rafael

---
 drivers/acpi/osl.c              |   25 -------------------------
 include/acpi/acpiosxf.h         |    8 --------
 include/acpi/platform/aclinux.h |   20 ++++++++++++++++++++
 3 files changed, 20 insertions(+), 33 deletions(-)

Index: linux-2.6/drivers/acpi/osl.c
===================================================================
--- linux-2.6.orig/drivers/acpi/osl.c
+++ linux-2.6/drivers/acpi/osl.c
@@ -1333,31 +1333,6 @@ int acpi_resources_are_enforced(void)
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
- * Deallocate the memory for a spinlock.
- */
-void acpi_os_delete_lock(acpi_spinlock handle)
-{
-	ACPI_FREE(handle);
-}
-
-/*
  * Acquire a spinlock.
  *
  * handle is a pointer to the spinlock_t.
Index: linux-2.6/include/acpi/acpiosxf.h
===================================================================
--- linux-2.6.orig/include/acpi/acpiosxf.h
+++ linux-2.6/include/acpi/acpiosxf.h
@@ -95,14 +95,6 @@ acpi_status
 acpi_os_table_override(struct acpi_table_header *existing_table,
 		       struct acpi_table_header **new_table);
 
-/*
- * Spinlock primitives
- */
-acpi_status
-acpi_os_create_lock(acpi_spinlock *out_handle);
-
-void acpi_os_delete_lock(acpi_spinlock handle);
-
 acpi_cpu_flags acpi_os_acquire_lock(acpi_spinlock handle);
 
 void acpi_os_release_lock(acpi_spinlock handle, acpi_cpu_flags flags);
Index: linux-2.6/include/acpi/platform/aclinux.h
===================================================================
--- linux-2.6.orig/include/acpi/platform/aclinux.h
+++ linux-2.6/include/acpi/platform/aclinux.h
@@ -159,6 +159,26 @@ static inline void *acpi_os_acquire_obje
 	} while (0)
 #endif
 
+/*
+ * Spinlock primitives
+ */
+
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
+#define acpi_os_delete_lock(__handle)	\
+	do {				\
+		ACPI_FREE(__handle);	\
+	} while (0)
+
 #endif /* __KERNEL__ */
 
 #endif /* __ACLINUX_H__ */
