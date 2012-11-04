Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab2KDOaa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 09:30:30 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:56479 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab2KDOa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 09:30:26 -0500
Message-ID: <50967BFD.6000308@gmail.com>
Date: Sun, 04 Nov 2012 15:30:21 +0100
From: Dmytro Milinevskyy <milinevskyy@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: gadget: ncm: correct endianess conversion
References: <50929233.7030609@gmail.com>
In-Reply-To: <50929233.7030609@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert USB descriptor's fields to CPU byte order before using locally in USB NCM gadget driver.
Tested on MIPS32 big-endian device.

Signed-off-by: Dmytro Milinevskyy <milinevskyy@gmail.com>
---
  drivers/usb/gadget/f_ncm.c | 12 ++++++++----
  1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/f_ncm.c b/drivers/usb/gadget/f_ncm.c
index b651b52..a7cdd47 100644
--- a/drivers/usb/gadget/f_ncm.c
+++ b/drivers/usb/gadget/f_ncm.c
@@ -102,7 +102,7 @@ static inline unsigned ncm_bitrate(struct usb_gadget *g)
  				 USB_CDC_NCM_NTB32_SUPPORTED)
  
  static struct usb_cdc_ncm_ntb_parameters ntb_parameters = {
-	.wLength = sizeof ntb_parameters,
+	.wLength = cpu_to_le16(sizeof(ntb_parameters)),
  	.bmNtbFormatsSupported = cpu_to_le16(FORMATS_SUPPORTED),
  	.dwNtbInMaxSize = cpu_to_le32(NTB_DEFAULT_IN_SIZE),
  	.wNdpInDivisor = cpu_to_le16(4),
@@ -869,15 +869,19 @@ static struct sk_buff *ncm_wrap_ntb(struct gether *port,
  	struct sk_buff	*skb2;
  	int		ncb_len = 0;
  	__le16		*tmp;
-	int		div = ntb_parameters.wNdpInDivisor;
-	int		rem = ntb_parameters.wNdpInPayloadRemainder;
+	int		div;
+	int		rem;
  	int		pad;
-	int		ndp_align = ntb_parameters.wNdpInAlignment;
+	int		ndp_align;
  	int		ndp_pad;
  	unsigned	max_size = ncm->port.fixed_in_len;
  	struct ndp_parser_opts *opts = ncm->parser_opts;
  	unsigned	crc_len = ncm->is_crc ? sizeof(uint32_t) : 0;
  
+	div = le16_to_cpu(ntb_parameters.wNdpInDivisor);
+	rem = le16_to_cpu(ntb_parameters.wNdpInPayloadRemainder);
+	ndp_align = le16_to_cpu(ntb_parameters.wNdpInAlignment);
+
  	ncb_len += opts->nth_size;
  	ndp_pad = ALIGN(ncb_len, ndp_align) - ncb_len;
  	ncb_len += ndp_pad;
-- 
1.8.0


