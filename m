Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab2JWIGB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 04:06:01 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:20627
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752891Ab2JWIFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 04:05:05 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VPS3(zzc8kzz1202h1d1ah1d2ahzz8275ch8275bhz2dh668h839hd24he5bhf0ah107ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1155h)
X-WSS-ID: 0MCC6G0-02-2M3-02
X-M-MSG: 
From: <steffen.schwigon@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <ss5@renormalist.net>, <srostedt@redhat.com>,
        <Dariusz.Filipski@comarch.com>, <yoshitake.kobayashi@toshiba.co.jp>,
        <sassmann@redhat.com>, <andre.przywara@amd.com>,
        <frank.arnold@amd.com>, <conny.seidel@amd.com>, <csd@broadcom.com>,
        Steffen Schwigon <steffen.schwigon@amd.com>
Subject: [PATCH 1/2] bash-test-utils: support writing functional tests
Date: Tue, 23 Oct 2012 10:03:01 +0200
Message-ID: <1350979382-19983-2-git-send-email-steffen.schwigon@amd.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350979382-19983-1-git-send-email-steffen.schwigon@amd.com>
References: <1350979382-19983-1-git-send-email-steffen.schwigon@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steffen Schwigon <steffen.schwigon@amd.com>

It provides utility functions and facilities to write tests in
baremetal and Xen/KVM contexts (host and guest support) and was
polished to work with i686, x86_64, and ARM under lots of major
Linux distributions (Debian, Ubuntu, RHEL, SLES, Slackware,
Fedora, openSUSE).

It can be run as normal bash script or indirectly via the "prove"
command, a standard Linux tool to run test scripts.

Synopsis:

  $ cd /usr/src/linux

  $ cat t/my-feature-test.t
  #! /bin/bash
  . tools/testing/tap/bash-test-utils
  test_feature_foo
  ok $? "feature foo"
  done_testing

  $ prove -v t/my-feature-test.t

Signed-off-by: Steffen Schwigon <steffen.schwigon@amd.com>
Signed-off-by: Andre Przywara <andre.przywara@amd.com>
Signed-off-by: Frank Arnold <frank.arnold@amd.com>
Signed-off-by: Conny Seidel <conny.seidel@amd.com>
Signed-off-by: Christian Daudt <csd@broadcom.com>
---
 tools/testing/tap/bash-test-utils     | 1508 +++++++++++++++++++++++++++++++++
 tools/testing/tap/bash-test-utils.txt |  320 +++++++
 2 files changed, 1828 insertions(+)
 create mode 100755 tools/testing/tap/bash-test-utils
 create mode 100644 tools/testing/tap/bash-test-utils.txt

diff --git a/tools/testing/tap/bash-test-utils b/tools/testing/tap/bash-test-utils
new file mode 100755
index 0000000..68661dd
--- /dev/null
+++ b/tools/testing/tap/bash-test-utils
@@ -0,0 +1,1508 @@
+#! /bin/bash
+
+# bash-test-utils -- an include file to support writing test scripts.
+#
+# --------------------------------------------------------------------
+#
+# It provides utility functions and facilities to write tests in
+# baremetal and Xen/KVM contexts (host and guest support) and was
+# polished to work with i686, x86_64, and ARM under lots of major
+# Linux distributions (Debian, Ubuntu, RHEL, SLES, Slackware,
+# Fedora, openSUSE).
+#
+# It can be run as normal bash script or indirectly via the "prove"
+# command, a standard Linux tool to run test scripts.
+#
+# Synopsis:
+#
+#   $ cd /usr/src/linux
+#
+#   $ cat > t/my-feature-test.t
+#   #! /bin/bash
+#   . tools/testing/tap/bash-test-utils
+#   test_feature_foo
+#   ok $? "feature foo worked"
+#   done_testing
+#
+#   $ prove -v t/my-feature-test.t
+#
+# --------------------------------------------------------------------
+#
+# Copyright (c) 2009-2012, Advanced Micro Devices, Inc.
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License version 2 as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+
+
+# ==================== Utility functions =============================
+
+# constants
+_SUCCESS=0
+_FAILURE=1
+
+# gets vendor "AMD" or "Intel" from /proc/cpuinfo
+get_vendor () {
+    vendor=$(echo $(grep vendor_id /proc/cpuinfo |head -1|cut -d: -f2|sed -e "s/Genuine\|Authentic//"))
+    echo $vendor
+}
+
+# checks for vendor "Intel" in /proc/cpuinfo
+vendor_intel () {
+    grep -Eq 'vendor_id.*:.*Intel' /proc/cpuinfo
+}
+
+# checks for vendor "AMD" in /proc/cpuinfo
+vendor_amd () {
+    grep -Eq 'vendor_id.*:.*AMD' /proc/cpuinfo
+}
+
+# stops testscript if not matching required cpu vendor
+require_vendor_intel () {
+    if vendor_intel
+    then
+        if [ "x1" = "x$REQUIRES_GENERATE_TAP" ] ; then ok 0 "require_vendor_intel" ; fi
+        return $_SUCCESS
+    else
+        explanation="${1:-vendor does not match Intel}"
+        autoreport_skip_all "$explanation"
+    fi
+}
+
+# stops testscript if not matching required cpu vendor
+require_vendor_amd () {
+    if vendor_amd
+    then
+        if [ "x1" = "x$REQUIRES_GENERATE_TAP" ] ; then ok 0 "require_vendor_amd" ; fi
+        return $_SUCCESS
+    else
+        explanation="${1:-vendor does not match AMD}"
+        autoreport_skip_all "$explanation"
+    fi
+}
+
+# Checks for ARM cpu
+arm_cpu () {
+    grep -Eqi 'Processor.*:.*ARM' /proc/cpuinfo
+}
+
+# outputs cpu stepping from /proc/cpuinfo
+get_cpu_stepping () {
+    echo $(echo $(grep "^stepping" /proc/cpuinfo |head -1|cut -d: -f2))
+}
+# outputs cpu model from /proc/cpuinfo
+get_cpu_model () {
+    echo $(echo $(grep "^model[^ ]" /proc/cpuinfo |head -1|cut -d: -f2))
+}
+
+# outputs cpu model from /proc/cpuinfo
+get_cpu_model_hex () {
+    echo "0x"$(get_hex_from_int $(get_cpu_model))
+}
+
+# checks cpu model from /proc/cpuinfo against a minimum model
+cpu_model_min () {
+    min=${1:-0}
+    mod=$(get_cpu_model)
+    [ $(($mod)) -ge $(($min)) ]
+}
+
+# checks cpu model from /proc/cpuinfo against a maximum model
+cpu_model_max () {
+    max=${1:-0x999}
+    mod=$(get_cpu_model)
+    [ $(($mod)) -le $(($max)) ]
+}
+
+# outputs cpu family from /proc/cpuinfo
+# since all testsuites using hex values, return value in hex format
+get_cpu_family () {
+    echo $(echo $(grep "^cpu family" /proc/cpuinfo |head -1|cut -d: -f2))
+}
+
+get_cpu_family_hex () {
+    echo "0x"$(get_hex_from_int $(get_cpu_family))
+}
+
+# checks cpu family from /proc/cpuinfo against a minimum family
+cpu_family_min () {
+    min=${1:-0}
+    fam=$(get_cpu_family)
+    [ $(($fam)) -ge $(($min)) ]
+}
+
+# checks cpu family from /proc/cpuinfo against a maximum family
+cpu_family_max () {
+    max=${1:-0x999}
+    fam=$(get_cpu_family)
+    [ $(($fam)) -le $(($max)) ]
+}
+
+is_amd_family_range () {
+    min="${1:-0}"
+    max="${2:-$min}"
+    if vendor_amd && cpu_family_min "$min" && cpu_family_max "$max" ; then
+        return $_SUCCESS
+    else
+        return $_FAILURE
+    fi
+}
+
+# stops testscript if not matching required cpu family from
+# /proc/cpuinfo of a minimum/maximum range
+require_amd_family_range () {
+    min="${1:-0}"
+    max="${2:-$min}"
+    if is_amd_family_range "$min" "$max" ; then
+        if [ "x1" = "x$REQUIRES_GENERATE_TAP" ] ; then ok 0 "require_amd_family_range $min $max" ; fi
+        return $_SUCCESS
+    else
+        vendor=$(get_vendor);
+        fam=$(printf "0x%x" $(get_cpu_family));
+        explanation="${3:-Family $vendor/$fam does not match AMD/$min..$max}"
+        autoreport_skip_all "$explanation"
+    fi
+}
+
+# Checks all nodes for NB devices with one of the supplied PCI device ids
+# Note: Call it separately for different PCI device functions
+has_amd_nb_function_id () {
+    devids=${@:-"0xffffffff"}
+
+    for devid in $devids; do
+        devid=$(printf '0x%x' $devid)
+        nbdevs="/sys/bus/pci/devices/0000:00:1[89abcdef].*"
+
+        [ $(ls $nbdevs 2>/dev/null | wc -l) -gt 0 ] || continue
+
+        f0devs="/sys/bus/pci/devices/0000:00:1[89abcdef].0/vendor"
+        northbridges=$(ls $f0devs 2>/dev/null | wc -l)
+
+        devices=0
+        for nbdev in $nbdevs; do
+            vendor=$(cat $nbdev/vendor 2>/dev/null)
+            if [ "$vendor" != "0x1022" ]; then
+                return $_FAILURE
+            fi
+
+            device=$(cat $nbdev/device 2>/dev/null)
+            if [ "$device" = "$devid" ]; then
+                let devices++
+            fi
+        done
+
+        if [ $devices -gt 0 -a $devices -eq $northbridges ]; then
+            return $_SUCCESS
+        fi
+    done
+
+    return $_FAILURE
+}
+
+# Stops if no NB devices with one of supplied PCI device ids exist on all nodes
+# Note: Call it separately for different PCI device functions
+require_amd_nb_function_id () {
+    devids=${@:-"0xffffffff"}
+    if has_amd_nb_function_id "$devids"; then
+        if [ "x1" = "x$REQUIRES_GENERATE_TAP" ] ; then ok $_SUCCESS "require_amd_nb_function_id" ; fi
+    else
+        autoreport_skip_all "No supported AMD northbridge function devices"
+    fi
+}
+
+get_number_cpus () {
+    (getconf _NPROCESSORS_ONLN || grep -ci "^bogomips" /proc/cpuinfo || echo -1) 2>/dev/null
+}
+
+# check sysfs whether cpu has L3 cache
+has_l3cache () {
+    if [ -d /sys/devices/system/cpu/cpu0/cache/index3 ] ; then
+        return $_SUCCESS
+    else
+        return $_FAILURE
+    fi
+}
+
+# stops testscript if cpu does not have L3 cache
+require_l3cache () {
+    explanation="${1:-No L3 cache}"
+    if has_l3cache ; then
+        if [ "x1" = "x$REQUIRES_GENERATE_TAP" ] ; then ok $_SUCCESS "require_l3cache" ; fi
+        return $_SUCCESS
+    else
+        autoreport_skip_all "$explanation"
+    fi
+}
+
+# check x86_64
+is_x86_64 () {
+    if uname -m | grep -q x86_64 ; then
+        return $_SUCCESS
+    else
+        return $_FAILURE
+    fi
+}
+
+# stops testscript if is not x86_64
+require_x86_64 () {
+    explanation="${1:-No x86_64}"
+    if is_x86_64 ; then
+        if [ "x1" = "x$REQUIRES_GENERATE_TAP" ] ; then ok $_SUCCESS "require_x86_64" ; fi
+        return $_SUCCESS
+    else
+        autoreport_skip_all "$explanation"
+    fi
+}
+
+# scan all PCI devices for one with XenSource's PCI-ID
+has_xen_pci_device() {
+    # try lspci (not in PATH if not root)
+    _ta_xen_LSPCI=$(which lspci 2> /dev/null) || _ta_xen_LSPCI=/sbin/lspci
+    if [ -x "$_ta_xen_LSPCI" ]
+    then
+        $_ta_xen_LSPCI -n | grep -q " 5853:"
+        return $?
+    else
+        # directly query sysfs and check for XenSource's PCI-ID
+        if [ -r /sys/bus/pci/devices/0000:00:00.0/vendor ] ; then
+            cat /sys/bus/pci/devices/*/vendor | grep -q 0x5853
+            return $?
+        else
+            return $_FAILURE
+        fi
+    fi
+}
+
+# checks the PCI hostbridge's vendor and optionally device ID
+# usage: check_hostbridge 0x1022 (for checking for AMD northbridge)
+#        check_hostbridge 0x8086 0x1237 (for QEMU host bridge)
+check_hostbridge() (
+    LSPCI=$(which lspci 2> /dev/null) || LSPCI=/sbin/lspci
+    if [ -x "$LSPCI" ]
+    then
+        lspciout=$($LSPCI -s 0:0.0 -n | cut -d: -f3- | tr -d \ )
+        vendor="0x$(echo $lspciout | cut -d: -f1)"
+        device="0x$(echo $lspciout | cut -d: -f2)"
+    else
+        vendor=$(cat /sys/bus/pci/devices/0000:00:00.0/vendor)
+        device=$(cat /sys/bus/pci/devices/0000:00:00.0/device)
+    fi
+    [ "$vendor" = "$1" ] || return $_FAILURE
+    [ -z "$2" ] && return $_SUCCESS
+    [ "$device" = "$2" ]
+    return $?
+)
+
+# checks whether the Xen hypervisor is running
+# this returns 0 if we are a Dom0 or PV DomU or HVM DomU
+is_running_under_xen_hv () {
+    if [ -r /sys/hypervisor/type ] ; then
+        [ $(cat /sys/hypervisor/type) = "xen" ]
+        return $?
+    fi
+
+    [ -r /proc/xen/capabilities ] && return $_SUCCESS
+
+    # Linux denies registering XenFS if not running under Xen
+    if has_kernel_config CONFIG_XENFS ; then
+        grep -q xenfs /proc/filesystems
+        return $?
+    fi
+
+    # TODO: do older kernels support this? At least RHEL5 does
+    has_cpufeature hypervisor || return $_FAILURE
+
+    _ta_e820prov=$(dmesg | sed -e 's/^\[.*\] *//' | grep -A1 "^BIOS-provided physical RAM map:" | tail -1 | cut -d: -f1)
+    [ -n "$_ta_820prov" ] && [ "$_ta_e820prov" = "Xen" ] && return $_SUCCESS
+
+    dmesg | grep -q "Booting paravirtualized kernel on Xen" && return $_SUCCESS
+
+    return $_FAILURE
+}
+
+# check if we are in a Xen host
+# it is a bit tricky to differentiate Dom0 and (PV-)DomU
+is_running_in_xen_dom0 () {
+
+    # this is a definite way to check for Dom0, but not always available, since
+    # XENFS could not be mounted
+    if [ -r /proc/xen/capabilities ] ; then
+        grep -q control_d /proc/xen/capabilities
+        return $?
+    fi
+
+    # this should sort out most of the other possibilities
+    is_running_under_xen_hv || return $_FAILURE
+
+    # we need to sort out only Dom0 vs. DomU from now on
+
+    # an ATI or AMD northbridge means Dom0
+    if check_hostbridge 0x1002 || check_hostbridge 0x1022 ; then
+        return $_SUCCESS
+    fi
+
+    # a QEMU northbridge cannot be Dom0
+    check_hostbridge 0x8086 0x1237 && return $_FAILURE
+
+    # out of clues, but we are probably not Dom0 at this point anymore
+    return $_FAILURE
+}
+
+# check if we are in a KVM host
+is_running_in_kvm_host () {
+    [ -e /dev/kvm ]
+}
+
+# check if we have KVM guests running
+has_kvm_guests () {
+    counter=$(lsmod |grep '^kvm_'|awk '{print $3}')
+    if [ $counter -gt 0 ] ; then
+        return $_SUCCESS
+    else
+        return $_FAILURE
+    fi
+}
+
+get_xen_tool() {
+    which xl 2> /dev/null || which xm 2> /dev/null
+}
+
+get_number_xen_guests() {
+    XL=$(get_xen_tool) || return $_FAILURE
+    res=$($XL list | wc -l)
+    if [ -n "$res" -a "$res" -ge 2 ] ; then
+        echo "$((res-2))"
+        return $_SUCCESS
+    else
+        echo "0"
+        return $_FAILURE
+    fi
+}
+
+# check if we are in a Xen guest
+# Note:
+#   In Xen the dom0 reports the same 'hypervisor' flag and CPUID entry
+#   as in domU therefore the CPUID check is not enough, but dmidecode
+#   and lspci show different devices inside a domU.
+is_running_in_xen_guest () {
+
+    is_running_under_xen_hv || return $_FAILURE
+
+    has_xen_pci_device && return $_SUCCESS
+
+    check_hostbridge 0x8086 0x1237 && return $_SUCCESS
+
+    # try dmidecode
+    if dmidecode > /dev/null 2>&1 ; then
+        _dmi_chassis=$(dmidecode -s chassis-manufacturer)
+        # dmidecode does not output anything in PV Xen
+        if [ -n "$_dmi_chassis" ] ; then
+            echo "$_dmi_chassis" | grep -q Xen
+            return $?
+        fi
+    fi
+
+    # last resort: check for Xen Dom0
+    is_running_in_xen_dom0 && return $_FAILURE
+
+    # there are no PCI device by default in PV guests
+    _nr_pci_devices=$(ls /sys/bus/pci/devices | wc -l)
+    [ "$_nr_pci_devices" -eq 0 ] && return $_SUCCESS
+
+    # no more clues at this point, assume we are some kind of DomU
+    return $_SUCCESS
+}
+
+# check if we are in a KVM guest
+# Note:
+#   In KVM the hypervisor CPUID check is relieable and we can first
+#   narrow it against being not a Xen guest. After that the devices
+#   are less significant in KVM so here we then check for the CPUID.
+is_running_in_kvm_guest () {
+
+    is_running_in_xen_guest && return $_FAILURE
+    has_cpufeature hypervisor || return $_FAILURE
+
+    # try to load the cpuid module if not already done
+    [ -c /dev/cpu/0/cpuid ] || modprobe cpuid > /dev/null 2>&1
+
+    if [ -c /dev/cpu/0/cpuid ] ; then
+        virtvendor=$(dd if=/dev/cpu/0/cpuid bs=16 skip=67108864 count=1 2> /dev/null)
+        [ "$virtvendor" = "KVMKVMKVM" ]
+        return $?
+    fi
+    return 1
+}
+
+# check if we are in a virtualized guest (Xen or KVM)
+is_running_in_virtualized_guest () {
+    is_running_in_xen_guest || is_running_in_kvm_guest
+    return $?
+}
+
+# stops testscript if we aren't a Xen guest
+require_running_in_xen_guest () {
+    explanation="${1:-Needs to run in Xen guest}"
+    if is_running_in_xen_guest ; then
+        if [ "x1" = "x$REQUIRES_GENERATE_TAP" ] ; then ok $_SUCCESS "require_running_in_xen_guest" ; fi
+        return $_SUCCESS
+    else
+        autoreport_skip_all "$explanation"
+    fi
+}
+
+# stops testscript if we aren't a Xen dom0
+require_running_in_xen_dom0 () {
+    explanation="${1:-Needs to run in Xen dom0}"
+    if is_running_in_xen_dom0 ; then
+        if [ "x1" = "x$REQUIRES_GENERATE_TAP" ] ; then ok $_SUCCESS "require_running_in_xen_dom0" ; fi
+        return $_SUCCESS
+    else
+        autoreport_skip_all "$explanation"
+    fi
+}
+
+# stops testscript if we aren't a KVM guest
+require_running_in_kvm_guest () {
+    explanation="${1:-Needs to run in KVM guest}"
+    if is_running_in_kvm_guest ; then
+        if [ "x1" = "x$REQUIRES_GENERATE_TAP" ] ; then ok $_SUCCESS "require_running_in_kvm_guest" ; fi
+        return $_SUCCESS
+    else
+        autoreport_skip_all "$explanation"
+    fi
+}
+
+# stops testscript if we aren't a KVM host
+require_running_in_kvm_host () {
+    explanation="${1:-Needs to run in KVM host}"
+    if is_running_in_kvm_host ; then
+        if [ "x1" = "x$REQUIRES_GENERATE_TAP" ] ; then ok $_SUCCESS "require_running_in_kvm_host" ; fi
+        return $_SUCCESS
+    else
+        autoreport_skip_all "$explanation"
+    fi
+}
+
+# stops testscript if we aren't a virtualized guest
+require_running_in_virtualized_guest () {
+    explanation="${1:-Needs to run in virtualized guest}"
+    if is_running_in_virtualized_guest ; then
+        if [ "x1" = "x$REQUIRES_GENERATE_TAP" ] ; then ok $_SUCCESS "require_running_in_virtualized_guest" ; fi
+        return $_SUCCESS
+    else
+        autoreport_skip_all "$explanation"
+    fi
+}
+
+# checks for a feature flag in /proc/cpuinfo
+has_cpufeature () {
+    _ta_feature="${1:-UNKNOWNFEATURE}"
+    if cat /proc/cpuinfo | grep -E '^flags\W*:' | head -1 | sed -e 's/^flags\W*://' | grep -q "\<${_ta_feature}\>" 2>&1 ; then
+        return $_SUCCESS
+    else
+        return $_FAILURE
+    fi
+}
+
+# stops testscript if a feature flag is not found in /proc/cpuinfo
+require_cpufeature () {
+    _ta2_feature="${1:-UNKNOWNFEATURE}"
+    explanation="${2:-Missing cpufeature $_ta2_feature}"
+    if has_cpufeature "$_ta2_feature" ; then
+        if [ "x1" = "x$REQUIRES_GENERATE_TAP" ] ; then ok $_SUCCESS "require_cpufeature $_ta2_feature" ; fi
+        return $_SUCCESS
+    else
+        autoreport_skip_all "$explanation"
+    fi
+}
+
+# checks for a config in /proc/config.gz or /boot/config/$(uname -r)
+has_kernel_config () {
+    _ta3_feature="${1:-UNKNOWNFEATURE}"
+    CONFIG=$(get_first_file "/proc/config.gz" "/boot/config-$(uname -r)")
+    if [ -z "$CONFIG" ] ; then
+        return $_FAILURE
+    fi
+    if echo $CONFIG | grep -q '\.gz' ; then
+        gzip -cd "$CONFIG" | grep -q "^${_ta3_feature}=."
+    else
+        grep -q "^${_ta3_feature}=." "$CONFIG"
+    fi
+}
+
+# stops testscript if a feature flag is not found in /proc/cpuinfo
+require_kernel_config () {
+    _ta4_feature="${1:-UNKNOWNFEATURE}"
+    explanation="${2:-Missing kernel config $_ta4_feature}"
+    if has_kernel_config "$_ta4_feature" ; then
+        if [ "x1" = "x$REQUIRES_GENERATE_TAP" ] ; then ok $_SUCCESS "require_kernel_config $_ta4_feature" ; fi
+        return $_SUCCESS
+    else
+        autoreport_skip_all "$explanation"
+    fi
+}
+
+# Enable CPU frequency scaling and set sane defaults
+# - Makes sure the appropriate cpufreq driver is loaded
+# - Enables ondemand governor on all cores
+# - Sets the boost state, on=1 (default), off=0
+enable_cpufreq () {
+    booststate="$1"
+    [ "$booststate" != "0" ] && booststate=1
+
+    # Load cpufreq driver module
+    for module in acpi-cpufreq powernow-k8; do
+        [ -d /sys/devices/system/cpu/cpu0/cpufreq ] && break
+        modprobe $module 2>/dev/null
+    done
+    if [ ! -d /sys/devices/system/cpu/cpu0/cpufreq ]; then
+        echo "failed to load cpufreq driver"
+        return $_FAILURE
+    fi
+
+    # Load ondemand governor module and set ondemand governor
+    if ! grep -q ondemand /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors; then
+        modprobe cpufreq-ondemand 2>/dev/null
+    fi
+    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
+        echo ondemand > $cpu 2>/dev/null
+        if [ "$(cat $cpu)" != "ondemand" ]; then
+            echo "failed to set ondemand governor"
+            return $_FAILURE
+        fi
+    done
+
+    # Set requested boost state
+    if ! has_cpufeature cpb; then
+        return $_SUCCESS
+    elif [ -f /sys/devices/system/cpu/cpufreq/boost ]; then
+        interfaces="/sys/devices/system/cpu/cpufreq/boost"
+    elif [ $(ls /sys/devices/system/cpu/cpu*/cpufreq/cpb 2>/dev/null | wc -l) -gt 0 ]; then
+        interfaces="/sys/devices/system/cpu/cpu*/cpufreq/cpb"
+    elif grep -q " show_cpb\| show_global_boost" /proc/kallsyms; then
+        echo "failed to find sysfs boost state interface"
+        return $_FAILURE
+    elif [ $booststate -eq 0 ]; then
+        echo "cpufreq driver doesn't provide sysfs boost state interface"
+        return $_FAILURE
+    else
+        return $_SUCCESS
+    fi
+    for interface in $interfaces; do
+       echo $booststate > $interface 2>/dev/null
+       if [ "$(cat $interface)" != "$booststate" ]; then
+            echo "failed to set requested boost state"
+            return $_FAILURE
+       fi
+    done
+
+    return $_SUCCESS
+}
+
+require_cpufreq_enabled () {
+    explanation="${1:-CPUFreq not available}"
+    reason=$(enable_cpufreq 1)
+    if [ $? -eq $_SUCCESS ] ; then
+        if [ "x1" = "x$REQUIRES_GENERATE_TAP" ] ; then ok $_SUCCESS "require_cpufreq_enabled" ; fi
+        return $_SUCCESS
+    else
+        autoreport_skip_all "$explanation ($reason)"
+    fi
+}
+
+require_cpb_disabled () {
+    explanation="${1:-Failed to disable Core Boosting}"
+    reason=$(enable_cpufreq 0)
+    if [ $? -eq $_SUCCESS ] ; then
+        if [ "x1" = "x$REQUIRES_GENERATE_TAP" ] ; then ok $_SUCCESS "require_cpufreq_enabled" ; fi
+        return $_SUCCESS
+    else
+        autoreport_skip_all "$explanation ($reason)"
+    fi
+}
+
+request_cpufreq_enabled () {
+    todo="# TODO $(enable_cpufreq 1)" && todo=""
+    ok $? "request_cpufreq_enabled $todo"
+    [ -n "$todo" ] && return $_FAILURE
+    return $_SUCCESS
+}
+
+request_cpb_disabled () {
+    todo="# TODO $(enable_cpufreq 0)" && todo=""
+    ok $? "request_cpb_disabled $todo"
+    [ -n "$todo" ] && return $_FAILURE
+    return $_SUCCESS
+}
+
+# disables core performance boosting for reproducable and well scaling
+# benchmarks. Tries hard to learn the actual state and to really disable
+# it. Diagnostic messages will be print to stdout, the return value
+# describes the success: 0=CPB is disabled, 1=CPB is (probably) still enabled.
+# possible usage (failed disabling is non-fatal, but report it):
+#   todostem="# TODO "
+#   expl=$(disable_cpb) && todostem=""
+#   ok $? "disable CPB $todostem$expl"
+# or a fatal version ending the script:
+#   expl=$(disable_cpb)
+#   require_ok $? "disable CPB"
+# or: just try to disable it, but don't care if we fail
+#   disable_cpb > /dev/null
+disable_cpb() {
+    # check whether the CPB sysfs knob is there
+    if [ ! -r /sys/devices/system/cpu/cpu0/cpufreq/cpb ] ; then
+        is_running_in_virtualized_guest && _cpbhint=" (running virtualized)"
+        # if the CPU does not support boosting, we dont care
+        if ! has_cpufeature cpb ; then
+            echo "# CPU has no CPB support$_cpbhint"
+            return 0
+        fi
+        # is the powernow_k8 driver loaded?
+        if ! grep -q " powernowk8_init" /proc/kallsyms; then
+            # if not, try to load it
+            if ! _modprobe_res=$(modprobe powernow_k8 2>&1) ; then
+                echo "# modprobe powernow_k8: $_modprobe_res"
+                return 1
+            fi
+        fi
+        # does this version of powernow_k8 support CPB?
+        if ! grep -q " show_cpb" /proc/kallsyms ; then
+            echo "# powernow_k8 loaded, but no CPB support"
+            return 1
+        fi
+    fi
+    # now check for the sysfs knob again (we may have loaded the driver)
+    if [ ! -r /sys/devices/system/cpu/cpu0/cpufreq/cpb ] ; then
+        echo "# no sysfs knob for disabling CPB, probably still active"
+        return 1
+    fi
+
+    # if the knob is there and it reads 0, everything is fine
+    if [ $(cat /sys/devices/system/cpu/cpu0/cpufreq/cpb) = "0" ] ; then
+        echo "# CPB already disabled"
+        return 0
+    fi
+    # try to disable CPB on all cores and count the number of failures
+    failures=0
+    for cpb in /sys/devices/system/cpu/cpu*/cpufreq/cpb; do
+        echo 0 2> /dev/null > $cpb || let failures++
+    done
+    # no failures means everything is fine
+    if [ "$failures" = 0 ] ; then
+        echo "# CPB successfully disabled"
+        return 0
+    fi
+    # don't give up so quickly, try to explore dmesg for the right message
+    if $(dmesg | grep -q "Core Boosting .*abled") ; then
+        # there was at least one messages, check the last one
+        if dmesg | grep -q "Core Boosting .*abled" | tail -1 | grep -q "Core Boosting disabled" ; then
+            # the last message says its disabled, believe this
+            echo "# CPB disabling failed, but probably disabled before"
+            return 0
+        else
+            # the last message says its enabled, we failed eventually
+            echo "# CPB disabling failed (no permissions), CPB active"
+            return 1
+        fi
+    fi
+    # we have no real clue at this point, but assume the worst
+    echo "# CPB disabling failed, probably still active"
+    return 1
+}
+
+# checks whether the cpbdisable file exists in sysfs
+has_cpbdisable () {
+    # This file's existence is not the best check.
+    # It also exists on non-cpb systems.
+    if [ -e /sys/devices/system/cpu/cpu0/cpufreq/cpb ] ; then
+        return $_SUCCESS
+    else
+        return $_FAILURE
+    fi
+}
+
+# stops testscript if the cpbdisable file does not exist in sysfs
+require_cpbdisable () {
+    explanation="${1:-No CPB disable}"
+    if has_cpbdisable ; then
+        if [ "x1" = "x$REQUIRES_GENERATE_TAP" ] ; then ok $_SUCCESS "require_cpbdisable" ; fi
+        return $_SUCCESS
+    else
+        autoreport_skip_all "$explanation"
+    fi
+}
+
+# checks whether the module is ther
+has_module () {
+    module="${1:-UNKNOWNMODULE}"
+    if lsmod | grep -q "^$module\b" ; then
+        return $_SUCCESS
+    else
+        return $_FAILURE
+    fi
+}
+
+# stops testscript if the cpbdisable file does not exist in sysfs
+require_module () {
+    module="${1:-UNKNOWNMODULE}"
+    explanation="${2:-No module $module disable}"
+    if has_module "$module"; then
+        if [ "x1" = "x$REQUIRES_GENERATE_TAP" ] ; then ok $_SUCCESS "require_module" ; fi
+        return $_SUCCESS
+    else
+        autoreport_skip_all "$explanation"
+    fi
+}
+
+# checks whether the program is available
+has_program () {
+    program="${1:-UNKNOWNPROGRAM}"
+    if which "$program" > /dev/null 2>&1 ; then
+        return $_SUCCESS
+    else
+        return $_FAILURE
+    fi
+}
+
+# stops testscript if program not available
+require_program () {
+    program="${1:-UNKNOWNPROGRAM}"
+    explanation="${2:-Missing program $program}"
+    if has_program "$program" ; then
+        return $_SUCCESS
+    else
+        autoreport_skip_all "$explanation"
+    fi
+}
+
+# checks whether the file is available
+has_file () {
+    file="${1:-UNKNOWNFILE}"
+    explanation="${2:-Missing file $file}"
+    if [ -e "$file" ] ; then
+        return $_SUCCESS
+    else
+        return $_FAILURE
+    fi
+}
+
+# stops testscript if file not available
+require_file () {
+    file="${1:-UNKNOWNFILE}"
+    explanation="${2:-Missing file $file}"
+    if has_file "$file" ; then
+        if [ "x1" = "x$REQUIRES_GENERATE_TAP" ] ; then ok $_SUCCESS "require_file $file" ; fi
+        return $_SUCCESS
+    else
+        autoreport_skip_all "$explanation"
+    fi
+}
+
+# checks whether the script's criticality is in allowed range
+has_crit_level () {
+    _ta_crit_level="${1:-5}"
+    _ta_crit_level_allowed="${CRITICALITY:-0}"
+    if [ $_ta_crit_level -le $_ta_crit_level_allowed ] ; then
+        return $_SUCCESS;
+    else
+        return $_FAILURE
+    fi
+}
+
+# stops testscript if script's criticality is not in allowed range
+require_crit_level () {
+    _ta_crit_level="${1:-5}"
+    _ta_crit_level_allowed="${CRITICALITY:-0}"
+    explanation="${2:-Too high criticality level: $_ta_crit_level (CRITICALITY=$_ta_crit_level_allowed)}"
+
+    if has_crit_level $_ta_crit_level ; then
+        if [ "x1" = "x$REQUIRES_GENERATE_TAP" ] ; then ok $_SUCCESS "criticality level $_ta_crit_level (CRITICALITY=$_ta_crit_level_allowed)" ; fi
+        return $_SUCCESS
+    else
+        autoreport_skip_all "$explanation"
+    fi
+}
+
+require_root () {
+    explanation="${1:-Need to run as root}"
+    ID=$(id|cut -d" " -f1|cut -d= -f2|cut -d\( -f1)
+    if [ "x$ID" == "x0" ] ; then
+        if [ "x1" = "x$REQUIRES_GENERATE_TAP" ] ; then ok $_SUCCESS "require_root" ; fi
+        return $_SUCCESS
+    else
+        autoreport_skip_all "$explanation"
+    fi
+}
+
+get_first_file () {
+    for i in $(seq 1 $#) ; do
+        file=${!i}
+        if [ -r "$file" ] ; then
+            echo "$file"
+            return
+        fi
+    done
+}
+
+# checks whether MSRs could be read from userspace
+# will try to load the appropriate kernel module if not already done
+# will return an error if the file is not readable (not root)
+has_msr_access() (
+    cpu=${1:-0}
+    if [ ! -e /dev/cpu/$cpu/msr ] ; then
+        has_program modprobe || return 1
+        modprobe msr || return 1
+    fi
+    [ -r /dev/cpu/$cpu/msr ]
+)
+
+# reads a MSR via the /dev/cpu/<n>/msr device
+# expects the MSR number (in hex) as the first parameter and optionally the
+# CPU number from which to read as the second argument (defaults to 0)
+# outputs a 16 char hex value (lower case letters) to stdout
+# returns 0 on success, 1 for an invalid MSR and 2 for permission issues
+read_msr() (
+    cpu=${2:-0}
+    if has_program rdmsr ; then
+        rdmsr -x -0 -p $cpu "$1" 2> /dev/null
+        return $?
+    fi
+    [ -r /dev/cpu/$cpu/msr ] || return 2
+
+    perl -e 'my $msr;sysseek(STDIN,hex($ARGV[0]),0);sysread(STDIN,$msr,8) or exit(1);my @words=unpack("LL",$msr);printf("%08x%08x\n",$words[1],$words[0]);' $1 < /dev/cpu/$cpu/msr
+)
+
+# writes a MSR via the /dev/cpu/<n>/msr device
+# expects the MSR number (in hex) as the first parameter, the value (in hex)
+# is the second one. Optionally the CPU number to use for the write can be
+# given as the third argument (defaults to 0)
+# returns 0 on success, 1 for an invalid MSR and 2 for permission issues
+write_msr() (
+    [ $# -lt 2 ] && return 3
+    cpu=${3:-0}
+    if has_program wrmsr ; then
+        wrmsr -p $cpu "$1" "$2" 2> /dev/null
+        return $?
+    fi
+    [ -w /dev/cpu/$cpu/msr ] || return 2
+    low=$(printf "0x%x" $(($2 & (2**32 - 1))))
+    high=$(printf "0x%x" $((($2 >> 32) & (2**32 - 1))))
+    perl -e 'my $value=pack("LL",hex($ARGV[1]),hex($ARGV[2]));sysseek(STDOUT,hex($ARGV[0]),0);syswrite(STDOUT,$value,8) or exit(1);' $1 $low $high > /dev/cpu/$cpu/msr
+)
+
+# Reads an entire cpuid register
+# Usage: get_cpuid_register <leafnr_in_hex> e[abcd]x
+# Example: get_cpuid_register 0x80000001 ecx
+# Outputs the decimal register value to stdout
+# Returns 0 for success, 1 for invalid cpuid leaf, 2 for permission
+get_cpuid_register() {
+    [ $# -lt 2 ] && return 3
+    cpu=${3:-0}
+
+    # try to load the cpuid module if not already done
+    [ -c /dev/cpu/$cpu/cpuid ] || modprobe cpuid > /dev/null 2>&1
+    [ -r /dev/cpu/$cpu/cpuid ] || return 2
+
+    perl -e 'my $leaf;sysseek(STDIN, hex($ARGV[0]),0);sysread(STDIN,$leaf,16) or exit(1);my @regs=unpack("LLLL",$leaf);printf("%u\n",$regs[ord(substr($ARGV[1],1,1))-ord("a")]);' $1 $2 < /dev/cpu/$cpu/cpuid
+}
+
+# Reads a cpuid register and filters a certain bit
+# Usage: get_cpuid_bit <leafnr_in_hex> e[abcd]x <bitnr>
+# Example: get_cpuid_bit 0x80000001 ecx 2
+# Outputs either 0 or 1 to stdout
+# Returns 0 for success, 1 for invalid cpuid leaf, 2 for permission
+get_cpuid_bit() {
+    [ $# -lt 3 ] && return 3
+    cpu=${4:-0}
+    reg=$(get_cpuid_register $1 $2 $4) || return $?
+
+    echo $(($reg >> $3 & 1))
+}
+
+# Get a space separated list of CPUs from a sysfs cpumap file
+# Example:
+#   get_cpus_from_cpumap /sys/devices/system/node/node0/cpumap
+#   0 1 2 3
+# Notes:
+#   Result may be an empty string
+#   Result may be -1 in case of parsing errors
+get_cpus_from_cpumap () {
+    cpumap="${1}"
+    cpus=""
+    wordcnt=$(cat $cpumap | sed -e 's/,/ /g' | wc -w)
+
+    if [ $wordcnt -eq 0 ]; then
+        echo -1
+        return
+    fi
+
+    for i in $(seq $wordcnt -1 1); do
+        offset=$(($wordcnt - $i))
+        word=$((0x$(cat $cpumap | cut -d , -f $i)))
+        if [ $? -ne 0 ]; then cpus=-1; break; fi
+        for j in $(seq 0 31); do
+            if [ $(($word >> $j & 1 )) -eq 1 ]; then
+                cpus="$cpus $((32 * $offset + $j))"
+            fi
+        done
+    done
+
+    echo $cpus
+}
+
+# Get a space separated list of CPUs from a sysfs cpulist file
+# Example:
+#   get_cpus_from_cpulist /sys/devices/system/cpu/online
+#   0 1 2 3
+# Notes:
+#   Result may be an empty string
+#   Result may be -1 in case of parsing errors
+get_cpus_from_cpulist () {
+    cpulist="${1}"
+    cpus=""
+    ranges=$(cat $cpulist | sed -e 's/,/ /g')
+
+    if [ -z "$ranges" ]; then
+        echo -1
+        return
+    fi
+
+    for range in $ranges; do
+        if echo $range | grep -q '^[0-9]\+-[0-9]\+$'; then
+            min=$(echo $range | sed 's/-[0-9]\+$//')
+            max=$(echo $range | sed 's/^[0-9]\+-//')
+            if [ $min -ge $max ]; then cpus=-1; break; fi
+            for cpu in $(seq $min $max); do cpus="$cpus $cpu"; done
+        elif echo $range | grep -q '^[0-9]\+$'; then
+            cpus="$cpus $range"
+        else
+            cpus=-1; break
+        fi
+    done
+
+    echo $cpus
+}
+
+autoreport_skip_all () {
+    explanation="${1:-'no explanation'}"
+    SKIPALL="1..0 # skip $explanation"
+    autoreport_start
+    exit 0
+}
+
+# ==================== TAP utils ====================
+
+get_tap_counter () {
+     echo ${#TAP[@]}
+}
+
+get_tapdata_counter () {
+     echo ${#TAPDATA[@]}
+}
+
+append_tap () {
+    tapline="${1:-'not ok - unknown TAP line in utility function append_tap'}"
+    TAP=( "${TAP[@]}" "$tapline" )
+}
+
+append_tapdata () {
+    tapline="${1:-'not ok - unknown TAP line in utility function append_tapdata'}"
+    TAPDATA=( "${TAPDATA[@]}" "$tapline" )
+}
+
+append_comment () {
+    tapline="# ${@:-''}"
+    TAP=( "${TAP[@]}" "$tapline" )
+    COMMENTCOUNTER=$((COMMENTCOUNTER + 1))
+}
+
+diag () {
+    append_comment "${@}"
+}
+
+is () {
+    A="${1:-}"
+    B="${2:-}"
+    msg="${3:-unknown}"
+
+    if [ "x$A" != "x$B" ] ; then
+        append_tap "not ok - $msg"
+        append_comment "Failed test '$msg'"
+        append_comment "got: '$A'"
+        append_comment "expected: '$B'"
+    else
+        append_tap "ok - $msg"
+    fi
+}
+
+isnt () {
+    A="${1:-}"
+    B="${2:-}"
+    msg="${3:-unknown}"
+
+    if [ "x$A" = "x$B" ] ; then
+        append_tap "not ok - $msg"
+        append_comment "Failed test '$msg'"
+        append_comment "got: '$A'"
+        append_comment "expected: anything else"
+    else
+        append_tap "ok - $msg"
+    fi
+}
+
+require_ok () {
+    success="${1:-0}"
+    msg="${2:-unknown}"
+    if [ "$success" != "0" ] ; then
+        NOT="not "
+    else
+        NOT=""
+    fi
+    append_tap "${NOT}ok - $msg"
+
+    if [ "$success" = "0" ] ; then
+        return
+    fi
+
+    # similar to SKIPALL but report what we have so far
+    if [[ -n $EXIT_ON_SKIPALL ]]; then
+        exit 254
+    else
+        autoreport_start
+        exit 0
+    fi
+}
+
+ok () {
+    success="${1:-0}"
+    msg="${2:-unknown}"
+    if [ "$success" != "0" ] ; then
+        NOT="not "
+    else
+        NOT=""
+    fi
+    append_tap "${NOT}ok - $msg"
+    return $success
+}
+
+negate_ok () {
+    success="${1:-0}"
+    msg="${2:-unknown}"
+    if [ "$success" == "0" ] ; then
+        NOT="not "
+    else
+        NOT=""
+    fi
+    append_tap "${NOT}ok - $msg"
+    return $success
+}
+
+get_hex_from_int() { # returns lower case
+    printf "%x\n" "$1"
+}
+
+lower_case () {
+    string="${1:-}"
+    echo $(echo "$string" | tr '[A-Z]' '[a-z]')
+}
+
+get_random_number () {
+    range_max="${1:-32768}"
+    number=$RANDOM
+    let "number %= $range_max"
+    echo "$number"
+}
+
+get_kernel_release_1 () {
+    uname -r | cut -d. -f1
+}
+
+get_kernel_release_2 () {
+    uname -r | cut -d. -f2
+}
+
+get_kernel_release_3 () {
+    uname -r | cut -d. -f3 | sed -s 's/^\([0-9]*\).*$/\1/'
+}
+
+get_kernel_release () {
+    echo $(uname -r | cut -d. -f1-2).$(get_kernel_release_3)
+}
+
+normalize_version_number () {
+    A="${1:-0}"
+    # triplets x.y.z are converted to x + y/thousands + z/millions
+    # easier, but requires awk:
+    # awk -F. '{printf ("%d.%03d%03d\n",$1,$2,$3);}'
+    # we have to do a trick do avoid octal interpretation due to leading
+    # zeros, we use $((10#<number>)), which overrides with a base of 10
+    if echo $A | grep -q '\.' ; then
+        printf "%d.%03d%03d\n" $((10#$(echo "$A" | cut -d. -f1))) $((10#$(echo "$A" | cut -d. -f2))) $((10#$(echo "$A" | cut -d. -f3)))
+    else
+        echo "$A.000000"
+    fi
+}
+
+version_number_compare () {
+    A="${1:-0}"
+    COMPARATOR="${2:-'-eq'}"
+    B="${3:-0}"
+
+    An=$(normalize_version_number $A | tr -d .)
+    Bn=$(normalize_version_number $B | tr -d .)
+
+	test "$An" $COMPARATOR "$Bn"
+}
+
+version_number_gt () {
+    A="${1:-0}"
+    B="${2:-0}"
+    return $(version_number_compare "$A" -gt "$B")
+}
+
+version_number_ge () {
+    A="${1:-0}"
+    B="${2:-0}"
+    return $(version_number_compare "$A" -ge "$B")
+}
+
+version_number_lt () {
+    A="${1:-0}"
+    B="${2:-0}"
+    return $(version_number_compare "$A" -lt "$B")
+}
+
+version_number_le () {
+    A="${1:-0}"
+    B="${2:-0}"
+    return $(version_number_compare "$A" -le "$B")
+}
+
+has_kernel_release_min () {
+    _ta_autoreport_v="${1:-0}"
+    version_number_compare $(get_kernel_release) -gt $_ta_autoreport_v
+}
+
+require_kernel_release_min () {
+    release_req="${1:-}"
+    explanation="${2:-Linux Kernel must be newer than ${release_req}}"
+    if has_kernel_release_min "$release_req"; then
+        if [ "x1" = "x$REQUIRES_GENERATE_TAP" ] ; then ok $_SUCCESS "require_kernel_release_min $release_req" ; fi
+        return $_SUCCESS
+    else
+        autoreport_skip_all "$explanation"
+    fi
+}
+
+prepare_information() {
+
+    # ===== control variables defaults ==================
+
+    # by default require_* functions generate TAP ok lines
+    REQUIRES_GENERATE_TAP=${REQUIRES_GENERATE_TAP:-1}
+
+    # ===== kernel details ==================
+
+    kernelrelease=$(uname -r)
+
+    # ===== suite name ==================
+
+    myname=$(echo $(basename -- $0 | sed -e 's/\.\w*$//i'))
+
+    SUITE=${myname:-bash-test-utils}
+    VERSION=1.000
+
+    # ===== other meta info ==================
+
+    suite_name=${SUITENAME:-$(echo $SUITE)}
+    suite_version=${SUITEVERSION:-$VERSION}
+    hostname=${HOSTNAME:-$(hostname)}
+    hostname=$(echo $hostname | cut -d. -f1)
+
+    if [ -e /etc/issue.net ]
+    then
+	osname=${OSNAME:-$(cat /etc/issue.net | head -1)}
+    else
+	osname=${OSNAME:-$(uname -o)}
+    fi
+
+    changeset=${CHANGESET:-$(cat /proc/version | head -1)}
+    kernelflags=$(cat /proc/cmdline)
+    uname=$(uname -a)
+    ram=$(free -m | grep -i mem: | awk '{print $2}'MB)
+    starttime_test_program=${starttime_test_program:-$(date --rfc-2822)} # first occurrence
+    starttime_test_program_epoch=${starttime_test_program_epoch:-$(date +"%s")}
+    endtime_test_program=$(date --rfc-2822) # last occurrence
+    endtime_test_program_epoch=$(date +"%s")
+    bogomips=$(echo $(cat /proc/cpuinfo | grep -i bogomips | head -1 | cut -d: -f2))
+    cpuinfo=$(
+        if arm_cpu
+        then
+            cpu=$(grep 'Processor' < /proc/cpuinfo | cut -d: -f2- |head -1 | cut -d" " -f2);
+        else
+            cpu=$(grep 'model name' < /proc/cpuinfo | cut -d: -f2- | head -1 | sed -e "s/^ *//");
+        fi
+        echo "$(get_number_cpus) cores [$cpu]";
+    )
+    # TODO: bogomips from /proc/cpuinfo
+
+    if [ -e "/boot/config-$kernelrelease" ]
+    then
+	BOOTCONFIG="/boot/config-$kernelrelease"
+    else
+	BOOTCONFIG=
+    fi
+    PROCCONFIG="/proc/config.gz"
+
+} # prepare_information()
+
+ltu_suite_meta() {
+    if [[ -n $VERBOSE ]]; then
+        echo "# Test-section: $suite_name";
+        echo "# Test-suite-version: $suite_version";
+    fi
+    echo "# Test-suite-name: $suite_name";
+    echo "# Test-machine-name: $hostname";
+}
+
+ltu_base_os_description () {
+    if [ -r /etc/lsb-release ] ; then
+        . /etc/lsb-release
+        BASE_OS_DESCRIPTION="$DISTRIB_DESCRIPTION"
+    else
+        RELEASE_FILES="/etc/slackware-version /etc/gentoo-release /etc/SuSE-release /etc/issue /etc/issue.net /etc/motd"
+        for i in $RELEASE_FILES ; do if [ -r $i ] ; then RELEASE_FILE=$i ; break ; fi; done
+        BASE_OS_DESCRIPTION=$(cat $RELEASE_FILE | perl -ne 'print if /\w/' | head -1)
+    fi
+    echo $BASE_OS_DESCRIPTION
+}
+
+# we could as well use uname -r here, but lets explicitly ask Xen
+# first what it thinks the Dom0 kernel version is
+ltu_xen_dom0_kernel () {
+    XL=$(get_xen_tool)
+    if [ "$?" -eq 0 ] ; then
+        $XL info 2> /dev/null | grep '^release.*:' | cut -d: -f2 || uname -r
+    else
+        uname -r
+    fi
+}
+
+ltu_xen_changeset () {
+    if [ -r /sys/hypervisor/properties/changeset ] ; then
+        cat /sys/hypervisor/properties/changeset | sed -e 's/^.* \([^ ]*\)/\1/'
+    else
+        XL=$(get_xen_tool) || return $_FAILURE
+        echo $($XL info|grep '^xen_changeset.*:'|sed -e 's/^.* \([^ ]*\)/\1/')
+    fi
+}
+
+ltu_xen_version () {
+    if [ -r /sys/hypervisor/version/major ] ; then
+        _VPATH="/sys/hypervisor/version"
+        echo "$(cat $_VPATH/major).$(cat $_VPATH/minor)$(cat $_VPATH/extra)"
+    else
+        XL=$(get_xen_tool) || return $_FAILURE
+        XEN_VERSION_MAJOR=$(echo $($XL info|grep '^xen_major.*:'|cut -d: -f2))
+        XEN_VERSION_MINOR=$(echo $($XL info|grep '^xen_minor.*:'|cut -d: -f2))
+        XEN_VERSION_EXTRA=$(echo $($XL info|grep '^xen_extra.*:'|cut -d: -f2))
+        XEN_VERSION=""
+        if [ -n "$XEN_VERSION_MAJOR" ] ; then
+            XEN_VERSION="$XEN_VERSION_MAJOR.$XEN_VERSION_MINOR$XEN_VERSION_EXTRA"
+        fi
+        echo $XEN_VERSION
+    fi
+}
+
+ltu_xen_meta () {
+    echo "# Test-xen-dom0-kernel: $(ltu_xen_dom0_kernel)"
+    echo "# Test-xen-version: $(ltu_xen_version)"
+    echo "# Test-xen-changeset: $(ltu_xen_changeset)"
+    echo "# Test-xen-base-os-description: $(ltu_base_os_description)"
+}
+
+ltu_kvm_meta () {
+    echo "# Test-kvm-version: $(uname -r)"
+    echo "# Test-kvm-base-os-description: $(ltu_base_os_description)"
+}
+
+ltu_section_meta() {
+    if [ ! "x1" = "x$DONTREPEATMETA" ] ; then
+        echo "# Test-uname: $uname"
+        echo "# Test-osname: $osname"
+        echo "# Test-kernel: $kernelrelease"
+        echo "# Test-changeset: $changeset"
+        echo "# Test-flags: $kernelflags"
+        echo "# Test-cpuinfo: $cpuinfo"
+        echo "# Test-ram: $ram"
+        echo "# Test-starttime-test-program: $starttime_test_program"
+        echo "# Test-endtime-test-program: $endtime_test_program"
+        if is_running_in_xen_dom0 ; then
+            ltu_xen_meta
+        fi
+        if is_running_in_kvm_host ; then
+            ltu_kvm_meta
+        fi
+    fi
+
+    if [ -n "$SECTION" ] ; then
+        echo "# Test-section:              $SECTION"
+    fi
+}
+
+ltu_help () {
+    echo "bash-test-utils"
+    echo ""
+    echo "This is the 'bash-test-utils' bash utility -- a bash include file"
+    echo "to turn your bash script into a test suite that can optionally be"
+    echo "used with the 'prove' command, a standard tool to run test scripts."
+    echo ""
+    echo "Use in your script:"
+    echo "  . ./bash-test-utils"
+    echo "  # ... your testing here, eg.:"
+    echo "  grep -q foobar /proc/cpuinfo"
+    echo '  ok $? "found foobar in cpuinfo"'
+    echo "  done_testing"
+    echo ""
+    echo "Run:"
+    echo "  prove    ./examples/utils-example-01.t"
+    echo "  prove -v ./examples/utils-example-01.t  # verbose"
+    echo "  prove    ./examples/                    # whole subdir"
+    echo ""
+}
+
+ltu_version () {
+	echo "$VERSION"
+}
+
+# ===== param evaluation ==============================
+
+prepare_start () {
+    prepare_information
+    # other context sensitive initialization (eg. default, destructive, ...)
+}
+
+prepare_plan() {
+    # count of our own tests
+    COUNT=${#TAP[@]}
+    PLAN=$(($MYPLAN + $COUNT - $COMMENTCOUNTER))
+}
+
+# ===== main =========================================
+
+autoreport_main() {
+
+    COMMENTCOUNTER=${COMMENTCOUNTER:-0}
+
+    if [ -n "$SKIPALL" ] ; then
+        echo "$SKIPALL"
+        ltu_suite_meta
+        if [[ -n $VERBOSE ]]; then
+            ltu_section_meta
+        fi
+        return
+    fi
+
+    # ==================== prepare plan
+
+    # count of tests until "END of own tests"
+    MYPLAN=2
+    prepare_plan
+    echo "TAP Version 13"
+    echo "1..$PLAN"
+
+    # ==================== meta info ====================
+    ltu_suite_meta
+    if [[ -n $VERBOSE ]]; then
+        ltu_section_meta
+    fi
+
+    # =============== own headers (later entries win) ===============
+    HEADERSCOUNT=${#HEADERS[@]}
+    for l in $(seq 0 $(($HEADERSCOUNT - 1))) ; do
+        echo ${HEADERS[l]}
+    done
+
+    # ,==================== BEGIN of own tests ====================
+    # |
+    #
+    echo "ok - autoreport"
+    #
+    # |
+    # `==================== END of own tests ====================
+
+    # ==================== remaining TAP ====================
+    for l in $(seq 0 $(($COUNT - 1))) ; do
+        echo ${TAP[l]}
+    done
+
+    # ==================== additional TAP/YAML data ====================
+    echo "ok - tapdata"
+    echo "  ---"
+    echo "  tapdata: 1"
+    if [ -n "$starttime_test_program_epoch" ] && [ -n "$endtime_test_program_epoch" ] ; then
+        echo "  starttime: $starttime_test_program_epoch"
+        echo "  endtime: $endtime_test_program_epoch"
+        echo "  runtime: $((endtime_test_program_epoch-starttime_test_program_epoch))"
+    fi
+    TAPDATACOUNT=${#TAPDATA[@]}
+    if [ "$TAPDATACOUNT" -gt 0 ] ; then
+        for l in $(seq 0 $(($TAPDATACOUNT - 1))) ; do
+            echo "  ${TAPDATA[l]}"
+        done
+    fi
+    echo "  ..."
+
+    # ==================== remaining output ====================
+    OUTPUTCOUNT=${#OUTPUT[@]}
+    for l in $(seq 0 $(($OUTPUTCOUNT - 1))) ; do
+        echo ${OUTPUT[l]}
+    done
+
+    # ==================== files ====================
+    for f in $(seq 0 $(($FILECOUNT - 1))) ; do
+        echo "# File upload: '${FILES[f]}'"
+    done
+
+    if set | grep -q '^main_after_hook \(\)' ; then
+        main_after_hook
+    fi
+}
+
+# ===== main =========================================
+
+autoreport_start () {
+
+    prepare_start "${@}"
+    autoreport_main
+}
+
+done_testing () {
+    autoreport_start "${@}"
+}
+
+# =====================================================
+
+function recover_kill {
+    ok 1 'GOT KILLED EXTERNALLY'
+    done_testing
+    exit
+}
+
+trap "recover_kill" SIGTERM SIGHUP SIGINT SIGKILL
+
+# =====================================================
+
+[ "$1" == "--help" ]         && ltu_help    && exit $_SUCCESS
+[ "$1" == "--version" ]      && ltu_version && exit $_SUCCESS
+
+# =====================================================
+
+prepare_information
diff --git a/tools/testing/tap/bash-test-utils.txt b/tools/testing/tap/bash-test-utils.txt
new file mode 100644
index 0000000..b0596db
--- /dev/null
+++ b/tools/testing/tap/bash-test-utils.txt
@@ -0,0 +1,320 @@
+bash-test-utils -- support writing functional tests
+
+ABOUT
+=====
+
+It provides utility functions and facilities to write tests in
+baremetal and Xen/KVM contexts (host and guest support) and was
+polished to work with i686, x86_64, and ARM under lots of major Linux
+distributions (Debian, Ubuntu, RHEL, SLES, Slackware, Fedora,
+openSUSE).
+
+It can be run as normal bash script or indirectly via the "prove"
+command, a standard Linux tool to run test scripts.
+
+
+SYNOPSIS
+========
+
+A test script
+-------------
+
+  #! /bin/bash
+  . ./bash-test-utils
+  # your_feature_test here
+  done_testing
+
+This imports utility functions to be used by your script, then you
+write your tests, and at the end it calls the actual printing of test
+results.
+
+
+Run it via 'prove' (a standard test utility)
+--------------------------------------------
+
+  $ prove ./trivial-example-1.sh
+  ./trivial-example-1.sh .. ok
+  All tests successful.
+  Files=1, Tests=5, 20 wallclock secs
+  Result: PASS
+
+The tool "prove" is a standard tool available in every Linux
+distribution. It runs the script and prints success statistics. See
+"man prove" for more options.
+
+
+UTILITY FUNCTIONS
+=================
+
+Import utility functions at the beginning of the script via
+
+  . tools/testing/tap/bash-test-utils
+
+Then you have several functions available.
+
+Expressing test results
+-----------------------
+
+* ok ARG1 "some description"
+
+  Evaluates the first argument with Shell boolean semantics (0 is
+  true) and appends a corresponding TAP line. See also "require_ok"
+  below.
+
+* negate_ok ARG1 "some description"
+
+  Evaluates the first argument with Shell inverse boolean semantics (0
+  is false) and appends a corresponding TAP line.
+
+* append_tap "ok - some description"
+
+  Appends a complete TAP line where you have taken care for the
+  "ok"/"not ok" at the beginning.
+
+* append_comment "foo bar baz"
+
+  Appends a complete comment line starting with "#". It appears
+  directly after the last added TAP line so it can be used for
+  diagnostics.
+
+* append_tapdata "key: value"
+
+  Appends a key:value line at the final tapdata YAML block. The key
+  must start with letter and consist of only alphanum an underscore.
+
+
+require_* functions
+-------------------
+
+  All require_* functions check for something and gracefully exit the
+  script if the requirement is not fulfilled. Use this to allow the
+  script to run everywhere without polluting results with false
+  negatives.
+
+* require_ok ARG1 "some description"
+
+  Evaluates the first argument with Shell boolean semantics (0 is
+  true) and appends a corresponding TAP line. If it reports "not ok"
+  the script gracefully exits.
+
+* require_amd_family_range [ MIN [ MAX ] ]
+
+  Ensures vendor is AMD and cpu family from /proc/cpuinfo is in a
+  minimum/maximum range. If you don't specify MIN it defaults to 0. If
+  you don't specify MAX it defaults to MIN.
+
+* require_cpufeature "foo"
+
+  Verifies that the string "foo" occurs in /proc/cpuinfo flags section.
+
+* require_kernel_config "CONFIG_FOO"
+
+  Verify that regex "^CONFIG_FOO=." occurs in /proc/config.gz or
+  /boot/config/$ (uname -r).
+
+* require_program "foo"
+
+  Verify that the program "foo" is available. Use it to declare
+  external programs you call, like "awk", "bc", "perl", etc.
+
+* require_l3cache
+
+  Verify that L3 cache is available (checked in
+  /sys/devices/system/cpu/cpu0/ cache/index3).
+
+* require_root
+
+  Verify that the user executing the script is root (UID 0).
+
+* require_crit_level N
+
+  Verify that the criticality level N of the script is allowed to be
+  run, which is controlled by environment variable CRITICALITY. See
+  "has_crit_level" for meaning of criticality levels.
+
+* require_cpb_disabled
+
+  Enables cpufreq and disables boosting. In case of errors the calling
+  test is skipped.
+
+* require_cpufreq_enabled
+
+  Enables cpufreq and also core boosting. In case of errors the
+  calling test is skipped.
+
+* require_kernel_release_min
+
+  Verify that the current LK release is at least the required version
+  number.
+
+* require_running_in_xen_guest
+
+  Verify if we are in a Xen guest.
+
+* require_running_in_kvm_guest
+
+  Verify if we are in a KVM guest.
+
+* require_running_in_virtualized_guest
+
+  Verify if we are in a virtualized guest (Xen or KVM).
+
+
+request_* functions
+-------------------
+
+All request_* functions try to enable something and if that fails mark it as
+#TODO but continue the test. It's kind of an "uncritical require_*".
+
+* request_cpb_disabled
+
+  Enables cpufreq and disables boosting. The result will be reported
+  and returned. Errors are marked as TODO.
+
+* request_cpufreq_enabled
+
+  Enables cpufreq and also core boosting. The result will be reported
+  and returned. Errors are marked as TODO.
+
+
+Misc auxiliary functions
+------------------------
+
+These are really just utilities to help you but they don't influence the
+behaviour like the require_* functions do.
+
+* has_l3cache
+
+  Returns 0 (shell TRUE) if L3 cache is available (checked in
+  /sys/devices/ system/cpu/cpu0/cache/index3).
+
+* has_cpufeature "foo"
+
+  Returns 0 (shell TRUE) if string "foo" occurs in /proc/cpuinfo flags
+  section.
+
+* has_kernel_release_min
+
+  Returns 0 (shell TRUE) if the current LK release is at least the
+  required version number.
+
+* has_kernel_config "CONFIG_FOO"
+
+  Returns 0 (shell TRUE) if regex "^CONFIG_FOO=." occurs in
+  /proc/config.gz or / boot/config/$(uname -r).
+
+* has_program "foo"
+
+  Return 0 (shell TRUE) if the program "foo" is available.
+
+* has_crit_level N
+
+  Checks whether the criticality level N of the script is allowed to
+  be run, which is controlled by environment variable CRITICALITY. The
+  criticality levels are defined as this:
+
+   * 0: not critical
+   * 1: read sysfs/debugfs/proc files
+   * 2: read HW (MSRs/Northbridge)
+   * 3: write sysfs/debugfs/proc files
+   * 4: write HW (MSRs/Northbridge) or potentially crash the machine
+
+* get_vendor
+
+  Prints vendor "AMD" or "Intel" from /proc/cpuinfo.
+
+* vendor_intel
+
+  Returns 0 (shell TRUE) if vendor is Intel.
+
+* vendor_amd
+
+  Returns 0 (shell TRUE) if vendor is AMD.
+
+* get_random_number [ MAX ]
+
+  Prints a random integer between 0 and MAX (default 32768).
+
+* get_cpu_family
+
+  Print cpu family from /proc/cpuinfo.
+
+* get_cpu_family_hex
+
+  Print cpu family from /proc/cpuinfo in hex syntax (0x...).
+
+* cpu_family_min [ MINFAMILY ]
+
+  Returns 0 (shell TRUE) if cpu family from /proc/cpuinfo is greater
+  or equal to MINFAMILY. Defaults to 0.
+
+* cpu_family_max [ MAXFAMILY ]
+
+  Returns 0 (shell TRUE) if cpu family from /proc/cpuinfo is less or
+  equal to MAXFAMILY. Defaults to 999.
+
+* get_first_file [ LIST OF FILENAMES ]
+
+  Goes through all specified filenames and prints the first one that
+  exists and is readable.
+
+* is_element_in_list WORD "SPACE SEPARATED LIST OF WORDS"
+
+  Returns 0 (shell TRUE) if WORD appears in "SPACE SEPARATED LIST OF
+  WORDS". Remember the usual shell quoting rules.
+
+* get_kernel_release
+
+  Prints the kernel version number from uname -r.
+
+* is_running_in_xen_guest
+
+  Check if we are in a Xen guest.
+
+* is_running_in_kvm_guest
+
+  Check if we are in a KVM guest.
+
+* is_running_in_virtualized_guest
+
+  Check if we are in a virtualized guest (Xen or KVM).
+
+
+INFLUENCING BEHAVIOUR
+=====================
+
+Environment Variables
+---------------------
+
+These variables are expected to be set inside the script to declare
+meta information or influence behaviour:
+
+* TAP[*]                - Array of TAP lines
+* TAPDATA[*]            - Array of YAML lines that contain data in TAP
+* OUTPUT[*]             - Array of additional output lines
+* SUITENAME             - alternative suite name instead of $0
+* SUITEVERSION          - alternative suite version
+* KEYWORDS              - space separated keywords to influence suite
+                          name
+* OSNAME                - alternative OS description
+* CHANGESET             - alternative changeset
+* HOSTNAME              - alternative hostname
+* TICKETURL             - relevant URL in used ticket system
+                          (Bugzilla)
+* WIKIURL               - relevant URL in used wiki
+* PLANNINGID            - relevant task planning id
+                          (MS Project, TaskJuggler, etc.)
+* REQUIRES_GENERATE_TAP - if "1" then require_* functions generate
+                          additional "ok" line on success
+
+
+External environment variables
+------------------------------
+
+These variables are expected to be set from outside of the script to
+influence behaviour:
+
+* EXIT_ON_SKIPALL - if "1" then on skip_all we immediately exit
+                    with exitcode 254.
+* CRITICALITY     - Sets the allowed maximal criticality level.
+                    Scripts with higher level call skip_all().
-- 
1.7.10.4


