Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab1JJMd3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 08:33:29 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:45027 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab1JJMd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 08:33:26 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH v2 3/3] Update documentation
To: rjw@sisk.pl
Cc: srivatsa.bhat@linux.vnet.ibm.com, bp@amd64.org, pavel@ucw.cz,
        len.brown@intel.com, tj@kernel.org, mingo@elte.hu,
        a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
        suresh.b.siddha@intel.com, lucas.demarchi@profusion.mobi,
        rusty@rustcorp.com.au, rdunlap@xenotime.net, vatsa@linux.vnet.ibm.com,
        ashok.raj@intel.com, tigran@aivazian.fsnet.co.uk, tglx@linutronix.de,
        hpa@zytor.com, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Date: Mon, 10 Oct 2011 18:03:16 +0530
Message-ID: <20111010123312.15067.83231.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20111010123102.15067.23128.stgit@srivatsabhat.in.ibm.com>
References: <20111010123102.15067.23128.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 11101003-3568-0000-0000-000000801CC5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update documentation about the cpu hotplug and suspend/hibernate
race condition related issue in Documentation/power directory.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 Documentation/power/freezing-of-tasks.txt |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/Documentation/power/freezing-of-tasks.txt b/Documentation/power/freezing-of-tasks.txt
index 38b5724..80acd30 100644
--- a/Documentation/power/freezing-of-tasks.txt
+++ b/Documentation/power/freezing-of-tasks.txt
@@ -176,3 +176,25 @@ tasks, since it generally exists anyway.
 A driver must have all firmwares it may need in RAM before suspend() is called.
 If keeping them is not practical, for example due to their size, they must be
 requested early enough using the suspend notifier API described in notifiers.txt.
+
+However, there is another problem related to request_firmware() which is not
+related to device drivers. The x86 microcode core uses request_firmware() to
+get the CPU microcode from userspace. And microcode updates can be triggered by
+various events such as loading of microcode driver module, reloading of
+microcode image by writing 1 to the sysfs file /sys/devices/system/cpu/cpu*/
+microcode/reload or by onlining a CPU during a CPU hotplug operation (in this
+case, the microcode driver's callback for CPU online event does a microcode
+update).
+In all these scenarios, due to some race condition with the freezing of tasks,
+if the userspace happens to be frozen at the moment when request_firmware() is
+called, then since the caller will be waiting for the firmware, eventually
+the freezing of tasks will fail.
+
+To solve the issue in the CPU hotplug case, synchronization has been added to
+prevent the CPU hotplug online operation from running in parallel with
+suspend/hibernate. The microcode driver module load/unload and microcode image
+reload are carried out quite infrequently in practice and hence the chances of
+these events racing with suspend/hibernation are very rare. Anyway, even those
+corner cases are expected to be handled well when microcode loading via the
+bootloader gets implemented.
+

