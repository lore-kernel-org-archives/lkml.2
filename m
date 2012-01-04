Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991Ab2ADPMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 10:12:23 -0500
Received: from smtpq3.tb.mail.iss.as9143.net ([212.54.42.166]:43981 "EHLO
	smtpq3.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755918Ab2ADPMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 10:12:21 -0500
Message-ID: <4F046C50.9010201@gmail.com>
Date: Wed, 04 Jan 2012 16:12:16 +0100
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111224 Thunderbird/9.0.1
MIME-Version: 1.0
To: Andre Guedes <andre.guedes@openbossa.org>
CC: Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <padovan@profusion.mobi>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Subject: Re: [bluetooth] linux-3.x regression (bisected)
References: <4EF3BACA.1080405@gmail.com> <CACJA=fVezGGcgAtbzG=+ouWq0PiHbgXN1YPwL+VDUphWS7wnrw@mail.gmail.com> <4EFA1EB8.9090005@gmail.com> <20111227203008.GA13870@joana> <4EFA447C.3030906@gmail.com> <20111228012248.GC13870@joana> <20111228012850.GD13870@joana> <4EFA7696.6060506@gmail.com> <20111228155225.GA23292@joana> <1325090923.1965.282.camel@aeonflux> <4F044042.2080502@gmail.com> <CACJA=fU4QerTS0EEz_Q+16_nPH73WEPadVM53-ZEV8vkEgQD8Q@mail.gmail.com>
In-Reply-To: <CACJA=fU4QerTS0EEz_Q+16_nPH73WEPadVM53-ZEV8vkEgQD8Q@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080901060107000207060908"
X-Ziggo-spambar: ---
X-Ziggo-spamscore: -3.6
X-Ziggo-spamreport: ALL_TRUSTED=-1,BAYES_00=-1.9,FREEMAIL_FROM=0.5,PROLO_TRUST_RDNS=-3,RDNS_DYNAMIC=0.982,SPF_NEUTRAL=0.779
X-Ziggo-Spam-Status: No
X-Spam-Flag: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080901060107000207060908
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 04-01-12 15:16, Andre Guedes wrote:

>> Any word on a final fix for this?
>
> Yes,this couple of patches fixes this issue:
> http://article.gmane.org/gmane.linux.bluez.kernel/19950/
> http://article.gmane.org/gmane.linux.bluez.kernel/19951/
>
> They were already pushed to bluetooth-next tree.

Thank you. Just in case anyone cares, versions against 3.1.7 re-attached 
(and confirmed, of course).

Regards,
Rene


--------------080901060107000207060908
Content-Type: text/x-patch;
 name="bluetooth-3.1.7_1-2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bluetooth-3.1.7_1-2.diff"

[PATCH 1/2] Bluetooth: Rename extfeatures
    
From: Andre Guedes <aguedespe@gmail.com>
    
This patch renames hdev->extfeatures to hdev->host_features since it
holds the extended features Page 1 (aka host features).

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 8f441b8..61deef8 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -130,7 +130,7 @@ struct hci_dev {
 	__u8		major_class;
 	__u8		minor_class;
 	__u8		features[8];
-	__u8		extfeatures[8];
+	__u8		host_features[8];
 	__u8		commands[64];
 	__u8		ssp_mode;
 	__u8		hci_ver;
@@ -601,7 +601,7 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 #define lmp_le_capable(dev)        ((dev)->features[4] & LMP_LE)
 
 /* ----- Extended LMP capabilities ----- */
-#define lmp_host_le_capable(dev)   ((dev)->extfeatures[0] & LMP_HOST_LE)
+#define lmp_host_le_capable(dev)   ((dev)->host_features[0] & LMP_HOST_LE)
 
 /* ----- HCI protocols ----- */
 struct hci_proto {
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 7ef4eb4..6a09143 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -695,7 +695,7 @@ static void hci_cc_read_local_ext_features(struct hci_dev *hdev,
 	if (rp->status)
 		return;
 
-	memcpy(hdev->extfeatures, rp->features, 8);
+	memcpy(hdev->host_features, rp->features, 8);
 
 	hci_req_complete(hdev, HCI_OP_READ_LOCAL_EXT_FEATURES, rp->status);
 }

--------------080901060107000207060908
Content-Type: text/x-patch;
 name="bluetooth-3.1.7_2-2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="bluetooth-3.1.7_2-2.diff"

[PATCH 2/2] Bluetooh: Fix hci_cc_read_local_ext_features()
    
From: Andre Guedes <aguedespe@gmail.com>
    
Copy the Features value according to the Page number.

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 6a09143..9ef6012 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -695,7 +695,14 @@ static void hci_cc_read_local_ext_features(struct hci_dev *hdev,
 	if (rp->status)
 		return;
 
-	memcpy(hdev->host_features, rp->features, 8);
+	switch (rp->page) {
+	case 0:
+		memcpy(hdev->features, rp->features, 8);
+		break;
+	case 1:
+		memcpy(hdev->host_features, rp->features, 8);
+		break;
+	}
 
 	hci_req_complete(hdev, HCI_OP_READ_LOCAL_EXT_FEATURES, rp->status);
 }

--------------080901060107000207060908--
