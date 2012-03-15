Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031470Ab2COBby (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 21:31:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16558 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031252Ab2COBbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 21:31:44 -0400
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=UBy9sU4F98IA:10 a=vCGTztSxuj0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=ph9qUFhQvZVhXCd9vxkA:9 a=oePGxOlT7QubWxG_81QA:7 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=kVWnHooyxdFBvMy2:21 a=htm5C8gjvA0uNf28:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20120315013139.091200939@goodmis.org>
User-Agent: quilt/0.50-1
Date: Wed, 14 Mar 2012 21:30:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH RT 1/2] rt: Revert: acpi: Make gbl_[hardware|gpe]_lock raw
References: <20120315013058.145666805@goodmis.org>
Content-Disposition: inline; filename=0001-rt-Revert-acpi-Make-gbl_-hardware-gpe-_lock-raw.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Revert:

  commit bf30ab190c1237ba18f534455becc045422c891d
  Author: Thomas Gleixner <tglx@linutronix.de>
  Date:   Mon Nov 28 17:09:54 2011 +0100

    acpi: Make gbl_[hardware|gpe]_lock raw

    These locks are taken in the guts of the idle code and cannot be
    converted to "sleeping" spinlocks on RT

As they do not seem to be an issue, and they cause ACPI bugs.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/acpi/acpica/acglobal.h  |    4 ++--
 drivers/acpi/acpica/evgpe.c     |    4 ++--
 drivers/acpi/acpica/evgpeblk.c  |    8 ++++----
 drivers/acpi/acpica/evgpeutil.c |   12 ++++++------
 drivers/acpi/acpica/evxface.c   |   10 +++++-----
 drivers/acpi/acpica/evxfgpe.c   |   24 ++++++++++++------------
 drivers/acpi/acpica/hwregs.c    |    4 ++--
 drivers/acpi/acpica/hwxface.c   |    4 ++--
 drivers/acpi/acpica/utmutex.c   |   21 ++++++++++++++++++---
 9 files changed, 53 insertions(+), 38 deletions(-)

diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.h
index 6c169a2..73863d8 100644
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -229,8 +229,8 @@ ACPI_EXTERN u8 acpi_gbl_global_lock_pending;
  * Spinlocks are used for interfaces that can be possibly called at
  * interrupt level
  */
-extern raw_spinlock_t acpi_gbl_gpe_lock;	/* For GPE data structs and registers */
-extern raw_spinlock_t acpi_gbl_hardware_lock;	/* For ACPI H/W except GPE registers */
+ACPI_EXTERN acpi_spinlock acpi_gbl_gpe_lock;	/* For GPE data structs and registers */
+ACPI_EXTERN acpi_spinlock acpi_gbl_hardware_lock;	/* For ACPI H/W except GPE registers */
 
 /*****************************************************************************
  *
diff --git a/drivers/acpi/acpica/evgpe.c b/drivers/acpi/acpica/evgpe.c
index 36e7e10..65c79ad 100644
--- a/drivers/acpi/acpica/evgpe.c
+++ b/drivers/acpi/acpica/evgpe.c
@@ -357,7 +357,7 @@ u32 acpi_ev_gpe_detect(struct acpi_gpe_xrupt_info * gpe_xrupt_list)
 	 * Note: Not necessary to obtain the hardware lock, since the GPE
 	 * registers are owned by the gpe_lock.
 	 */
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 
 	/* Examine all GPE blocks attached to this interrupt level */
 
@@ -440,7 +440,7 @@ u32 acpi_ev_gpe_detect(struct acpi_gpe_xrupt_info * gpe_xrupt_list)
 
       unlock_and_exit:
 
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	return (int_status);
 }
 
diff --git a/drivers/acpi/acpica/evgpeblk.c b/drivers/acpi/acpica/evgpeblk.c
index 60c47b9..ca2c41a 100644
--- a/drivers/acpi/acpica/evgpeblk.c
+++ b/drivers/acpi/acpica/evgpeblk.c
@@ -95,7 +95,7 @@ acpi_ev_install_gpe_block(struct acpi_gpe_block_info *gpe_block,
 
 	/* Install the new block at the end of the list with lock */
 
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 	if (gpe_xrupt_block->gpe_block_list_head) {
 		next_gpe_block = gpe_xrupt_block->gpe_block_list_head;
 		while (next_gpe_block->next) {
@@ -109,7 +109,7 @@ acpi_ev_install_gpe_block(struct acpi_gpe_block_info *gpe_block,
 	}
 
 	gpe_block->xrupt_block = gpe_xrupt_block;
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 
       unlock_and_exit:
 	status = acpi_ut_release_mutex(ACPI_MTX_EVENTS);
@@ -156,7 +156,7 @@ acpi_status acpi_ev_delete_gpe_block(struct acpi_gpe_block_info *gpe_block)
 	} else {
 		/* Remove the block on this interrupt with lock */
 
-		raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+		flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 		if (gpe_block->previous) {
 			gpe_block->previous->next = gpe_block->next;
 		} else {
@@ -167,7 +167,7 @@ acpi_status acpi_ev_delete_gpe_block(struct acpi_gpe_block_info *gpe_block)
 		if (gpe_block->next) {
 			gpe_block->next->previous = gpe_block->previous;
 		}
-		raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+		acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	}
 
 	acpi_current_gpe_count -= gpe_block->gpe_count;
diff --git a/drivers/acpi/acpica/evgpeutil.c b/drivers/acpi/acpica/evgpeutil.c
index 895b68ab..80a81d0 100644
--- a/drivers/acpi/acpica/evgpeutil.c
+++ b/drivers/acpi/acpica/evgpeutil.c
@@ -70,7 +70,7 @@ acpi_ev_walk_gpe_list(acpi_gpe_callback gpe_walk_callback, void *context)
 
 	ACPI_FUNCTION_TRACE(ev_walk_gpe_list);
 
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 
 	/* Walk the interrupt level descriptor list */
 
@@ -101,7 +101,7 @@ acpi_ev_walk_gpe_list(acpi_gpe_callback gpe_walk_callback, void *context)
 	}
 
       unlock_and_exit:
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 
@@ -237,7 +237,7 @@ struct acpi_gpe_xrupt_info *acpi_ev_get_gpe_xrupt_block(u32 interrupt_number)
 
 	/* Install new interrupt descriptor with spin lock */
 
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 	if (acpi_gbl_gpe_xrupt_list_head) {
 		next_gpe_xrupt = acpi_gbl_gpe_xrupt_list_head;
 		while (next_gpe_xrupt->next) {
@@ -249,7 +249,7 @@ struct acpi_gpe_xrupt_info *acpi_ev_get_gpe_xrupt_block(u32 interrupt_number)
 	} else {
 		acpi_gbl_gpe_xrupt_list_head = gpe_xrupt;
 	}
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 
 	/* Install new interrupt handler if not SCI_INT */
 
@@ -306,7 +306,7 @@ acpi_status acpi_ev_delete_gpe_xrupt(struct acpi_gpe_xrupt_info *gpe_xrupt)
 
 	/* Unlink the interrupt block with lock */
 
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 	if (gpe_xrupt->previous) {
 		gpe_xrupt->previous->next = gpe_xrupt->next;
 	} else {
@@ -318,7 +318,7 @@ acpi_status acpi_ev_delete_gpe_xrupt(struct acpi_gpe_xrupt_info *gpe_xrupt)
 	if (gpe_xrupt->next) {
 		gpe_xrupt->next->previous = gpe_xrupt->previous;
 	}
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 
 	/* Free the block */
 
diff --git a/drivers/acpi/acpica/evxface.c b/drivers/acpi/acpica/evxface.c
index e849c10..e114140 100644
--- a/drivers/acpi/acpica/evxface.c
+++ b/drivers/acpi/acpica/evxface.c
@@ -750,7 +750,7 @@ acpi_install_gpe_handler(acpi_handle gpe_device,
 		goto unlock_and_exit;
 	}
 
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 
 	/* Ensure that we have a valid GPE number */
 
@@ -798,14 +798,14 @@ acpi_install_gpe_handler(acpi_handle gpe_device,
 	    ~(ACPI_GPE_XRUPT_TYPE_MASK | ACPI_GPE_DISPATCH_MASK);
 	gpe_event_info->flags |= (u8) (type | ACPI_GPE_DISPATCH_HANDLER);
 
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 
 unlock_and_exit:
 	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
 	return_ACPI_STATUS(status);
 
 free_and_exit:
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	ACPI_FREE(handler);
 	goto unlock_and_exit;
 }
@@ -852,7 +852,7 @@ acpi_remove_gpe_handler(acpi_handle gpe_device,
 		return_ACPI_STATUS(status);
 	}
 
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 
 	/* Ensure that we have a valid GPE number */
 
@@ -903,7 +903,7 @@ acpi_remove_gpe_handler(acpi_handle gpe_device,
 	ACPI_FREE(handler);
 
 unlock_and_exit:
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 
 	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
 	return_ACPI_STATUS(status);
diff --git a/drivers/acpi/acpica/evxfgpe.c b/drivers/acpi/acpica/evxfgpe.c
index ce07ebb..52aaff3 100644
--- a/drivers/acpi/acpica/evxfgpe.c
+++ b/drivers/acpi/acpica/evxfgpe.c
@@ -121,7 +121,7 @@ acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32 gpe_number)
 
 	ACPI_FUNCTION_TRACE(acpi_enable_gpe);
 
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 
 	/* Ensure that we have a valid GPE number */
 
@@ -130,7 +130,7 @@ acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32 gpe_number)
 		status = acpi_ev_add_gpe_reference(gpe_event_info);
 	}
 
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 ACPI_EXPORT_SYMBOL(acpi_enable_gpe)
@@ -158,7 +158,7 @@ acpi_status acpi_disable_gpe(acpi_handle gpe_device, u32 gpe_number)
 
 	ACPI_FUNCTION_TRACE(acpi_disable_gpe);
 
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 
 	/* Ensure that we have a valid GPE number */
 
@@ -167,7 +167,7 @@ acpi_status acpi_disable_gpe(acpi_handle gpe_device, u32 gpe_number)
 		status = acpi_ev_remove_gpe_reference(gpe_event_info) ;
 	}
 
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 ACPI_EXPORT_SYMBOL(acpi_disable_gpe)
@@ -214,7 +214,7 @@ acpi_setup_gpe_for_wake(acpi_handle wake_device,
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}
 
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 
 	/* Ensure that we have a valid GPE number */
 
@@ -270,7 +270,7 @@ acpi_setup_gpe_for_wake(acpi_handle wake_device,
 	status = AE_OK;
 
  unlock_and_exit:
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 ACPI_EXPORT_SYMBOL(acpi_setup_gpe_for_wake)
@@ -300,7 +300,7 @@ acpi_status acpi_set_gpe_wake_mask(acpi_handle gpe_device, u32 gpe_number, u8 ac
 
 	ACPI_FUNCTION_TRACE(acpi_set_gpe_wake_mask);
 
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 
 	/*
 	 * Ensure that we have a valid GPE number and that this GPE is in
@@ -346,7 +346,7 @@ acpi_status acpi_set_gpe_wake_mask(acpi_handle gpe_device, u32 gpe_number, u8 ac
 	}
 
 unlock_and_exit:
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 
@@ -372,7 +372,7 @@ acpi_status acpi_clear_gpe(acpi_handle gpe_device, u32 gpe_number)
 
 	ACPI_FUNCTION_TRACE(acpi_clear_gpe);
 
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 
 	/* Ensure that we have a valid GPE number */
 
@@ -385,7 +385,7 @@ acpi_status acpi_clear_gpe(acpi_handle gpe_device, u32 gpe_number)
 	status = acpi_hw_clear_gpe(gpe_event_info);
 
       unlock_and_exit:
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 
@@ -415,7 +415,7 @@ acpi_get_gpe_status(acpi_handle gpe_device,
 
 	ACPI_FUNCTION_TRACE(acpi_get_gpe_status);
 
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags = acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 
 	/* Ensure that we have a valid GPE number */
 
@@ -433,7 +433,7 @@ acpi_get_gpe_status(acpi_handle gpe_device,
 		*event_status |= ACPI_EVENT_FLAG_HANDLE;
 
       unlock_and_exit:
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 
diff --git a/drivers/acpi/acpica/hwregs.c b/drivers/acpi/acpica/hwregs.c
index 4772930..55accb7 100644
--- a/drivers/acpi/acpica/hwregs.c
+++ b/drivers/acpi/acpica/hwregs.c
@@ -263,7 +263,7 @@ acpi_status acpi_hw_clear_acpi_status(void)
 			  ACPI_BITMASK_ALL_FIXED_STATUS,
 			  ACPI_FORMAT_UINT64(acpi_gbl_xpm1a_status.address)));
 
-	raw_spin_lock_irqsave(&acpi_gbl_hardware_lock, lock_flags);
+	lock_flags = acpi_os_acquire_lock(acpi_gbl_hardware_lock);
 
 	/* Clear the fixed events in PM1 A/B */
 
@@ -278,7 +278,7 @@ acpi_status acpi_hw_clear_acpi_status(void)
 	status = acpi_ev_walk_gpe_list(acpi_hw_clear_gpe_block, NULL);
 
       unlock_and_exit:
-	raw_spin_unlock_irqrestore(&acpi_gbl_hardware_lock, lock_flags);
+	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
 	return_ACPI_STATUS(status);
 }
 
diff --git a/drivers/acpi/acpica/hwxface.c b/drivers/acpi/acpica/hwxface.c
index 76159ba..f75f81a 100644
--- a/drivers/acpi/acpica/hwxface.c
+++ b/drivers/acpi/acpica/hwxface.c
@@ -386,7 +386,7 @@ acpi_status acpi_write_bit_register(u32 register_id, u32 value)
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}
 
-	raw_spin_lock_irqsave(&acpi_gbl_hardware_lock, lock_flags);
+	lock_flags = acpi_os_acquire_lock(acpi_gbl_hardware_lock);
 
 	/*
 	 * At this point, we know that the parent register is one of the
@@ -447,7 +447,7 @@ acpi_status acpi_write_bit_register(u32 register_id, u32 value)
 
 unlock_and_exit:
 
-	raw_spin_unlock_irqrestore(&acpi_gbl_hardware_lock, lock_flags);
+	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
 	return_ACPI_STATUS(status);
 }
 
diff --git a/drivers/acpi/acpica/utmutex.c b/drivers/acpi/acpica/utmutex.c
index 420eecf..7d797e2 100644
--- a/drivers/acpi/acpica/utmutex.c
+++ b/drivers/acpi/acpica/utmutex.c
@@ -52,9 +52,6 @@ static acpi_status acpi_ut_create_mutex(acpi_mutex_handle mutex_id);
 
 static void acpi_ut_delete_mutex(acpi_mutex_handle mutex_id);
 
-DEFINE_RAW_SPINLOCK(acpi_gbl_gpe_lock);
-DEFINE_RAW_SPINLOCK(acpi_gbl_hardware_lock);
-
 /*******************************************************************************
  *
  * FUNCTION:    acpi_ut_mutex_initialize
@@ -84,6 +81,18 @@ acpi_status acpi_ut_mutex_initialize(void)
 		}
 	}
 
+	/* Create the spinlocks for use at interrupt level */
+
+	status = acpi_os_create_lock (&acpi_gbl_gpe_lock);
+	if (ACPI_FAILURE (status)) {
+		return_ACPI_STATUS (status);
+	}
+
+	status = acpi_os_create_lock (&acpi_gbl_hardware_lock);
+	if (ACPI_FAILURE (status)) {
+		return_ACPI_STATUS (status);
+	}
+
 	/* Mutex for _OSI support */
 	status = acpi_os_create_mutex(&acpi_gbl_osi_mutex);
 	if (ACPI_FAILURE(status)) {
@@ -123,7 +132,13 @@ void acpi_ut_mutex_terminate(void)
 
 	acpi_os_delete_mutex(acpi_gbl_osi_mutex);
 
+	/* Delete the spinlocks */
+
+	acpi_os_delete_lock(acpi_gbl_gpe_lock);
+	acpi_os_delete_lock(acpi_gbl_hardware_lock);
+
 	/* Delete the reader/writer lock */
+
 	acpi_ut_delete_rw_lock(&acpi_gbl_namespace_rw_lock);
 	return_VOID;
 }
-- 
1.7.8.3


