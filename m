Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751992Ab1F3QTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 12:19:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57449 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750698Ab1F3QTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 12:19:46 -0400
Date: Thu, 30 Jun 2011 12:19:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: 3.0rc3-rc5: usb stops working after resume from suspend to ram
In-Reply-To: <201106301725.00791.a.miskiewicz@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1106301158310.1957-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Jun 2011, Arkadiusz Miskiewicz wrote:

> > Actually bisection might end up being quicker.  This looks like a
> > pretty tricky problem.  Maybe you should start a bisection while I look
> > at this stuff; you'll probably reach an answer before I do!
> 
> Looks tricky indeed. There seem to be two related problems actually. I'm 
> bisecting between rc3 (good) and rc5 (bad). 

These are separate problems, not related.

> At 3.0.0-rc4-00059-g143e859 usb auto-suspend suspends my mouse usb port after 
> like 4 seconds when I don't move mouse. That's not a problem. The problem is 
> that resume takes like 1-2seconds and in that time mouse cursor doesn't move 
> when I move mouse of course.

For the record, the log you posted shows that autoresuming the mouse
takes less than 60 ms.  If it seems longer, it may be that the mouse 
doesn't send a wakeup request as soon as you move it or press a 
button.

On the other hand, the log shows that the mouse does work properly
following system suspend.  Part of the problem here seems to be the
Logitech receiver; even 130 ms after the USB bus was reset, the
receiver still had not reconnected itself electrically to the bus.

With 3.0-rc4 that's okay, because the receiver is rediscovered after 
the resume and it starts working again.  With 3.5-rc5 the rediscovery 
doesn't occur, apparently because the khubd thread is hung.

> With previous kernel (rc5) the problem become worse as I described in previous 
> emails.

And now you know why, more or less -- we still have to figure out the
reason for the hang.  Probably something goes wrong when cdc-ether is
unbound from the wireless device.

> So for now I'm bisecting autosuspend issue since maybe it is some indirect 
> cause of usb-not-working-at-all in rc5 problem.

No, they are not related.  USB not working at all is a result of khubd 
being hung in rc5.

It's not even clear that autosuspend is a problem.  Doesn't 3.0-rc3
also autosuspend the mouse?  If not, have you compared the contents of
/sys/bus/usb/devices/3-1/power/control under the various kernels?

The fact is, some mice are very slow and non-responsive while waking up
from suspend.  There's not much we can do about that except to avoid
autosuspending them -- which you do by making sure the power/control
file contains "on".

Alan Stern

