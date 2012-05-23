Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933785Ab2EWRxp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:53:45 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:46181 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933646Ab2EWRxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:53:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH] bug-fixes to hvc-xen driver in v3.4 (and earlier).
Date: Wed, 23 May 2012 13:46:58 -0400
Message-Id: <1337795222-29946-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three of the patches could be squashed in one, but it makes more sense
to review them as three. These patches fix the case of an PVHVM
guest not being able to resume propely b/c of hitting:

 142         BUG_ON(info->type != IRQT_UNBOUND && info->type != type);

(in events.c) and also adds a WARN to catch situations like these.

The reason for this is that the Xen python toolstack does not
setup HVM_PARAM_CONSOLE_EVTCHN parameter, so we would use the
default value (0).. and ended up using the same IRQ line as the
xen-platform-pci driver. Huh? Note: the 'xl' toolstack _does_
set it.

The reason is that the when the xen-platform-pci starts, it requests
an PIRQ, and the info structure in events.c is filled as such:

 info->type = IRQT_PIRQ
 info->events = 0
 info->irq = 28
 evtchn_to_irq[0] = 28

And when xen_hvc_init is called during bootup, it figures out the
event from HVM_PARAM_CONSOLE_EVTCHN as zero, and plugs them in:

 532                 info->irq = bind_evtchn_to_irq(info->evtchn);

getting IRQ 28 as bind_evtchn_to_irq does a quick lookup:

 818         irq = evtchn_to_irq[evtchn];

and gives an already used IRQ line.

When we suspend the guest (xm save), then try to resume, we call
xen_console_resume, which does:

301         if (info != NULL && info->irq)
302                 rebind_evtchn_irq(info->evtchn, info->irq);

and that triggers the BUG_ON mentioned above (b/c the type
we want is IRQT_EVTCHN and the type info->type is IRQT_PIRQ).

 drivers/tty/hvc/hvc_xen.c |   24 +++++++++++-------------
 drivers/xen/events.c      |   11 +++++++++--
 2 files changed, 20 insertions(+), 15 deletions(-)
