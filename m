Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab0JKTLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 15:11:34 -0400
Received: from smtp.outflux.net ([198.145.64.163]:50125 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754576Ab0JKTLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 15:11:33 -0400
Date: Mon, 11 Oct 2010 12:11:19 -0700
From: Kees Cook <kees.cook@canonical.com>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Oliver Neukum <oliver@neukum.org>, Joe Perches <joe@perches.com>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: don't trust report_size for buffer size
Message-ID: <20101011191119.GN4991@outflux.net>
References: <20101011182816.GA15451@outflux.net>
 <4CB35D4C.9000406@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4CB35D4C.9000406@freemail.hu>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Németh,

On Mon, Oct 11, 2010 at 08:54:04PM +0200, Németh Márton wrote:
> There might be similar problem also in the case USB_DEVICE_ID_CODEMERCS_IOW56. There
> is buf is allocated with usb_alloc_coherent() to the size dev->report_size. However,
> some lines later the copy_from_user() function tries to copy "count" number of
> bytes to the dev->report_size allocated buffer. Unfortunately I don't have such
> devices to try the driver so these are just coming from "static analysis".

I don't think the USB_DEVICE_ID_CODEMERCS_IOW56 path is a problem:

        if (count != dev->report_size) {
                retval = -EINVAL;
                goto exit;
        }
        switch (dev->product_id) {
...
        case USB_DEVICE_ID_CODEMERCS_IOW56:
...
                buf = usb_alloc_coherent(dev->udev, dev->report_size,
                                         GFP_KERNEL, &int_out_urb->transfer_dma);
...
                if (copy_from_user(buf, user_buffer, count)) {

i.e. count must == dev->report_size, and the buf is allocated with size
dev->report_size even though copy_from_user uses "count".

-Kees

-- 
Kees Cook
Ubuntu Security Team
