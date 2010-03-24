Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab0CXOwl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 10:52:41 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:33707 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756278Ab0CXOwk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 10:52:40 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Subject: Re: [rt2x00-users] [PATCH RFC] rt2500usb: disable broken HW  encryption by default
Date: Wed, 24 Mar 2010 15:52:29 +0100
User-Agent: KMail/1.9.10
Cc: rt2x00 Users List <users@rt2x00.serialmonkey.com>,
       linux-kernel@vger.kernel.org
References: <201003221601.36559.linux@rainbow-software.org> <201003241412.38128.linux@rainbow-software.org> <a32f33a41003240624u204cfd71jbf2effbd09ff220a@mail.gmail.com>
In-Reply-To: <a32f33a41003240624u204cfd71jbf2effbd09ff220a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201003241552.32184.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 March 2010, Ivo Van Doorn wrote:
> On Wed, Mar 24, 2010 at 2:12 PM, Ondrej Zary <linux@rainbow-software.org> 
wrote:
> > On Tuesday 23 March 2010, Ivo Van Doorn wrote:
> >> On Tue, Mar 23, 2010 at 4:09 PM, Ondrej Zary
> >> <linux@rainbow-software.org>
> >
> > wrote:
> >> > On Tuesday 23 March 2010, Ivo Van Doorn wrote:
> >> >> On Tue, Mar 23, 2010 at 10:27 AM, Ondrej Zary
> >> >>
> >> >> <linux@rainbow-software.org> wrote:
> >> >> > On Monday 22 March 2010, Ivo Van Doorn wrote:
> >> >> >> >> But I though it was mentioned that disabling HW crypto didn't
> >> >> >> >> solve the issue due to a second bug in a later kernel?
> >> >> >> >
> >> >> >> > That was a false positive. Probably because the device was not
> >> >> >> > unplugged between the tests (and looks like the driver does not
> >> >> >> > initialize the chip completely). It's not reliable, it sometimes
> >> >> >> > stops working after reboot.
> >> >> >>
> >> >> >> Ah well that at least simplifies the problem. I'll have to retest
> >> >> >> rt2500usb soon to see why the HW crypto failed. I am sure I had it
> >> >> >> working for WEP, WPA and WPA2
> >> >> >> before I submitted the patch.
> >> >> >
> >> >> > So let's try to fix it instead of disabling.
> >> >> >
> >> >> > First, the unrealiability (keeping HW encryption disabled). With
> >> >> > the driver loaded but not doing anything more, the register dumps
> >> >> > are same for both working and non-working case (dump-init.txt).
> >> >> >
> >> >> > dump-good-connected.txt is a dump after successful association and
> >> >> > DHCP dump-bad-attempt.txt is a dump after successful association
> >> >> > during non-working DHCP attempt
> >> >> > dump-bad-after.txt is a dump after DHCP timed out
> >> >>
> >> >> With association working, but DHCP failing it most likely means that
> >> >> somehow the frame was malformatted.
> >> >> The code for HW crypto alters the frame (alters IV/EIV/ICV data etc).
> >> >> And that is commonly the source of
> >> >> problems, because what has to be done depends heavily on the
> >> >> encryption type.
> >> >>
> >> >> So could you verify which of the encryption types (WEP,WPA,WPA2) is
> >> >> failing or working? That would give a starting
> >> >> position on which bytes might be corrupted.
> >> >
> >> > I was testing only with WPA2 before. I did some more testing today.
> >> > The results:
> >> >
> >> > No encryption - works always
> >> > WEP - sometimes works, sometimes not - same with and without HW
> >> > encryption WPA - sometimes works, sometimes not - same with and
> >> > without HW encryption WPA2 - never works with HW encryption
> >> >     - sometimes works, sometimes not without HW encryptionn
> >> >
> >> > So it seems that there are two problems:
> >> >  1. random problems with any encryption
> >> >  2. WPA2 is broken with HW encryption
> >> >
> >> > When the "random" problem appears, this appears in dmesg:
> >> > wlan1: authenticate with 00:13:d4:0f:f3:17 (try 1)
> >> > wlan1: authenticated
> >> > wlan1: associate with 00:13:d4:0f:f3:17 (try 1)
> >> > wlan1: RX AssocResp from 00:13:d4:0f:f3:17 (capab=0x411 status=0
> >> > aid=2) wlan1: associated
> >> > phy0 -> rt2500usb_set_device_state: Error - Device failed to enter
> >> > state 3 (-16). phy0 -> rt2500usb_set_device_state: Error - Device
> >> > failed to enter state 3 (-16). No probe response from AP
> >> > 00:13:d4:0f:f3:17 after 500ms, disconnecting.
> >> >
> >> > Disabling call to rt2500usb_set_state() in
> >> > rt2500usb_set_device_state() seems to fix problem 1. After this
> >> > change, WEP and WPA work always regardless of HW encryption (and WPA2
> >> > works always without it).
> >>
> >> Ok, lets focus on the HW crypto for now.
> >>
> >> If WPA2 fails, then the WPA2 specific code for IV/EIV/ICV isn't
> >> working. Most likely
> >> the device either doesn't send all data back to the driver (while the
> >> driver does expect it)
> >> or it adds additional data which the driver doesn't expect. (See
> >> rt2x00crypto.c for the frame
> >> manipulation during HW crypto).
> >>
> >> Could you check the full packet data of a DHCP request with and
> >> without HW crypto?
> >> That might give a clue about what the hardware is sending for extra
> >> data.
> >
> > How do I access the full packets? I tried using another machine with
> > "iwconfig wlan0 mode monitor" and tcpdump. It captured many packets and
> > I'm unable to identify the interesting ones.
>
> You won't get the useful stuff from monitor mode.
> You have to enable rt2x00 debugfs support, to find a framedump file in
> the rt2x00 debugfs folder.
>
> You should use the framedump tool from:
> http://kernel.org/pub/linux/kernel/people/ivd/tools/
>
> To get the frame dumps in nicely formatted lines for analysis.

Thanks, here are the dump files:
http://www.rainbow-software.org/linux_files/rt2500usb/dump-wpa2-bad.txt
http://www.rainbow-software.org/linux_files/rt2500usb/dump-wpa2-good.txt

I don't know how wifi encryption works so I don't know what to look for.

-- 
Ondrej Zary
