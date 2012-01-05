Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964907Ab2AEXpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 18:45:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44001 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964854Ab2AEXpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 18:45:16 -0500
Date: Thu, 5 Jan 2012 15:45:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20120105154515.6e40fadf.akpm@linux-foundation.org>
In-Reply-To: <20120105231958.GA15643@kroah.com>
References: <20120105182937.58ec59c2fa2bc34e9e48542a@canb.auug.org.au>
	<20120105231958.GA15643@kroah.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jan 2012 15:19:58 -0800
Greg KH <greg@kroah.com> wrote:

> On Thu, Jan 05, 2012 at 06:29:37PM +1100, Stephen Rothwell wrote:
> > Hi Andrew,
> > 
> > After merging the akpm tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > drivers/base/memory.c: In function 'memory_block_change_state':
> > drivers/base/memory.c:306:22: error: 'struct memory_block' has no member named 'sysdev'
> > drivers/base/memory.c:309:22: error: 'struct memory_block' has no member named 'sysdev'
> > 
> > Caused by commit 2691cc121386 ("kdump: add udev events for memory
> > online/offline") interacting with commit 10fbcf4c6cb1 ("convert 'memory'
> > sysdev_class to a regular subsystem") from the driver-core tree.
> 
> I can't recall this kdump patch coming through before, have I seen it?

I carefully added you to the Nov 22 commit email cc list :(

> creating new uevents is not something to be done lightly, has this been
> tested with the existing userspace tools to make sure it doesn't cause
> problems?

Seems to be covered in the changelog:


From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Subject: kdump: add udev events for memory online/offline

Currently no udev events for memory hotplug "online" and "offline" are
generated:

# udevadm monitor
# echo offline > /sys/devices/system/memory/memory4/state
==> No event

When kdump is loaded, kexec detects the current memory configuration and
stores it in the pre-allocated ELF core header.  Therefore, for kdump it
is necessary to reload the kdump kernel with kexec when the memory
configuration changes (e.g.  for online/offline hotplug memory).

In order to do this automatically, udev rules should be used.  This kernel
patch adds udev events for "online" and "offline".  Together with this
kernel patch, the following udev rules for online/offline have to be added
to "/etc/udev/rules.d/98-kexec.rules":

SUBSYSTEM=="memory", ACTION=="online", PROGRAM="/etc/init.d/kdump restart"
SUBSYSTEM=="memory", ACTION=="offline", PROGRAM="/etc/init.d/kdump restart"

Signed-off-by: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/memory.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN drivers/base/memory.c~kdump-add-udev-events-for-memory-online-offline drivers/base/memory.c
--- a/drivers/base/memory.c~kdump-add-udev-events-for-memory-online-offline
+++ a/drivers/base/memory.c
@@ -313,11 +313,22 @@ static int memory_block_change_state(str
 
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
_

