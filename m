Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755419Ab1HEIRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 04:17:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab1HEIRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 04:17:09 -0400
Message-ID: <4E3BA739.20101@redhat.com>
Date: Fri, 05 Aug 2011 10:18:01 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Greg KH <greg@kroah.com>, Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        libusb-devel@lists.sourceforge.net, Alexander Graf <agraf@suse.de>,
        Gerd Hoffmann <kraxel@redhat.com>, hector@marcansoft.com,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouveroliver
References: <20110610002103.GA7169@xanatos> <20110804225603.GA2557@kroah.com> <4E3B9FB4.30709@redhat.com> <201108050959.00873.oliver@neukum.org>
In-Reply-To: <201108050959.00873.oliver@neukum.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/05/2011 09:59 AM, Oliver Neukum wrote:
> Am Freitag, 5. August 2011, 09:45:56 schrieb Hans de Goede:
>> This is the issue on which I feel a bit stonewalled. Simple putting your
>> fingers in your ears and singing la la la do it in userspace is not going
>> to cut it here. There is no way to do this race free in userspace, unless
>> all possible callers of mount get modified. Moreover 99% of the necessary
>> accounting for this is already done in the kernel. We already have the notion
>> of a block device being in use. We simply need to add some code to pass
>> this notion to the usb mass storage driver, and add a new try_disconnect
>> callback for usb drivers. I'm not saying this is going to be completely
>> straight forward, but it ain't rocket science either. And it so very
>> obviously is the right thing to do, that I'm getting very tired of
>> the do it in userspace song I keep hearing.
>
> Doing a try_disconnect() would also solve the dual camera issue.
> But it doesn't really interfere with the user space vs. kernel space
> issue. You simply have to expand the ioctl interface to have
> an ioctl that triggers this API call in the kernel.
>
> A V4L2 device would return an error if its device node is opened,
> otherwise disconnect.

Getting a bit offtopic here, but no a try_disconnect will fix the
userspace stillcam mode driver being able to disconnect the device
while the webcam function is active. If the webcam is not active
userspace will still "win", and possibly never return the device
back to the kernel driver (this already happens today with
gvfs-gphoto creating a fuse mount and keeping the device open
indefinitely, locking out the webcam function).

Likewise a v4l2 control panel like app (think alsamixer for
videodevs to set brightness / contrast, etc.) can keep the /dev/video
node open indefinitely. Unless we rewrite most of userspace, we need
to allow the device to be open in bode modes *at the same time* and
only fail with -EBUSY when something really exclusive is requested
(so not just having the device open, or setting contrast, but
trying to stream and read/delete pictures from the stillcam
memory at the same time).

Regards,

Hans
