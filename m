Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab0HPRge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 13:36:34 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:52053 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752725Ab0HPRgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 13:36:33 -0400
X-Greylist: delayed 1266 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Aug 2010 13:36:32 EDT
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <201008161711.o7GHBw0x007457@mercury.physics.adelaide.edu.au>
Subject: Re: [PATCH 15/16] drivers/platform/x86: Use available error codes
To: julia@diku.dk (Julia Lawall)
Date: Tue, 17 Aug 2010 02:41:57 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
        mjg@redhat.com (Matthew Garrett), platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.1008161828350.19313@ask.diku.dk> from "Julia Lawall" at Aug 16, 2010 06:28:52 PM
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've had a quick look at this and the idea behind it is sound.  While it
does change the symantics as noted in the original post, the change is only
in an error path and to my eye the error code should be returned in that
case - as the code currently stands a 0 is returned even if ENOMEM has
occurred.

It seems to me that error and result have been (wrongly) used interchangedly
within these two functions (possibly be different authors).  I agree that
one of them should be eliminated, and error seems the sensible choice.  So
something like the following is probably in order.

===

An error code is stored in the variable error, but it is the variable result
that is returned instead.  So store the error code in result and eliminate
the unnecessary variable error.  Initial report and patch from Julia Lawall
<julia@diku.dk>.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
local idexpression x;
constant C;
@@

if (...) { ...
  x = -C
  ... when != x
(
  return <+...x...+>;
|
  return NULL;
|
  return;
|
* return ...;
)
}
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>

--- a/drivers/platform/x86/fujitsu-laptop.c	2010-03-16 02:39:39.000000000 +1030
+++ b/drivers/platform/x86/fujitsu-laptop.c	2010-08-17 02:37:18.556779664 +0930
@@ -655,7 +655,6 @@
 	int result = 0;
 	int state = 0;
 	struct input_dev *input;
-	int error;
 
 	if (!device)
 		return -EINVAL;
@@ -667,7 +666,7 @@
 
 	fujitsu->input = input = input_allocate_device();
 	if (!input) {
-		error = -ENOMEM;
+		result = -ENOMEM;
 		goto err_stop;
 	}
 
@@ -684,8 +683,8 @@
 	set_bit(KEY_BRIGHTNESSDOWN, input->keybit);
 	set_bit(KEY_UNKNOWN, input->keybit);
 
-	error = input_register_device(input);
-	if (error)
+	result = input_register_device(input);
+	if (result)
 		goto err_free_input_dev;
 
 	result = acpi_bus_get_power(fujitsu->acpi_handle, &state);
@@ -810,7 +809,6 @@
 	int result = 0;
 	int state = 0;
 	struct input_dev *input;
-	int error;
 	int i;
 
 	if (!device)
@@ -824,16 +822,16 @@
 
 	/* kfifo */
 	spin_lock_init(&fujitsu_hotkey->fifo_lock);
-	error = kfifo_alloc(&fujitsu_hotkey->fifo, RINGBUFFERSIZE * sizeof(int),
+	result = kfifo_alloc(&fujitsu_hotkey->fifo, RINGBUFFERSIZE * sizeof(int),
 			GFP_KERNEL);
-	if (error) {
+	if (result) {
 		printk(KERN_ERR "kfifo_alloc failed\n");
 		goto err_stop;
 	}
 
 	fujitsu_hotkey->input = input = input_allocate_device();
 	if (!input) {
-		error = -ENOMEM;
+		result = -ENOMEM;
 		goto err_free_fifo;
 	}
 
@@ -853,8 +851,8 @@
 	set_bit(fujitsu->keycode4, input->keybit);
 	set_bit(KEY_UNKNOWN, input->keybit);
 
-	error = input_register_device(input);
-	if (error)
+	result = input_register_device(input);
+	if (result)
 		goto err_free_input_dev;
 
 	result = acpi_bus_get_power(fujitsu_hotkey->acpi_handle, &state);
