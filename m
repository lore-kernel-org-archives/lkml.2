Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab0DBSXh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 14:23:37 -0400
Received: from capside.net ([81.19.98.74]:59060 "EHLO eul0600410.eu.verio.net"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751589Ab0DBSX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:23:28 -0400
Message-ID: <4BB63619.6070607@sysvalve.es>
Date: Fri, 02 Apr 2010 20:23:21 +0200
From: =?UTF-8?B?IkwuIEFsYmVydG8gR2ltw6luZXoi?= <agimenez@sysvalve.es>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-usb@vger.kernel.org, linville@tuxdriver.com, j.dumon@option.com,
       steve.glendinning@smsc.com, davem@davemloft.net, gregkh@suse.de,
       dgiagio@gmail.com, dborca@yahoo.com
Subject: Re: [PATCHv3] drivers/net/usb: Add new driver ipheth
References: <1269984864-28159-1-git-send-email-agimenez@sysvalve.es> <1270064527-8485-1-git-send-email-agimenez@sysvalve.es> <201003312233.26130.oliver@neukum.org>
In-Reply-To: <201003312233.26130.oliver@neukum.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2010 10:33 PM, Oliver Neukum wrote:
> Am Mittwoch, 31. März 2010 21:42:07 schrieb L. Alberto Giménez:

Hi Oliver,

Just like with Ben's comments I still have a couple of doubts about your
comments.


>> +
>> +static int ipheth_open(struct net_device *net)
>> +{
>> +	struct ipheth_device *dev = netdev_priv(net);
>> +	struct usb_device *udev = dev->udev;
>> +	int retval = 0;
>> +
>> +	usb_set_interface(udev, IPHETH_INTFNUM, IPHETH_ALT_INTFNUM);
>> +	usb_clear_halt(udev, usb_rcvbulkpipe(udev, dev->bulk_in));
>> +	usb_clear_halt(udev, usb_sndbulkpipe(udev, dev->bulk_out));
> 
> Is this really needed? If so, please add a comment.

I understand that usb_clear_halt is only needed when the device has
transmitted data, and as it is "open" time, we can assume that no
transmissions ere made, so we don't need to clear anything (aka: remove
both lines), am I right?


>> +
>> +	retval = ipheth_carrier_set(dev);
>> +	if (retval)
>> +		goto error;
>> +
>> +	retval = ipheth_rx_submit(dev, GFP_KERNEL);
>> +	if (retval)
>> +		goto error;
>> +
>> +	schedule_delayed_work(&dev->carrier_work, IPHETH_CARRIER_CHECK_TIMEOUT);
> 
> Does it make sense to start rx while you have no carrier?

Well, I have no clue about this one. I think that upstream developers
should take a look into this (Dario, Daniel, could you?) since I don't
have the knowledge to decide what to do about it.

But I assume that as with the previous one, we have just opened the
device and we aren't (yet) doing anything with it, so we shouldn't start rx?

>> +static void ipheth_disconnect(struct usb_interface *intf)
>> +{
>> +	struct ipheth_device *dev;
>> +
>> +	dev = usb_get_intfdata(intf);
>> +	if (dev != NULL) {
> 
> is this check needed?

Does usb_get_infdata always return not NULL? I haven't found anything
about it (just manual pages for the function, but can't spot if it
cannot return NULL). We disconnected the device, but I understand that
the kernel still has the information and the allocated memory, so the
cleanup code is still needed, isn't it?


> 
>> +static struct usb_driver ipheth_driver = {
>> +	.name =		"ipheth",
>> +	.probe =	ipheth_probe,
>> +	.disconnect =	ipheth_disconnect,
>> +	.id_table =	ipheth_table,
>> +	.supports_autosuspend = 0,
> 
> redundant

Why?

Thanks a lot in advance.


Best regards,
-- 
L. Alberto Giménez
JabberID agimenez@jabber.sysvalve.es
GnuPG key ID 0x3BAABDE1
