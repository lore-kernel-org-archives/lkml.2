Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738Ab1ANW02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 17:26:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37707 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab1ANW00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 17:26:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: BUG: spinlock bad magic on CPU#0
Date: Fri, 14 Jan 2011 23:25:57 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <20110114140803.GA4003@swordfish> <201101142209.35892.rjw@sisk.pl> <20110114215118.GA3893@swordfish>
In-Reply-To: <20110114215118.GA3893@swordfish>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201101142325.57449.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 14, 2011, Sergey Senozhatsky wrote:
> On (01/14/11 22:09), Rafael J. Wysocki wrote:
> > > Hello,
> > 
> > Does the appended patch help?
> > 
> >
> 
> Hello,
> Yes, it does. Seems to be fixed.
> 
> Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Thanks for testing, appended is a changelogged version.

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: ACPI / ACPICA: Initialize the global lock spinlock as appropriate

Commit 9cd0314 (ACPI / ACPICA: Fix global lock acquisition) forgot to
initialize the spinlock it added.  Fix that.

Reported-and-tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/acpica/acglobal.h |    2 ++
 drivers/acpi/acpica/evmisc.c   |    2 --
 drivers/acpi/acpica/utmutex.c  |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/drivers/acpi/acpica/acglobal.h
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/acglobal.h
+++ linux-2.6/drivers/acpi/acpica/acglobal.h
@@ -228,8 +228,10 @@ ACPI_EXTERN u8 acpi_gbl_global_lock_pres
  */
 ACPI_EXTERN spinlock_t _acpi_gbl_gpe_lock;	/* For GPE data structs and registers */
 ACPI_EXTERN spinlock_t _acpi_gbl_hardware_lock;	/* For ACPI H/W except GPE registers */
+ACPI_EXTERN spinlock_t _acpi_ev_global_lock_pending_lock; /* For global lock */
 #define acpi_gbl_gpe_lock	&_acpi_gbl_gpe_lock
 #define acpi_gbl_hardware_lock	&_acpi_gbl_hardware_lock
+#define acpi_ev_global_lock_pending_lock &_acpi_ev_global_lock_pending_lock
 
 /*****************************************************************************
  *
Index: linux-2.6/drivers/acpi/acpica/evmisc.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/evmisc.c
+++ linux-2.6/drivers/acpi/acpica/evmisc.c
@@ -293,8 +293,6 @@ static void ACPI_SYSTEM_XFACE acpi_ev_no
  *
  ******************************************************************************/
 static u8 acpi_ev_global_lock_pending;
-static spinlock_t _acpi_ev_global_lock_pending_lock;
-#define acpi_ev_global_lock_pending_lock &_acpi_ev_global_lock_pending_lock
 
 static u32 acpi_ev_global_lock_handler(void *context)
 {
Index: linux-2.6/drivers/acpi/acpica/utmutex.c
===================================================================
--- linux-2.6.orig/drivers/acpi/acpica/utmutex.c
+++ linux-2.6/drivers/acpi/acpica/utmutex.c
@@ -85,6 +85,7 @@ acpi_status acpi_ut_mutex_initialize(voi
 
 	spin_lock_init(acpi_gbl_gpe_lock);
 	spin_lock_init(acpi_gbl_hardware_lock);
+	spin_lock_init(acpi_ev_global_lock_pending_lock);
 
 	/* Mutex for _OSI support */
 	status = acpi_os_create_mutex(&acpi_gbl_osi_mutex);
