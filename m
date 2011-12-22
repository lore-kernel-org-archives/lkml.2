Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab1LVXmE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 18:42:04 -0500
Received: from smtpq3.gn.mail.iss.as9143.net ([212.54.34.166]:44170 "EHLO
	smtpq3.gn.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756027Ab1LVXmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 18:42:01 -0500
X-Greylist: delayed 1404 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Dec 2011 18:42:01 EST
Message-ID: <4EF3BACA.1080405@gmail.com>
Date: Fri, 23 Dec 2011 00:18:34 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111221 Thunderbird/9.0
MIME-Version: 1.0
To: Andre Guedes <andre.guedes@openbossa.org>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
CC: linux-kernel@vger.kernel.org
Subject: [bluetooth] linux-3.x regression (bisected)
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Ziggo-spambar: ---
X-Ziggo-spamscore: -3.6
X-Ziggo-spamreport: ALL_TRUSTED=-1,BAYES_00=-1.9,FREEMAIL_FROM=0.5,PROLO_TRUST_RDNS=-3,RDNS_DYNAMIC=0.982,SPF_NEUTRAL=0.779
X-Ziggo-Spam-Status: No
X-Spam-Flag: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good day.

A while ago, my noname USB Bluetooth adapter stopped working, with from 
that point on only "Bluetooth: hci0 command tx timeout" appearing in the 
kernel messages.

I just now got around to looking at it and bisected this to commit 
eead27da60df80a112d1ac3ea482226e9794c26b:

===
Author: Andre Guedes <andre.guedes@openbossa.org>
Date:   Thu Jun 30 19:20:55 2011 -0300

     Bluetooth: Add lmp_host_le_capable() macro

     Since we have the extended LMP features properly implemented, we
     should check the LMP_HOST_LE bit to know if the host supports LE.

     Signed-off-by: Andre Guedes <andre.guedes@openbossa.org>
     Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
===

while that commit cannot be reverted outright due to dependencies, 
reverting it functionally fixes things for me. That is, Bluetooth works 
again after applying (to linux-3.1.6):

===
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 56943ad..c7f794e 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -540,7 +540,7 @@ int hci_dev_open(__u16 dev)
                 ret = __hci_request(hdev, hci_init_req, 0,
 
msecs_to_jiffies(HCI_INIT_TIMEOUT));

-               if (lmp_host_le_capable(hdev))
+               if (lmp_le_capable(hdev))
                         ret = __hci_request(hdev, hci_le_init_req, 0,
 
msecs_to_jiffies(HCI_INIT_TIMEOUT));
===

It seems that my adapter wasn't ready for the change. It is a:

002 Device 002: ID 1131:1004 Integrated System Solution Corp. Bluetooth 
Device

If more specific information is wanted (to add adapter-specific quirk 
handling, perhaps?) please be verbose on how to obtain it. I don't know 
anything about Bluetooth

Rene.
