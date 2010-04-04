Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab0DDHYv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 03:24:51 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:38925 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab0DDHYo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 03:24:44 -0400
From: Oliver Neukum <oliver@neukum.org>
To: "L. Alberto =?utf-8?q?Gim=C3=A9nez?=" <agimenez@sysvalve.es>
Subject: Re: [PATCHv3] drivers/net/usb: Add new driver ipheth
Date: Sun, 4 Apr 2010 09:24:43 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-usb@vger.kernel.org, linville@tuxdriver.com, j.dumon@option.com,
       steve.glendinning@smsc.com, davem@davemloft.net, gregkh@suse.de,
       dgiagio@gmail.com, dborca@yahoo.com
References: <1269984864-28159-1-git-send-email-agimenez@sysvalve.es> <201003312233.26130.oliver@neukum.org> <4BB63619.6070607@sysvalve.es>
In-Reply-To: <4BB63619.6070607@sysvalve.es>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004040924.43949.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 2. April 2010 20:23:21 schrieb L. Alberto Giménez:
> On 03/31/2010 10:33 PM, Oliver Neukum wrote:
> > Am Mittwoch, 31. März 2010 21:42:07 schrieb L. Alberto Giménez:
> 
> Hi Oliver,
> 
> Just like with Ben's comments I still have a couple of doubts about your
> comments.
> 
> 
> >> +
> >> +static int ipheth_open(struct net_device *net)
> >> +{
> >> +	struct ipheth_device *dev = netdev_priv(net);
> >> +	struct usb_device *udev = dev->udev;
> >> +	int retval = 0;
> >> +
> >> +	usb_set_interface(udev, IPHETH_INTFNUM, IPHETH_ALT_INTFNUM);
> >> +	usb_clear_halt(udev, usb_rcvbulkpipe(udev, dev->bulk_in));
> >> +	usb_clear_halt(udev, usb_sndbulkpipe(udev, dev->bulk_out));
> > 
> > Is this really needed? If so, please add a comment.
> 
> I understand that usb_clear_halt is only needed when the device has
> transmitted data, and as it is "open" time, we can assume that no
> transmissions ere made, so we don't need to clear anything (aka: remove
> both lines), am I right?

Clearing a halt is necessary only when a device has stalled due to an
error condition. Unless the device is buggy and produces errors for
no good reason you don't need these lines.
 
> >> +
> >> +	retval = ipheth_carrier_set(dev);
> >> +	if (retval)
> >> +		goto error;
> >> +
> >> +	retval = ipheth_rx_submit(dev, GFP_KERNEL);
> >> +	if (retval)
> >> +		goto error;
> >> +
> >> +	schedule_delayed_work(&dev->carrier_work, IPHETH_CARRIER_CHECK_TIMEOUT);
> > 
> > Does it make sense to start rx while you have no carrier?
> 
> Well, I have no clue about this one. I think that upstream developers
> should take a look into this (Dario, Daniel, could you?) since I don't
> have the knowledge to decide what to do about it.
> 
> But I assume that as with the previous one, we have just opened the
> device and we aren't (yet) doing anything with it, so we shouldn't start rx?

Your code as is is correct, I just wondered whether it could be made more
efficient.

> >> +static void ipheth_disconnect(struct usb_interface *intf)
> >> +{
> >> +	struct ipheth_device *dev;
> >> +
> >> +	dev = usb_get_intfdata(intf);
> >> +	if (dev != NULL) {
> > 
> > is this check needed?
> 
> Does usb_get_infdata always return not NULL? I haven't found anything

It returns what you gave it with  usb_set_intfdata().

> about it (just manual pages for the function, but can't spot if it
> cannot return NULL). We disconnected the device, but I understand that
> the kernel still has the information and the allocated memory, so the
> cleanup code is still needed, isn't it?

It is definitely needed.

> >> +static struct usb_driver ipheth_driver = {
> >> +	.name =		"ipheth",
> >> +	.probe =	ipheth_probe,
> >> +	.disconnect =	ipheth_disconnect,
> >> +	.id_table =	ipheth_table,
> >> +	.supports_autosuspend = 0,
> > 
> > redundant
> 
> Why?

0 is the default.

	Regards
		Oliver
