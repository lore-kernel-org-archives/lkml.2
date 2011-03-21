Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab1CUOJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 10:09:42 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48919 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753194Ab1CUOJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 10:09:40 -0400
Date: Mon, 21 Mar 2011 10:09:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Jiri Kosina <jkosina@suse.cz>, Greg KH <gregkh@suse.de>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: "usb_wwan: error case of resume" (16871dcac) is buggy
In-Reply-To: <201103211011.07282.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.1103211006170.1978-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Mar 2011, Oliver Neukum wrote:

> Am Montag, 21. März 2011, 01:36:45 schrieb Jiri Kosina:
> > Hi,
> > 
> > the commit in subject make the kernel with CONFIG_PM_RUNTIME unset fail 
> > during compilation, as struct dev_pm_info doesn't have whole bunch of 
> > members in such case.
> > 
> > The commit in question adds this code:
> > 
> > 	/* we have to throw away the rest */
> > 	do {
> > 		unbusy_queued_urb(urb, portdata);
> > 		//extremely dirty
> > 		atomic_dec(&port->serial->interface->dev.power.usage_count);
> > 	} while ((urb = usb_get_from_anchor(&portdata->delayed)));
> > 
> > The 'extermely dirty' comment makes me a bit nervous whether the patch 
> > below is correct or some more thinking would be necessary.
> 
> I've since posted a clean patch, although your fix looks correct to me.

In fact the original code and Jiri's fix are both wrong.  The layering 
violation here is not only inelegant, it is downright buggy.

The USB core contains its own usage_count for interfaces, in parallel 
with the usage_count in interface->dev.power.  Bypassing the USB layer 
in this way causes the two counts to get out of sync, which will lead 
to errors.

Oliver's new fix is correct.

Alan Stern

