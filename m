Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1LCBh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 20:37:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:49271 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309Ab1LCBhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 20:37:51 -0500
X-Authority-Analysis: v=2.0 cv=bdLpoZzB c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=vhdKIqpQuCYA:10 a=_cDpD3Nza5wA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=ph9qUFhQvZVhXCd9vxkA:9 a=kGFfUk9mnI2VJ1Ynbb0A:7 a=QEXdDO2ut3YA:10 a=Zh68SRI7RUMA:10 a=jeBq3FmKZ4MA:10 a=G7vUbxx_U2aS9xtU:21 a=jmdY7YoaUyku0SrR:21 a=LdNGxyMK65CIV2RsjNoA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-Id: <20111203013747.752732372@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 02 Dec 2011 20:37:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        stable-rt@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 07/10] acpi: Make gbl_[hardware|gpe]_lock raw
References: <20111203013653.090501690@goodmis.org>
Content-Disposition: inline; filename=0007-acpi-Make-gbl_-hardware-gpe-_lock-raw.patch
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="00GvhwF7k39YY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--00GvhwF7k39YY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Thomas Gleixner <tglx@linutronix.de>

These locks are taken in the guts of the idle code and cannot be
converted to "sleeping" spinlocks on RT

Cc: stable-rt@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
 drivers/acpi/acpica/utmutex.c   |   21 +++------------------
 9 files changed, 38 insertions(+), 53 deletions(-)

diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.h
index 73863d8..6c169a2 100644
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -229,8 +229,8 @@ ACPI_EXTERN u8 acpi_gbl_global_lock_pending;
  * Spinlocks are used for interfaces that can be possibly called at
  * interrupt level
  */
-ACPI_EXTERN acpi_spinlock acpi_gbl_gpe_lock;	/* For GPE data structs and r=
egisters */
-ACPI_EXTERN acpi_spinlock acpi_gbl_hardware_lock;	/* For ACPI H/W except G=
PE registers */
+extern raw_spinlock_t acpi_gbl_gpe_lock;	/* For GPE data structs and regis=
ters */
+extern raw_spinlock_t acpi_gbl_hardware_lock;	/* For ACPI H/W except GPE r=
egisters */
=20
 /*************************************************************************=
****
  *
diff --git a/drivers/acpi/acpica/evgpe.c b/drivers/acpi/acpica/evgpe.c
index 65c79ad..36e7e10 100644
--- a/drivers/acpi/acpica/evgpe.c
+++ b/drivers/acpi/acpica/evgpe.c
@@ -357,7 +357,7 @@ u32 acpi_ev_gpe_detect(struct acpi_gpe_xrupt_info * gpe=
_xrupt_list)
 	 * Note: Not necessary to obtain the hardware lock, since the GPE
 	 * registers are owned by the gpe_lock.
 	 */
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
=20
 	/* Examine all GPE blocks attached to this interrupt level */
=20
@@ -440,7 +440,7 @@ u32 acpi_ev_gpe_detect(struct acpi_gpe_xrupt_info * gpe=
_xrupt_list)
=20
       unlock_and_exit:
=20
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return (int_status);
 }
=20
diff --git a/drivers/acpi/acpica/evgpeblk.c b/drivers/acpi/acpica/evgpeblk.c
index ca2c41a..60c47b9 100644
--- a/drivers/acpi/acpica/evgpeblk.c
+++ b/drivers/acpi/acpica/evgpeblk.c
@@ -95,7 +95,7 @@ acpi_ev_install_gpe_block(struct acpi_gpe_block_info *gpe=
_block,
=20
 	/* Install the new block at the end of the list with lock */
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
 	if (gpe_xrupt_block->gpe_block_list_head) {
 		next_gpe_block =3D gpe_xrupt_block->gpe_block_list_head;
 		while (next_gpe_block->next) {
@@ -109,7 +109,7 @@ acpi_ev_install_gpe_block(struct acpi_gpe_block_info *g=
pe_block,
 	}
=20
 	gpe_block->xrupt_block =3D gpe_xrupt_block;
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
=20
       unlock_and_exit:
 	status =3D acpi_ut_release_mutex(ACPI_MTX_EVENTS);
@@ -156,7 +156,7 @@ acpi_status acpi_ev_delete_gpe_block(struct acpi_gpe_bl=
ock_info *gpe_block)
 	} else {
 		/* Remove the block on this interrupt with lock */
=20
-		flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+		raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
 		if (gpe_block->previous) {
 			gpe_block->previous->next =3D gpe_block->next;
 		} else {
@@ -167,7 +167,7 @@ acpi_status acpi_ev_delete_gpe_block(struct acpi_gpe_bl=
ock_info *gpe_block)
 		if (gpe_block->next) {
 			gpe_block->next->previous =3D gpe_block->previous;
 		}
-		acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+		raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	}
=20
 	acpi_current_gpe_count -=3D gpe_block->gpe_count;
diff --git a/drivers/acpi/acpica/evgpeutil.c b/drivers/acpi/acpica/evgpeuti=
l.c
index 80a81d0..895b68ab 100644
--- a/drivers/acpi/acpica/evgpeutil.c
+++ b/drivers/acpi/acpica/evgpeutil.c
@@ -70,7 +70,7 @@ acpi_ev_walk_gpe_list(acpi_gpe_callback gpe_walk_callback=
, void *context)
=20
 	ACPI_FUNCTION_TRACE(ev_walk_gpe_list);
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
=20
 	/* Walk the interrupt level descriptor list */
=20
@@ -101,7 +101,7 @@ acpi_ev_walk_gpe_list(acpi_gpe_callback gpe_walk_callba=
ck, void *context)
 	}
=20
       unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
=20
@@ -237,7 +237,7 @@ struct acpi_gpe_xrupt_info *acpi_ev_get_gpe_xrupt_block=
(u32 interrupt_number)
=20
 	/* Install new interrupt descriptor with spin lock */
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
 	if (acpi_gbl_gpe_xrupt_list_head) {
 		next_gpe_xrupt =3D acpi_gbl_gpe_xrupt_list_head;
 		while (next_gpe_xrupt->next) {
@@ -249,7 +249,7 @@ struct acpi_gpe_xrupt_info *acpi_ev_get_gpe_xrupt_block=
(u32 interrupt_number)
 	} else {
 		acpi_gbl_gpe_xrupt_list_head =3D gpe_xrupt;
 	}
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
=20
 	/* Install new interrupt handler if not SCI_INT */
=20
@@ -306,7 +306,7 @@ acpi_status acpi_ev_delete_gpe_xrupt(struct acpi_gpe_xr=
upt_info *gpe_xrupt)
=20
 	/* Unlink the interrupt block with lock */
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
 	if (gpe_xrupt->previous) {
 		gpe_xrupt->previous->next =3D gpe_xrupt->next;
 	} else {
@@ -318,7 +318,7 @@ acpi_status acpi_ev_delete_gpe_xrupt(struct acpi_gpe_xr=
upt_info *gpe_xrupt)
 	if (gpe_xrupt->next) {
 		gpe_xrupt->next->previous =3D gpe_xrupt->previous;
 	}
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
=20
 	/* Free the block */
=20
diff --git a/drivers/acpi/acpica/evxface.c b/drivers/acpi/acpica/evxface.c
index e114140..e849c10 100644
--- a/drivers/acpi/acpica/evxface.c
+++ b/drivers/acpi/acpica/evxface.c
@@ -750,7 +750,7 @@ acpi_install_gpe_handler(acpi_handle gpe_device,
 		goto unlock_and_exit;
 	}
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
=20
 	/* Ensure that we have a valid GPE number */
=20
@@ -798,14 +798,14 @@ acpi_install_gpe_handler(acpi_handle gpe_device,
 	    ~(ACPI_GPE_XRUPT_TYPE_MASK | ACPI_GPE_DISPATCH_MASK);
 	gpe_event_info->flags |=3D (u8) (type | ACPI_GPE_DISPATCH_HANDLER);
=20
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
=20
 unlock_and_exit:
 	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
 	return_ACPI_STATUS(status);
=20
 free_and_exit:
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	ACPI_FREE(handler);
 	goto unlock_and_exit;
 }
@@ -852,7 +852,7 @@ acpi_remove_gpe_handler(acpi_handle gpe_device,
 		return_ACPI_STATUS(status);
 	}
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
=20
 	/* Ensure that we have a valid GPE number */
=20
@@ -903,7 +903,7 @@ acpi_remove_gpe_handler(acpi_handle gpe_device,
 	ACPI_FREE(handler);
=20
 unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
=20
 	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
 	return_ACPI_STATUS(status);
diff --git a/drivers/acpi/acpica/evxfgpe.c b/drivers/acpi/acpica/evxfgpe.c
index 52aaff3..ce07ebb 100644
--- a/drivers/acpi/acpica/evxfgpe.c
+++ b/drivers/acpi/acpica/evxfgpe.c
@@ -121,7 +121,7 @@ acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32=
 gpe_number)
=20
 	ACPI_FUNCTION_TRACE(acpi_enable_gpe);
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
=20
 	/* Ensure that we have a valid GPE number */
=20
@@ -130,7 +130,7 @@ acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32=
 gpe_number)
 		status =3D acpi_ev_add_gpe_reference(gpe_event_info);
 	}
=20
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 ACPI_EXPORT_SYMBOL(acpi_enable_gpe)
@@ -158,7 +158,7 @@ acpi_status acpi_disable_gpe(acpi_handle gpe_device, u3=
2 gpe_number)
=20
 	ACPI_FUNCTION_TRACE(acpi_disable_gpe);
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
=20
 	/* Ensure that we have a valid GPE number */
=20
@@ -167,7 +167,7 @@ acpi_status acpi_disable_gpe(acpi_handle gpe_device, u3=
2 gpe_number)
 		status =3D acpi_ev_remove_gpe_reference(gpe_event_info) ;
 	}
=20
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 ACPI_EXPORT_SYMBOL(acpi_disable_gpe)
@@ -214,7 +214,7 @@ acpi_setup_gpe_for_wake(acpi_handle wake_device,
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
=20
 	/* Ensure that we have a valid GPE number */
=20
@@ -270,7 +270,7 @@ acpi_setup_gpe_for_wake(acpi_handle wake_device,
 	status =3D AE_OK;
=20
  unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 ACPI_EXPORT_SYMBOL(acpi_setup_gpe_for_wake)
@@ -300,7 +300,7 @@ acpi_status acpi_set_gpe_wake_mask(acpi_handle gpe_devi=
ce, u32 gpe_number, u8 ac
=20
 	ACPI_FUNCTION_TRACE(acpi_set_gpe_wake_mask);
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
=20
 	/*
 	 * Ensure that we have a valid GPE number and that this GPE is in
@@ -346,7 +346,7 @@ acpi_status acpi_set_gpe_wake_mask(acpi_handle gpe_devi=
ce, u32 gpe_number, u8 ac
 	}
=20
 unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
=20
@@ -372,7 +372,7 @@ acpi_status acpi_clear_gpe(acpi_handle gpe_device, u32 =
gpe_number)
=20
 	ACPI_FUNCTION_TRACE(acpi_clear_gpe);
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
=20
 	/* Ensure that we have a valid GPE number */
=20
@@ -385,7 +385,7 @@ acpi_status acpi_clear_gpe(acpi_handle gpe_device, u32 =
gpe_number)
 	status =3D acpi_hw_clear_gpe(gpe_event_info);
=20
       unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
=20
@@ -415,7 +415,7 @@ acpi_get_gpe_status(acpi_handle gpe_device,
=20
 	ACPI_FUNCTION_TRACE(acpi_get_gpe_status);
=20
-	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
=20
 	/* Ensure that we have a valid GPE number */
=20
@@ -433,7 +433,7 @@ acpi_get_gpe_status(acpi_handle gpe_device,
 		*event_status |=3D ACPI_EVENT_FLAG_HANDLE;
=20
       unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
=20
diff --git a/drivers/acpi/acpica/hwregs.c b/drivers/acpi/acpica/hwregs.c
index 55accb7..4772930 100644
--- a/drivers/acpi/acpica/hwregs.c
+++ b/drivers/acpi/acpica/hwregs.c
@@ -263,7 +263,7 @@ acpi_status acpi_hw_clear_acpi_status(void)
 			  ACPI_BITMASK_ALL_FIXED_STATUS,
 			  ACPI_FORMAT_UINT64(acpi_gbl_xpm1a_status.address)));
=20
-	lock_flags =3D acpi_os_acquire_lock(acpi_gbl_hardware_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_hardware_lock, lock_flags);
=20
 	/* Clear the fixed events in PM1 A/B */
=20
@@ -278,7 +278,7 @@ acpi_status acpi_hw_clear_acpi_status(void)
 	status =3D acpi_ev_walk_gpe_list(acpi_hw_clear_gpe_block, NULL);
=20
       unlock_and_exit:
-	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_hardware_lock, lock_flags);
 	return_ACPI_STATUS(status);
 }
=20
diff --git a/drivers/acpi/acpica/hwxface.c b/drivers/acpi/acpica/hwxface.c
index f75f81a..76159ba 100644
--- a/drivers/acpi/acpica/hwxface.c
+++ b/drivers/acpi/acpica/hwxface.c
@@ -386,7 +386,7 @@ acpi_status acpi_write_bit_register(u32 register_id, u3=
2 value)
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}
=20
-	lock_flags =3D acpi_os_acquire_lock(acpi_gbl_hardware_lock);
+	raw_spin_lock_irqsave(&acpi_gbl_hardware_lock, lock_flags);
=20
 	/*
 	 * At this point, we know that the parent register is one of the
@@ -447,7 +447,7 @@ acpi_status acpi_write_bit_register(u32 register_id, u3=
2 value)
=20
 unlock_and_exit:
=20
-	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
+	raw_spin_unlock_irqrestore(&acpi_gbl_hardware_lock, lock_flags);
 	return_ACPI_STATUS(status);
 }
=20
diff --git a/drivers/acpi/acpica/utmutex.c b/drivers/acpi/acpica/utmutex.c
index 7d797e2..420eecf 100644
--- a/drivers/acpi/acpica/utmutex.c
+++ b/drivers/acpi/acpica/utmutex.c
@@ -52,6 +52,9 @@ static acpi_status acpi_ut_create_mutex(acpi_mutex_handle=
 mutex_id);
=20
 static void acpi_ut_delete_mutex(acpi_mutex_handle mutex_id);
=20
+DEFINE_RAW_SPINLOCK(acpi_gbl_gpe_lock);
+DEFINE_RAW_SPINLOCK(acpi_gbl_hardware_lock);
+
 /*************************************************************************=
******
  *
  * FUNCTION:    acpi_ut_mutex_initialize
@@ -81,18 +84,6 @@ acpi_status acpi_ut_mutex_initialize(void)
 		}
 	}
=20
-	/* Create the spinlocks for use at interrupt level */
-
-	status =3D acpi_os_create_lock (&acpi_gbl_gpe_lock);
-	if (ACPI_FAILURE (status)) {
-		return_ACPI_STATUS (status);
-	}
-
-	status =3D acpi_os_create_lock (&acpi_gbl_hardware_lock);
-	if (ACPI_FAILURE (status)) {
-		return_ACPI_STATUS (status);
-	}
-
 	/* Mutex for _OSI support */
 	status =3D acpi_os_create_mutex(&acpi_gbl_osi_mutex);
 	if (ACPI_FAILURE(status)) {
@@ -132,13 +123,7 @@ void acpi_ut_mutex_terminate(void)
=20
 	acpi_os_delete_mutex(acpi_gbl_osi_mutex);
=20
-	/* Delete the spinlocks */
-
-	acpi_os_delete_lock(acpi_gbl_gpe_lock);
-	acpi_os_delete_lock(acpi_gbl_hardware_lock);
-
 	/* Delete the reader/writer lock */
-
 	acpi_ut_delete_rw_lock(&acpi_gbl_namespace_rw_lock);
 	return_VOID;
 }
--=20
1.7.7.1



--00GvhwF7k39YY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO2X1rAAoJEIy3vGnGbaoABo0P/27B7BFCi74ZkWRTc7tGs0o3
77MWo3mSrB3PMf2W5pkdpzYeBWpEAJZMY2z7VLbPuTx9VXFROYa/J1njNdqyZpmg
8N30GiTEf7K3oLSsJE42Nd6q9WH4kN3vXcLnKmez+lgC8k5KSOCS6sfJXcx9kynh
xoLKL8QiZUCmjkHJxQBt5c0+ySZuFW5BzI+Cf2magARb812gOKZm+I80HE1B2FGe
rt2JyizkCL1NNuJDxa7h0JSYBpDPa6Dkz4MjrFOSxpUvbEvrdEqRs34Lq9l3AHUe
aeubRr+6++qHNAp9BDZ1hkKDH9uWNS9v3wzKOWevHq9cZK+FZRAVfIPYeba2OZJP
XBKhsCLgQNPjj5y6umdY4pxZxYu5EG4tnUpVeLgTgTXP4k3ecbjDLbpVymwFqazw
Ay8wiCoSdOQ+rTLJOHwnTFSvrJfgYtwO9vFgYh3W+tbh2M5/5xXdhEWgn5lMD0J1
ZQXKBOznnrpJNf2CpCxQ3LT0Mz1JHYTGyoeh/cPMaF7kCtxUYSenB2dxjCvRMhm6
5DlM+U411dx65YcW8qwSykHCl4Ive3Ptw77c8fLyj4ZkCewwYjX+RC9H9muV6rev
RpOBrZchGvWbDTfcdSbp/60Lzm9Lz6cjTAz24cFW4Xyh4znI82uAZHa4IOm2PddH
8Zq8fV19Wh1hqAOZl7aO
=nImy
-----END PGP SIGNATURE-----

--00GvhwF7k39YY--
