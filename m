Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1HPNRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 09:17:43 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:57193 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108Ab1HPNRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 09:17:40 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmztM8TOFPjjUQEnt0KA==
X-RZG-CLASS-ID: mo00
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com
Subject: [PATCH 0/3] [v5] kexec and kdump for Xen PVonHVM guests
Date: Tue, 16 Aug 2011 15:16:50 +0200
Message-Id: <1313500613-21394-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following series implements kexec and kdump in a Xen PVonHVM guest.

It is available via git:

 git://github.com/olafhering/linux.git xen-kexec-3.0

changes since v4:
- drop patch which uses XS_INTRODUCE, a different way to reset watches
  has to be found
- find_virq(): use NR_EVENT_CHANNELS instead of private MAX_EVTCHNS
- reconnect devices:
  add timeout when waiting for backend state change
  extent printk message to include backend string
  add comment to fall-through case in xenbus_reset_frontend
- new patch which prevents crash in xenwatch_thread() during repeated
  kexec boots


The kexec or kdump kernel has to take care of already allocated virqs,
PV devices in Closed or Connected state, and of registered watches in
the old kernel. With the three patches these conditions are checked
during boot of the new kernel rather than in the reboot/crash path.

A fixed kexec-tools-2.0.2 package is required:
http://lists.infradead.org/pipermail/kexec/2011-May/005026.html
http://lists.infradead.org/pipermail/kexec/2011-August/005339.html

Another fix is for xenstored, it has to accept the XS_RESET_WATCHES from
a guest. Since the exact interface to xenstored is not yet final, the
patch to deal with the reset was removed from this series.
http://lists.xensource.com/archives/html/xen-devel/2011-08/msg00529.html
http://lists.xensource.com/archives/html/xen-devel/2011-08/msg00533.html

One open issue is the balloon driver. It removes pages from the guest
and gives them back to the hypervisor. The kexec kernel is not aware of
the fact that some pages are unavailable, and hangs or crashes.
The workaround for the time being is:

if test -f /sys/devices/system/xen_memory/xen_memory0/target -a \
        -f /sys/devices/system/xen_memory/xen_memory0/target_kb
then
    cat /sys/devices/system/xen_memory/xen_memory0/target > \
        /sys/devices/system/xen_memory/xen_memory0/target_kb
fi
kexec -e

This balloon issue has to be resolved with another series of changes.

Olaf

Olaf Hering (3):
  xen/pv-on-hvm kexec: prevent crash in xenwatch_thread() when stale
    watch events arrive
  xen/pv-on-hvm kexec: rebind virqs to existing eventchannel ports
  xen/pv-on-hvm kexec+kdump: reset PV devices in kexec or crash kernel

 drivers/xen/events.c                       |   37 +++++++-
 drivers/xen/xenbus/xenbus_comms.c          |    4 +-
 drivers/xen/xenbus/xenbus_probe_frontend.c |  121 ++++++++++++++++++++++++++++
 drivers/xen/xenbus/xenbus_xs.c             |    2 +-
 4 files changed, 157 insertions(+), 7 deletions(-)

-- 
1.7.3.4

