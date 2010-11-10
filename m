Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab0KJA5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:57:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:31316 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab0KJA5k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:57:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,176,1288594800"; 
   d="scan'208";a="855945525"
From: "Luck, Tony" <tony.luck@intel.com>
To: linux-kernel@vger.kernel.org
Cc: ying.huang@intel.com, mingo@elte.hu, bp@alien8.de, tglx@linutronix.de,
        akpm@linux-foundation.org, mchehab@redhat.com
Subject: [RFC/Requirements/Design] h/w error reporting
Date: Tue, 09 Nov 2010 16:56:55 -0800
Message-Id: <4cd9edd7543527b78@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the Linux plumbers conference we had an interesting discussion on
the current state and future direction for hardware error reporting.
Thanks to Mauro for setting up the session, and to all those who
attended.  Cc: list created by looking at the most vocal on the last
thread on this subject - but everyone is invited to chime in.

Here are my notes on what was said - please add anything that I
missed/forgot ... or with your own thoughts on this topic.

The current situation
---------------------

We have several subsystems & methods for reporting hardware errors:

1) EDAC ("Error Detection and Correction").  In its original form
this consisted of a platform specific driver that read topology
information and error counts from chipset registers and reported
the results via a sysfs interface.  For example:

# ls -l /sys/devices/system/edac/mc/mc0
total 0
-r--r--r-- 1 root root 4096 Nov  8 14:48 ce_count
-r--r--r-- 1 root root 4096 Nov  8 14:48 ce_noinfo_count
drwxr-xr-x 2 root root    0 Nov  8 14:47 csrow0
drwxr-xr-x 2 root root    0 Nov  8 14:47 csrow1
lrwxrwxrwx 1 root root    0 Nov  8 14:48 device -> ../../../../pci0000:00/0000:00:10.0
-r--r--r-- 1 root root 4096 Nov  8 14:48 mc_name
--w------- 1 root root 4096 Nov  8 14:48 reset_counters
-rw-r--r-- 1 root root 4096 Nov  8 14:48 sdram_scrub_rate
-r--r--r-- 1 root root 4096 Nov  8 14:48 seconds_since_reset
-r--r--r-- 1 root root 4096 Nov  8 14:48 size_mb
-r--r--r-- 1 root root 4096 Nov  8 14:48 ue_count
-r--r--r-- 1 root root 4096 Nov  8 14:48 ue_noinfo_count

some chipset drivers also report some pci device error information
and others provide mechanisms to inject errors for testing.

2) mcelog - x86 specific decoding of machine check bank registers
reporting in binary form via /dev/mcelog. Recent additions make use
of the APEI extensions that were documented in version 4.0a of the
ACPI specification to acquire more information about errors without
having to rely reading chipset registers directly. A user level
programs decodes into somewhat human readable format.

3) drivers/edac/mce_amd.c  A recent addition - this driver hooks into
the mcelog path and decodes errors reported via machine check bank
registers in AMD processors to the console log using printk() [despite
being in the drivers/edac directory, this seems completely different
from classic EDAC to me].

Each of these mechanisms has a band of followers ... and none
of them appear to meet all the needs of all users. Some of the
issues are:
1) New EDAC drivers need to be written for each chipset. Documentation
is often opaque, so there is often a delay between the introduction
of a new platform and availability of EDAC drivers.
2) Some platforms do not allow the OS to read chipset error counters.
3) Some parts of mcelog use ACPI - which taints the whole subsystem
(somewhat unfairly - most of it depends on machine check bank registers).
4) Some large cluster users are not happy about parsing console logs
looking for patterns of warning messages that indicate possible
future problems.

Taking a cue from the tracing session from the previous day (where
the "perf" vs. "ftrace" vs. "lttng" war was ended by proposing a
new tracing methodology that would overcome the shortcomings of
both of the merged subsystems while also addressing the requirements
of the lttng users) we explored whether the solution would be to
define a new "system health" subsystem that could be used by any
part of the kernel to report hardware issues in a coherent way so
that end users would have a single place to look for all error
information.

Use cases:
----------
There are a number of things that people may want to do with h/w
error data:

*) Corrected errors -> Look for patterns, or for rates above a particular
   threshold and use this for "predictive failure analysis" (i.e. to
   schedule replacement of a component before it is the source of an
   uncorrectable error).
*) Uncorrected errors -> Identify failing component for replacement.


Requirements (woefully incomplete - please help):
-------------------------------------------------

*) Architecture independent (both power and arm are potentially interested)

*) Report errors against human readable labels (e.g. using motherboard
   labels to identify DIMM or PCI slots).  This is hard (will often need
   some platform-specific mapping table to provide, or override, detailed
   information).

*) General interface available for any kind of h/w error report (e.g.
   device driver might use it for board level problems, or IPMI might
   report fan speed problems or over-temperature events).

*) Useful to make it easy to adapt existing EDAC drivers, machine-check
   bank decoders and other existing error reporters to use this new
   mechanism.

*) Robust - should not lose error information.  If the platform provides
   some sort of persistent storage, should make use of it to preserve
   details for fatal errors across reboot.  But may need some threshold
   mechanism that copes with floods of errors from a failed object.

*) Flexible: Errors may be discovered by polling, or reported by some
   interrupt/exception

Open questions:
---------------

For error sources that require polling to collect information, who should
initiate polling?  Kernel (from a timer) or user?

There are lots of potential configuration options and tuneables - so how
to keep to the minimum necessary?

How should reports of h/w error events get from kernel to user (in
earlier instantiations of this discussion, Ingo suggested "perf").

What should each error report look like? Some sort of record structure
would seem to be needed - but needs to be flexible to cope with
different needs from different types of device.

If multiple user agents are interested in looking at errors, how to
ensure that every agent gets a chance to see every error.

Some errors may be found before userspace has been started. How/where
to hold these reliably until daemons are running.

Where should platform specific tables that map from hard to interpret
"device numbers" to actual numbered slots reside?  Should this be left
to user-mode to tidy up? Or should we somehow load mapping information
into the kernel?

-Tony
