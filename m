Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab1HKINi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 04:13:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab1HKINZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 04:13:25 -0400
Message-ID: <4E438F69.4030902@redhat.com>
Date: Thu, 11 Aug 2011 10:14:33 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Theodore Kilgore <kilgota@banach.math.auburn.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>, Greg KH <greg@kroah.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, libusb-devel@lists.sourceforge.net,
        Alexander Graf <agraf@suse.de>, Gerd Hoffmann <kraxel@redhat.com>,
        hector@marcansoft.com, Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, pbonzini@redhat.com,
        Anthony Liguori <aliguori@us.ibm.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>,
        Oliver Neukum <oliver@neukum.org>, Felipe Balbi <balbi@ti.com>,
        Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Adam Baker <linux@baker-net.org.uk>
Subject: Re: USB mini-summit at LinuxCon Vancouver
References: <Pine.LNX.4.44L0.1108101156350.1917-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1108101156350.1917-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/10/2011 06:09 PM, Alan Stern wrote:
> On Wed, 10 Aug 2011, Theodore Kilgore wrote:
>
>>> Okay, I didn't realize that the different cameras used different webcam
>>> drivers as well as different stillcam drivers.
>>
>> Oh, yes. They are Proprietary devices. And that means what it says. :-)
>> And all different from each other, too.
>>
>>> As far as I can see, there's nothing to stop anybody from adding the
>>> stillcam functionality into the webcam drivers right now.  If some
>>> common code can be abstracted out into a shared source file, so much
>>> the better.
>>>
>>> That would solve the problem, right?
>>
>> I think everyone involved believes that it would solve the problem.
>>
>> The question has been all along whether or not there is any other way
>> which would work. Also the question of what, exactly, "belongs" in the
>> kernel and what does not. For, if something has been historically
>> supported in userspace (stillcam support, in this case) and has worked
>> well there, I would think it is kind of too bad to have to move said
>> support into the kernel just because the same hardware requires kernel
>> support for another functionality and the two sides clash. I mean, the
>> kernel is already big enough, no? But the logic that Hans has set forth
>> seems rather compelling.
>
> The alternative seems to be to define a device-sharing protocol for USB
> drivers.  Kernel drivers would implement a new callback (asking them to
> give up control of the device), and usbfs would implement new ioctls by
> which a program could ask for and relinquish control of a device.  The
> amount of rewriting needed would be relatively small.
>
> A few loose ends would remain, such as how to handle suspends, resumes,
> resets, and disconnects.  Assuming usbfs is the only driver that will
> want to share a device in this way, we could handle them.
>
> Hans, what do you think?
>

First of all thanks for the constructive input!

When you say: "device-sharing protocol", do you mean 2 drivers been
attached, but only 1 being active. Or just some additional glue to make
hand-over between them work better?

I've 2 concerns with this approach:
1) Assuming we are going for the just make hand over work better solution
we will still have the whole disappear / reappear act of the /dev/video#
node, which I don't like at all.

If for example skype gets started it will say the user has no camera. If it
were to say the device is busy, the user just might make a link to some
application using the device in stillcam mode still being open.

2) The whole notion of the device being in use is rather vague when it comes
to the userspace parts of this. Simply leaving say F-Spot running, or having
a gvfs libgphoto share mounted, should not lead to not being able to use the
device in webcam mode. But currently it will.

Fixing all users of libgphoto2 wrt this is unlikely to happen, and even if
we do that now, more broken ones will likely come along later. I estimate
98% of all cameras are not dual mode cameras, so the average stillcam
application developer will not test for this.

That leaves us with fixing the busy notion inside libgphoto2, iow, release
the device as soon as an operation has completed. This will be quite slow,
since both drivers don't know anything about each other, they will just
know there is some $random_other_driver. So they need to assume the
device state is unclean and re-init the device from scratch each time.

Where as if we have both functions in one driver, that can remember the
actual device state and only make changes if needed, so downloading +
deleting 10 photos will lead to setting it to stillcam mode once, rather
then 20 times.

Regards,

Hans
