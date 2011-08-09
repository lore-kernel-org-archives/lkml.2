Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab1HIUiO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 16:38:14 -0400
Received: from april.london.02.net ([87.194.255.143]:41405 "EHLO
	april.london.02.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1HIUiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 16:38:14 -0400
X-Greylist: delayed 408 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Aug 2011 16:38:13 EDT
From: Adam Baker <linux@baker-net.org.uk>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: USB mini-summit at LinuxCon Vancouver
Date: Tue, 9 Aug 2011 21:31:03 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38-10-generic; KDE/4.6.2; i686; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
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
        Theodore Kilgore <kilgota@banach.math.auburn.edu>
References: <Pine.LNX.4.44L0.1108091016380.1949-100000@iolanthe.rowland.org> <4E41912F.50901@redhat.com>
In-Reply-To: <4E41912F.50901@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108092131.03818.linux@baker-net.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 August 2011, Hans de Goede wrote:
> Hi,
> 
> On 08/09/2011 04:19 PM, Alan Stern wrote:

> >  Does it really make sense to combine 5 drivers into one?
> 
> Right, that is not the plan. The plan is to simply stop having 2 drivers
> for 1 logical (and physical) block. So we go from 10 drivers, 5 stillcam
> + 5 webcam, to just 5 drivers. We will also likely be able to share
> code between the code for the 2 functionalities for things like generic
> set / get register functions, initialization, etc.
> 

Unfortunately as Theodore recently pointed out you don't go from 10 to 5, you 
go from 10 to 10 where 5 of the new 10 are only used on Win32, FreeBSD and OSX 
(but they aren't any simpler because they still rely on libusb) and the other 
5 that are only used on Linux become significantly more complicated than they 
currently are.

It has also just occured to me that it might be possible to solve the issues 
we are facing just in the kernel. At the moment when the kernel performs a 
USBDEVFS_DISCONNECT it keeps the kernel driver locked out until userspace 
performs a USBDEVFS_CONNECT. If the kernel reattached the kernel driver when 
the device file was closed then, as gvfs doesn't keep the file open the 
biggest current issue would be solved instantly. If a mechanism could be found 
to prevent USBDEVFS_DISCONNECT from succeeding when the corresponding 
/dev/videox file was open then that would seem to be a reasonable solution.

Hans had expressed the opinion that merely having the device open to control 
the camera not to stream shouldn't  prevent stillcam operation - I disagree 
because if you are setting up the controls you are probably already streaming 
so you can see what you are doing and if not you are probably about to.

Of course changing the behaviour of USBDEVFS_DISCONNECT is not something to be 
done lightly. I don't know how many other users there are for it and if the 
current behaviour is actually correct for any of them. Cleaning up on file 
close does have the useful side effect though that applications no longer need 
to worry about the fact that even if they clean up properly on a normal exit, 
if they crash they leave the kernel driver permanently disabled

Regards

Adam
