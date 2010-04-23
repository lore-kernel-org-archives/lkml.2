Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab0DWPFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:05:53 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:36446 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450Ab0DWPFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:05:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hepbVxpeBMCW6HSvt2f5dd47DnHCOYuhe7qwaMVWhbymOWrnICbokmoFMy9rut6yHO
         AMBKfV+i8I/gSAzv89iKv41HW86fcWRdV44RNjAgUgiq3RsAdfo6V7GIajWSsNKAP3vo
         JYN9dkJW9+MEkb/u/84bRSDhpeG5D9fCwJL+8=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1004231020300.1777-100000@iolanthe.rowland.org>
References: <1272025288-32555-2-git-send-email-fabien.chouteau@gmail.com>
	 <Pine.LNX.4.44L0.1004231020300.1777-100000@iolanthe.rowland.org>
Date: Fri, 23 Apr 2010 17:05:49 +0200
Message-ID: <g2lfb5cec441004230805m8fc1251ekeb936837349b6e16@mail.gmail.com>
Subject: Re: [PATCH RESEND 2/2] Mass storage gadget: Handle eject request
From: Chouteau Fabien <fabien.chouteau@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Michal Nazarewicz <m.nazarewicz@samsung.com>,
       Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 4:23 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
>
> On Fri, 23 Apr 2010 fabien.chouteau@gmail.com wrote:
>
> > From: Fabien Chouteau <fabien.chouteau@barco.com>
> >
> > This patch adds handling of the "Start/Stop Unit" SCSI request to simulate media
> > ejection. A sysfs entry to get the "eject" state of a LUN is also added.
>
> Sorry I didn't notice this earlier...
>
> > --- a/drivers/usb/gadget/f_mass_storage.c
> > +++ b/drivers/usb/gadget/f_mass_storage.c
> > @@ -163,6 +163,13 @@
> >   * ro setting are not allowed when the medium is loaded or if CD-ROM
> >   * emulation is being used.
> >   *
> > + * When a LUN receive an "eject" SCSI request (Start/Stop Unit),
> > + * if the LUN is removable, the backing file is released to simulate
> > + * ejection.
> > + * The "eject" state of a LUN is available in the "ejected" file of the
> > + * LUN's sysfs directory (see above). The "eject" state is only updated
> > + * by SCSI request, not by user ejection.
>
> What's the reason for that?  With a real removable device, like a CD
> player, it doesn't make any difference whether the medium was ejected
> because of a SCSI command or because I pressed the "eject" button.
>
> I just don't see any point in keeping track of the two actions
> separately, since they end up having the same final result.
>

By user ejection, I mean send an empty line in the "file" sysfs entry.
The Start/Stop request is an action from the USB host side, user
ejection is from the USB device side, for me it's two different
events.
Maybe my comment is not clear about this point.

I use a FAT disk image as LUN file, users can put some files in the
"fake" disk and then eject it. When I get the ejected signal, I mount
the disk image on loop device and perform operations on the user's
files.
So I want to know when users eject the disk and only when users do.

I still can use the LUN ejection from device side to disable the mass
storage device, and in this case I don't want to mount the disk and
search for user's files.

--
Fabien Chouteau
EPITA GISTR 2010
