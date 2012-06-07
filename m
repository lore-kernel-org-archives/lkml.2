Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab2FGHLi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 03:11:38 -0400
Received: from canardo.mork.no ([148.122.252.1]:38844 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab2FGHLg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 03:11:36 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Stefani Seibold <stefani@seibold.net>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, oneukum@suse.de, alan@lxorguk.ukuu.org.uk,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] fix usb skeleton driver
Organization: m
References: <Pine.LNX.4.44L0.1206061406500.1788-100000@iolanthe.rowland.org>
	<1339013986.3437.20.camel@wall-e>
Date: Thu, 07 Jun 2012 09:10:27 +0200
In-Reply-To: <1339013986.3437.20.camel@wall-e> (Stefani Seibold's message of
	"Wed, 06 Jun 2012 22:19:46 +0200")
Message-ID: <87k3zjtx5o.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefani Seibold <stefani@seibold.net> writes:
> Am Mittwoch, den 06.06.2012, 14:16 -0400 schrieb Alan Stern:
>
>> But that's wrong -- the accesses should go through the interface 
>> pointer.  After all, the driver is bound to the interface, not to the 
>> device.
>> 
>
> Not really true, in whole driver only the open() and close() use the
> interface pointer.
>
> In the open path the interface is already determinate by
> usb_find_interface(), so it was reasonable to do this also in the close
> path.

You are ignoring a few printk's you had to change:

@@ -460,9 +466,8 @@ static ssize_t skel_write(struct file *file, const char *user_buffer,
 
 	/* send the data out the bulk port */
 	retval = usb_submit_urb(urb, GFP_KERNEL);
-	mutex_unlock(&dev->io_mutex);
 	if (retval) {
-		dev_err(&dev->interface->dev,
+		dev_err(&dev->udev->dev,
 			"%s - failed submitting write urb, error %d\n",
 			__func__, retval);
 		goto error_unanchor;


IMHO this is really bad in an example driver.  This is an interface
driver, and any messages from it should either reference the interface
or some related device the driver has registered.

"Simplifying" like this is not the way to go when writing a HOWTO.


Bjørn
