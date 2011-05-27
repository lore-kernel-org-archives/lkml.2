Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab1E0XTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 19:19:01 -0400
Received: from mx-3.enea.com ([192.36.1.72]:26737 "EHLO mx-3.enea.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352Ab1E0XTA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 19:19:00 -0400
X-Greylist: delayed 849 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 May 2011 19:18:59 EDT
Message-ID: <4DE02E11.5060007@enea.com>
Date: Sat, 28 May 2011 01:04:49 +0200
From: Arvid Brodin <arvid.brodin@enea.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-usb@vger.kernel.org, Juergen Beisert <jbe@pengutronix.de>
Subject: A standardized way of reporting kernel events to userspace
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 May 2011 23:04:12.0198 (UTC) FILETIME=[647BF460:01CC1CC2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After I asked on linux-usb for a way for userspace to catch over-current events
on the usb bus, it turned out that Juergen Beisert had had the need to do the
exact same thing some time ago. He posted this patch using a uevent to notify
userspace:

Signed-off-by: Juergen Beisert <jbe@pengutronix.de>
Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
---
 drivers/usb/core/hub.c           |    4 ++++
 1 file changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 84c18971..c615292 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3372,9 +3372,13 @@ static void hub_events(void)
 			}
 			
 			if (portchange & USB_PORT_STAT_C_OVERCURRENT) {
+				char event[] = "POWERFAIL=1";
+				char *envp[] = { event, NULL };
+
 				dev_err (hub_dev,
 					"over-current change on port %d\n",
 					i);
+				kobject_uevent_env(&hub->intfdev->kobj, KOBJ_CHANGE, envp);
 				clear_port_feature(hdev, i,
 					USB_PORT_FEAT_C_OVER_CURRENT);
 				hub_power_on(hub, true);


Alan Stern noted that having a standardized, accepted way for the kernel to
report important hardware or software events to userspace could be useful, and
suggested we start a discussion about this here on lkml. He noted some
things to consider:

	The type of event (hardware failure, data structure corruption,
	imminent data loss, imminent hardware destruction...).

	Whether or not the user can do anything to fix the problem.

	Whatever else you can think of.


So, please feel free to comment on this, and perhaps with time some kind of
consensus can be reached on how to report issues like this to userspace.

(My initial email to linux-usb: http://www.spinics.net/lists/linux-usb/msg47088.html)

-- 
Arvid Brodin
Enea Services Stockholm AB
