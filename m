Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1LNJNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 04:13:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45091 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab1LNJNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 04:13:04 -0500
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Daniel Kurtz <djkurtz@chromium.org>
Subject: Re: [PATCH 2/3] HID: usbhid: hid-core: submit queued urbs before suspend
Date: Wed, 14 Dec 2011 10:14:33 +0100
User-Agent: KMail/1.13.5 (Linux/3.2.0-rc4-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: jkosina@suse.cz, bleung@chromium.org, stern@rowland.harvard.edu,
        olofj@chromium.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <1321529030-7845-1-git-send-email-djkurtz@chromium.org> <201112140855.40050.oneukum@suse.de> <CAGS+omDMipRTVOGV9fG0ciWpuwMRBL-eTY8uDwaiSOW==CkQ-w@mail.gmail.com>
In-Reply-To: <CAGS+omDMipRTVOGV9fG0ciWpuwMRBL-eTY8uDwaiSOW==CkQ-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112141014.33696.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 14. Dezember 2011, 09:00:18 schrieb Daniel Kurtz:
> On Wed, Dec 14, 2011 at 3:55 PM, Oliver Neukum <oneukum@suse.de> wrote:
> > Am Donnerstag, 17. November 2011, 12:23:49 schrieb Daniel Kurtz:
> >> Unfortunately, this usually happens while the first LED request is
> >> actually still being processed.  Thus when the completion handler tries
> >> to submit the second LED request it fails, since REPORTED_IDLE is
> >> already set!  This REPORTED_IDLE check failure causes the completion
> >> handler to complete, however without clearing the CTRL_RUNNING flag.
> >> This, in turn, means that the suspend() handler's wait_io() condition
> >> is never satisfied, and instead it times out after 10 seconds, aborting
> >> the original system suspend.
> >>
> >> This patch changes the behavior to the following:
> >>   (1) allow completion handler to finish submitting all queued URBs, even if
> >>       REPORTED_IDLE is set.  This guarantees that all URBs queued before the
> >>       hid-core suspend() call will be submitted before the system is
> >>       suspended.
> >
> > Hi,
> >
> > why is this desirable? You'd want to requests to be executed at resumption.
> > A system suspend will alter the LED state anyway.
> 
> This is how a system suspend 'alters' the LED state.  The input layer
> sends those LED off commands down through HID as it is trying to
> suspend.  We want to make sure the usbhid layer actually finishes
> forwarding those requests on to the device before the system is
> suspended.

You know the HID layer will send those commands. You don't know which
other commands may already be queued. So I don't know whether you really want
to execute them all while the system is asuspending.

	Regards
		Oliver
