Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab2CMTh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 15:37:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42987 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448Ab2CMTh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 15:37:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when helper is not yet available
Date: Tue, 13 Mar 2012 20:42:07 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <20120309233659.GA21256@kroah.com> <CAPXgP10oHRnPo7Es1RX8GM68dH13E0rzcFhXzOYFPcmKs=yh1A@mail.gmail.com>
In-Reply-To: <CAPXgP10oHRnPo7Es1RX8GM68dH13E0rzcFhXzOYFPcmKs=yh1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203132042.07794.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, March 11, 2012, Kay Sievers wrote:
> On Sat, Mar 10, 2012 at 00:36, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Fri, Mar 09, 2012 at 11:30:24PM +0100, Christian Lamparter wrote:
> >> This patch fixes a regression which was introduced by:
> >> "PM: Print a warning if firmware is requested when tasks are frozen"
> >>
> >> request_firmware_nowait does not stall in any system resume paths.
> >> Therefore, I think it is perfectly save to use request_firmware_nowait
> >> from at least the ->complete() callback.
> >
> > Is there code somewhere in the kernel that wants to do this?  Has commit
> > a144c6a broken it somehow that this fix would resolve it?
> >
> >>
> >> Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
> >> ---
> >>  drivers/base/firmware_class.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> >> index 6c9387d..017e020 100644
> >> --- a/drivers/base/firmware_class.c
> >> +++ b/drivers/base/firmware_class.c
> >> @@ -535,7 +535,7 @@ static int _request_firmware(const struct firmware **firmware_p,
> >>
> >>       read_lock_usermodehelper();
> >>
> >> -     if (WARN_ON(usermodehelper_is_disabled())) {
> >> +     if (WARN_ON(usermodehelper_is_disabled() && !(nowait && uevent))) {
> >
> > What does uevent have to do with things here?
> 
> I don't think that the firmware loader should care about the
> usermodehelper at all, and that stuff fiddling should just be removed
> from the firmware class.

It's there to warn people that their drivers do stupid things like
loading frimware during system resume, which is guaranteed not to work.

IOW, it's there very much on purpose.

> Forking /sbin/hotplug is disabled by default, it is a broken concept,
> and it cannot work reliably on today's systems.
> 
> Firmware is not loaded by /sbin/hotplug since many years, but by udev
> or whatever service handles uevents, like ueventd on android.

Which I'm not sure why is relevant here.

Thanks,
Rafael
