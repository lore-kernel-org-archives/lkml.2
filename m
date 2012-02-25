Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756453Ab2BYLx4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 06:53:56 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:54988 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753416Ab2BYLxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 06:53:55 -0500
Message-ID: <4F48CBCF.7060004@metafoo.de>
Date: Sat, 25 Feb 2012 12:53:51 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] USB: create module_usb_serial_driver macro
References: <20120224233814.GA16588@kroah.com>
In-Reply-To: <20120224233814.GA16588@kroah.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2012 12:38 AM, Greg KH wrote:
> Now that Alan Stern has cleaned up the usb serial driver registration,
> we have the ability to create a module_usb_serial_driver macro to make
> things a bit simpler, like the other *_driver macros created.
> 
> But, as we need two functions here, we can't reuse the existing
> module_driver() macro, so we need to roll our own.
> 
> Lars-Peter, or anyone else, am I missing something here and we can use
> module_driver() somehow, or even modify it, to work for subsystems that
> need 2 parameters for their function calls to register/deregister?
> 

I suppose we can make module_driver a variadic macro and pass any additional
parameters to the register and unregister functions. Patch attached.

- Lars

8<-------------------------------------------------------------------->8
>From 0d731970249b787748eccd6e81890c012a44e5a6 Mon Sep 17 00:00:00 2001
From: Lars-Peter Clausen <lars@metafoo.de>
Date: Sat, 25 Feb 2012 11:25:58 +0100
Subject: [PATCH] driver-core: Allow additional parameters for module_driver

Allow module_driver take additional parameters which will be passed to the
register and unregister function calls. This allows it to be used in cases
where additional parameters are required (e.g. usb_serial_register_drivers).

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 include/linux/device.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index b63fb39..bccccef 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1007,19 +1007,20 @@ extern long sysfs_deprecated;
  * @__driver: driver name
  * @__register: register function for this driver type
  * @__unregister: unregister function for this driver type
+ * @...: Additional arguments to be passed to __register and __unregister.
  *
  * Use this macro to construct bus specific macros for registering
  * drivers, and do not use it on its own.
  */
-#define module_driver(__driver, __register, __unregister) \
+#define module_driver(__driver, __register, __unregister, ...) \
 static int __init __driver##_init(void) \
 { \
-	return __register(&(__driver)); \
+	return __register(&(__driver) , ##__VA_ARGS__); \
 } \
 module_init(__driver##_init); \
 static void __exit __driver##_exit(void) \
 { \
-	__unregister(&(__driver)); \
+	__unregister(&(__driver) , ##__VA_ARGS__); \
 } \
 module_exit(__driver##_exit);

-- 
1.7.2.5
