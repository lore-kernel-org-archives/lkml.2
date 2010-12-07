Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0LGSNT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 13:13:19 -0500
Received: from mail.perches.com ([173.55.12.10]:2371 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207Ab0LGSNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 13:13:16 -0500
From: Joe Perches <joe@perches.com>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>,
        Matthew Garrett <mjg@redhat.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wmi: Variable renaming and neatening, use printf extension %pUL
Date: Tue,  7 Dec 2010 10:13:13 -0800
Message-Id: <ab6b8fa7000fdb979bc84759627671fbcb9df5b0.1291745536.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8b14d7b22c61f17ccb869e0047d9df6dd9f50a9f
("wmi: use memcmp instead of strncmp to compare GUIDs")
fixed a problem with comparisons of GUIDs, but the problem
stemmed from using guid_string for the variable name when
it was not used as the ascii representation of the guid.

Consistently use guid and guid_string for the binary
and ascii representations.
Use %pUL to format the ascii representations.
Remove local function wmi_gtoa.
Use char not u8 to match the variable type declarations.
Use ARRAY_SIZE instead of magic number.
Align arguments to function declarations.
Remove trailing space from wmi_dump_wdg output.

Reduces size ~1K.

$ size drivers/platform/x86/wmi.o*
   text	   data	    bss	    dec	    hex	filename
   8298	    445	   2016	  10759	   2a07	drivers/platform/x86/wmi.o.new
   9072	    445	   2176	  11693	   2dad	drivers/platform/x86/wmi.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/platform/x86/wmi.c |  109 ++++++++++++++------------------------------
 1 files changed, 34 insertions(+), 75 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index aecd9a9..ebd44b4 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -150,7 +150,7 @@ static int wmi_parse_hexbyte(const u8 *src)
  *
  * Byte swap a binary GUID to match it's real GUID value
  */
-static void wmi_swap_bytes(u8 *src, u8 *dest)
+static void wmi_swap_bytes(char *src, char *dest)
 {
 	int i;
 
@@ -176,7 +176,7 @@ static void wmi_swap_bytes(u8 *src, u8 *dest)
  * Return:  'true'   @dest contains binary GUID
  *          'false'  @dest contents are undefined
  */
-static bool wmi_parse_guid(const u8 *src, u8 *dest)
+static bool wmi_parse_guid(const u8 *src, char *dest)
 {
 	static const int size[] = { 4, 2, 2, 2, 6 };
 	int i, j, v;
@@ -185,7 +185,7 @@ static bool wmi_parse_guid(const u8 *src, u8 *dest)
 		src[18] != '-' || src[23] != '-')
 		return false;
 
-	for (j = 0; j < 5; j++, src++) {
+	for (j = 0; j < ARRAY_SIZE(size); j++, src++) {
 		for (i = 0; i < size[j]; i++, src += 2, *dest++ = v) {
 			v = wmi_parse_hexbyte(src);
 			if (v < 0)
@@ -196,34 +196,6 @@ static bool wmi_parse_guid(const u8 *src, u8 *dest)
 	return true;
 }
 
-/*
- * Convert a raw GUID to the ACII string representation
- */
-static int wmi_gtoa(const char *in, char *out)
-{
-	int i;
-
-	for (i = 3; i >= 0; i--)
-		out += sprintf(out, "%02X", in[i] & 0xFF);
-
-	out += sprintf(out, "-");
-	out += sprintf(out, "%02X", in[5] & 0xFF);
-	out += sprintf(out, "%02X", in[4] & 0xFF);
-	out += sprintf(out, "-");
-	out += sprintf(out, "%02X", in[7] & 0xFF);
-	out += sprintf(out, "%02X", in[6] & 0xFF);
-	out += sprintf(out, "-");
-	out += sprintf(out, "%02X", in[8] & 0xFF);
-	out += sprintf(out, "%02X", in[9] & 0xFF);
-	out += sprintf(out, "-");
-
-	for (i = 10; i <= 15; i++)
-		out += sprintf(out, "%02X", in[i] & 0xFF);
-
-	*out = '\0';
-	return 0;
-}
-
 static bool find_guid(const char *guid_string, struct wmi_block **out)
 {
 	char tmp[16], guid_input[16];
@@ -290,7 +262,9 @@ static acpi_status wmi_method_enable(struct wmi_block *wblock, int enable)
  * Call an ACPI-WMI method
  */
 acpi_status wmi_evaluate_method(const char *guid_string, u8 instance,
-u32 method_id, const struct acpi_buffer *in, struct acpi_buffer *out)
+				u32 method_id,
+				const struct acpi_buffer *in,
+				struct acpi_buffer *out)
 {
 	struct guid_block *block = NULL;
 	struct wmi_block *wblock = NULL;
@@ -348,7 +322,7 @@ EXPORT_SYMBOL_GPL(wmi_evaluate_method);
  * Return the contents of an ACPI-WMI data block to a buffer
  */
 acpi_status wmi_query_block(const char *guid_string, u8 instance,
-struct acpi_buffer *out)
+			    struct acpi_buffer *out)
 {
 	struct guid_block *block = NULL;
 	struct wmi_block *wblock = NULL;
@@ -431,7 +405,7 @@ EXPORT_SYMBOL_GPL(wmi_query_block);
  * Write the contents of the input buffer to an ACPI-WMI data block
  */
 acpi_status wmi_set_block(const char *guid_string, u8 instance,
-const struct acpi_buffer *in)
+			  const struct acpi_buffer *in)
 {
 	struct guid_block *block = NULL;
 	struct wmi_block *wblock = NULL;
@@ -477,25 +451,21 @@ EXPORT_SYMBOL_GPL(wmi_set_block);
 
 static void wmi_dump_wdg(const struct guid_block *g)
 {
-	char guid_string[37];
-
-	wmi_gtoa(g->guid, guid_string);
-
-	pr_info("%s:\n", guid_string);
+	pr_info("%pUL:\n", g->guid);
 	pr_info("\tobject_id: %c%c\n", g->object_id[0], g->object_id[1]);
 	pr_info("\tnotify_id: %02X\n", g->notify_id);
 	pr_info("\treserved: %02X\n", g->reserved);
 	pr_info("\tinstance_count: %d\n", g->instance_count);
-	pr_info("\tflags: %#x ", g->flags);
+	pr_info("\tflags: %#x", g->flags);
 	if (g->flags) {
 		if (g->flags & ACPI_WMI_EXPENSIVE)
-			pr_cont("ACPI_WMI_EXPENSIVE ");
+			pr_cont(" ACPI_WMI_EXPENSIVE");
 		if (g->flags & ACPI_WMI_METHOD)
-			pr_cont("ACPI_WMI_METHOD ");
+			pr_cont(" ACPI_WMI_METHOD");
 		if (g->flags & ACPI_WMI_STRING)
-			pr_cont("ACPI_WMI_STRING ");
+			pr_cont(" ACPI_WMI_STRING");
 		if (g->flags & ACPI_WMI_EVENT)
-			pr_cont("ACPI_WMI_EVENT ");
+			pr_cont(" ACPI_WMI_EVENT");
 	}
 	pr_cont("\n");
 
@@ -545,16 +515,16 @@ static void wmi_notify_debug(u32 value, void *context)
  *
  * Register a handler for events sent to the ACPI-WMI mapper device.
  */
-acpi_status wmi_install_notify_handler(const char *guid,
-wmi_notify_handler handler, void *data)
+acpi_status wmi_install_notify_handler(const char *guid_string,
+				       wmi_notify_handler handler, void *data)
 {
 	struct wmi_block *block;
 	acpi_status status;
 
-	if (!guid || !handler)
+	if (!guid_string || !handler)
 		return AE_BAD_PARAMETER;
 
-	if (!find_guid(guid, &block))
+	if (!find_guid(guid_string, &block))
 		return AE_NOT_EXIST;
 
 	if (block->handler && block->handler != wmi_notify_debug)
@@ -574,15 +544,15 @@ EXPORT_SYMBOL_GPL(wmi_install_notify_handler);
  *
  * Unregister handler for events sent to the ACPI-WMI mapper device.
  */
-acpi_status wmi_remove_notify_handler(const char *guid)
+acpi_status wmi_remove_notify_handler(const char *guid_string)
 {
 	struct wmi_block *block;
 	acpi_status status = AE_OK;
 
-	if (!guid)
+	if (!guid_string)
 		return AE_BAD_PARAMETER;
 
-	if (!find_guid(guid, &block))
+	if (!find_guid(guid_string, &block))
 		return AE_NOT_EXIST;
 
 	if (!block->handler || block->handler == wmi_notify_debug)
@@ -652,16 +622,13 @@ EXPORT_SYMBOL_GPL(wmi_has_guid);
 static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
-	char guid_string[37];
 	struct wmi_block *wblock;
 
 	wblock = dev_get_drvdata(dev);
 	if (!wblock)
 		return -ENOMEM;
 
-	wmi_gtoa(wblock->gblock.guid, guid_string);
-
-	return sprintf(buf, "wmi:%s\n", guid_string);
+	return sprintf(buf, "wmi:%pUL\n", wblock->gblock.guid);
 }
 
 static struct device_attribute wmi_dev_attrs[] = {
@@ -671,8 +638,6 @@ static struct device_attribute wmi_dev_attrs[] = {
 
 static int wmi_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
-	char guid_string[37];
-
 	struct wmi_block *wblock;
 
 	if (add_uevent_var(env, "MODALIAS="))
@@ -682,11 +647,8 @@ static int wmi_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
 	if (!wblock)
 		return -ENOMEM;
 
-	wmi_gtoa(wblock->gblock.guid, guid_string);
-
-	strcpy(&env->buf[env->buflen - 1], "wmi:");
-	memcpy(&env->buf[env->buflen - 1 + 4], guid_string, 36);
-	env->buflen += 40;
+	env->buflen += sprintf(&env->buf[env->buflen - 1],
+			       "wmi:%pUL", wblock->gblock.guid);
 
 	return 0;
 }
@@ -723,7 +685,7 @@ static struct wmi_block *wmi_create_device(const struct guid_block *gblock,
 
 	wblock->dev.class = &wmi_class;
 
-	wmi_gtoa(gblock->guid, guid_string);
+	sprintf(guid_string, "%pUL", gblock->guid);
 	dev_set_name(&wblock->dev, guid_string);
 
 	dev_set_drvdata(&wblock->dev, wblock);
@@ -750,12 +712,12 @@ static void wmi_free_devices(void)
 		device_unregister(&wblock->dev);
 }
 
-static bool guid_already_parsed(const char *guid_string)
+static bool guid_already_parsed(const char *guid)
 {
 	struct wmi_block *wblock;
 
 	list_for_each_entry(wblock, &wmi_block_list, list)
-		if (memcmp(wblock->gblock.guid, guid_string, 16) == 0)
+		if (memcmp(wblock->gblock.guid, guid, 16) == 0)
 			return true;
 
 	return false;
@@ -770,7 +732,6 @@ static acpi_status parse_wdg(acpi_handle handle)
 	union acpi_object *obj;
 	const struct guid_block *gblock;
 	struct wmi_block *wblock;
-	char guid_string[37];
 	acpi_status status;
 	int retval;
 	u32 i, total;
@@ -800,8 +761,8 @@ static acpi_status parse_wdg(acpi_handle handle)
 		  up with a better workaround for the mess then.
 		*/
 		if (guid_already_parsed(gblock[i].guid) == true) {
-			wmi_gtoa(gblock[i].guid, guid_string);
-			pr_info("Skipping duplicate GUID %s\n", guid_string);
+			pr_info("Skipping duplicate GUID %pUL\n",
+				gblock[i].guid);
 			continue;
 		}
 
@@ -835,8 +796,8 @@ out_free_pointer:
  */
 static acpi_status
 acpi_wmi_ec_space_handler(u32 function, acpi_physical_address address,
-		      u32 bits, u64 *value,
-		      void *handler_context, void *region_context)
+			  u32 bits, u64 *value,
+			  void *handler_context, void *region_context)
 {
 	int result = 0, i = 0;
 	u8 temp = 0;
@@ -878,7 +839,6 @@ static void acpi_wmi_notify(struct acpi_device *device, u32 event)
 	struct guid_block *block;
 	struct wmi_block *wblock;
 	struct list_head *p;
-	char guid_string[37];
 
 	list_for_each(p, &wmi_block_list) {
 		wblock = list_entry(p, struct wmi_block, list);
@@ -888,10 +848,9 @@ static void acpi_wmi_notify(struct acpi_device *device, u32 event)
 			(block->notify_id == event)) {
 			if (wblock->handler)
 				wblock->handler(event, wblock->handler_data);
-			if (debug_event) {
-				wmi_gtoa(wblock->gblock.guid, guid_string);
-				pr_info("DEBUG Event GUID: %s\n", guid_string);
-			}
+			if (debug_event)
+				pr_info("DEBUG Event GUID: %pUL\n",
+					wblock->gblock.guid);
 
 			acpi_bus_generate_netlink_event(
 				device->pnp.device_class, dev_name(&device->dev),
-- 
1.7.3.3.398.g0b0cd.dirty

