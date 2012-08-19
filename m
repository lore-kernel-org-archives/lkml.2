Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab2HST41 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 15:56:27 -0400
Received: from netrider.rowland.org ([192.131.102.5]:42679 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752100Ab2HST4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 15:56:25 -0400
Date: Sun, 19 Aug 2012 15:56:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
cc: Jiri Kosina <jkosina@suse.cz>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 0/7] HID: picoLCD updates
In-Reply-To: <20120819182300.63665a0b@neptune.home>
Message-ID: <Pine.LNX.4.44L0.1208191545230.7627-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Aug 2012, Bruno Prémont wrote:

> > I don't know bout hid_hw_close().  Certainly no more reports should be 
> > submitted following usbhid_stop().
> 
> Ok, I did just that, prevent new calls to usbhid_submit_report(), after
> calling hid_hw_close(), fixed one bug in my code that triggers the NULL
> pointer dereference (calling hid_set_drvdata(hdev, NULL) too early).
> 
> Now I'm still seeing the bad paging request in _mmx_memcpy(), though rather
> sporadically.
> The last ones I saw were during remove() around the time of calling hid_hw_close()
> and hid_hw_stop(). Adding a printk() between the two (at least while picoLCD
> is hosting fbcon) makes it very improbably for the bad page to happen.
> 
> It looks like low-level driver did free memory in hid_hw_close() for some
> in-flight URB and thus things break in following USB interrupt.

No, memory is not freed in usbhid_close().  It is freed in 
usbhid_stop().

> From mapping trace information to source it seems:
> usbhid/hid-core.c:
> static int hid_submit_out(struct hid_device *hid)
> {
>         struct hid_report *report;
>         char *raw_report;
>         struct usbhid_device *usbhid = hid->driver_data;
>         int r;
> 
>         report = usbhid->out[usbhid->outtail].report;
>         raw_report = usbhid->out[usbhid->outtail].raw_report;
> 
>         usbhid->urbout->transfer_buffer_length = ((report->size - 1) >> 3) +
>                                                  1 + (report->id > 0);
>         usbhid->urbout->dev = hid_to_usb_dev(hid);
>         if (raw_report) {
>                 memcpy(usbhid->outbuf, raw_report,
>                                 usbhid->urbout->transfer_buffer_length);
>                 ^^^^^^^^^^^^^^^_ this is exploding

Right.  Like I said, usbhid->outbuf is freed in hid_free_buffers(), 
which is called from usbhid_stop().

Forget about usbhid_close().  The race is between hid_submit_out() and 
usbhid_stop().

Alan Stern

