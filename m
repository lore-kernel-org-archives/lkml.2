Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab2GVM6u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 08:58:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60427 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394Ab2GVM6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 08:58:47 -0400
Date: Sun, 22 Jul 2012 14:58:43 +0200
From: Borislav Petkov <bp@alien8.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] firmware load: defer request_firmware during early boot
 and resume
Message-ID: <20120722125843.GC18939@liondog.tnic>
Reply-To: Borislav Petkov <borislav.petkov@amd.com>
Mail-Followup-To: Borislav Petkov <borislav.petkov@amd.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ming Lei <tom.leiming@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-usb <linux-usb@vger.kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
References: <CACVXFVNWOcrR9tYhU1wVUSJ_DJ8x+SCk993Sn9dYDe2kzJBDuQ@mail.gmail.com>
 <CA+55aFwZRvtpE2e3zNqvtobpPROqw_bOwNt+=DBzmScV0_rq=w@mail.gmail.com>
 <CACVXFVPupumYqeBwTwgK3C04VQBxOjkFMbaKQ-Gsz3teCWqQ=w@mail.gmail.com>
 <CA+55aFwte5bc-4FC758pBN3FbrtKQfwm_Mv_banekhL=kSF8kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFwte5bc-4FC758pBN3FbrtKQfwm_Mv_banekhL=kSF8kg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 21, 2012 at 01:38:52PM -0700, Linus Torvalds wrote:
> > Looks it is not difficult to cache firmware data by kernel, for example, just
> > call the
> >
> >            cache_firmware(fw_name)
> >
> > for each device which need firmware before suspending,
> > then call the below to uncache firmware after resume:
> >
> >            uncache_firmware(fw_name)
> 
> Exactly. But we should make it automatic, and we should only do it if
> the device is actually *active*. If nobody is using the device over
> the suspend-resume event, the firmware shouldn't be loaded in the
> first place, and resume obviously shouldn't need to re-load it.
> Wouldn't it be nice if something like the PCI layer (or the USB layer)
> just knew to do the rigth thing for the device on its own?
> 
> I would also suggest that the firmware caching have some internal
> timeout, so that for the (fairly common) case where a suspend/resume
> event might look like a unplug/replug event, the caching would
> actually still remember the firmware despite the fact that it looked
> (for a short while) like the device went away.
> 
> So *this* is where I think we could improve on the generic code. Make
> it really easy for devices to do the right thing. Make sure that
> firmware caches work, even if it looks like devices disappeared
> momentarily. Maybe add a few callbacks from generic code to say "you
> can load your firmware now, because the system is up".

Question: is there any other reason

  [besides maybe embedded people who care about each single Kb of memory
   on the system]

why we don't make this cache/uncache firmware thing *implicit*? That is,
load it once at driver open time and keep it in memory during the whole
driver's lifetime. And this all taken care of by the driver core, btw.

This way you have the const void *firmware always there and can
apply it whenever you feel like it, you obviate all the problems of
request_firmware and it needing userspace and simpify the whole firmware
handling and delays stuff immensely.

You'd only waste just a couple of Kbs per system but what does memory
cost nowadays...

Oh, we'd probably need to be able to jettison the old firmware and
update to a new one but this can be done at convenient moments when the
system is up and we have userspace to do so.

Hmm...

-- 
Regards/Gruss,
    Boris.
