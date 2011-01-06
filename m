Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab1AFWos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:44:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37904 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685Ab1AFWoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:44:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 8/11] ACPI / PM: Check status of power resources under mutexes
Date: Thu, 6 Jan 2011 23:38:57 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <201101062331.17079.rjw@sisk.pl>
In-Reply-To: <201101062331.17079.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101062338.57967.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

It certainly is not a good idea to execute _ON or _OFF and _STA
for the same power resource at the same time which may happen in
some circumstances in theory.  To prevent that from happening,
read the power state of each power resource under its mutex, as
that will prevent the sate from being changed at the same time.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/power.c |   33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

Index: linux-2.6/drivers/acpi/power.c
===================================================================
--- linux-2.6.orig/drivers/acpi/power.c
+++ linux-2.6/drivers/acpi/power.c
@@ -145,9 +145,8 @@ static int acpi_power_get_state(acpi_han
 
 static int acpi_power_get_list_state(struct acpi_handle_list *list, int *state)
 {
-	int result = 0, state1;
-	u32 i = 0;
-
+	int cur_state;
+	int i = 0;
 
 	if (!list || !state)
 		return -EINVAL;
@@ -155,25 +154,33 @@ static int acpi_power_get_list_state(str
 	/* The state of the list is 'on' IFF all resources are 'on'. */
 
 	for (i = 0; i < list->count; i++) {
-		/*
-		 * The state of the power resource can be obtained by
-		 * using the ACPI handle. In such case it is unnecessary to
-		 * get the Power resource first and then get its state again.
-		 */
-		result = acpi_power_get_state(list->handles[i], &state1);
+		struct acpi_power_resource *resource;
+		acpi_handle handle = list->handles[i];
+		int result;
+
+		result = acpi_power_get_context(handle, &resource);
 		if (result)
 			return result;
 
-		*state = state1;
+		mutex_lock(&resource->resource_lock);
 
-		if (*state != ACPI_POWER_RESOURCE_STATE_ON)
+		result = acpi_power_get_state(handle, &cur_state);
+
+		mutex_unlock(&resource->resource_lock);
+
+		if (result)
+			return result;
+
+		if (cur_state != ACPI_POWER_RESOURCE_STATE_ON)
 			break;
 	}
 
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Resource list is %s\n",
-			  *state ? "on" : "off"));
+			  cur_state ? "on" : "off"));
 
-	return result;
+	*state = cur_state;
+
+	return 0;
 }
 
 static int __acpi_power_on(struct acpi_power_resource *resource)

