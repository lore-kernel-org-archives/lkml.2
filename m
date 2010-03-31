Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756873Ab0CaWKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 18:10:55 -0400
Received: from n23a.bullet.mail.mud.yahoo.com ([68.142.207.189]:30476 "HELO
	n23a.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756427Ab0CaWKx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 18:10:53 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 11363.17519.bm@omp119.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=V8PJFyO/JFZt6Z2yZAnuuhleHaXckcH/ZljgPZpDPvVmrr77Bg5BGqPlLNMfS9JRa0MkOU07guMJi9gnW2+702ZszfV7AeQB+t64l4/GFn1VLaA11Z66hZBEThld7PhukanbohYk0vvl+ZCHE4o/n++g6neawXaTal91WUveO58=;
Message-ID: <917081.88187.qm@web110406.mail.gq1.yahoo.com>
X-YMail-OSG: uAwFOc0VM1mTTZxrbxQ.E.oVAc5FRp9.lWGRwi3YMPDtk4H
 ol7VQR75J0E74VHj6DDoR21sTdCFc9WI0SKRf5sA8hlLgEOAeT5LmghqD.sI
 4RO65bbLPyYREfeq1CiCimP.8asYwXq.6kHa8odg428trWpocnavGbzP9u1V
 oCCHoEXCIXKLMLYIi.10bgZbeY8ImiW8Cc0s8DjGkmdUzmBIlJ.auQOU.Z5m
 8C3cACraAcXQEkzpc9hRP894.Q6igP56JFPU_CfEp0VRtPPcaCUu0Y1XcxBo
 Qbd_4PBYfmIR3H4pVzEyYeoW3zriU2Cxp6eln9qWir3FDyo8HZR4HOwqMGuI
 8SoNbbpJeCzYyvmOZ6yC_m2AkW0lEpyb0FvcXjEHFmqaGM44x7DLlqLZok4k
 HCpyd754-
X-Mailer: YahooMailWebService/0.8.100.260964
Date: Wed, 31 Mar 2010 15:10:52 -0700 (PDT)
From: Daniel Borca <dborca@yahoo.com>
Subject: Re: [PATCHv3] drivers/net/usb: Add new driver ipheth
To: Oliver Neukum <oliver@neukum.org>
Cc: =?iso-8859-1?Q?L=2E_Alberto_Gim=E9nez?= <agimenez@sysvalve.es>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linville@tuxdriver.com" <linville@tuxdriver.com>,
       "j.dumon@option.com" <j.dumon@option.com>,
       "steve.glendinning@smsc.com" <steve.glendinning@smsc.com>,
       "davem@davemloft.net" <davem@davemloft.net>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "dgiagio@gmail.com" <dgiagio@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Thanks for the comments.  I've already fixed a few things.  We'll fix the remaining ones (below) ASAP.  

Regards,
Daniel Borca

On 31.03.2010, at 23:33, Oliver Neukum <oliver@neukum.org> wrote:

Am Mittwoch, 31. März 2010 21:42:07 schrieb L. Alberto Giménez:

Hi,

a few comments below.

   Regards
       Oliver

+
+static int ipheth_open(struct net_device *net)
+{
+    struct ipheth_device *dev = netdev_priv(net);
+    struct usb_device *udev = dev->udev;
+    int retval = 0;
+
+    usb_set_interface(udev, IPHETH_INTFNUM, IPHETH_ALT_INTFNUM);
+    usb_clear_halt(udev, usb_rcvbulkpipe(udev, dev->bulk_in));
+    usb_clear_halt(udev, usb_sndbulkpipe(udev, dev->bulk_out));

Is this really needed? If so, please add a comment.

+
+    retval = ipheth_carrier_set(dev);
+    if (retval)
+        goto error;
+
+    retval = ipheth_rx_submit(dev, GFP_KERNEL);
+    if (retval)
+        goto error;
+
+    schedule_delayed_work(&dev->carrier_work, IPHETH_CARRIER_CHECK_TIMEOUT);

Does it make sense to start rx while you have no carrier?

+static int ipheth_tx(struct sk_buff *skb, struct net_device *net)
+{
+    struct ipheth_device *dev = netdev_priv(net);
+    struct usb_device *udev = dev->udev;
+    int retval;
+
+    /* Paranoid */
+    if (skb->len > IPHETH_BUF_SIZE) {
+        err("%s: skb too large: %d bytes", __func__, skb->len);
+        dev->stats.tx_dropped++;
+        dev_kfree_skb_irq(skb);
+        goto exit;
+    }
+
+    memset(dev->tx_buf, 0, IPHETH_BUF_SIZE);
+    memcpy(dev->tx_buf, skb->data, skb->len);

a bit wasteful

+static void ipheth_disconnect(struct usb_interface *intf)
+{
+    struct ipheth_device *dev;
+
+    dev = usb_get_intfdata(intf);
+    if (dev != NULL) {

is this check needed?

+static struct usb_driver ipheth_driver = {
+    .name =        "ipheth",
+    .probe =    ipheth_probe,
+    .disconnect =    ipheth_disconnect,
+    .id_table =    ipheth_table,
+    .supports_autosuspend = 0,

redundant



      

