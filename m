Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab1AYSAY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 13:00:24 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:11961 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab1AYR7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:59:49 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-usb@vger.kernel.org, gregkh@suse.de, dbrownell@users.sourceforge.net
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 4/4] USB: EHCI: Rearrange create_companion_file() to avoid GCC-4.6 warnings.
Date: Tue, 25 Jan 2011 09:59:37 -0800
Message-Id: <1295978377-22930-4-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 25 Jan 2011 17:59:49.0118 (UTC) FILETIME=[A87199E0:01CBBCB9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In create_companion_file() there is a bogus assignemt to i created for
the express purpose of avoiding an ignored return value warning.

With pre-release GCC-4.6, this causes a 'set but not used' warning.

Kick the problem further down the road by just returning i.  All the
callers of create_companion_file() ignore its return value, so all is
good:

o No warnings are issued.

o We still subvert the desires of the authors of device_create_file()
  by ignorning error conditions.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 drivers/usb/host/ehci-hub.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-hub.c b/drivers/usb/host/ehci-hub.c
index 796ea0c..5aa6c49 100644
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -531,14 +531,15 @@ static ssize_t store_companion(struct device *dev,
 }
 static DEVICE_ATTR(companion, 0644, show_companion, store_companion);
 
-static inline void create_companion_file(struct ehci_hcd *ehci)
+static inline int create_companion_file(struct ehci_hcd *ehci)
 {
-	int	i;
+	int	i = 0;
 
 	/* with integrated TT there is no companion! */
 	if (!ehci_is_TDI(ehci))
 		i = device_create_file(ehci_to_hcd(ehci)->self.controller,
 				       &dev_attr_companion);
+	return i;
 }
 
 static inline void remove_companion_file(struct ehci_hcd *ehci)
-- 
1.7.2.3

