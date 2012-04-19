Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab2DSPfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 11:35:10 -0400
Received: from 2481.rev.megiteam.pl ([91.227.36.129]:56945 "EHLO
	vk1001.megiteam.com.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab2DSPfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 11:35:08 -0400
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Apr 2012 11:35:08 EDT
Message-ID: <4F902F60.4080709@localdomain.pl>
Date: Thu, 19 Apr 2012 17:29:36 +0200
From: Grzegorz Nosek <root@localdomain.pl>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: support@supermicro.com
Subject: EHCI software retries break Supermicro IPKVM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(Supermicro support: cc'd as you might be interested)

Commit a2c2706e1043c17139c2dafd171c4a5cf008ef7e introduced software retries for transient USB errors. Unfortunately, it turns out that this change breaks the Supermicro AOC SIMSO IPKVM board plugged into a SYS-6015B-3R server, X7DBR-3 board. It renders unusable both the keyboard and media redirection as soon as the kernel boots (display works fine). An excerpt from dmesg:

[   76.587521] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 1
[   76.587646] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 2
[   76.587772] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 3
[   76.587896] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 4
[   76.588020] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 5
[   76.588144] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 6
[   76.588271] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 7
[   76.588395] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 8
[   76.588518] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 9
[   76.588644] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 10
[   76.588770] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 11
[   76.588893] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 12
[   76.589017] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 13
[   76.589142] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 14
[   76.589268] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 15
[   76.589391] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 16
[   76.589516] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 17
[   76.589641] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 18
[   76.589767] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 19
[   76.589891] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 20
[   76.590015] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 21
[   76.590140] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 22
[   76.590266] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 23
[   76.590390] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 24
[   76.590514] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 25
[   76.590639] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 26
[   76.590765] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 27
[   76.590889] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 28
[   76.591013] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 29
[   76.591138] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 30
[   76.591264] ehci_hcd 0000:00:1d.7: detected XactErr len 0/8 retry 31
[   76.591388] ehci_hcd 0000:00:1d.7: devpath 7 ep0out 3strikes
[   76.591402] usb 1-7: can't set config #1, error -71
[   76.596519] drivers/usb/core/inode.c: creating file '007'
[   76.596542] hub 1-0:1.0: state 7 ports 8 chg 0000 evt fe80

After disarming the retry logic with the patch below, the KVM works fine again. Now, this is certainly a crude hack but apparently some better checks are needed to determine whether to retry the transaction.

Best regards,
 Grzegorz Nosek

---
 drivers/usb/host/ehci.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index 0a5fda7..aa3a09e 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -373,7 +373,7 @@ struct ehci_qh {
 #define	QH_STATE_COMPLETING	5		/* don't touch token.HALT */
 
 	u8			xacterrs;	/* XactErr retry counter */
-#define	QH_XACTERR_MAX		32		/* XactErr retry limit */
+#define	QH_XACTERR_MAX		1		/* XactErr retry limit */
 
 	/* periodic schedule info */
 	u8			usecs;		/* intr bandwidth */
-- 
1.7.2.3
