Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515Ab2CUBcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 21:32:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7316 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133Ab2CUBcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 21:32:02 -0400
X-Authority-Analysis: v=2.0 cv=d9t3OGfE c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=VwQbUJbxAAAA:8 a=aQJyAL91xNMBMNrjV8YA:9 a=4bSRmuNZrrZWH2eIgYMA:7 a=PUjeQqilurYA:10 a=uBUnZITvTVmzaNPa:21 a=0e9NHVZ4bKx4By-z:21 a=K2UANjU77ReV3YYfb64A:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332293515.23924.23.camel@gandalf.stny.rr.com>
Subject: [ANNOUNCE] 3.0.24-rt42
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>
Date: Tue, 20 Mar 2012 21:31:55 -0400
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-xdbmxk+m6dO+iU7RITLX"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xdbmxk+m6dO+iU7RITLX
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Dear RT Folks,

I'm pleased to announce the 3.0.24-rt42 stable release.

This is also a special release. As special as the date of 11/11/11, or
the kernel release of 3.0. That is, nothing special with the content,
but he number has meaning. This is the RT release with the answer to the
universe. Now it's up to the realtime maintainers to come up with the
question ;-)

Also, this 3.0 version is almost a palindrome: 24-rt42


You can get this release via the git tree at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rt/linux-stable-rt.git

  Head SHA1: b503b58bfe89fed3b61009b7acd981b50ff384b5


Or to build 3.0.24-rt42 directly, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v3.0/linux-3.0.tar.xz

  http://www.kernel.org/pub/linux/kernel/v3.0/patch-3.0.24.xz

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/patch-3.0.24-rt42.=
patch.xz


You can also build from 3.0.24-rt41 by applying the incremental patch:

  http://www.kernel.org/pub/linux/kernel/projects/rt/3.0/incr/patch-3.0.24-=
rt41-rt42.patch.xz



Enjoy,

-- Steve


Changes from 3.0.24-rt41:

---

Steven Rostedt (2):
      rt: Revert: acpi: Make gbl_[hardware|gpe]_lock raw
      Linux 3.0.24-rt42

----
 drivers/acpi/acpica/acglobal.h  |    4 ++--
 drivers/acpi/acpica/evgpe.c     |    4 ++--
 drivers/acpi/acpica/evgpeblk.c  |    8 ++++----
 drivers/acpi/acpica/evgpeutil.c |   12 ++++++------
 drivers/acpi/acpica/evxface.c   |   10 +++++-----
 drivers/acpi/acpica/evxfgpe.c   |   24 ++++++++++++------------
 drivers/acpi/acpica/hwregs.c    |    4 ++--
 drivers/acpi/acpica/hwxface.c   |    4 ++--
 drivers/acpi/acpica/utmutex.c   |   21 ++++++++++++++++++---
 localversion-rt                 |    2 +-
 10 files changed, 54 insertions(+), 39 deletions(-)
---------------------------
diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.=
h
index 6c169a2..73863d8 100644
--- a/drivers/acpi/acpica/acglobal.h
+++ b/drivers/acpi/acpica/acglobal.h
@@ -229,8 +229,8 @@ ACPI_EXTERN u8 acpi_gbl_global_lock_pending;
  * Spinlocks are used for interfaces that can be possibly called at
  * interrupt level
  */
-extern raw_spinlock_t acpi_gbl_gpe_lock;	/* For GPE data structs and regis=
ters */
-extern raw_spinlock_t acpi_gbl_hardware_lock;	/* For ACPI H/W except GPE r=
egisters */
+ACPI_EXTERN acpi_spinlock acpi_gbl_gpe_lock;	/* For GPE data structs and r=
egisters */
+ACPI_EXTERN acpi_spinlock acpi_gbl_hardware_lock;	/* For ACPI H/W except G=
PE registers */
=20
 /*************************************************************************=
****
  *
diff --git a/drivers/acpi/acpica/evgpe.c b/drivers/acpi/acpica/evgpe.c
index 36e7e10..65c79ad 100644
--- a/drivers/acpi/acpica/evgpe.c
+++ b/drivers/acpi/acpica/evgpe.c
@@ -357,7 +357,7 @@ u32 acpi_ev_gpe_detect(struct acpi_gpe_xrupt_info * gpe=
_xrupt_list)
 	 * Note: Not necessary to obtain the hardware lock, since the GPE
 	 * registers are owned by the gpe_lock.
 	 */
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
=20
 	/* Examine all GPE blocks attached to this interrupt level */
=20
@@ -440,7 +440,7 @@ u32 acpi_ev_gpe_detect(struct acpi_gpe_xrupt_info * gpe=
_xrupt_list)
=20
       unlock_and_exit:
=20
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	return (int_status);
 }
=20
diff --git a/drivers/acpi/acpica/evgpeblk.c b/drivers/acpi/acpica/evgpeblk.=
c
index 60c47b9..ca2c41a 100644
--- a/drivers/acpi/acpica/evgpeblk.c
+++ b/drivers/acpi/acpica/evgpeblk.c
@@ -95,7 +95,7 @@ acpi_ev_install_gpe_block(struct acpi_gpe_block_info *gpe=
_block,
=20
 	/* Install the new block at the end of the list with lock */
=20
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 	if (gpe_xrupt_block->gpe_block_list_head) {
 		next_gpe_block =3D gpe_xrupt_block->gpe_block_list_head;
 		while (next_gpe_block->next) {
@@ -109,7 +109,7 @@ acpi_ev_install_gpe_block(struct acpi_gpe_block_info *g=
pe_block,
 	}
=20
 	gpe_block->xrupt_block =3D gpe_xrupt_block;
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
=20
       unlock_and_exit:
 	status =3D acpi_ut_release_mutex(ACPI_MTX_EVENTS);
@@ -156,7 +156,7 @@ acpi_status acpi_ev_delete_gpe_block(struct acpi_gpe_bl=
ock_info *gpe_block)
 	} else {
 		/* Remove the block on this interrupt with lock */
=20
-		raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+		flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 		if (gpe_block->previous) {
 			gpe_block->previous->next =3D gpe_block->next;
 		} else {
@@ -167,7 +167,7 @@ acpi_status acpi_ev_delete_gpe_block(struct acpi_gpe_bl=
ock_info *gpe_block)
 		if (gpe_block->next) {
 			gpe_block->next->previous =3D gpe_block->previous;
 		}
-		raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+		acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	}
=20
 	acpi_current_gpe_count -=3D gpe_block->gpe_count;
diff --git a/drivers/acpi/acpica/evgpeutil.c b/drivers/acpi/acpica/evgpeuti=
l.c
index 895b68ab..80a81d0 100644
--- a/drivers/acpi/acpica/evgpeutil.c
+++ b/drivers/acpi/acpica/evgpeutil.c
@@ -70,7 +70,7 @@ acpi_ev_walk_gpe_list(acpi_gpe_callback gpe_walk_callback=
, void *context)
=20
 	ACPI_FUNCTION_TRACE(ev_walk_gpe_list);
=20
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
=20
 	/* Walk the interrupt level descriptor list */
=20
@@ -101,7 +101,7 @@ acpi_ev_walk_gpe_list(acpi_gpe_callback gpe_walk_callba=
ck, void *context)
 	}
=20
       unlock_and_exit:
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
=20
@@ -237,7 +237,7 @@ struct acpi_gpe_xrupt_info *acpi_ev_get_gpe_xrupt_block=
(u32 interrupt_number)
=20
 	/* Install new interrupt descriptor with spin lock */
=20
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 	if (acpi_gbl_gpe_xrupt_list_head) {
 		next_gpe_xrupt =3D acpi_gbl_gpe_xrupt_list_head;
 		while (next_gpe_xrupt->next) {
@@ -249,7 +249,7 @@ struct acpi_gpe_xrupt_info *acpi_ev_get_gpe_xrupt_block=
(u32 interrupt_number)
 	} else {
 		acpi_gbl_gpe_xrupt_list_head =3D gpe_xrupt;
 	}
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
=20
 	/* Install new interrupt handler if not SCI_INT */
=20
@@ -306,7 +306,7 @@ acpi_status acpi_ev_delete_gpe_xrupt(struct acpi_gpe_xr=
upt_info *gpe_xrupt)
=20
 	/* Unlink the interrupt block with lock */
=20
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
 	if (gpe_xrupt->previous) {
 		gpe_xrupt->previous->next =3D gpe_xrupt->next;
 	} else {
@@ -318,7 +318,7 @@ acpi_status acpi_ev_delete_gpe_xrupt(struct acpi_gpe_xr=
upt_info *gpe_xrupt)
 	if (gpe_xrupt->next) {
 		gpe_xrupt->next->previous =3D gpe_xrupt->previous;
 	}
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
=20
 	/* Free the block */
=20
diff --git a/drivers/acpi/acpica/evxface.c b/drivers/acpi/acpica/evxface.c
index e849c10..e114140 100644
--- a/drivers/acpi/acpica/evxface.c
+++ b/drivers/acpi/acpica/evxface.c
@@ -750,7 +750,7 @@ acpi_install_gpe_handler(acpi_handle gpe_device,
 		goto unlock_and_exit;
 	}
=20
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
=20
 	/* Ensure that we have a valid GPE number */
=20
@@ -798,14 +798,14 @@ acpi_install_gpe_handler(acpi_handle gpe_device,
 	    ~(ACPI_GPE_XRUPT_TYPE_MASK | ACPI_GPE_DISPATCH_MASK);
 	gpe_event_info->flags |=3D (u8) (type | ACPI_GPE_DISPATCH_HANDLER);
=20
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
=20
 unlock_and_exit:
 	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
 	return_ACPI_STATUS(status);
=20
 free_and_exit:
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	ACPI_FREE(handler);
 	goto unlock_and_exit;
 }
@@ -852,7 +852,7 @@ acpi_remove_gpe_handler(acpi_handle gpe_device,
 		return_ACPI_STATUS(status);
 	}
=20
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
=20
 	/* Ensure that we have a valid GPE number */
=20
@@ -903,7 +903,7 @@ acpi_remove_gpe_handler(acpi_handle gpe_device,
 	ACPI_FREE(handler);
=20
 unlock_and_exit:
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
=20
 	(void)acpi_ut_release_mutex(ACPI_MTX_EVENTS);
 	return_ACPI_STATUS(status);
diff --git a/drivers/acpi/acpica/evxfgpe.c b/drivers/acpi/acpica/evxfgpe.c
index ce07ebb..52aaff3 100644
--- a/drivers/acpi/acpica/evxfgpe.c
+++ b/drivers/acpi/acpica/evxfgpe.c
@@ -121,7 +121,7 @@ acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32=
 gpe_number)
=20
 	ACPI_FUNCTION_TRACE(acpi_enable_gpe);
=20
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
=20
 	/* Ensure that we have a valid GPE number */
=20
@@ -130,7 +130,7 @@ acpi_status acpi_enable_gpe(acpi_handle gpe_device, u32=
 gpe_number)
 		status =3D acpi_ev_add_gpe_reference(gpe_event_info);
 	}
=20
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 ACPI_EXPORT_SYMBOL(acpi_enable_gpe)
@@ -158,7 +158,7 @@ acpi_status acpi_disable_gpe(acpi_handle gpe_device, u3=
2 gpe_number)
=20
 	ACPI_FUNCTION_TRACE(acpi_disable_gpe);
=20
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
=20
 	/* Ensure that we have a valid GPE number */
=20
@@ -167,7 +167,7 @@ acpi_status acpi_disable_gpe(acpi_handle gpe_device, u3=
2 gpe_number)
 		status =3D acpi_ev_remove_gpe_reference(gpe_event_info) ;
 	}
=20
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 ACPI_EXPORT_SYMBOL(acpi_disable_gpe)
@@ -214,7 +214,7 @@ acpi_setup_gpe_for_wake(acpi_handle wake_device,
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}
=20
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
=20
 	/* Ensure that we have a valid GPE number */
=20
@@ -270,7 +270,7 @@ acpi_setup_gpe_for_wake(acpi_handle wake_device,
 	status =3D AE_OK;
=20
  unlock_and_exit:
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
 ACPI_EXPORT_SYMBOL(acpi_setup_gpe_for_wake)
@@ -300,7 +300,7 @@ acpi_status acpi_set_gpe_wake_mask(acpi_handle gpe_devi=
ce, u32 gpe_number, u8 ac
=20
 	ACPI_FUNCTION_TRACE(acpi_set_gpe_wake_mask);
=20
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
=20
 	/*
 	 * Ensure that we have a valid GPE number and that this GPE is in
@@ -346,7 +346,7 @@ acpi_status acpi_set_gpe_wake_mask(acpi_handle gpe_devi=
ce, u32 gpe_number, u8 ac
 	}
=20
 unlock_and_exit:
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
=20
@@ -372,7 +372,7 @@ acpi_status acpi_clear_gpe(acpi_handle gpe_device, u32 =
gpe_number)
=20
 	ACPI_FUNCTION_TRACE(acpi_clear_gpe);
=20
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
=20
 	/* Ensure that we have a valid GPE number */
=20
@@ -385,7 +385,7 @@ acpi_status acpi_clear_gpe(acpi_handle gpe_device, u32 =
gpe_number)
 	status =3D acpi_hw_clear_gpe(gpe_event_info);
=20
       unlock_and_exit:
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
=20
@@ -415,7 +415,7 @@ acpi_get_gpe_status(acpi_handle gpe_device,
=20
 	ACPI_FUNCTION_TRACE(acpi_get_gpe_status);
=20
-	raw_spin_lock_irqsave(&acpi_gbl_gpe_lock, flags);
+	flags =3D acpi_os_acquire_lock(acpi_gbl_gpe_lock);
=20
 	/* Ensure that we have a valid GPE number */
=20
@@ -433,7 +433,7 @@ acpi_get_gpe_status(acpi_handle gpe_device,
 		*event_status |=3D ACPI_EVENT_FLAG_HANDLE;
=20
       unlock_and_exit:
-	raw_spin_unlock_irqrestore(&acpi_gbl_gpe_lock, flags);
+	acpi_os_release_lock(acpi_gbl_gpe_lock, flags);
 	return_ACPI_STATUS(status);
 }
=20
diff --git a/drivers/acpi/acpica/hwregs.c b/drivers/acpi/acpica/hwregs.c
index 4772930..55accb7 100644
--- a/drivers/acpi/acpica/hwregs.c
+++ b/drivers/acpi/acpica/hwregs.c
@@ -263,7 +263,7 @@ acpi_status acpi_hw_clear_acpi_status(void)
 			  ACPI_BITMASK_ALL_FIXED_STATUS,
 			  ACPI_FORMAT_UINT64(acpi_gbl_xpm1a_status.address)));
=20
-	raw_spin_lock_irqsave(&acpi_gbl_hardware_lock, lock_flags);
+	lock_flags =3D acpi_os_acquire_lock(acpi_gbl_hardware_lock);
=20
 	/* Clear the fixed events in PM1 A/B */
=20
@@ -278,7 +278,7 @@ acpi_status acpi_hw_clear_acpi_status(void)
 	status =3D acpi_ev_walk_gpe_list(acpi_hw_clear_gpe_block, NULL);
=20
       unlock_and_exit:
-	raw_spin_unlock_irqrestore(&acpi_gbl_hardware_lock, lock_flags);
+	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
 	return_ACPI_STATUS(status);
 }
=20
diff --git a/drivers/acpi/acpica/hwxface.c b/drivers/acpi/acpica/hwxface.c
index 76159ba..f75f81a 100644
--- a/drivers/acpi/acpica/hwxface.c
+++ b/drivers/acpi/acpica/hwxface.c
@@ -386,7 +386,7 @@ acpi_status acpi_write_bit_register(u32 register_id, u3=
2 value)
 		return_ACPI_STATUS(AE_BAD_PARAMETER);
 	}
=20
-	raw_spin_lock_irqsave(&acpi_gbl_hardware_lock, lock_flags);
+	lock_flags =3D acpi_os_acquire_lock(acpi_gbl_hardware_lock);
=20
 	/*
 	 * At this point, we know that the parent register is one of the
@@ -447,7 +447,7 @@ acpi_status acpi_write_bit_register(u32 register_id, u3=
2 value)
=20
 unlock_and_exit:
=20
-	raw_spin_unlock_irqrestore(&acpi_gbl_hardware_lock, lock_flags);
+	acpi_os_release_lock(acpi_gbl_hardware_lock, lock_flags);
 	return_ACPI_STATUS(status);
 }
=20
diff --git a/drivers/acpi/acpica/utmutex.c b/drivers/acpi/acpica/utmutex.c
index 420eecf..7d797e2 100644
--- a/drivers/acpi/acpica/utmutex.c
+++ b/drivers/acpi/acpica/utmutex.c
@@ -52,9 +52,6 @@ static acpi_status acpi_ut_create_mutex(acpi_mutex_handle=
 mutex_id);
=20
 static void acpi_ut_delete_mutex(acpi_mutex_handle mutex_id);
=20
-DEFINE_RAW_SPINLOCK(acpi_gbl_gpe_lock);
-DEFINE_RAW_SPINLOCK(acpi_gbl_hardware_lock);
-
 /*************************************************************************=
******
  *
  * FUNCTION:    acpi_ut_mutex_initialize
@@ -84,6 +81,18 @@ acpi_status acpi_ut_mutex_initialize(void)
 		}
 	}
=20
+	/* Create the spinlocks for use at interrupt level */
+
+	status =3D acpi_os_create_lock (&acpi_gbl_gpe_lock);
+	if (ACPI_FAILURE (status)) {
+		return_ACPI_STATUS (status);
+	}
+
+	status =3D acpi_os_create_lock (&acpi_gbl_hardware_lock);
+	if (ACPI_FAILURE (status)) {
+		return_ACPI_STATUS (status);
+	}
+
 	/* Mutex for _OSI support */
 	status =3D acpi_os_create_mutex(&acpi_gbl_osi_mutex);
 	if (ACPI_FAILURE(status)) {
@@ -123,7 +132,13 @@ void acpi_ut_mutex_terminate(void)
=20
 	acpi_os_delete_mutex(acpi_gbl_osi_mutex);
=20
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
diff --git a/localversion-rt b/localversion-rt
index 629e0b4..8bdfb9a 100644
--- a/localversion-rt
+++ b/localversion-rt
@@ -1 +1 @@
--rt41
+-rt42


--=-xdbmxk+m6dO+iU7RITLX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPaS+LAAoJEIy3vGnGbaoABbIP/2C9xLRXgUrLlgF32jJ8NWy7
lnplKKQh/8ngIXKbI7fBPse69q+5Ex/pSideIhYBxhq09M5nA3HyW4eYS9Lmbeif
ZRlS77TyZztgeOcRQEOH0q31aVxOOUy6gLR9bob9oMl9C9wdcRHpYe/0rA85G7yo
CVRHaZlZhG7wMoN70nIfDoAlfgDBkyg8Y0ACD84nhsggXvDgV0N0xez5ayewTneM
AM9tvo2MhhKRlvLIcZhACZqmG0AJotV7PZz1svHPciwDqMcIIA9w8CyvVPwXuZBf
Fd/F5xGmlTMfbqAeKLxi1uC12WcQzMfyGYXGkiOsK8OY/mpjgw4ql0PdCNL9n+sV
uqO3KpXGiv7Yo1lVQo38rF7PaNHFglSUIZkfcRy2wKjNjSWSu6qFB2NGvY3L/9UZ
pgNldrgmuYYvIBHLHvACL6KPH6H2z/5pH1a3WBHYpKIz8LtIS97jK08uzOyoO/z2
MpMuhMw91SG9wqzoiAgwhWKKDIosVosa8OVWEKH9cGsBpWHygPtzaaelUhP6Kdig
lAcp6c4QUwU6mXKfe31IFYnAW9rubZLYJwC35gs9HwsT/W+qf+lBtbisjVZzT9B0
AWaQuuMZH3xQhjLfPkAlYu1lSMHxIufMmkV5XmYQLFOjU95oWIo8N8K5uGBcDPPS
JbdGSnOSIkQBCEqor1Ia
=j0Ut
-----END PGP SIGNATURE-----

--=-xdbmxk+m6dO+iU7RITLX--

