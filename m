Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032155Ab2CPXia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:38:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39045 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946128Ab2CPXiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:38:19 -0400
Message-Id: <20120316233448.615147556@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:35:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ike Panhc <ike.pan@canonical.com>,
        Matthew Garrett <mjg@redhat.com>, Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 15/38] acer-wmi: No wifi rfkill on Lenovo machines
In-Reply-To: <20120316233422.GA5461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ike Panhc <ike.pan@canonical.com>

commit 461e74377cfcfc2c0d6bbdfa8fc5fbc21b052c2a upstream.

We have several reports which says acer-wmi is loaded on ideapads
and register rfkill for wifi which can not be unblocked.

Since ideapad-laptop also register rfkill for wifi and it works
reliably, it will be fine acer-wmi is not going to register rfkill
for wifi once VPC2004 is found.

Also put IBM0068/LEN0068 in the list. Though thinkpad_acpi has no
wifi rfkill capability, there are reports which says acer-wmi also
block wireless on Thinkpad E520/E420.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/platform/x86/acer-wmi.c |   30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -676,6 +676,32 @@ static acpi_status AMW0_find_mailled(voi
 	return AE_OK;
 }
 
+static int AMW0_set_cap_acpi_check_device_found;
+
+static acpi_status AMW0_set_cap_acpi_check_device_cb(acpi_handle handle,
+	u32 level, void *context, void **retval)
+{
+	AMW0_set_cap_acpi_check_device_found = 1;
+	return AE_OK;
+}
+
+static const struct acpi_device_id norfkill_ids[] = {
+	{ "VPC2004", 0},
+	{ "IBM0068", 0},
+	{ "LEN0068", 0},
+	{ "", 0},
+};
+
+static int AMW0_set_cap_acpi_check_device(void)
+{
+	const struct acpi_device_id *id;
+
+	for (id = norfkill_ids; id->id[0]; id++)
+		acpi_get_devices(id->id, AMW0_set_cap_acpi_check_device_cb,
+				NULL, NULL);
+	return AMW0_set_cap_acpi_check_device_found;
+}
+
 static acpi_status AMW0_set_capabilities(void)
 {
 	struct wmab_args args;
@@ -689,7 +715,9 @@ static acpi_status AMW0_set_capabilities
 	 * work.
 	 */
 	if (wmi_has_guid(AMW0_GUID2)) {
-		interface->capability |= ACER_CAP_WIRELESS;
+		if ((quirks != &quirk_unknown) ||
+		    !AMW0_set_cap_acpi_check_device())
+			interface->capability |= ACER_CAP_WIRELESS;
 		return AE_OK;
 	}
 


