Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab2JVPSC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:18:02 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53318 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751554Ab2JVPR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:17:59 -0400
Date: Mon, 22 Oct 2012 11:17:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Artem S. Tashkinov" <t.artem@lycos.com>
cc: bp@alien8.de, <pavel@ucw.cz>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <security@kernel.org>,
        <linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <zonque@gmail.com>, <alsa-devel@alsa-project.org>
Subject: Re: Re: Re: Re: Re: Re: A reliable kernel panic (3.6.2) and system
 crash when visiting a particular website
In-Reply-To: <1906833625.122006.1350848941352.JavaMail.mail@webmail16>
Message-ID: <Pine.LNX.4.44L0.1210221116040.1724-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Oct 2012, Artem S. Tashkinov wrote:

> dmesg messages up to a crash can be seen here: https://bugzilla.kernel.org/attachment.cgi?id=84221

The first problem in the log is endpoint list corruption.  Here's a 
debugging patch which should provide a little more information.

Alan Stern


 drivers/usb/core/hcd.c |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

Index: usb-3.6/drivers/usb/core/hcd.c
===================================================================
--- usb-3.6.orig/drivers/usb/core/hcd.c
+++ usb-3.6/drivers/usb/core/hcd.c
@@ -1083,6 +1083,8 @@ EXPORT_SYMBOL_GPL(usb_calc_bus_time);
 
 /*-------------------------------------------------------------------------*/
 
+static bool list_error;
+
 /**
  * usb_hcd_link_urb_to_ep - add an URB to its endpoint queue
  * @hcd: host controller to which @urb was submitted
@@ -1126,6 +1128,20 @@ int usb_hcd_link_urb_to_ep(struct usb_hc
 	 */
 	if (HCD_RH_RUNNING(hcd)) {
 		urb->unlinked = 0;
+
+		{
+			struct list_head *cur = &urb->ep->urb_list;
+			struct list_head *prev = cur->prev;
+
+			if (prev->next != cur && !list_error) {
+				list_error = true;
+				dev_err(&urb->dev->dev,
+					"ep %x list add corruption: %p %p %p\n",
+					urb->ep->desc.bEndpointAddress,
+					cur, prev, prev->next);
+			}
+		}
+
 		list_add_tail(&urb->urb_list, &urb->ep->urb_list);
 	} else {
 		rc = -ESHUTDOWN;
@@ -1193,6 +1209,26 @@ void usb_hcd_unlink_urb_from_ep(struct u
 {
 	/* clear all state linking urb to this dev (and hcd) */
 	spin_lock(&hcd_urb_list_lock);
+	{
+		struct list_head *cur = &urb->urb_list;
+		struct list_head *prev = cur->prev;
+		struct list_head *next = cur->next;
+
+		if (prev->next != cur && !list_error) {
+			list_error = true;
+			dev_err(&urb->dev->dev,
+				"ep %x list del corruption prev: %p %p %p\n",
+				urb->ep->desc.bEndpointAddress,
+				cur, prev, prev->next);
+		}
+		if (next->prev != cur && !list_error) {
+			list_error = true;
+			dev_err(&urb->dev->dev,
+				"ep %x list del corruption next: %p %p %p\n",
+				urb->ep->desc.bEndpointAddress,
+				cur, next, next->prev);
+		}
+	}
 	list_del_init(&urb->urb_list);
 	spin_unlock(&hcd_urb_list_lock);
 }

