Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab2GISQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 14:16:54 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48312 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab2GISQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:16:27 -0400
MIME-Version: 1.0
In-Reply-To: <87bojp3hek.fsf@rustcorp.com.au>
References: <CALyZvKyEiTaU4CDh3F-fYkSjyyFkmhjitaWmXs_PORVEeOnirw@mail.gmail.com>
	<87bojp3hek.fsf@rustcorp.com.au>
Date: Mon, 9 Jul 2012 19:16:24 +0100
Message-ID: <CALyZvKxP793Qq5-SHt1ExfivHWhNeMOgVWD6qDsQ0kjEBOA96w@mail.gmail.com>
Subject: Re: [PATCH: 1/1] ACPI: make evaluation of thermal trip points before
 temperature or vice versa dependant on new "temp_b4_trip" module parameter to
 support older AMD x86_64s
From: Jason Vas Dias <jason.vas.dias@gmail.com>
To: Rusty Russell <rusty@ozlabs.org>
Cc: linux-kernel@vger.kernel.org,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
        Comrade DOS <suloevdmitry@gmail.com>
Content-Type: multipart/mixed; boundary=f46d0401730b9e0ade04c4699c42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d0401730b9e0ade04c4699c42
Content-Type: text/plain; charset=UTF-8

Thanks Rusty - sorry I didn't see your email until now - revised patch
addressing your comments attached -
BTW,  sorry about the word wrap on the initial posting - should I
attach a '.patch' file or inline ?  Trying both .

The Revised Patch (against :
commit bd0a521e88aa7a06ae7aabaed7ae196ed4ad867a
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat Jul 7 17:23:56 2012 -0700

    Linux 3.5-rc6
) :
$ git diff bd0a521e88aa7a06ae7aabaed7ae196ed4ad867a >
/tmp/acpi_thermal_temp_b4_trip.patch
$ cat /tmp/acpi_thermal_temp_b4_trip.patch
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 7dbebea..13d3b22 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -96,6 +96,10 @@ static int psv;
 module_param(psv, int, 0644);
 MODULE_PARM_DESC(psv, "Disable or override all passive trip
points.");

+static bool temp_b4_trip;
+module_param(temp_b4_trip, bool, 0644);
+MODULE_PARM_DESC(temp_b4_trip, "Get the temperature before
initializing trip points.");
+
 static int acpi_thermal_add(struct acpi_device *device);
 static int acpi_thermal_remove(struct acpi_device *device, int type);
 static int acpi_thermal_resume(struct acpi_device *device);
@@ -941,27 +945,41 @@ static int acpi_thermal_get_info(struct
acpi_thermal *tz)
        if (!tz)
                return -EINVAL;

-       /* Get trip points [_CRT, _PSV, etc.] (required) */
-       result = acpi_thermal_get_trip_points(tz);
-       if (result)
+       if( temp_b4_trip )
+       { /* some CPUs, eg AMD K8 need temperature before trip points
can be obtained */
+           /* Get temperature [_TMP] (required) */
+           result = acpi_thermal_get_temperature(tz);
+           if (result)
                return result;
-
-       /* Get temperature [_TMP] (required) */
-       result = acpi_thermal_get_temperature(tz);
-       if (result)
+
+           /* Get trip points [_CRT, _PSV, etc.] (required) */
+           result = acpi_thermal_get_trip_points(tz);
+           if (result)
                return result;
-
+       }else
+       { /* newer x86_64s need trip points set before temperature
obtained */
+           /* Get trip points [_CRT, _PSV, etc.] (required) */
+           result = acpi_thermal_get_trip_points(tz);
+           if (result)
+               return result;
+
+           /* Get temperature [_TMP] (required) */
+           result = acpi_thermal_get_temperature(tz);
+           if (result)
+               return result;
+       }
+
        /* Set the cooling mode [_SCP] to active cooling (default) */
        result = acpi_thermal_set_cooling_mode(tz,
ACPI_THERMAL_MODE_ACTIVE);
        if (!result)
                tz->flags.cooling_mode = 1;
-
+
        /* Get default polling frequency [_TZP] (optional) */
        if (tzp)
                tz->polling_frequency = tzp;
        else
                acpi_thermal_get_polling_frequency(tz);
-
+
        return 0;
 }

@@ -1110,6 +1128,14 @@ static int thermal_psv(const struct
dmi_system_id *d) {
        return 0;
 }

+static int thermal_temp_b4_trip(const struct dmi_system_id *d) {
+
+       printk(KERN_NOTICE "ACPI: %s detected: : "
+                           "getting temperature before trip point
initialisation\n", d->ident);
+       temp_b4_trip = TRUE;
+       return 0;
+}
+
 static struct dmi_system_id thermal_dmi_table[] __initdata = {
        /*
         * Award BIOS on this AOpen makes thermal control almost
worthless.
@@ -1147,6 +1173,14 @@ static struct dmi_system_id thermal_dmi_table[]
__initdata = {
                DMI_MATCH(DMI_BOARD_NAME, "7ZX"),
                },
        },
+       {
+        .callback = thermal_temp_b4_trip,
+        .ident = "HP 6715b laptop",
+        .matches = {
+                    DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+                    DMI_MATCH(DMI_PRODUCT_NAME, "HP Compaq 6715b"),
+               },
+       },
        {}
 };

Incidentally,  there are still plenty of cpufreq and temperature
related issues on this platform :
    with the "ondemand" or "performance"  governors,  placing a large
load on system
      ( eg. building gcc-4.7.1 ) makes the CPU switch into highest
frequency, but not switch
     down after the 65 degree trip point has been toggled once .
     And once the trip point has been reached once and the temperature
falls below 65, returning CPU freq to 2GHz,
     the reported temperature seems to be stuck at 62 degrees even
though the base of   the laptop nearly burns my hand .
     So I get emergency overheating reboots unless I manually run my
cpufreq & temperature monitoring scripts -
     which, if the CPU freq is 2Ghz,  now have to down the freqency to
800Khz for 2 seconds every 8 seconds
regardless of what temperature
     is reported .


On Mon, Jul 9, 2012 at 1:30 AM, Rusty Russell <rusty@ozlabs.org> wrote:
> On Sun, 8 Jul 2012 19:50:54 +0100, Jason Vas Dias <jason.vas.dias@gmail.com> wrote:
>> This patch adds a new acpi.thermal.temp_b4_trip = 1 settting, which
>> causes the temperature
>> to be set before evaluation of thermal trip points (the old default) ;
>>  this mode should
>> be selected automatically by DMI match if the system identifies as "HP
>> Compaq 6715b" .
>>
>> Please consider applying a patch like that attached to fix the issue reported
>> in lkml thread "Re: PROBLEM: Performance drop" recently,  whereby
>> it was found that HP 6715b laptops ( which have 2.2Ghz dual-core  AMD
>> x86_64 k8 CPUs)
>> get stuck running the CPU at 800Khz and cannot switch frequency. I have verified
>> that this still the case with v3.4.4 tagged "stable" kernel.
>
>
>>
>> diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
>> index 7dbebea..de2b164 100644
>> --- a/drivers/acpi/thermal.c
>> +++ b/drivers/acpi/thermal.c
>> @@ -96,6 +96,10 @@ static int psv;
>>  module_param(psv, int, 0644);
>>  MODULE_PARM_DESC(psv, "Disable or override all passive trip points.");
>>
>> +static int temp_b4_trip;
>> +module_param(temp_b4_trip, int, 0);
>> +MODULE_PARM_DESC(temp_b4_trip, "Get the temperature before
>> initializing trip points.");
>> +
>
> Hi Jason,
>
>         Two points: this is a bool, why not make it one?  I know, the
> rest of the code is old-school, but this is a new parameter.  Also, why
> not 0644 so it can be read and set at runtime?
>
> Cheers,
> Rusty.

--f46d0401730b9e0ade04c4699c42
Content-Type: application/octet-stream; 
	name="acpi_thermal_temp_b4_trip.patch"
Content-Disposition: attachment; filename="acpi_thermal_temp_b4_trip.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h4fv2vt30

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYWNwaS90aGVybWFsLmMgYi9kcml2ZXJzL2FjcGkvdGhlcm1h
bC5jCmluZGV4IDdkYmViZWEuLjEzZDNiMjIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvYWNwaS90aGVy
bWFsLmMKKysrIGIvZHJpdmVycy9hY3BpL3RoZXJtYWwuYwpAQCAtOTYsNiArOTYsMTAgQEAgc3Rh
dGljIGludCBwc3Y7CiBtb2R1bGVfcGFyYW0ocHN2LCBpbnQsIDA2NDQpOwogTU9EVUxFX1BBUk1f
REVTQyhwc3YsICJEaXNhYmxlIG9yIG92ZXJyaWRlIGFsbCBwYXNzaXZlIHRyaXAgcG9pbnRzLiIp
OwogCitzdGF0aWMgYm9vbCB0ZW1wX2I0X3RyaXA7Cittb2R1bGVfcGFyYW0odGVtcF9iNF90cmlw
LCBib29sLCAwNjQ0KTsKK01PRFVMRV9QQVJNX0RFU0ModGVtcF9iNF90cmlwLCAiR2V0IHRoZSB0
ZW1wZXJhdHVyZSBiZWZvcmUgaW5pdGlhbGl6aW5nIHRyaXAgcG9pbnRzLiIpOworCiBzdGF0aWMg
aW50IGFjcGlfdGhlcm1hbF9hZGQoc3RydWN0IGFjcGlfZGV2aWNlICpkZXZpY2UpOwogc3RhdGlj
IGludCBhY3BpX3RoZXJtYWxfcmVtb3ZlKHN0cnVjdCBhY3BpX2RldmljZSAqZGV2aWNlLCBpbnQg
dHlwZSk7CiBzdGF0aWMgaW50IGFjcGlfdGhlcm1hbF9yZXN1bWUoc3RydWN0IGFjcGlfZGV2aWNl
ICpkZXZpY2UpOwpAQCAtOTQxLDI3ICs5NDUsNDEgQEAgc3RhdGljIGludCBhY3BpX3RoZXJtYWxf
Z2V0X2luZm8oc3RydWN0IGFjcGlfdGhlcm1hbCAqdHopCiAJaWYgKCF0eikKIAkJcmV0dXJuIC1F
SU5WQUw7CiAKLQkvKiBHZXQgdHJpcCBwb2ludHMgW19DUlQsIF9QU1YsIGV0Yy5dIChyZXF1aXJl
ZCkgKi8KLQlyZXN1bHQgPSBhY3BpX3RoZXJtYWxfZ2V0X3RyaXBfcG9pbnRzKHR6KTsKLQlpZiAo
cmVzdWx0KQorCWlmKCB0ZW1wX2I0X3RyaXAgKQorCXsgLyogc29tZSBDUFVzLCBlZyBBTUQgSzgg
bmVlZCB0ZW1wZXJhdHVyZSBiZWZvcmUgdHJpcCBwb2ludHMgY2FuIGJlIG9idGFpbmVkICovCisJ
ICAgIC8qIEdldCB0ZW1wZXJhdHVyZSBbX1RNUF0gKHJlcXVpcmVkKSAqLworCSAgICByZXN1bHQg
PSBhY3BpX3RoZXJtYWxfZ2V0X3RlbXBlcmF0dXJlKHR6KTsKKwkgICAgaWYgKHJlc3VsdCkKIAkJ
cmV0dXJuIHJlc3VsdDsKLQotCS8qIEdldCB0ZW1wZXJhdHVyZSBbX1RNUF0gKHJlcXVpcmVkKSAq
LwotCXJlc3VsdCA9IGFjcGlfdGhlcm1hbF9nZXRfdGVtcGVyYXR1cmUodHopOwotCWlmIChyZXN1
bHQpCisJICAgIAorCSAgICAvKiBHZXQgdHJpcCBwb2ludHMgW19DUlQsIF9QU1YsIGV0Yy5dIChy
ZXF1aXJlZCkgKi8KKwkgICAgcmVzdWx0ID0gYWNwaV90aGVybWFsX2dldF90cmlwX3BvaW50cyh0
eik7CisJICAgIGlmIChyZXN1bHQpCiAJCXJldHVybiByZXN1bHQ7Ci0KKwl9ZWxzZQorCXsgLyog
bmV3ZXIgeDg2XzY0cyBuZWVkIHRyaXAgcG9pbnRzIHNldCBiZWZvcmUgdGVtcGVyYXR1cmUgb2J0
YWluZWQgKi8KKwkgICAgLyogR2V0IHRyaXAgcG9pbnRzIFtfQ1JULCBfUFNWLCBldGMuXSAocmVx
dWlyZWQpICovCisJICAgIHJlc3VsdCA9IGFjcGlfdGhlcm1hbF9nZXRfdHJpcF9wb2ludHModHop
OworCSAgICBpZiAocmVzdWx0KQorCQlyZXR1cm4gcmVzdWx0OworCSAgICAKKwkgICAgLyogR2V0
IHRlbXBlcmF0dXJlIFtfVE1QXSAocmVxdWlyZWQpICovCisJICAgIHJlc3VsdCA9IGFjcGlfdGhl
cm1hbF9nZXRfdGVtcGVyYXR1cmUodHopOworCSAgICBpZiAocmVzdWx0KQorCQlyZXR1cm4gcmVz
dWx0OworCX0KKwkKIAkvKiBTZXQgdGhlIGNvb2xpbmcgbW9kZSBbX1NDUF0gdG8gYWN0aXZlIGNv
b2xpbmcgKGRlZmF1bHQpICovCiAJcmVzdWx0ID0gYWNwaV90aGVybWFsX3NldF9jb29saW5nX21v
ZGUodHosIEFDUElfVEhFUk1BTF9NT0RFX0FDVElWRSk7CiAJaWYgKCFyZXN1bHQpCiAJCXR6LT5m
bGFncy5jb29saW5nX21vZGUgPSAxOwotCisJCiAJLyogR2V0IGRlZmF1bHQgcG9sbGluZyBmcmVx
dWVuY3kgW19UWlBdIChvcHRpb25hbCkgKi8KIAlpZiAodHpwKQogCQl0ei0+cG9sbGluZ19mcmVx
dWVuY3kgPSB0enA7CiAJZWxzZQogCQlhY3BpX3RoZXJtYWxfZ2V0X3BvbGxpbmdfZnJlcXVlbmN5
KHR6KTsKLQorCQogCXJldHVybiAwOwogfQogCkBAIC0xMTEwLDYgKzExMjgsMTQgQEAgc3RhdGlj
IGludCB0aGVybWFsX3Bzdihjb25zdCBzdHJ1Y3QgZG1pX3N5c3RlbV9pZCAqZCkgewogCXJldHVy
biAwOwogfQogCitzdGF0aWMgaW50IHRoZXJtYWxfdGVtcF9iNF90cmlwKGNvbnN0IHN0cnVjdCBk
bWlfc3lzdGVtX2lkICpkKSB7CisKKwlwcmludGsoS0VSTl9OT1RJQ0UgIkFDUEk6ICVzIGRldGVj
dGVkOiA6ICIKKyAgICAgICAgICAgICAgICAgICAgICAgICAgICJnZXR0aW5nIHRlbXBlcmF0dXJl
IGJlZm9yZSB0cmlwIHBvaW50IGluaXRpYWxpc2F0aW9uXG4iLCBkLT5pZGVudCk7CisJdGVtcF9i
NF90cmlwID0gVFJVRTsKKwlyZXR1cm4gMDsKK30KKwogc3RhdGljIHN0cnVjdCBkbWlfc3lzdGVt
X2lkIHRoZXJtYWxfZG1pX3RhYmxlW10gX19pbml0ZGF0YSA9IHsKIAkvKgogCSAqIEF3YXJkIEJJ
T1Mgb24gdGhpcyBBT3BlbiBtYWtlcyB0aGVybWFsIGNvbnRyb2wgYWxtb3N0IHdvcnRobGVzcy4K
QEAgLTExNDcsNiArMTE3MywxNCBAQCBzdGF0aWMgc3RydWN0IGRtaV9zeXN0ZW1faWQgdGhlcm1h
bF9kbWlfdGFibGVbXSBfX2luaXRkYXRhID0gewogCQlETUlfTUFUQ0goRE1JX0JPQVJEX05BTUUs
ICI3WlgiKSwKIAkJfSwKIAl9LAorCXsKKwkgLmNhbGxiYWNrID0gdGhlcm1hbF90ZW1wX2I0X3Ry
aXAsCisJIC5pZGVudCA9ICJIUCA2NzE1YiBsYXB0b3AiLAorCSAubWF0Y2hlcyA9IHsKKwkJICAg
ICBETUlfTUFUQ0goRE1JX1NZU19WRU5ET1IsICJIZXdsZXR0LVBhY2thcmQiKSwKKwkJICAgICBE
TUlfTUFUQ0goRE1JX1BST0RVQ1RfTkFNRSwgIkhQIENvbXBhcSA2NzE1YiIpLAorCQl9LAorCX0s
CiAJe30KIH07CiAK
--f46d0401730b9e0ade04c4699c42--
