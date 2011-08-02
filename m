Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab1HBKkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 06:40:36 -0400
Received: from ist.d-labs.de ([213.239.218.44]:57042 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174Ab1HBKka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 06:40:30 -0400
Date: Tue, 2 Aug 2011 12:40:28 +0200
From: Florian Mickler <florian@mickler.org>
To: Dan Carpenter <error27@gmail.com>
Cc: Florian Mickler <florian@mickler.org>, linux-kernel@vger.kernel.org,
        Tino Keitel <tino.keitel@tikei.de>, mchehab@infradead.org
Subject: Re: USB related "unable to handle kernel paging request" in
 3.0.0-rc7
Message-ID: <20110802124028.3b8dcd5a@schatten.dmk.lab>
In-Reply-To: <20110802115145.25b6a445@schatten.dmk.lab>
References: <20110722192722.GA9369@x61.home>
	<20110802085447.GA4522@shale.localdomain>
	<20110802115145.25b6a445@schatten.dmk.lab>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Aug 2011 11:51:45 +0200
Florian Mickler <florian@mickler.org> wrote:

> On Tue, 2 Aug 2011 11:54:47 +0300
> Dan Carpenter <error27@gmail.com> wrote:
> 
> > Looking at this, I noticed a memory corruption bug introduce in:
> > ab22cbda6651d "[media] vp7045: get rid of on-stack dma buffers"
> > 
> > vp7045_properties.size_of_priv is sizeof(u8 *) so in vp7045_usb_probe()
> > the d->priv buffer gets allocated twice.  Once in:
> > 	dvb_usb_device_init()
> > 	-> dvb_usb_init()
> > 
> > And once explicitly to a larger buffer later on in the function with
> > a kmalloc().
> > 
> > So the two places that use the buffer will probably race and cause
> > memory corruption.

Btw, what two places use the buffer? I only see vp7045_usb_op. Did you
mean s/use/free/ or did I overlook it?

Patch below.

> > 
> > regards,
> > dan carpenter
> 
> Damn. That (u8*)sized priv buffer should only hold a pointer to the
> transfer buffer allocated in the prope routine. But I botched that. 
> I will send a fixup in a minute.  
> 
> Regards,
> Flo

This should fix it. 

[git am -c ]
--------->8-------->8---------->8------------>8---------------------------
commit 2c505d4867be9f3605c20ed505ec62d2096a05b1
Author: Florian Mickler <florian@mickler.org>
Date:   Tue Aug 2 12:18:55 2011 +0200

    [media] vp7045: fix double free and mem leak
    
    The vp7045 priv data should be a pointer to a buffer.
    Make it so.
    
    This was introduced in commit ab22cbda6651db25 ([media] vp7045: get rid of on-stack
    dma buffers).
    
    CC: stable@kernel.org
    Reported-by: Dan Carpenter <error27@gmail.com>
    Signed-off-by: Florian Mickler <florian@mickler.org>

diff --git a/drivers/media/dvb/dvb-usb/vp7045.c b/drivers/media/dvb/dvb-usb/vp7045.c
index 3db89e3..8dd348b 100644
--- a/drivers/media/dvb/dvb-usb/vp7045.c
+++ b/drivers/media/dvb/dvb-usb/vp7045.c
@@ -28,7 +28,8 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 int vp7045_usb_op(struct dvb_usb_device *d, u8 cmd, u8 *out, int outlen, u8 *in, int inlen, int msec)
 {
 	int ret = 0;
-	u8 *buf = d->priv;
+	u8 **bufp = d->priv;
+	u8 *buf = *bufp
 
 	buf[0] = cmd;
 
@@ -224,14 +225,16 @@ static struct dvb_usb_device_properties vp7045_properties;
 static int vp7045_usb_probe(struct usb_interface *intf,
 		const struct usb_device_id *id)
 {
+	u8 **bufp;
 	struct dvb_usb_device *d;
 	int ret = dvb_usb_device_init(intf, &vp7045_properties,
 				   THIS_MODULE, &d, adapter_nr);
 	if (ret)
 		return ret;
 
-	d->priv = kmalloc(20, GFP_KERNEL);
-	if (!d->priv) {
+	bufp = d->priv;
+	*bufp = kmalloc(20, GFP_KERNEL);
+	if (!*bufp) {
 		dvb_usb_device_exit(intf);
 		return -ENOMEM;
 	}
@@ -241,8 +244,10 @@ static int vp7045_usb_probe(struct usb_interface *intf,
 
 static void vp7045_usb_disconnect(struct usb_interface *intf)
 {
+	u8 **bufp;
 	struct dvb_usb_device *d = usb_get_intfdata(intf);
-	kfree(d->priv);
+	bufp = d->priv;
+	kfree(*bufp);
 	dvb_usb_device_exit(intf);
 }
 
