Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab2BQJC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:02:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:31971 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab2BQJC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:02:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="118567380"
From: "Liu, Jinsong" <jinsong.liu@intel.com>
To: Jan Beulich <JBeulich@suse.com>, "keir.xen@gmail.com" <keir.xen@gmail.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
CC: "Li, Shaohua" <shaohua.li@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [Patch 2/2] Xen core parking 2: core parking implementation
Thread-Topic: [Patch 2/2] Xen core parking 2: core parking implementation
Thread-Index: AcztUrPbW9dePUw1SLqPZ9Ouh5ZgWA==
Date: Fri, 17 Feb 2012 09:01:15 +0000
Message-ID: <DE8DF0795D48FD4CA783C40EC829233509D8BC@SHSMSX101.ccr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: multipart/mixed;
	boundary="_002_DE8DF0795D48FD4CA783C40EC829233509D8BCSHSMSX101ccrcorpi_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_DE8DF0795D48FD4CA783C40EC829233509D8BCSHSMSX101ccrcorpi_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Xen core parking 2: core parking implementation

This patch implement Xen core parking.
Different core parking sequence has different power/performance result, due=
 to cpu socket/core/thread topology.
This patch provide power-first and performance-first policies, users can ch=
oose core parking policy by their own demand.

Signed-off-by: Liu, Jinsong <jinsong.liu@intel.com>

diff -r 392e77171d74 xen/common/core_parking.c
--- a/xen/common/core_parking.c	Mon Feb 13 11:33:17 2012 +0800
+++ b/xen/common/core_parking.c	Thu Feb 16 23:39:57 2012 +0800
@@ -1,13 +1,240 @@
+/*
+ *  core_parking.c - implement core parking according to dom0 requirement
+ *
+ *  Copyright (C) 2012, Intel Corporation.
+ *     Author: Liu, Jinsong <jinsong.liu@intel.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or (at
+ *  your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ */
+
 #include <xen/types.h>
+#include <xen/cpu.h>
+#include <xen/init.h>
+#include <xen/cpumask.h>
+#include <asm/percpu.h>
+#include <asm/smp.h>
+
+#define CORE_PARKING_INCREMENT 1
+#define CORE_PARKING_DECREMENT 2
+
+static unsigned int core_parking_power(unsigned int event);
+static unsigned int core_parking_performance(unsigned int event);
=20
 static uint32_t cur_idle_nums;
+static unsigned int core_parking_cpunum[NR_CPUS] =3D {[0 ... NR_CPUS-1] =
=3D -1};
+
+static struct core_parking_policy {
+    char name[30];
+    unsigned int (*next)(unsigned int event);
+} *core_parking_policy;
+
+static enum core_parking_controller {
+    POWER_FIRST,
+    PERFORMANCE_FIRST
+} core_parking_controller =3D POWER_FIRST;
+
+static void __init setup_core_parking_option(char *str)
+{
+    if ( !strcmp(str, "power") )
+        core_parking_controller =3D POWER_FIRST;
+    else if ( !strcmp(str, "performance") )
+        core_parking_controller =3D PERFORMANCE_FIRST;
+    else
+        return;
+}
+custom_param("core_parking", setup_core_parking_option);
+
+static unsigned int core_parking_performance(unsigned int event)
+{
+    unsigned int cpu =3D -1;
+
+    switch ( event )
+    {
+    case CORE_PARKING_INCREMENT:
+    {
+        int core_tmp, core_weight =3D -1;
+        int sibling_tmp, sibling_weight =3D -1;
+        cpumask_t core_candidate_map, sibling_candidate_map;
+        cpumask_clear(&core_candidate_map);
+        cpumask_clear(&sibling_candidate_map);
+
+        for_each_cpu(cpu, &cpu_online_map)
+        {
+            if ( cpu =3D=3D 0 )
+                continue;
+
+            core_tmp =3D cpumask_weight(per_cpu(cpu_core_mask, cpu));
+            if ( core_weight < core_tmp )
+            {
+                core_weight =3D core_tmp;
+                cpumask_clear(&core_candidate_map);
+                cpumask_set_cpu(cpu, &core_candidate_map);
+            }
+            else if ( core_weight =3D=3D core_tmp )
+                cpumask_set_cpu(cpu, &core_candidate_map);
+        }
+
+        for_each_cpu(cpu, &core_candidate_map)
+        {
+            sibling_tmp =3D cpumask_weight(per_cpu(cpu_sibling_mask, cpu))=
;
+            if ( sibling_weight < sibling_tmp )
+            {
+                sibling_weight =3D sibling_tmp;
+                cpumask_clear(&sibling_candidate_map);
+                cpumask_set_cpu(cpu, &sibling_candidate_map);
+            }
+            else if ( sibling_weight =3D=3D sibling_tmp )
+                cpumask_set_cpu(cpu, &sibling_candidate_map);
+        }
+
+        cpu =3D cpumask_first(&sibling_candidate_map);
+    }
+    break;
+
+    case CORE_PARKING_DECREMENT:
+    {
+        cpu =3D core_parking_cpunum[cur_idle_nums -1];
+    }
+    break;
+
+    default:
+        break;
+    }
+
+    return cpu;
+}
+
+static unsigned int core_parking_power(unsigned int event)
+{
+    unsigned int cpu =3D -1;
+
+    switch ( event )
+    {
+    case CORE_PARKING_INCREMENT:
+    {
+        int core_tmp, core_weight =3D NR_CPUS + 1;
+        int sibling_tmp, sibling_weight =3D NR_CPUS + 1;
+        cpumask_t core_candidate_map, sibling_candidate_map;
+        cpumask_clear(&core_candidate_map);
+        cpumask_clear(&sibling_candidate_map);
+
+        for_each_cpu(cpu, &cpu_online_map)
+        {
+            if ( cpu =3D=3D 0 )
+                continue;
+
+            core_tmp =3D cpumask_weight(per_cpu(cpu_core_mask, cpu));
+            if ( core_weight > core_tmp )
+            {
+                core_weight =3D core_tmp;
+                cpumask_clear(&core_candidate_map);
+                cpumask_set_cpu(cpu, &core_candidate_map);
+            }
+            else if ( core_weight =3D=3D core_tmp )
+                cpumask_set_cpu(cpu, &core_candidate_map);
+        }
+
+        for_each_cpu(cpu, &core_candidate_map)
+        {
+            sibling_tmp =3D cpumask_weight(per_cpu(cpu_sibling_mask, cpu))=
;
+            if ( sibling_weight > sibling_tmp )
+            {
+                sibling_weight =3D sibling_tmp;
+                cpumask_clear(&sibling_candidate_map);
+                cpumask_set_cpu(cpu, &sibling_candidate_map);
+            }
+            else if ( sibling_weight =3D=3D sibling_tmp )
+                cpumask_set_cpu(cpu, &sibling_candidate_map);
+        }
+
+        cpu =3D cpumask_first(&sibling_candidate_map);
+    }
+    break;
+
+    case CORE_PARKING_DECREMENT:
+    {
+        cpu =3D core_parking_cpunum[cur_idle_nums -1];
+    }
+    break;
+
+    default:
+        break;
+    }
+
+    return cpu;
+}
=20
 long core_parking_helper(void *data)
 {
-    return 0;
+    uint32_t idle_nums =3D (unsigned long)data;
+    unsigned int cpu;
+    int ret =3D 0;
+
+    if ( !core_parking_policy )
+        return -EINVAL;
+
+    while ( cur_idle_nums < idle_nums )
+    {
+        cpu =3D core_parking_policy->next(CORE_PARKING_INCREMENT);
+        ret =3D cpu_down(cpu);
+        if ( ret )
+            return ret;
+        core_parking_cpunum[cur_idle_nums++] =3D cpu;
+    }
+
+    while ( cur_idle_nums > idle_nums )
+    {
+        cpu =3D core_parking_policy->next(CORE_PARKING_DECREMENT);
+        ret =3D cpu_up(cpu);
+        if ( ret )
+            return ret;
+        core_parking_cpunum[--cur_idle_nums] =3D -1;
+    }
+
+    return ret;
 }
=20
 uint32_t get_cur_idle_nums(void)
 {
     return cur_idle_nums;
 }
+
+static struct core_parking_policy power_first =3D {
+    .name =3D "power",
+    .next =3D core_parking_power,
+};
+
+static struct core_parking_policy performance_first =3D {
+    .name =3D "performance",
+    .next =3D core_parking_performance,
+};
+
+static int register_core_parking_policy(struct core_parking_policy *policy=
)
+{
+    if ( !policy || !policy->next )
+        return -EINVAL;
+
+    core_parking_policy =3D policy;
+    return 0;
+}
+
+static int __init core_parking_init(void)
+{
+    int ret =3D 0;
+
+    if ( core_parking_controller =3D=3D PERFORMANCE_FIRST )
+        ret =3D register_core_parking_policy(&performance_first);
+    else
+        ret =3D register_core_parking_policy(&power_first);
+
+    return ret;
+}
+__initcall(core_parking_init);=

--_002_DE8DF0795D48FD4CA783C40EC829233509D8BCSHSMSX101ccrcorpi_
Content-Type: application/octet-stream; name="xen_core_parking_2.patch"
Content-Description: xen_core_parking_2.patch
Content-Disposition: attachment; filename="xen_core_parking_2.patch";
	size=7292; creation-date="Fri, 17 Feb 2012 08:53:15 GMT";
	modification-date="Thu, 16 Feb 2012 15:39:58 GMT"
Content-Transfer-Encoding: base64

WGVuIGNvcmUgcGFya2luZyAyOiBjb3JlIHBhcmtpbmcgaW1wbGVtZW50YXRpb24KClRoaXMgcGF0
Y2ggaW1wbGVtZW50IFhlbiBjb3JlIHBhcmtpbmcuCkRpZmZlcmVudCBjb3JlIHBhcmtpbmcgc2Vx
dWVuY2UgaGFzIGRpZmZlcmVudCBwb3dlci9wZXJmb3JtYW5jZSByZXN1bHQsIGR1ZSB0byBjcHUg
c29ja2V0L2NvcmUvdGhyZWFkIHRvcG9sb2d5LgpUaGlzIHBhdGNoIHByb3ZpZGUgcG93ZXItZmly
c3QgYW5kIHBlcmZvcm1hbmNlLWZpcnN0IHBvbGljaWVzLCB1c2VycyBjYW4gY2hvb3NlIGNvcmUg
cGFya2luZyBwb2xpY3kgYnkgdGhlaXIgb3duIGRlbWFuZC4KClNpZ25lZC1vZmYtYnk6IExpdSwg
Smluc29uZyA8amluc29uZy5saXVAaW50ZWwuY29tPgoKZGlmZiAtciAzOTJlNzcxNzFkNzQgeGVu
L2NvbW1vbi9jb3JlX3BhcmtpbmcuYwotLS0gYS94ZW4vY29tbW9uL2NvcmVfcGFya2luZy5jCU1v
biBGZWIgMTMgMTE6MzM6MTcgMjAxMiArMDgwMAorKysgYi94ZW4vY29tbW9uL2NvcmVfcGFya2lu
Zy5jCVRodSBGZWIgMTYgMjM6Mzk6NTcgMjAxMiArMDgwMApAQCAtMSwxMyArMSwyNDAgQEAKKy8q
CisgKiAgY29yZV9wYXJraW5nLmMgLSBpbXBsZW1lbnQgY29yZSBwYXJraW5nIGFjY29yZGluZyB0
byBkb20wIHJlcXVpcmVtZW50CisgKgorICogIENvcHlyaWdodCAoQykgMjAxMiwgSW50ZWwgQ29y
cG9yYXRpb24uCisgKiAgICAgQXV0aG9yOiBMaXUsIEppbnNvbmcgPGppbnNvbmcubGl1QGludGVs
LmNvbT4KKyAqCisgKiAgVGhpcyBwcm9ncmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVk
aXN0cmlidXRlIGl0IGFuZC9vciBtb2RpZnkKKyAqICBpdCB1bmRlciB0aGUgdGVybXMgb2YgdGhl
IEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGFzIHB1Ymxpc2hlZCBieQorICogIHRoZSBGcmVl
IFNvZnR3YXJlIEZvdW5kYXRpb247IGVpdGhlciB2ZXJzaW9uIDIgb2YgdGhlIExpY2Vuc2UsIG9y
IChhdAorICogIHlvdXIgb3B0aW9uKSBhbnkgbGF0ZXIgdmVyc2lvbi4KKyAqCisgKiAgVGhpcyBw
cm9ncmFtIGlzIGRpc3RyaWJ1dGVkIGluIHRoZSBob3BlIHRoYXQgaXQgd2lsbCBiZSB1c2VmdWws
IGJ1dAorICogIFdJVEhPVVQgQU5ZIFdBUlJBTlRZOyB3aXRob3V0IGV2ZW4gdGhlIGltcGxpZWQg
d2FycmFudHkgb2YKKyAqICBNRVJDSEFOVEFCSUxJVFkgb3IgRklUTkVTUyBGT1IgQSBQQVJUSUNV
TEFSIFBVUlBPU0UuICBTZWUgdGhlIEdOVQorICogIEdlbmVyYWwgUHVibGljIExpY2Vuc2UgZm9y
IG1vcmUgZGV0YWlscy4KKyAqLworCiAjaW5jbHVkZSA8eGVuL3R5cGVzLmg+CisjaW5jbHVkZSA8
eGVuL2NwdS5oPgorI2luY2x1ZGUgPHhlbi9pbml0Lmg+CisjaW5jbHVkZSA8eGVuL2NwdW1hc2su
aD4KKyNpbmNsdWRlIDxhc20vcGVyY3B1Lmg+CisjaW5jbHVkZSA8YXNtL3NtcC5oPgorCisjZGVm
aW5lIENPUkVfUEFSS0lOR19JTkNSRU1FTlQgMQorI2RlZmluZSBDT1JFX1BBUktJTkdfREVDUkVN
RU5UIDIKKworc3RhdGljIHVuc2lnbmVkIGludCBjb3JlX3BhcmtpbmdfcG93ZXIodW5zaWduZWQg
aW50IGV2ZW50KTsKK3N0YXRpYyB1bnNpZ25lZCBpbnQgY29yZV9wYXJraW5nX3BlcmZvcm1hbmNl
KHVuc2lnbmVkIGludCBldmVudCk7CiAKIHN0YXRpYyB1aW50MzJfdCBjdXJfaWRsZV9udW1zOwor
c3RhdGljIHVuc2lnbmVkIGludCBjb3JlX3BhcmtpbmdfY3B1bnVtW05SX0NQVVNdID0ge1swIC4u
LiBOUl9DUFVTLTFdID0gLTF9OworCitzdGF0aWMgc3RydWN0IGNvcmVfcGFya2luZ19wb2xpY3kg
eworICAgIGNoYXIgbmFtZVszMF07CisgICAgdW5zaWduZWQgaW50ICgqbmV4dCkodW5zaWduZWQg
aW50IGV2ZW50KTsKK30gKmNvcmVfcGFya2luZ19wb2xpY3k7CisKK3N0YXRpYyBlbnVtIGNvcmVf
cGFya2luZ19jb250cm9sbGVyIHsKKyAgICBQT1dFUl9GSVJTVCwKKyAgICBQRVJGT1JNQU5DRV9G
SVJTVAorfSBjb3JlX3BhcmtpbmdfY29udHJvbGxlciA9IFBPV0VSX0ZJUlNUOworCitzdGF0aWMg
dm9pZCBfX2luaXQgc2V0dXBfY29yZV9wYXJraW5nX29wdGlvbihjaGFyICpzdHIpCit7CisgICAg
aWYgKCAhc3RyY21wKHN0ciwgInBvd2VyIikgKQorICAgICAgICBjb3JlX3BhcmtpbmdfY29udHJv
bGxlciA9IFBPV0VSX0ZJUlNUOworICAgIGVsc2UgaWYgKCAhc3RyY21wKHN0ciwgInBlcmZvcm1h
bmNlIikgKQorICAgICAgICBjb3JlX3BhcmtpbmdfY29udHJvbGxlciA9IFBFUkZPUk1BTkNFX0ZJ
UlNUOworICAgIGVsc2UKKyAgICAgICAgcmV0dXJuOworfQorY3VzdG9tX3BhcmFtKCJjb3JlX3Bh
cmtpbmciLCBzZXR1cF9jb3JlX3Bhcmtpbmdfb3B0aW9uKTsKKworc3RhdGljIHVuc2lnbmVkIGlu
dCBjb3JlX3BhcmtpbmdfcGVyZm9ybWFuY2UodW5zaWduZWQgaW50IGV2ZW50KQoreworICAgIHVu
c2lnbmVkIGludCBjcHUgPSAtMTsKKworICAgIHN3aXRjaCAoIGV2ZW50ICkKKyAgICB7CisgICAg
Y2FzZSBDT1JFX1BBUktJTkdfSU5DUkVNRU5UOgorICAgIHsKKyAgICAgICAgaW50IGNvcmVfdG1w
LCBjb3JlX3dlaWdodCA9IC0xOworICAgICAgICBpbnQgc2libGluZ190bXAsIHNpYmxpbmdfd2Vp
Z2h0ID0gLTE7CisgICAgICAgIGNwdW1hc2tfdCBjb3JlX2NhbmRpZGF0ZV9tYXAsIHNpYmxpbmdf
Y2FuZGlkYXRlX21hcDsKKyAgICAgICAgY3B1bWFza19jbGVhcigmY29yZV9jYW5kaWRhdGVfbWFw
KTsKKyAgICAgICAgY3B1bWFza19jbGVhcigmc2libGluZ19jYW5kaWRhdGVfbWFwKTsKKworICAg
ICAgICBmb3JfZWFjaF9jcHUoY3B1LCAmY3B1X29ubGluZV9tYXApCisgICAgICAgIHsKKyAgICAg
ICAgICAgIGlmICggY3B1ID09IDAgKQorICAgICAgICAgICAgICAgIGNvbnRpbnVlOworCisgICAg
ICAgICAgICBjb3JlX3RtcCA9IGNwdW1hc2tfd2VpZ2h0KHBlcl9jcHUoY3B1X2NvcmVfbWFzaywg
Y3B1KSk7CisgICAgICAgICAgICBpZiAoIGNvcmVfd2VpZ2h0IDwgY29yZV90bXAgKQorICAgICAg
ICAgICAgeworICAgICAgICAgICAgICAgIGNvcmVfd2VpZ2h0ID0gY29yZV90bXA7CisgICAgICAg
ICAgICAgICAgY3B1bWFza19jbGVhcigmY29yZV9jYW5kaWRhdGVfbWFwKTsKKyAgICAgICAgICAg
ICAgICBjcHVtYXNrX3NldF9jcHUoY3B1LCAmY29yZV9jYW5kaWRhdGVfbWFwKTsKKyAgICAgICAg
ICAgIH0KKyAgICAgICAgICAgIGVsc2UgaWYgKCBjb3JlX3dlaWdodCA9PSBjb3JlX3RtcCApCisg
ICAgICAgICAgICAgICAgY3B1bWFza19zZXRfY3B1KGNwdSwgJmNvcmVfY2FuZGlkYXRlX21hcCk7
CisgICAgICAgIH0KKworICAgICAgICBmb3JfZWFjaF9jcHUoY3B1LCAmY29yZV9jYW5kaWRhdGVf
bWFwKQorICAgICAgICB7CisgICAgICAgICAgICBzaWJsaW5nX3RtcCA9IGNwdW1hc2tfd2VpZ2h0
KHBlcl9jcHUoY3B1X3NpYmxpbmdfbWFzaywgY3B1KSk7CisgICAgICAgICAgICBpZiAoIHNpYmxp
bmdfd2VpZ2h0IDwgc2libGluZ190bXAgKQorICAgICAgICAgICAgeworICAgICAgICAgICAgICAg
IHNpYmxpbmdfd2VpZ2h0ID0gc2libGluZ190bXA7CisgICAgICAgICAgICAgICAgY3B1bWFza19j
bGVhcigmc2libGluZ19jYW5kaWRhdGVfbWFwKTsKKyAgICAgICAgICAgICAgICBjcHVtYXNrX3Nl
dF9jcHUoY3B1LCAmc2libGluZ19jYW5kaWRhdGVfbWFwKTsKKyAgICAgICAgICAgIH0KKyAgICAg
ICAgICAgIGVsc2UgaWYgKCBzaWJsaW5nX3dlaWdodCA9PSBzaWJsaW5nX3RtcCApCisgICAgICAg
ICAgICAgICAgY3B1bWFza19zZXRfY3B1KGNwdSwgJnNpYmxpbmdfY2FuZGlkYXRlX21hcCk7Cisg
ICAgICAgIH0KKworICAgICAgICBjcHUgPSBjcHVtYXNrX2ZpcnN0KCZzaWJsaW5nX2NhbmRpZGF0
ZV9tYXApOworICAgIH0KKyAgICBicmVhazsKKworICAgIGNhc2UgQ09SRV9QQVJLSU5HX0RFQ1JF
TUVOVDoKKyAgICB7CisgICAgICAgIGNwdSA9IGNvcmVfcGFya2luZ19jcHVudW1bY3VyX2lkbGVf
bnVtcyAtMV07CisgICAgfQorICAgIGJyZWFrOworCisgICAgZGVmYXVsdDoKKyAgICAgICAgYnJl
YWs7CisgICAgfQorCisgICAgcmV0dXJuIGNwdTsKK30KKworc3RhdGljIHVuc2lnbmVkIGludCBj
b3JlX3BhcmtpbmdfcG93ZXIodW5zaWduZWQgaW50IGV2ZW50KQoreworICAgIHVuc2lnbmVkIGlu
dCBjcHUgPSAtMTsKKworICAgIHN3aXRjaCAoIGV2ZW50ICkKKyAgICB7CisgICAgY2FzZSBDT1JF
X1BBUktJTkdfSU5DUkVNRU5UOgorICAgIHsKKyAgICAgICAgaW50IGNvcmVfdG1wLCBjb3JlX3dl
aWdodCA9IE5SX0NQVVMgKyAxOworICAgICAgICBpbnQgc2libGluZ190bXAsIHNpYmxpbmdfd2Vp
Z2h0ID0gTlJfQ1BVUyArIDE7CisgICAgICAgIGNwdW1hc2tfdCBjb3JlX2NhbmRpZGF0ZV9tYXAs
IHNpYmxpbmdfY2FuZGlkYXRlX21hcDsKKyAgICAgICAgY3B1bWFza19jbGVhcigmY29yZV9jYW5k
aWRhdGVfbWFwKTsKKyAgICAgICAgY3B1bWFza19jbGVhcigmc2libGluZ19jYW5kaWRhdGVfbWFw
KTsKKworICAgICAgICBmb3JfZWFjaF9jcHUoY3B1LCAmY3B1X29ubGluZV9tYXApCisgICAgICAg
IHsKKyAgICAgICAgICAgIGlmICggY3B1ID09IDAgKQorICAgICAgICAgICAgICAgIGNvbnRpbnVl
OworCisgICAgICAgICAgICBjb3JlX3RtcCA9IGNwdW1hc2tfd2VpZ2h0KHBlcl9jcHUoY3B1X2Nv
cmVfbWFzaywgY3B1KSk7CisgICAgICAgICAgICBpZiAoIGNvcmVfd2VpZ2h0ID4gY29yZV90bXAg
KQorICAgICAgICAgICAgeworICAgICAgICAgICAgICAgIGNvcmVfd2VpZ2h0ID0gY29yZV90bXA7
CisgICAgICAgICAgICAgICAgY3B1bWFza19jbGVhcigmY29yZV9jYW5kaWRhdGVfbWFwKTsKKyAg
ICAgICAgICAgICAgICBjcHVtYXNrX3NldF9jcHUoY3B1LCAmY29yZV9jYW5kaWRhdGVfbWFwKTsK
KyAgICAgICAgICAgIH0KKyAgICAgICAgICAgIGVsc2UgaWYgKCBjb3JlX3dlaWdodCA9PSBjb3Jl
X3RtcCApCisgICAgICAgICAgICAgICAgY3B1bWFza19zZXRfY3B1KGNwdSwgJmNvcmVfY2FuZGlk
YXRlX21hcCk7CisgICAgICAgIH0KKworICAgICAgICBmb3JfZWFjaF9jcHUoY3B1LCAmY29yZV9j
YW5kaWRhdGVfbWFwKQorICAgICAgICB7CisgICAgICAgICAgICBzaWJsaW5nX3RtcCA9IGNwdW1h
c2tfd2VpZ2h0KHBlcl9jcHUoY3B1X3NpYmxpbmdfbWFzaywgY3B1KSk7CisgICAgICAgICAgICBp
ZiAoIHNpYmxpbmdfd2VpZ2h0ID4gc2libGluZ190bXAgKQorICAgICAgICAgICAgeworICAgICAg
ICAgICAgICAgIHNpYmxpbmdfd2VpZ2h0ID0gc2libGluZ190bXA7CisgICAgICAgICAgICAgICAg
Y3B1bWFza19jbGVhcigmc2libGluZ19jYW5kaWRhdGVfbWFwKTsKKyAgICAgICAgICAgICAgICBj
cHVtYXNrX3NldF9jcHUoY3B1LCAmc2libGluZ19jYW5kaWRhdGVfbWFwKTsKKyAgICAgICAgICAg
IH0KKyAgICAgICAgICAgIGVsc2UgaWYgKCBzaWJsaW5nX3dlaWdodCA9PSBzaWJsaW5nX3RtcCAp
CisgICAgICAgICAgICAgICAgY3B1bWFza19zZXRfY3B1KGNwdSwgJnNpYmxpbmdfY2FuZGlkYXRl
X21hcCk7CisgICAgICAgIH0KKworICAgICAgICBjcHUgPSBjcHVtYXNrX2ZpcnN0KCZzaWJsaW5n
X2NhbmRpZGF0ZV9tYXApOworICAgIH0KKyAgICBicmVhazsKKworICAgIGNhc2UgQ09SRV9QQVJL
SU5HX0RFQ1JFTUVOVDoKKyAgICB7CisgICAgICAgIGNwdSA9IGNvcmVfcGFya2luZ19jcHVudW1b
Y3VyX2lkbGVfbnVtcyAtMV07CisgICAgfQorICAgIGJyZWFrOworCisgICAgZGVmYXVsdDoKKyAg
ICAgICAgYnJlYWs7CisgICAgfQorCisgICAgcmV0dXJuIGNwdTsKK30KIAogbG9uZyBjb3JlX3Bh
cmtpbmdfaGVscGVyKHZvaWQgKmRhdGEpCiB7Ci0gICAgcmV0dXJuIDA7CisgICAgdWludDMyX3Qg
aWRsZV9udW1zID0gKHVuc2lnbmVkIGxvbmcpZGF0YTsKKyAgICB1bnNpZ25lZCBpbnQgY3B1Owor
ICAgIGludCByZXQgPSAwOworCisgICAgaWYgKCAhY29yZV9wYXJraW5nX3BvbGljeSApCisgICAg
ICAgIHJldHVybiAtRUlOVkFMOworCisgICAgd2hpbGUgKCBjdXJfaWRsZV9udW1zIDwgaWRsZV9u
dW1zICkKKyAgICB7CisgICAgICAgIGNwdSA9IGNvcmVfcGFya2luZ19wb2xpY3ktPm5leHQoQ09S
RV9QQVJLSU5HX0lOQ1JFTUVOVCk7CisgICAgICAgIHJldCA9IGNwdV9kb3duKGNwdSk7CisgICAg
ICAgIGlmICggcmV0ICkKKyAgICAgICAgICAgIHJldHVybiByZXQ7CisgICAgICAgIGNvcmVfcGFy
a2luZ19jcHVudW1bY3VyX2lkbGVfbnVtcysrXSA9IGNwdTsKKyAgICB9CisKKyAgICB3aGlsZSAo
IGN1cl9pZGxlX251bXMgPiBpZGxlX251bXMgKQorICAgIHsKKyAgICAgICAgY3B1ID0gY29yZV9w
YXJraW5nX3BvbGljeS0+bmV4dChDT1JFX1BBUktJTkdfREVDUkVNRU5UKTsKKyAgICAgICAgcmV0
ID0gY3B1X3VwKGNwdSk7CisgICAgICAgIGlmICggcmV0ICkKKyAgICAgICAgICAgIHJldHVybiBy
ZXQ7CisgICAgICAgIGNvcmVfcGFya2luZ19jcHVudW1bLS1jdXJfaWRsZV9udW1zXSA9IC0xOwor
ICAgIH0KKworICAgIHJldHVybiByZXQ7CiB9CiAKIHVpbnQzMl90IGdldF9jdXJfaWRsZV9udW1z
KHZvaWQpCiB7CiAgICAgcmV0dXJuIGN1cl9pZGxlX251bXM7CiB9CisKK3N0YXRpYyBzdHJ1Y3Qg
Y29yZV9wYXJraW5nX3BvbGljeSBwb3dlcl9maXJzdCA9IHsKKyAgICAubmFtZSA9ICJwb3dlciIs
CisgICAgLm5leHQgPSBjb3JlX3BhcmtpbmdfcG93ZXIsCit9OworCitzdGF0aWMgc3RydWN0IGNv
cmVfcGFya2luZ19wb2xpY3kgcGVyZm9ybWFuY2VfZmlyc3QgPSB7CisgICAgLm5hbWUgPSAicGVy
Zm9ybWFuY2UiLAorICAgIC5uZXh0ID0gY29yZV9wYXJraW5nX3BlcmZvcm1hbmNlLAorfTsKKwor
c3RhdGljIGludCByZWdpc3Rlcl9jb3JlX3BhcmtpbmdfcG9saWN5KHN0cnVjdCBjb3JlX3Bhcmtp
bmdfcG9saWN5ICpwb2xpY3kpCit7CisgICAgaWYgKCAhcG9saWN5IHx8ICFwb2xpY3ktPm5leHQg
KQorICAgICAgICByZXR1cm4gLUVJTlZBTDsKKworICAgIGNvcmVfcGFya2luZ19wb2xpY3kgPSBw
b2xpY3k7CisgICAgcmV0dXJuIDA7Cit9CisKK3N0YXRpYyBpbnQgX19pbml0IGNvcmVfcGFya2lu
Z19pbml0KHZvaWQpCit7CisgICAgaW50IHJldCA9IDA7CisKKyAgICBpZiAoIGNvcmVfcGFya2lu
Z19jb250cm9sbGVyID09IFBFUkZPUk1BTkNFX0ZJUlNUICkKKyAgICAgICAgcmV0ID0gcmVnaXN0
ZXJfY29yZV9wYXJraW5nX3BvbGljeSgmcGVyZm9ybWFuY2VfZmlyc3QpOworICAgIGVsc2UKKyAg
ICAgICAgcmV0ID0gcmVnaXN0ZXJfY29yZV9wYXJraW5nX3BvbGljeSgmcG93ZXJfZmlyc3QpOwor
CisgICAgcmV0dXJuIHJldDsKK30KK19faW5pdGNhbGwoY29yZV9wYXJraW5nX2luaXQpOwo=

--_002_DE8DF0795D48FD4CA783C40EC829233509D8BCSHSMSX101ccrcorpi_--
