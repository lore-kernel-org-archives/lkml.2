Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab1DQQfN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 12:35:13 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:43914 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751041Ab1DQQfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 12:35:09 -0400
Date: Sun, 17 Apr 2011 18:35:30 +0200
From: Pascal Dormeau <pdormeau@free.fr>
To: linux-kernel@vger.kernel.org
Subject: Re: [Bug #31872] boot panic unless acpi=off, Thread overran stack,
 or stack corrupted - Toshiba Satellite/mobile P4
Message-Id: <20110417183530.b36689c9.pdormeau@free.fr>
In-Reply-To: <IqJL5EkbqD.A.z9E.W4uqNB@chimera>
References: <sam8u5dLkaB.A.afE.53uqNB@chimera>
	<IqJL5EkbqD.A.z9E.W4uqNB@chimera>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Apr 2011 15:52:13 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.37 and 2.6.38.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.37 and 2.6.38.  Please verify if it still
> should be listed and let the tracking team know (either way).

As I indicated in the bugzilla, the problem arose after:
commit bf325f9538d8c89312be305b9779edbcb436af00
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Thu Nov 25 00:10:44 2010 +0100

    ACPI / PM: Register power resource devices as soon as they are
    needed

    Depending on the organization of the ACPI namespace, power resource
    device objects may generally be scanned after the "regular" device
    objects that they are referred from through _PRn.  This, in turn,
    may cause acpi_bus_get_power_flags() to attempt to access them
    through acpi_bus_init_power() before they are registered (and
    initialized by acpi_power_driver).  [This is not a theoretical
    issue, it actually happens for one PnP device on my testbed HP
     nx6325.]

    To fix this problem, make acpi_bus_get_power_flags() attempt to
    register power resource devices as soon as they have been found in
    the _PRn output for any other devices.

    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Signed-off-by: Len Brown <len.brown@intel.com>

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 2951a27..cb7956c 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -847,6 +847,8 @@ end:
    return 0;
 }
 
+static void acpi_bus_add_power_resource(acpi_handle handle);
+
 static int acpi_bus_get_power_flags(struct acpi_device *device)
 {
    acpi_status status = 0;
@@ -875,8 +877,12 @@ static int acpi_bus_get_power_flags(struct
acpi_device *device) acpi_evaluate_reference(device->handle,
object_name, NULL, &ps->resources);
        if (ps->resources.count) {
+           int j;
+
            device->power.flags.power_resources = 1;
            ps->flags.valid = 1;
+           for (j = 0; j < ps->resources.count; j++)
+               acpi_bus_add_power_resource(ps->resources.handles[j]);
        }
 
        /* Evaluate "_PSx" to see if we can do explicit sets */
@@ -1323,6 +1329,20 @@ end:
 #define ACPI_STA_DEFAULT (ACPI_STA_DEVICE_PRESENT |
ACPI_STA_DEVICE_ENABLED | \ ACPI_STA_DEVICE_UI      |
ACPI_STA_DEVICE_FUNCTIONING) 
+static void acpi_bus_add_power_resource(acpi_handle handle)
+{
+   struct acpi_bus_ops ops = {
+       .acpi_op_add = 1,
+       .acpi_op_start = 1,
+   };
+   struct acpi_device *device = NULL;
+
+   acpi_bus_get_device(handle, &device);
+   if (!device)
+       acpi_add_single_object(&device, handle, ACPI_BUS_TYPE_POWER,
+                   ACPI_STA_DEFAULT, &ops);
+}
+
 static int acpi_bus_type_and_status(acpi_handle handle, int *type,
                    unsigned long long *sta)
 {

I could build and run a 2.6.38 kernel with the above commit reverted.
It boots with no problem (with acpi support).

Today, I tested kernel from current linux-2.6 tree and the problem is
still there.
I don't have a clue where to start from to help debugging this.

Regards

Pascal Dormeau


> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=31872
> Subject		: boot panic unless acpi=off, Thread overran
> stack, or stack corrupted - Toshiba Satellite/mobile P4
> Submitter	: Pascal Dormeau <pdormeau@free.fr>
> Date		: 2011-03-25 20:17 (24 days old)
> 
> 
