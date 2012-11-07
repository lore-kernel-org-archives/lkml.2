Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab2KGRep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 12:34:45 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59582 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752685Ab2KGReo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 12:34:44 -0500
Date: Wed, 7 Nov 2012 12:34:43 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Christof Meerwald <cmeerw@cmeerw.org>, Takashi Iwai <tiwai@suse.de>
cc: Daniel Mack <zonque@gmail.com>, "Artem S. Tashkinov" <t.artem@lycos.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: A reliable kernel panic (3.6.2) and system crash when visiting
 a particular website
In-Reply-To: <20121105191336.GA1404@edge.cmeerw.net>
Message-ID: <Pine.LNX.4.44L0.1211071220230.1175-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2012, Christof Meerwald wrote:

> BTW, I have been able to reproduce the problem on a completely
> different machine (also running Ubuntu 12.10, but different hardware).
> The important thing appears to be that the USB audio device is
> connected via a USB 2.0 hub (and then using the test code posted in
> http://pastebin.com/aHGe1S1X specifying the audio device as
> "plughw:Set" (or whatever it's called) seems to trigger the freeze).

Christof: Thank you for that reference, it was a big help.  After
crashing my system many times I have tracked the problem, at least in
part.  The patch below should prevent your system from freezing.


Takashi: It turns out the the problem is triggered when the audio
subsystem calls snd_usb_endpoint_stop() with wait == 0 and then calls
snd_usb_endpoint_start().  Since the driver doesn't wait for the
outstanding URBs to finish, it tries to submit them again while they
are still active.

Normally the USB core would realize this and fail the submission, but a
bug in ehci-hcd prevented this from happening.  (That bug is what the
patch below fixes.)  The URB gets added to the active list twice,
resulting in list corruption and an oops in interrupt context, which
freezes the system.

The user program that triggers the problem basically looks like this:

  snd_pcm_prepare(rec_pcm);
  snd_pcm_start(rec_pcm);
  snd_pcm_drop(rec_pcm);

  snd_pcm_prepare(rec_pcm);
  snd_pcm_start(rec_pcm);

The snd_pcm_drop call unlinks the URBs but does not wait for them to
finish.  Then the second snd_pcm_start call submits the URBs before
they have finished.

What is the right solution for this problem?

Alan Stern



Index: usb-3.7/drivers/usb/host/ehci-sched.c
===================================================================
--- usb-3.7.orig/drivers/usb/host/ehci-sched.c
+++ usb-3.7/drivers/usb/host/ehci-sched.c
@@ -1632,7 +1632,7 @@ static void itd_link_urb(
 
 	/* don't need that schedule data any more */
 	iso_sched_free (stream, iso_sched);
-	urb->hcpriv = NULL;
+	urb->hcpriv = stream;
 
 	++ehci->isoc_count;
 	enable_periodic(ehci);
@@ -2031,7 +2031,7 @@ static void sitd_link_urb(
 
 	/* don't need that schedule data any more */
 	iso_sched_free (stream, sched);
-	urb->hcpriv = NULL;
+	urb->hcpriv = stream;
 
 	++ehci->isoc_count;
 	enable_periodic(ehci);

