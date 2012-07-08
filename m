Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab2GHSu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 14:50:57 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59284 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab2GHSu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 14:50:56 -0400
MIME-Version: 1.0
Date: Sun, 8 Jul 2012 19:50:54 +0100
Message-ID: <CALyZvKyEiTaU4CDh3F-fYkSjyyFkmhjitaWmXs_PORVEeOnirw@mail.gmail.com>
Subject: [PATCH: 1/1] ACPI: make evaluation of thermal trip points before
 temperature or vice versa dependant on new "temp_b4_trip" module parameter to
 support older AMD x86_64s
From: Jason Vas Dias <jason.vas.dias@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Matthew Garrett <mjg@redhat.com>, Len Brown <lenb@kernel.org>,
        Comrade DOS <suloevdmitry@gmail.com>
Content-Type: multipart/mixed; boundary=f46d042dfc93278f7504c455fa59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d042dfc93278f7504c455fa59
Content-Type: text/plain; charset=UTF-8

This patch adds a new acpi.thermal.temp_b4_trip = 1 settting, which
causes the temperature
to be set before evaluation of thermal trip points (the old default) ;
 this mode should
be selected automatically by DMI match if the system identifies as "HP
Compaq 6715b" .

Please consider applying a patch like that attached to fix the issue reported
in lkml thread "Re: PROBLEM: Performance drop" recently,  whereby
it was found that HP 6715b laptops ( which have 2.2Ghz dual-core  AMD
x86_64 k8 CPUs)
get stuck running the CPU at 800Khz and cannot switch frequency. I have verified
that this still the case with v3.4.4 tagged "stable" kernel.

diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 7dbebea..de2b164 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -96,6 +96,10 @@ static int psv;
 module_param(psv, int, 0644);
 MODULE_PARM_DESC(psv, "Disable or override all passive trip points.");

+static int temp_b4_trip;
+module_param(temp_b4_trip, int, 0);
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
        result = acpi_thermal_set_cooling_mode(tz, ACPI_THERMAL_MODE_ACTIVE);
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

@@ -1110,6 +1128,14 @@ static int thermal_psv(const struct dmi_system_id *d) {
        return 0;
 }

+static int thermal_temp_b4_trip(const struct dmi_system_id *d) {
+
+       printk(KERN_NOTICE "ACPI: %s detected: : "
+                           "getting temperature before trip point
initialisation\n", d->ident);
+       temp_b4_trip = 1;
+       return 0;
+}
+
 static struct dmi_system_id thermal_dmi_table[] __initdata = {
        /*
         * Award BIOS on this AOpen makes thermal control almost worthless.
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

--f46d042dfc93278f7504c455fa59
Content-Type: application/octet-stream; name="acpi_thermal_HP6715b.patch"
Content-Disposition: attachment; filename="acpi_thermal_HP6715b.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h4egi1hp0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYWNwaS90aGVybWFsLmMgYi9kcml2ZXJzL2FjcGkvdGhlcm1h
bC5jCmluZGV4IDdkYmViZWEuLmRlMmIxNjQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvYWNwaS90aGVy
bWFsLmMKKysrIGIvZHJpdmVycy9hY3BpL3RoZXJtYWwuYwpAQCAtOTYsNiArOTYsMTAgQEAgc3Rh
dGljIGludCBwc3Y7CiBtb2R1bGVfcGFyYW0ocHN2LCBpbnQsIDA2NDQpOwogTU9EVUxFX1BBUk1f
REVTQyhwc3YsICJEaXNhYmxlIG9yIG92ZXJyaWRlIGFsbCBwYXNzaXZlIHRyaXAgcG9pbnRzLiIp
OwogCitzdGF0aWMgaW50IHRlbXBfYjRfdHJpcDsKK21vZHVsZV9wYXJhbSh0ZW1wX2I0X3RyaXAs
IGludCwgMCk7CitNT0RVTEVfUEFSTV9ERVNDKHRlbXBfYjRfdHJpcCwgIkdldCB0aGUgdGVtcGVy
YXR1cmUgYmVmb3JlIGluaXRpYWxpemluZyB0cmlwIHBvaW50cy4iKTsKKwogc3RhdGljIGludCBh
Y3BpX3RoZXJtYWxfYWRkKHN0cnVjdCBhY3BpX2RldmljZSAqZGV2aWNlKTsKIHN0YXRpYyBpbnQg
YWNwaV90aGVybWFsX3JlbW92ZShzdHJ1Y3QgYWNwaV9kZXZpY2UgKmRldmljZSwgaW50IHR5cGUp
Owogc3RhdGljIGludCBhY3BpX3RoZXJtYWxfcmVzdW1lKHN0cnVjdCBhY3BpX2RldmljZSAqZGV2
aWNlKTsKQEAgLTk0MSwyNyArOTQ1LDQxIEBAIHN0YXRpYyBpbnQgYWNwaV90aGVybWFsX2dldF9p
bmZvKHN0cnVjdCBhY3BpX3RoZXJtYWwgKnR6KQogCWlmICghdHopCiAJCXJldHVybiAtRUlOVkFM
OwogCi0JLyogR2V0IHRyaXAgcG9pbnRzIFtfQ1JULCBfUFNWLCBldGMuXSAocmVxdWlyZWQpICov
Ci0JcmVzdWx0ID0gYWNwaV90aGVybWFsX2dldF90cmlwX3BvaW50cyh0eik7Ci0JaWYgKHJlc3Vs
dCkKKwlpZiggdGVtcF9iNF90cmlwICkKKwl7IC8qIHNvbWUgQ1BVcywgZWcgQU1EIEs4IG5lZWQg
dGVtcGVyYXR1cmUgYmVmb3JlIHRyaXAgcG9pbnRzIGNhbiBiZSBvYnRhaW5lZCAqLworCSAgICAv
KiBHZXQgdGVtcGVyYXR1cmUgW19UTVBdIChyZXF1aXJlZCkgKi8KKwkgICAgcmVzdWx0ID0gYWNw
aV90aGVybWFsX2dldF90ZW1wZXJhdHVyZSh0eik7CisJICAgIGlmIChyZXN1bHQpCiAJCXJldHVy
biByZXN1bHQ7Ci0KLQkvKiBHZXQgdGVtcGVyYXR1cmUgW19UTVBdIChyZXF1aXJlZCkgKi8KLQly
ZXN1bHQgPSBhY3BpX3RoZXJtYWxfZ2V0X3RlbXBlcmF0dXJlKHR6KTsKLQlpZiAocmVzdWx0KQor
CSAgICAKKwkgICAgLyogR2V0IHRyaXAgcG9pbnRzIFtfQ1JULCBfUFNWLCBldGMuXSAocmVxdWly
ZWQpICovCisJICAgIHJlc3VsdCA9IGFjcGlfdGhlcm1hbF9nZXRfdHJpcF9wb2ludHModHopOwor
CSAgICBpZiAocmVzdWx0KQogCQlyZXR1cm4gcmVzdWx0OwotCisJfWVsc2UKKwl7IC8qIG5ld2Vy
IHg4Nl82NHMgbmVlZCB0cmlwIHBvaW50cyBzZXQgYmVmb3JlIHRlbXBlcmF0dXJlIG9idGFpbmVk
ICovCisJICAgIC8qIEdldCB0cmlwIHBvaW50cyBbX0NSVCwgX1BTViwgZXRjLl0gKHJlcXVpcmVk
KSAqLworCSAgICByZXN1bHQgPSBhY3BpX3RoZXJtYWxfZ2V0X3RyaXBfcG9pbnRzKHR6KTsKKwkg
ICAgaWYgKHJlc3VsdCkKKwkJcmV0dXJuIHJlc3VsdDsKKwkgICAgCisJICAgIC8qIEdldCB0ZW1w
ZXJhdHVyZSBbX1RNUF0gKHJlcXVpcmVkKSAqLworCSAgICByZXN1bHQgPSBhY3BpX3RoZXJtYWxf
Z2V0X3RlbXBlcmF0dXJlKHR6KTsKKwkgICAgaWYgKHJlc3VsdCkKKwkJcmV0dXJuIHJlc3VsdDsK
Kwl9CisJCiAJLyogU2V0IHRoZSBjb29saW5nIG1vZGUgW19TQ1BdIHRvIGFjdGl2ZSBjb29saW5n
IChkZWZhdWx0KSAqLwogCXJlc3VsdCA9IGFjcGlfdGhlcm1hbF9zZXRfY29vbGluZ19tb2RlKHR6
LCBBQ1BJX1RIRVJNQUxfTU9ERV9BQ1RJVkUpOwogCWlmICghcmVzdWx0KQogCQl0ei0+ZmxhZ3Mu
Y29vbGluZ19tb2RlID0gMTsKLQorCQogCS8qIEdldCBkZWZhdWx0IHBvbGxpbmcgZnJlcXVlbmN5
IFtfVFpQXSAob3B0aW9uYWwpICovCiAJaWYgKHR6cCkKIAkJdHotPnBvbGxpbmdfZnJlcXVlbmN5
ID0gdHpwOwogCWVsc2UKIAkJYWNwaV90aGVybWFsX2dldF9wb2xsaW5nX2ZyZXF1ZW5jeSh0eik7
Ci0KKwkKIAlyZXR1cm4gMDsKIH0KIApAQCAtMTExMCw2ICsxMTI4LDE0IEBAIHN0YXRpYyBpbnQg
dGhlcm1hbF9wc3YoY29uc3Qgc3RydWN0IGRtaV9zeXN0ZW1faWQgKmQpIHsKIAlyZXR1cm4gMDsK
IH0KIAorc3RhdGljIGludCB0aGVybWFsX3RlbXBfYjRfdHJpcChjb25zdCBzdHJ1Y3QgZG1pX3N5
c3RlbV9pZCAqZCkgeworCisJcHJpbnRrKEtFUk5fTk9USUNFICJBQ1BJOiAlcyBkZXRlY3RlZDog
OiAiCisgICAgICAgICAgICAgICAgICAgICAgICAgICAiZ2V0dGluZyB0ZW1wZXJhdHVyZSBiZWZv
cmUgdHJpcCBwb2ludCBpbml0aWFsaXNhdGlvblxuIiwgZC0+aWRlbnQpOworCXRlbXBfYjRfdHJp
cCA9IDE7CisJcmV0dXJuIDA7Cit9CisKIHN0YXRpYyBzdHJ1Y3QgZG1pX3N5c3RlbV9pZCB0aGVy
bWFsX2RtaV90YWJsZVtdIF9faW5pdGRhdGEgPSB7CiAJLyoKIAkgKiBBd2FyZCBCSU9TIG9uIHRo
aXMgQU9wZW4gbWFrZXMgdGhlcm1hbCBjb250cm9sIGFsbW9zdCB3b3J0aGxlc3MuCkBAIC0xMTQ3
LDYgKzExNzMsMTQgQEAgc3RhdGljIHN0cnVjdCBkbWlfc3lzdGVtX2lkIHRoZXJtYWxfZG1pX3Rh
YmxlW10gX19pbml0ZGF0YSA9IHsKIAkJRE1JX01BVENIKERNSV9CT0FSRF9OQU1FLCAiN1pYIiks
CiAJCX0sCiAJfSwKKwl7CisJIC5jYWxsYmFjayA9IHRoZXJtYWxfdGVtcF9iNF90cmlwLAorCSAu
aWRlbnQgPSAiSFAgNjcxNWIgbGFwdG9wIiwKKwkgLm1hdGNoZXMgPSB7CisJCSAgICAgRE1JX01B
VENIKERNSV9TWVNfVkVORE9SLCAiSGV3bGV0dC1QYWNrYXJkIiksCisJCSAgICAgRE1JX01BVENI
KERNSV9QUk9EVUNUX05BTUUsICJIUCBDb21wYXEgNjcxNWIiKSwKKwkJfSwKKwl9LAogCXt9CiB9
OwogCg==
--f46d042dfc93278f7504c455fa59--
