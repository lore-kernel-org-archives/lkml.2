Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754971Ab0F2X3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 19:29:09 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58293 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab0F2X3F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 19:29:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TkFKezOjGGY4VUyB6iXc2GHrglw2IWWelbK5BjVZ7vchu3f+A31XKJAHHhEIY2h5RC
         eNqQ62vgRmUJX0xPAzSFMIzsYXK0/mfU+F4/pcnkcXX/nPKUUPL7a0258mCWTgG/Km79
         1lwPrsv08lGhmzZaycnvKZf419DCpa9zoDMkM=
MIME-Version: 1.0
Date: Tue, 29 Jun 2010 19:29:01 -0400
Message-ID: <AANLkTim1m-HIRMHVIkJLSZitXCh1ZwKh2eAN3UxUxJ1E@mail.gmail.com>
Subject: [PATCH] virt-what.in: Added VMware virt detection using cpuid in 
	wrapper script
From: Chetan Loke <chetanloke@gmail.com>
To: Anthony Liguori <anthony@codemonkey.ws>, rjones@trick.home.annexia.org,
       rjones@redhat.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       Tzy-Jye Daniel Lin <ephemient@gmail.com>, chetanloke@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brief discussion thread - http://lkml.org/lkml/2010/6/29/355

Added VMware detection via cpuid.Mimic'd VMware's balloon driver's init-time
check(cpuid followed by dmi-checks). Moved the existing logic into a simple
function to achieve that.

Tested virt-what.in(ran as a script) and virt-what-cpuid-helper within
a Linux guest on ESX. Thanks.

Signed-off-by: Chetan Loke <loke.c@alumni.neu.edu>

---

virt-what.in | 150 ++++++++++++++++++++++++++++++++++++-----------------------
1 file changed, 93 insertions(+), 57 deletions(-)



--- virt-what.in.orig   2010-06-29 18:42:20.166647585 -0400
+++ virt-what.in        2010-06-29 18:59:54.765647739 -0400
@@ -25,9 +25,19 @@
 #
 # The following resources were useful in writing this script:
 # . http://www.dmo.ca/blog/20080530151107
+#
+#
+# Added VMware detection using cpuid.
+# Added functions to check the environment type
+# 06/29/2010 - Chetan Loke <loke.c@alumni.neu.edu>
+#
+

 VERSION="@VERSION@"

+cpuid=
+is_xen=1
+
 function fail {
    echo "virt-what: $1"
    exit 1
@@ -38,7 +48,8 @@
    echo "Options:"
    echo "  --help          Display this help"
    echo "  --version       Display version and exit"
-    exit 0
+    # exit after printing
+    exit 1
 }

 # Handle the command line arguments, if any.
@@ -70,74 +81,99 @@
 exec_prefix=@exec_prefix@
 PATH=@libexecdir@:/sbin:/usr/sbin:$PATH

-# Check for various products in the BIOS information.
+detect_virt_env_using_misc_info() {

-dmi=`dmidecode 2>&1`
+       # Check for various products in the BIOS information.

-if echo "$dmi" | grep -q 'Manufacturer: VMware'; then
-    echo vmware
-fi
+       dmi=`dmidecode 2>&1`

-if echo "$dmi" | grep -q 'Manufacturer: Microsoft Corporation'; then
-    echo virtualpc
-fi
+       if echo "$dmi" | grep -q 'Manufacturer: VMware'; then
+               echo vmware
+               exit 0
+       fi

-# Check for VirtualBox.
-# Added by Laurent Léonard.
-if echo "$dmi" | grep -q 'Manufacturer: innotek GmbH'; then
-    echo virtualbox
-fi
+       if echo "$dmi" | grep -q 'Manufacturer: Microsoft Corporation'; then
+               echo virtualpc
+               exit 0
+       fi

-# Check for OpenVZ / Virtuozzo.
-# Added by Evgeniy Sokolov.
-# /proc/vz - always exists if OpenVZ kernel is running (inside and outside
-# container)
-# /proc/bc - exists on node, but not inside container.
+       # Check for VirtualBox.
+       # Added by Laurent Léonard.
+       if echo "$dmi" | grep -q 'Manufacturer: innotek GmbH'; then
+               echo virtualbox
+               exit 0
+       fi

-if [ -d /proc/vz -a ! -d /proc/bc ]; then
-    echo openvz
-fi
+       # Check for OpenVZ / Virtuozzo.
+       # Added by Evgeniy Sokolov.
+       # /proc/vz - always exists if OpenVZ kernel is running (inside
and outside
+       # container)
+       # /proc/bc - exists on node, but not inside container.
+
+       if [ -d /proc/vz -a ! -d /proc/bc ]; then
+               echo openvz
+               exit 0
+       fi

-# Check for UML.
-# Added by Laurent Léonard.
-if grep -q 'UML' /proc/cpuinfo; then
-       echo uml
-fi
+       # Check for UML.
+       # Added by Laurent Léonard.
+       if grep -q 'UML' /proc/cpuinfo; then
+               echo uml
+               exit 0
+       fi
+
+       exit 1
+}

 # To tell if it is Xen and KVM HVM (fully virtualized) we can use this
 # helper C program.

-cpuid=`virt-what-cpuid-helper`
-
-# Check for Xen.
+detect_virt_env_using_cpuid () {
+       cpuid=`virt-what-cpuid-helper`
+
+       # Check for Xen.
+
+       if [ "$cpuid" = "XenVMMXenVMM" ]; then
+               echo xen; echo xen-hvm
+               exit 0
+       elif [ -f /proc/xen/privcmd ]; then
+               echo xen; echo xen-dom0
+               exit 0
+       elif [ -f /proc/xen/capabilities ]; then
+               echo xen; echo xen-domU
+               exit 0
+       elif [ -d /proc/xen ]; then
+               # This directory can be present when Xen paravirt drivers are
+               # installed, even on baremetal.  Don't confuse people by
+               # printing anything.
+               :
+       fi

-if [ "$cpuid" = "XenVMMXenVMM" ]; then
-    echo xen; echo xen-hvm
-    is_xen=1
-elif [ -f /proc/xen/privcmd ]; then
-    echo xen; echo xen-dom0
-    is_xen=1
-elif [ -f /proc/xen/capabilities ]; then
-    echo xen; echo xen-domU
-    is_xen=1
-elif [ -d /proc/xen ]; then
-    # This directory can be present when Xen paravirt drivers are
-    # installed, even on baremetal.  Don't confuse people by
-    # printing anything.
-    :
-fi
+       # Check for QEMU/KVM.

-# Check for QEMU/KVM.
+       if [ ! "$is_xen" ]; then
+               # Disable this test if we know this is Xen already, because Xen
+               # uses QEMU for its device model.
+
+       if grep -q 'QEMU' /proc/cpuinfo; then
+               if [ "$cpuid" = "KVMKVMKVM" ]; then
+                       echo kvm
+                       exit 0
+               else
+                       echo qemu
+                       exit 0
+               fi
+    fi
+       fi

-if [ ! "$is_xen" ]; then
-    # Disable this test if we know this is Xen already, because Xen
-    # uses QEMU for its device model.
-
-    if grep -q 'QEMU' /proc/cpuinfo; then
-       if [ "$cpuid" = "KVMKVMKVM" ]; then
-           echo kvm
-       else
-           echo qemu
+       # Check for VMware
+       if [ "$cpuid" = "VMwareVMware" ]; then
+               echo vmware
+               exit 0
       fi
-    fi
-fi
+}
+
+
+detect_virt_env_using_cpuid
+# If the above fails then call the next function
+detect_virt_env_using_misc_info
