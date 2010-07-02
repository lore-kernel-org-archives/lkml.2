Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165Ab0GBBk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 21:40:29 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33812 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab0GBBk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 21:40:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=uo21sgbWCsT1i4Z+PQH249FYh03QtcBAV/kW3NPWuSBcOyTCP5HSzmmjXfWbOHNRLz
         7C3v4SqmUSlbUyrROxMJlBuffQ86xqeJ8KbVZZVludiIHKflhgn+5LOdYTeYqmrd6TwX
         4/blm0krO9jTwwPsO5RKe4ETlzkl2DjfTaUmw=
Subject: [PATCH] fujitsu-laptop: remove unnecessary input_free_device calls
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Matthew Garrett <mjg@redhat.com>, Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>, Andi Kleen <ak@linux.intel.com>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Fri, 02 Jul 2010 09:42:57 +0800
Message-Id: <1278034977.24246.6.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

input_free_device should only be used if input_register_device()
was not called yet or if it failed.
This patch removes unnecessary input_free_device calls.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/fujitsu-laptop.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index e325aeb..dab1a0e 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -686,8 +686,10 @@ static int acpi_fujitsu_add(struct acpi_device *device)
 	set_bit(KEY_UNKNOWN, input->keybit);
 
 	error = input_register_device(input);
-	if (error)
-		goto err_free_input_dev;
+	if (error) {
+		input_free_device(input);
+		goto err_stop;
+	}
 
 	result = acpi_bus_get_power(fujitsu->acpi_handle, &state);
 	if (result) {
@@ -725,8 +727,6 @@ static int acpi_fujitsu_add(struct acpi_device *device)
 
 err_unregister_input_dev:
 	input_unregister_device(input);
-err_free_input_dev:
-	input_free_device(input);
 err_stop:
 	return result;
 }
@@ -737,9 +737,6 @@ static int acpi_fujitsu_remove(struct acpi_device *device, int type)
 	struct input_dev *input = fujitsu->input;
 
 	input_unregister_device(input);
-
-	input_free_device(input);
-
 	fujitsu->acpi_handle = NULL;
 
 	return 0;
@@ -855,8 +852,10 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
 	set_bit(KEY_UNKNOWN, input->keybit);
 
 	error = input_register_device(input);
-	if (error)
-		goto err_free_input_dev;
+	if (error) {
+		input_free_device(input);
+		goto err_free_fifo;
+	}
 
 	result = acpi_bus_get_power(fujitsu_hotkey->acpi_handle, &state);
 	if (result) {
@@ -930,8 +929,6 @@ static int acpi_fujitsu_hotkey_add(struct acpi_device *device)
 
 err_unregister_input_dev:
 	input_unregister_device(input);
-err_free_input_dev:
-	input_free_device(input);
 err_free_fifo:
 	kfifo_free(&fujitsu_hotkey->fifo);
 err_stop:
@@ -953,8 +950,6 @@ static int acpi_fujitsu_hotkey_remove(struct acpi_device *device, int type)
 
 	input_unregister_device(input);
 
-	input_free_device(input);
-
 	kfifo_free(&fujitsu_hotkey->fifo);
 
 	fujitsu_hotkey->acpi_handle = NULL;
-- 
1.5.4.3



