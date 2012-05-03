Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab2ECOfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:35:21 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51258 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab2ECOfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:35:18 -0400
Date: Thu, 3 May 2012 16:34:54 +0200
From: Anisse Astier <anisse@astier.eu>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Oleksij Rempel <bug-track@fisher-privat.net>
Cc: linux-uvc-devel@lists.sourceforge.net, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: UVCvideo:  Failed to resubmit video URB (-27) with Linux 3.3.3
Message-ID: <20120503163454.1a835d87@destiny.ordissimo>
In-Reply-To: <1682934.ZponbpoO2x@avalon>
References: <20120426200721.0c3ca642@destiny.ordissimo>
	<1682934.ZponbpoO2x@avalon>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 May 2012 14:24:11 +0200, Laurent Pinchart <laurent.pinchart@ideasonboard.com> wrote :

> Hi Anisse,
> 
> On Thursday 26 April 2012 20:07:21 Anisse Astier wrote:
> > Hi,
> > 
> > I'm experiencing a problem with uvcvideo with kernel 3.3.3 and today's
> > Linus' tree.
> > 
> > Problem not reproduced in 3.2.15, so this could be labelled as a regression.
> > 
> > See webcam lsusb and (verbose!) dmesg log in attachment, which exhibits
> > the problem.
> > 
> > We see lots of error (-18 = -EXDEV), that indicate that URB was too late
> > and then dropped, and they add up until we reach the "Failed to resubmit
> > video URB" scheduling issue.
> 
> Those are USB controller issues. The uvcvideo driver submits URBs with the 
> URB_ISO_ASAP transfer flag, so the controller should not fail to schedule 
> them.
Yes, it's weird.

So I followed Oleksij's adviced and reverted the following commit groups:
 - 66847ef [media] uvcvideo: Add UVC timestamps support, 3afedb9 [media]
   uvcvideo: Don't skip erroneous payloads and ed0ee0c [media] uvcvideo:
   Fix race-related crash in uvc_video_clock_update()
 - ab86e9e [media] uvcvideo: Allow userptr IO mode and 6998b6f [media]
   uvcvideo: Use videobuf2-vmalloc
 - 3d95e93 [media] uvcvideo: Move fields from uvc_buffer::buf to
   uvc_buffer
 - c4d99f8 [media] uvcvideo: Ignore GET_RES error for XU controls
 - 806e23e [media] uvcvideo: Fix integer overflow in uvc_ioctl_ctrl_map()
 - d0d9748 [media] uvcvideo: Use kcalloc instead of kzalloc to allocate
   array
None of this fixed the issue.

So I just decided to revert the whole uvc driver: git checkout v3.2 --
drivers/media/video/uvc.
But, the problem was still here.

I reverted the usb host code in drivers/usb/host/. Again the problem was
reproduced (both with and without 3.2's uvcvideo driver)

Then I tested the whole kernel v3.2, and indeed it still works very well.

So this problem could have it's root in USB core changes, or even a
combilation of USB and UVC changes.


> 
> > Installed libv4l version is 0.8.6.
> > I'm reproducing this with: gst-launch-0.10 --verbose v4l2src  ! xvimagesink
> > (Skype exhibits the problem too, while it isn't using gstreamer, so it
> > really seems to come from kernel. Also, doesn't happen with 3.2)
> > 
> > This is the first part of the problem. The second part is that if I
> > restart the webcam with gst-launch after the first failure, I have a
> > total freeze, just after these messages in the log (fetched with
> > netconsole, I wasn't able to get a panic trace):
> > 
> > [  191.796217] uvcvideo: Marking buffer as bad (error bit set).
> > [  191.796233] uvcvideo: Marking buffer as bad (error bit set).
> > [  191.796244] uvcvideo: Marking buffer as bad (error bit set).
> > [  191.796252] uvcvideo: Marking buffer as bad (error bit set).
> > [  191.796259] uvcvideo: Frame complete (EOF found).
> > [  191.796265] uvcvideo: EOF in empty payload.
> > [  192.972803] uvcvideo: Marking buffer as bad (error bit set).
> > [  192.972818] uvcvideo: Dropping payload (out of sync).
> > [  194.289463] uvcvideo: Marking buffer as bad (error bit set).
> > [  194.289478] uvcvideo: Frame complete (FID bit toggled).
> > [  194.289486] uvcvideo: Marking buffer as bad (error bit set).
> > [  194.289493] uvcvideo: Frame complete (FID bit toggled).
> > [  194.289499] uvcvideo: Marking buffer as bad (error bit set).
> > [  194.289505] uvcvideo: Frame complete (FID bit toggled).
> > [  194.289511] uvcvideo: Marking buffer as bad (error bit set).
> > [  194.289518] uvcvideo: Frame complete (FID bit toggled).
> > [  194.289524] uvcvideo: Marking buffer as bad (error bit set).
> > [  194.289531] uvcvideo: Frame complete (FID bit toggled).
> >
> > Last but not least, uvcvideo is un-bisectable because there were a few
> > crash-fixes during the 3.3 development cycle. I started bisecting and got
> > kernel panics.
> 
> Are the kernel panics related to uvcvideo ? There's one known bug introduced 
> between v3.2 and v3.3 and fixed (before v3.3) in commit 
> 8e57dec0454d8a3ba987d18b3ab19922c766d4bc.
I don't think that's it. As I've said, problem exists with both 3.3.3 and
Linus' 3.4-rc5.


--
Anisse
