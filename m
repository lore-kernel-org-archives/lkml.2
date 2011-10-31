Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754906Ab1JaNVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 09:21:51 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:59248 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab1JaNVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 09:21:50 -0400
Message-ID: <1320067306.2796.34.camel@br98xy6r>
Subject: [PATCH v2] kdump: Add udev events for memory online/offline
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, schwidefsky@de.ibm.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kay Sievers <kay.sievers@vrfy.org>, Dave Hansen <haveblue@us.ibm.com>
Date: Mon, 31 Oct 2011 14:21:46 +0100
In-Reply-To: <20111028154630.77c7b96c.akpm@linux-foundation.org>
References: <1319645292.3321.24.camel@br98xy6r>
	 <20111026192449.GE355@redhat.com>
	 <20111027073058.GA2422@osiris.boeblingen.de.ibm.com>
	 <1319707965.2830.1.camel@br98xy6r>
	 <20111028154630.77c7b96c.akpm@linux-foundation.org>
Organization: IBM
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-28 at 15:46 -0700, Andrew Morton wrote:
> On Thu, 27 Oct 2011 11:32:45 +0200

[snip]

> I think a safer place from which to send the uevent is
> memory_block_change_state() or even memory_block_action().  Because if
> either of those functions later gets new callers, those callers might
> forget to send the uevent?

Ok fine. I put the code into memory_block_change_state(). This also has
the advantage that we are serialized by "mem->state_mutex". Not sure if
we need that, but for CPU hotplug the udev events are also serialized
with a lock. See  "drivers/base/cpu.c" -> cpu_hotplug_driver_lock()

Do you think the following patch is acceptable?
---
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>

Currently no udev events for memory hotplug "online" and "offline" are
generated:

# udevadm monitor
# echo offline > /sys/devices/system/memory/memory4/state
==> No event

When kdump is loaded, kexec detects the current memory configuration and
stores it in the pre-allocated ELF core header. Therefore, for kdump it is
necessary to reload the kdump kernel with kexec when the memory
configuration changes (e.g. for online/offline hotplug memory).

In order to do this automatically, udev rules should be used. This kernel
patch adds udev events for "online" and "offline". Together with this kernel
patch, the following udev rules for online/offline have to be added to
"/etc/udev/rules.d/98-kexec.rules":

SUBSYSTEM=="memory", ACTION=="online", PROGRAM="/etc/init.d/kdump restart"
SUBSYSTEM=="memory", ACTION=="offline", PROGRAM="/etc/init.d/kdump restart"

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
---
 drivers/base/memory.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -291,11 +291,22 @@ static int memory_block_change_state(str
 
 	ret = memory_block_action(mem->start_section_nr, to_state);
 
-	if (ret)
+	if (ret) {
 		mem->state = from_state_req;
-	else
-		mem->state = to_state;
+		goto out;
+	}
 
+	mem->state = to_state;
+	switch (mem->state) {
+	case MEM_OFFLINE:
+		kobject_uevent(&mem->sysdev.kobj, KOBJ_OFFLINE);
+		break;
+	case MEM_ONLINE:
+		kobject_uevent(&mem->sysdev.kobj, KOBJ_ONLINE);
+		break;
+	default:
+		break;
+	}
 out:
 	mutex_unlock(&mem->state_mutex);
 	return ret;


