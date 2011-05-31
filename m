Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1EaNrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:47:23 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:44425 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab1EaNrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:47:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=We16TiGr+U6dehzGnVNxqtt7LDOyOvqCbhAK059zVf1mJSxqlvB90LrmQaaXkS5xQq
         8P+AIbouI1e88Tu7gt1bfqkN2eci5IgSGhrdgVYpOWnIOwigqMipjzkMJy67Ysj4oMz4
         usQqAj1Etu8BzyAnCDj7pqNgcFAMppvco7WLg=
Message-ID: <4DE4F166.8020207@gmail.com>
Date: Tue, 31 May 2011 15:47:18 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Xu, Andiry" <Andiry.Xu@amd.com>
CC: linux-usb@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [RFC] usb: Do not attempt to reset the device while it is
 disabled
References: <1306749406-21124-1-git-send-email-m.b.lankhorst@gmail.com> <2DEEA3AB13739D45A22ADDB5086AEA0B016C1261@sshaexmb1.amd.com>
In-Reply-To: <2DEEA3AB13739D45A22ADDB5086AEA0B016C1261@sshaexmb1.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Andiry,

Op 31-05-11 02:34, Xu, Andiry schreef:
>> -----Original Message-----
>> From:linux-usb-owner@vger.kernel.org  [mailto:linux-usb-
>> owner@vger.kernel.org] On Behalf Of Maarten Lankhorst
>> Sent: Monday, May 30, 2011 5:57 PM
>> To:linux-usb@vger.kernel.org
>> Cc: Sarah Sharp;linux-kernel@vger.kernel.org; Maarten Lankhorst
>> Subject: [PATCH] [RFC] usb: Broaden range of vendor codes for xhci
>>
>> My asrock P67 chipset sends code 192 on device reset. Allowing>= 192
>> to be treated as success fixes it, and allows me to use my USB3 port.
>>
> TRB completion code 192-223 is defined as Vendor defined error. Your
> host
> controller returns a error - don't know what causes the error since it's
> vendor defined.
Ahh, making it the same as COMP_EBADSLT/COMP_CTX_STATE I get this:
[72677.470421] xhci_hcd 0000:04:00.0: Can't reset device (slot ID 1) in 
enabled/disabled state

Should reset_device even be called when in that state? The comments 
above claim:
/* The Reset Device command can't fail, according to the 0.95/0.96 spec,
  * unless we tried to reset a slot ID that wasn't enabled,
  * or the device wasn't in the addressed or configured state.
  */

Ignoring the error seems to make it work fine. It seems to me that 
device reset shouldn't even be attempted since it hasn't been brought up 
yet. The reset that fails is the one that happens on the original 
hub_port_init when it calls hub_port_reset which calls 
xhci_discover_or_reset_device. The failure I'm getting seems to be a 
vendor specific variant of "you're trying to reset the device while it 
wasn't enabled".

Signed-off-by: Maarten Lankhorst<m.b.lankhorst@gmail.com>

---
index 81b976e..9a869b2 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -2307,6 +2307,10 @@ int xhci_discover_or_reset_device(struct usb_hcd *hcd, struct usb_device *udev)
  			return -EINVAL;
  	}

+	if (GET_SLOT_STATE(xhci_get_slot_ctx(xhci, virt_dev->out_ctx)->dev_state) == 0&&
+	    (xhci_get_ep_ctx(xhci, virt_dev->out_ctx, 0)->ep_info&  EP_STATE_MASK) == EP_STATE_DISABLED)
+		return 0;
+
  	xhci_dbg(xhci, "Resetting device with slot ID %u\n", slot_id);
  	/* Allocate the command structure that holds the struct completion.
  	 * Assume we're in process context, since the normal device reset


   

