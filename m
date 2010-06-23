Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208Ab0FWFhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 01:37:11 -0400
Received: from amavis-smtp.knology.net ([75.76.199.6]:49637 "EHLO
	amavis-smtp.knology.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809Ab0FWFhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 01:37:09 -0400
Subject: Re: PROBLEM: SIS7019 stops recording after 42 min
From: David Dillow <dave@thedillows.org>
To: linux@schou.dk
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
In-Reply-To: <1277262047.10818.9.camel@obelisk.thedillows.org>
References: <AANLkTimO5PXmJiIPDw82MTA53mLSl-OC0e1SOEh7v8pH@mail.gmail.com>
	 <1276972298.22889.16.camel@obelisk.thedillows.org>
	 <AANLkTimwZFNLBNJWODyzKXwx9CbIorg3OCA53XZchkeN@mail.gmail.com>
	 <1277043970.22889.45.camel@obelisk.thedillows.org>
	 <AANLkTikBTMq3d-Ov65wYLJ_Vw-7Jde4AOwfXcEPB0wLr@mail.gmail.com>
	 <1277129180.22889.64.camel@obelisk.thedillows.org>
	 <AANLkTikW71h7ABVXY21pLL9AeOlmRTfVaSTjJ_6Ma0_R@mail.gmail.com>
	 <AANLkTikCGzUKe9Fy1d0xhberqGFe71lvrQbg5gkQzgf1@mail.gmail.com>
	 <AANLkTikPW9j4H15gq7nl0Tb213R15uIQAnSDi_cTOJre@mail.gmail.com>
	 <1277262047.10818.9.camel@obelisk.thedillows.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Jun 2010 01:36:59 -0400
Message-ID: <1277271419.10818.22.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-8.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-22 at 23:00 -0400, David Dillow wrote:
> On Mon, 2010-06-21 at 22:10 +0200, Hans Schou wrote:
> > 2010/6/21 Hans Schou <linux@schou.dk>:
> > 
> > > I have just started:
> > >  arecord -B 1000000 -F 500000 -c 1 -r 44100 -f S16 -M -D hw:0,0 -v arec.wav
> > 
> > It gave a file size of 258822944 bytes. Almost 50 min:
> >   echo "258822944/(2*60*44100)" | bc -ql
> > 48.90
> > 
> > This is the longest recording I have made on this hardware.
> > 
> > I have this running now:
> > + arecord -B 200000 -F 100000 -c 1 -r 44100 -f S16 -M -D hw:0,0 -v arec.wav
> 
> Ok, it seems something is definately funky with the driver in general,
> and gets worse when we're using more than 2 periods per buffer.

The driver's funkiness may be limited to the more than 2 periods per
buffer/10 second pause issue.

> I don't have any overruns, nor does it go into the 10-second pause mode.
> I do see an odd alternating pattern of one period taking 1.4ms to
> capture, and the next taking 732ms. The period should be about 371ms, so
> the lumpyness of the timing is likely making it easier to hit overruns.

I can reproduce the alternating pattern of periods using a different
device, so this may be something in the core code of ALSA.

Hardware PCM card 0 'HDA Intel' device 0 subdevice 0
Its setup is:
  stream       : CAPTURE
  access       : RW_INTERLEAVED
  format       : S16_LE
  subformat    : STD
  channels     : 2
  rate         : 44100
  exact rate   : 44100 (44100/1)
  msbits       : 16
  buffer_size  : 32768
  period_size  : 16384
  period_time  : 371519
  tstamp_mode  : NONE
  period_step  : 1
  avail_min    : 16384
  period_event : 0
  start_threshold  : 1
  stop_threshold   : 32768
  silence_threshold: 0
  silence_size : 0
  boundary     : 4611686018427387904
  appl_ptr     : 0
  hw_ptr       : 0

strace -T gives:
ioctl(4, 0x80184151, 0x7fff532cff70) = 0 <0.371672>
write(1, ..., 65536) = 65536 <0.000035>
ioctl(4, 0x80184151, 0x7fff532cff70) = 0 <0.742746>
write(1, ..., 65536) = 65536 <0.000013>
ioctl(4, 0x80184151, 0x7fff532cff70) = 0 <0.000027>
write(1, ..., 65536) = 65536 <0.000016>
ioctl(4, 0x80184151, 0x7fff532cff70) = 0 <0.742694>
write(1, ..., 65536) = 65536 <0.000011>
ioctl(4, 0x80184151, 0x7fff532cff70) = 0 <0.000038>
write(1, ..., 65536) = 65536 <0.000024>
ioctl(4, 0x80184151, 0x7fff532cff70) = 0 <0.742600>

The first period gets clocked out close to the expected time --
371.672ms actual vs 371.519 ms expected -- but then we're either running
almost a full buffer -- 742.746ms actual vs 743.038ms buffer -- or very,
very short at 0.027ms.

Since this problem is not related to the SiS7019 driver, I'll leave it
to later -- or for others to investigate. Using three periods per buffer
sees a similar pattern, but one has an extra period time to work
within. 

Dave







