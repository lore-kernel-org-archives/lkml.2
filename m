Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab0CXNKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 09:10:32 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:34549 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756157Ab0CXNKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 09:10:30 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [rt2x00-users] [PATCH RFC] rt2500usb: disable broken =?iso-8859-1?q?HW=09encryption_by?= default
Date: Wed, 24 Mar 2010 14:10:22 +0100
User-Agent: KMail/1.9.10
Cc: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
       Ivo Van Doorn <ivdoorn@gmail.com>, linux-kernel@vger.kernel.org
References: <201003221601.36559.linux@rainbow-software.org> <201003231609.57505.linux@rainbow-software.org> <4BA8E11A.2020300@gmail.com>
In-Reply-To: <4BA8E11A.2020300@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003241410.23554.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 March 2010, Gertjan van Wingerde wrote:
> On 03/23/10 16:09, Ondrej Zary wrote:
> > On Tuesday 23 March 2010, Ivo Van Doorn wrote:
> >> On Tue, Mar 23, 2010 at 10:27 AM, Ondrej Zary
> >>
> >> <linux@rainbow-software.org> wrote:
> >>> On Monday 22 March 2010, Ivo Van Doorn wrote:
> >>>>>> But I though it was mentioned that disabling HW crypto didn't solve
> >>>>>> the issue due to a second bug in a later kernel?
> >>>>>
> >>>>> That was a false positive. Probably because the device was not
> >>>>> unplugged between the tests (and looks like the driver does not
> >>>>> initialize the chip completely). It's not reliable, it sometimes
> >>>>> stops working after reboot.
> >>>>
> >>>> Ah well that at least simplifies the problem. I'll have to retest
> >>>> rt2500usb soon to see why the HW crypto failed. I am sure I had it
> >>>> working for WEP, WPA and WPA2
> >>>> before I submitted the patch.
> >>>
> >>> So let's try to fix it instead of disabling.
> >>>
> >>> First, the unrealiability (keeping HW encryption disabled). With the
> >>> driver loaded but not doing anything more, the register dumps are same
> >>> for both working and non-working case (dump-init.txt).
> >>>
> >>> dump-good-connected.txt is a dump after successful association and DHCP
> >>> dump-bad-attempt.txt is a dump after successful association during
> >>> non-working DHCP attempt
> >>> dump-bad-after.txt is a dump after DHCP timed out
> >>
> >> With association working, but DHCP failing it most likely means that
> >> somehow the frame was malformatted.
> >> The code for HW crypto alters the frame (alters IV/EIV/ICV data etc).
> >> And that is commonly the source of
> >> problems, because what has to be done depends heavily on the encryption
> >> type.
> >>
> >> So could you verify which of the encryption types (WEP,WPA,WPA2) is
> >> failing or working? That would give a starting
> >> position on which bytes might be corrupted.
> >
> > I was testing only with WPA2 before. I did some more testing today. The
> > results:
> >
> > No encryption - works always
> > WEP - sometimes works, sometimes not - same with and without HW
> > encryption WPA - sometimes works, sometimes not - same with and without
> > HW encryption WPA2 - never works with HW encryption
> >      - sometimes works, sometimes not without HW encryptionn
> >
> > So it seems that there are two problems:
> >  1. random problems with any encryption
> >  2. WPA2 is broken with HW encryption
> >
> > When the "random" problem appears, this appears in dmesg:
> > wlan1: authenticate with 00:13:d4:0f:f3:17 (try 1)
> > wlan1: authenticated
> > wlan1: associate with 00:13:d4:0f:f3:17 (try 1)
> > wlan1: RX AssocResp from 00:13:d4:0f:f3:17 (capab=0x411 status=0 aid=2)
> > wlan1: associated
> > phy0 -> rt2500usb_set_device_state: Error - Device failed to enter state
> > 3 (-16). phy0 -> rt2500usb_set_device_state: Error - Device failed to
> > enter state 3 (-16). No probe response from AP 00:13:d4:0f:f3:17 after
> > 500ms, disconnecting.
> >
> > Disabling call to rt2500usb_set_state() in rt2500usb_set_device_state()
> > seems to fix problem 1. After this change, WEP and WPA work always
> > regardless of HW encryption (and WPA2 works always without it).
>
> For this last issue, could you check with powersaving disabled. Just
> execute iwconfig wlan1 power off before associating.

Yes, you're right - executing "iwconfig wlan1 power off" before "ifup wlan1"
causes it to work always. Also when I don't execute it before ifup and it
fails, executing it fixes the problem.

> The powersaving code looks a bit odd here, and we've had issues with this
> in the other rt2x00 drivers as well.

Added some debugging code. 
Working case:
Mar 24 13:43:05 kiosk kernel: set_state=3
Mar 24 13:43:05 kiosk kernel: state=3, bbp_state=0, rf_state=0
Mar 24 13:43:05 kiosk kernel: state=3, bbp_state=1, rf_state=1
Mar 24 13:43:05 kiosk kernel: state=3, bbp_state=3, rf_state=3
Mar 24 13:43:05 kiosk kernel: set_state ok
Mar 24 13:43:05 kiosk kernel: set_state=3
Mar 24 13:43:05 kiosk kernel: state=3, bbp_state=3, rf_state=3
Mar 24 13:43:05 kiosk kernel: set_state ok
Mar 24 13:43:06 kiosk kernel: wlan1: deauthenticating from 00:13:d4:0f:f3:17 by local choice (reason=3)
Mar 24 13:43:06 kiosk kernel: wlan1: authenticate with 00:13:d4:0f:f3:17 (try 1)
Mar 24 13:43:06 kiosk kernel: wlan1: authenticated
Mar 24 13:43:06 kiosk kernel: wlan1: associate with 00:13:d4:0f:f3:17 (try 1)
Mar 24 13:43:06 kiosk kernel: wlan1: RX AssocResp from 00:13:d4:0f:f3:17 (capab=0x411 status=0 aid=1)
Mar 24 13:43:06 kiosk kernel: wlan1: associated
Mar 24 13:43:07 kiosk kernel: set_state=1
Mar 24 13:43:07 kiosk kernel: state=1, bbp_state=1, rf_state=1
Mar 24 13:43:07 kiosk kernel: set_state ok

Non-working case:
Mar 24 13:43:09 kiosk kernel: set_state=3
Mar 24 13:43:09 kiosk kernel: state=3, bbp_state=1, rf_state=1
Mar 24 13:43:09 kiosk kernel: state=3, bbp_state=1, rf_state=1
Mar 24 13:43:09 kiosk kernel: state=3, bbp_state=1, rf_state=1
Mar 24 13:43:09 kiosk kernel: state=3, bbp_state=1, rf_state=1
Mar 24 13:43:09 kiosk kernel: state=3, bbp_state=1, rf_state=1
Mar 24 13:43:09 kiosk kernel: set_state failed
Mar 24 13:43:09 kiosk kernel: phy1 -> rt2500usb_set_device_state: Error - Device failed to enter state 3 (-16).
Mar 24 13:43:12 kiosk kernel: No probe response from AP 00:13:d4:0f:f3:17 after 500ms, disconnecting.

Seems that the bpp_state and rf_state are stuck. Waiting longer (tried 10*REGISTER_BUSY_COUNT) does not help.

-- 
Ondrej Zary
