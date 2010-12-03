Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab0LCXYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 18:24:20 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35029 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab0LCXYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 18:24:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Go81NTMXrlsT8Jp78vJMcEOotRGxRl80uEDs8ZRFp9I6NoteMmmnrV1ns6/kJDdFZq
         M7Mt8zqvP5UYFGybov/Rx5R2zuA39+R+L2sgWN+rMryida/ND/6DH/W18mrDfSfHKe5d
         cLJijxOnUxx923ZV4ftESi8sFoq7YNgKffYSo=
Date: Fri, 3 Dec 2010 15:16:12 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Valentine Barshak <vbarshak@mvista.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: USBHID: Fix race between disconnect and hiddev_ioctl
Message-ID: <20101203231611.GB22969@core.coreip.homeip.net>
References: <20101203172746.GA31045@mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101203172746.GA31045@mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 08:27:46PM +0300, Valentine Barshak wrote:
> A USB HID device can be disconnected at any time.
> If this happens right before or while hiddev_ioctl is in progress,
> the hiddev_ioctl tries to access invalid hiddev->hid pointer.
> When the hid device is disconnected, the hiddev_disconnect()
> ends up with a call to hid_device_release() which frees
> hid_device, but doesn't set the hiddev->hid pointer to NULL.
> If the deallocated memory region has been re-used by the kernel,
> this can cause a crash or memory corruption.
> 
> Since disconnect can happen at any time, we can't initialize
> struct hid_device *hid = hiddev->hid at the beginning of ioctl
> and then use it.
> 
> This change checks hiddev->exist flag while holding
> the existancelock and uses hid_device only if it exists.

Why didn't you take the lock and check hiddev->exist at the beginning of
ioctl handler instead of pushing it down into individual command
handlers? I guess it would slow down HIDIOCGVERSION but I think we could
pay this price for code that is more clear ;)

-- 
Dmitry
