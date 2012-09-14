Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263Ab2INA2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 20:28:40 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:24592 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab2INA2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 20:28:38 -0400
Message-ID: <1347582132.3569.13.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI: Enable SCI_EMULATE to manually simulate physical
 hotplug testing.
From: Toshi Kani <toshi.kani@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ashok Raj <ashok.raj@intel.com>
Date: Thu, 13 Sep 2012 18:22:12 -0600
In-Reply-To: <1346794495.4732.221.camel@misato.fc.hp.com>
References: <1346707623-31476-1-git-send-email-yinghai@kernel.org>
	 <1346776024.4732.196.camel@misato.fc.hp.com>
	 <CAE9FiQXN1kDwSPTH5UWvDPbrtqGgcEKR4dWwYrP57H4aSA-UMA@mail.gmail.com>
	 <1346794495.4732.221.camel@misato.fc.hp.com>
Content-Type: multipart/mixed; boundary="=-9GC13nXKRrnpgBHzmF7/"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9GC13nXKRrnpgBHzmF7/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

> > >> +
> > >> +     /*
> > >> +      * Check for internal object and make sure there is a handler
> > >> +      * registered for this object
> > >> +      */
> > >> +     obj_desc = acpi_ns_get_attached_object(node);
> > >> +     if (obj_desc) {
> > >> +             if (obj_desc->common_notify.notify_list[0]) {
> > >
> > > Is the above check necessary?  acpi_ev_queue_notify_request() sets up to
> > > call the global handler, acpi_gbl_global_notify[0], even if the object
> > > does not have a local handler registered.
> > 
> > Not sure.
> > 
> > maybe Len or other acpi guyes could answer your questions.
> 
> I think this check should be removed, but would like someone to
> verify...


Hi Yinghai,

Attached is my suggested update to your patch. It allows a SCI to be
sent to any object, and therefore can be used for testing the global
notify handler. Some drivers such as dock.c only register their handler
to the global notify handler. I also made a few minor changes. I have
been testing with this update and it is working fine. I like this
feature, so I hope we can make progress with this update.

Thanks,
-Toshi

--=-9GC13nXKRrnpgBHzmF7/
Content-Disposition: attachment;
	filename="0001-ACPI-Update-CONFIG_ACPI_SCI_EMULATE-patch.patch"
Content-Type: text/x-patch; name="0001-ACPI-Update-CONFIG_ACPI_SCI_EMULATE-patch.patch";
	charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 2bd8a7998696c413dcc0bea089d7d9f8e548afcd Mon Sep 17 00:00:00 2001
From: Toshi Kani <toshi.kani@hp.com>
Date: Thu, 13 Sep 2012 17:45:38 -0600
Subject: [PATCH] ACPI: Update CONFIG_ACPI_SCI_EMULATE patch

---
 drivers/acpi/sci_emu.c |   47 +++++++++++++++--------------------------------
 1 files changed, 15 insertions(+), 32 deletions(-)

diff --git a/drivers/acpi/sci_emu.c b/drivers/acpi/sci_emu.c
index 2f13ca1..efa0f6a 100644
--- a/drivers/acpi/sci_emu.c
+++ b/drivers/acpi/sci_emu.c
@@ -23,16 +23,12 @@ static struct dentry *sci_notify_dentry;
 static void sci_notify_client(char *acpi_name, u32 event)
 {
 	struct acpi_namespace_node *node;
-	acpi_status status, status1;
-	acpi_handle hlsb, hsb;
-	union acpi_operand_object *obj_desc;
-
-	status = acpi_get_handle(NULL, "\\_SB", &hsb);
-	status1 = acpi_get_handle(hsb, acpi_name, &hlsb);
-	if (ACPI_FAILURE(status) || ACPI_FAILURE(status1)) {
-		pr_err(PREFIX
-	"acpi getting handle to <\\_SB.%s> failed inside notify_client\n",
-			acpi_name);
+	acpi_status status;
+	acpi_handle handle;
+
+	status = acpi_get_handle(NULL, acpi_name, &handle);
+	if (ACPI_FAILURE(status)) {
+		pr_err(PREFIX "Invalid ACPI device name <%s>\n", acpi_name);
 		return;
 	}
 
@@ -42,7 +38,7 @@ static void sci_notify_client(char *acpi_name, u32 event)
 		return;
 	}
 
-	node = acpi_ns_validate_handle(hlsb);
+	node = acpi_ns_validate_handle(handle);
 	if (!node) {
 		acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
 		pr_err(PREFIX "Mapping handle to node failed\n");
@@ -50,29 +46,16 @@ static void sci_notify_client(char *acpi_name, u32 event)
 	}
 
 	/*
-	 * Check for internal object and make sure there is a handler
-	 * registered for this object
+	 * Release the lock and queue the item for later
+	 * exectuion
 	 */
-	obj_desc = acpi_ns_get_attached_object(node);
-	if (obj_desc) {
-		if (obj_desc->common_notify.notify_list[0]) {
-			/*
-			 * Release the lock and queue the item for later
-			 * exectuion
-			 */
-			acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
-			status = acpi_ev_queue_notify_request(node, event);
-			if (ACPI_FAILURE(status))
-				pr_err(PREFIX "acpi_ev_queue_notify_request failed\n");
-			else
-				pr_info(PREFIX "Notify event is queued\n");
-			return;
-		}
-	} else {
-		pr_info(PREFIX "Notify handler not registered for this device\n");
-	}
-
 	acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
+	status = acpi_ev_queue_notify_request(node, event);
+	if (ACPI_FAILURE(status))
+		pr_err(PREFIX "acpi_ev_queue_notify_request failed\n");
+	else
+		pr_info(PREFIX "Notify event is queued\n");
+
 	return;
 }
 
-- 
1.7.7.6


--=-9GC13nXKRrnpgBHzmF7/--

