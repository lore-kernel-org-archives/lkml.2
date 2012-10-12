Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534Ab2JLPFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 11:05:24 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:38893 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab2JLPFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 11:05:22 -0400
X-SENDER-IP: [85.230.29.114]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjWKAKwweFBV5h1yPGdsb2JhbABEDoUbhSO0CwSBAxkBAQEBHxkNJ4IgAQEEAScTHBMBDwULCAMRAwECLxQlCgwOCgmHfgq6VRSLPgkqA4UnYAOVbIVyjHE9gVg
X-IronPort-AV: E=Sophos;i="4.80,577,1344204000"; 
   d="scan'208";a="209195496"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 12 Oct 2012 17:08:00 +0200
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Hans de Goede <hdegoede@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Stuge <peter@stuge.se>
Subject: Re: REGRESSION: usbdevfs:
 Use-scatter-gather-lists-for-large-bulk-transfers
Message-ID: <20121012150800.GA3097@polaris.bitmath.org>
References: <20121011213707.GA2187@polaris.bitmath.org>
 <Pine.LNX.4.44L0.1210121018390.1605-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1210121018390.1605-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> Instead of introducing a new local variable, why not simply update 
> uurb->buffer?  That's what we do elsewhere in the code.

It seemed fragile, due to these scary lines:

	if (is_in && uurb->buffer_length > 0)
		as->userbuffer = uurb->buffer;
	else
		as->userbuffer = NULL;

I suppose it works in this particular case.  How is the
USBDEVFS_URB_TYPE_CONTROL case supposed to work here?

I can certainly change the patch if preferred. Tested and attached
below.

Thanks,
Henrik

>From 40b70394747eea51fdd07cc8213dd6afd24b1b30 Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Thu, 11 Oct 2012 23:27:04 +0200
Subject: [PATCH v2] usbdevfs: Fix broken scatter-gather transfer

The handling of large output bulk transfers is broken; the same user
page is read over and over again. Fixed with this patch.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/usb/core/devio.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index ebb8a9d..6e58b59 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1349,6 +1351,7 @@
 					goto error;
 				}
 			}
+			uurb->buffer += u;
 			totlen -= u;
 		}
 	} else if (uurb->buffer_length > 0) {

