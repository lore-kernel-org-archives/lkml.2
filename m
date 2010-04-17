Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab0DQPNI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 11:13:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:50970 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab0DQPNE (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 11:13:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:x-url:x-pgp-fp:x-pgp:date
         :in-reply-to:message-id:user-agent:mime-version:content-type;
        b=hQq5UG/5h48Xdzd4V4NUGK6heeBxVy0npYO/xF4WTiZ6VYJAVsffcY0fkIvKE+JUfr
         x2cqtWYPcCQw2JKfbGATBoMO5H7awCU45jSFcdNgS/CRKNiFyzg0+IUvzJgUa43l2j7q
         MqZm0P0S9eiiywo7tqXNY1rEGPV5bVQ6X66lw=
From: Michal Nazarewicz <mina86@mina86.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, <Linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] usb: core: config.c: usb_get_configuration() simplified
References: <Pine.LNX.4.44L0.1004171041240.4980-100000@netrider.rowland.org>
X-Url: http://mina86.com/
X-PGP-FP: 9134 06FA 7AD8 D134 9D0C  C33F 532C CB00 B7C6 DF1E
X-PGP: B7C6DF1E
Date: Sat, 17 Apr 2010 17:12:58 +0200
In-Reply-To: <Pine.LNX.4.44L0.1004171041240.4980-100000@netrider.rowland.org>
	(Alan Stern's message of "Sat, 17 Apr 2010 10:42:17 -0400 (EDT)")
Message-ID: <87sk6uaz9h.fsf@erwin.mina86.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0 (Slckware Linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb_gat_configuratio() used two pointers to point to the same
memory.  Code simplified, by removing one of them.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/core/config.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

> On Sat, 17 Apr 2010, Michal Nazarewicz wrote:
>> usb_get_configuration() uses a temporary buffer allocated on heap
>> to read USB configuration descriptor.  The buffer is just nine
>> bytes an so it is a waste to allocate it on heap where it can be
>> allocated on stack with the rest of local variables.  This
>> simplifies the code and minimises memory usage.

Alan Stern <stern@rowland.harvard.edu> writes:
> This is completely wrong.  You are not allowed to do DMA to buffers on 
> the stack; some architectures are not capable of handling it.

That makes sense; I haven't considered this thinking that copying nine
bytes by CPU, rather then using DMA, is not a big issue.

Still, the change proposed by attached commit does not suffer from DMA
issue and still simplify the code.

diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index 0d3af6a..4b23e7f 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -722,7 +722,6 @@ int usb_get_configuration(struct usb_device *dev)
 	int ncfg = dev->descriptor.bNumConfigurations;
 	int result = 0;
 	unsigned int cfgno, length;
-	unsigned char *buffer;
 	unsigned char *bigbuffer;
 	struct usb_config_descriptor *desc;
 
@@ -751,17 +750,16 @@ int usb_get_configuration(struct usb_device *dev)
 	if (!dev->rawdescriptors)
 		goto err2;
 
-	buffer = kmalloc(USB_DT_CONFIG_SIZE, GFP_KERNEL);
-	if (!buffer)
+	desc = kmalloc(USB_DT_CONFIG_SIZE, GFP_KERNEL);
+	if (!desc)
 		goto err2;
-	desc = (struct usb_config_descriptor *)buffer;
 
 	result = 0;
 	for (; cfgno < ncfg; cfgno++) {
 		/* We grab just the first descriptor so we know how long
 		 * the whole configuration is */
 		result = usb_get_descriptor(dev, USB_DT_CONFIG, cfgno,
-		    buffer, USB_DT_CONFIG_SIZE);
+		    desc, USB_DT_CONFIG_SIZE);
 		if (result < 0) {
 			dev_err(ddev, "unable to read config index %d "
 			    "descriptor/%s: %d\n", cfgno, "start", result);
@@ -810,7 +808,7 @@ int usb_get_configuration(struct usb_device *dev)
 	result = 0;
 
 err:
-	kfree(buffer);
+	kfree(desc);
 out_not_authorized:
 	dev->descriptor.bNumConfigurations = cfgno;
 err2:
-- 
Best regards,                                         _     _
 .o. | Liege of Serenly Enlightened Majesty of      o' \,=./ `o
 ..o | Computer Science,  Michal "mina86" Nazarewicz   (o o)
 ooo +--<mina86-tlen.pl>--<jid:mina86-jabber.org>--ooO--(_)--Ooo--
