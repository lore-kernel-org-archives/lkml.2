Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508Ab0FWDBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 23:01:05 -0400
Received: from amavis-smtp.knology.net ([75.76.199.6]:38972 "EHLO
	amavis-smtp.knology.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab0FWDBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 23:01:01 -0400
Subject: Re: PROBLEM: SIS7019 stops recording after 42 min
From: David Dillow <dave@thedillows.org>
To: linux@schou.dk
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
In-Reply-To: <AANLkTikPW9j4H15gq7nl0Tb213R15uIQAnSDi_cTOJre@mail.gmail.com>
References: <AANLkTimO5PXmJiIPDw82MTA53mLSl-OC0e1SOEh7v8pH@mail.gmail.com>
	 <1276972298.22889.16.camel@obelisk.thedillows.org>
	 <AANLkTimwZFNLBNJWODyzKXwx9CbIorg3OCA53XZchkeN@mail.gmail.com>
	 <1277043970.22889.45.camel@obelisk.thedillows.org>
	 <AANLkTikBTMq3d-Ov65wYLJ_Vw-7Jde4AOwfXcEPB0wLr@mail.gmail.com>
	 <1277129180.22889.64.camel@obelisk.thedillows.org>
	 <AANLkTikW71h7ABVXY21pLL9AeOlmRTfVaSTjJ_6Ma0_R@mail.gmail.com>
	 <AANLkTikCGzUKe9Fy1d0xhberqGFe71lvrQbg5gkQzgf1@mail.gmail.com>
	 <AANLkTikPW9j4H15gq7nl0Tb213R15uIQAnSDi_cTOJre@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 22 Jun 2010 23:00:47 -0400
Message-ID: <1277262047.10818.9.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-8.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 22:10 +0200, Hans Schou wrote:
> 2010/6/21 Hans Schou <linux@schou.dk>:
> 
> > I have just started:
> >  arecord -B 1000000 -F 500000 -c 1 -r 44100 -f S16 -M -D hw:0,0 -v arec.wav
> 
> It gave a file size of 258822944 bytes. Almost 50 min:
>   echo "258822944/(2*60*44100)" | bc -ql
> 48.90
> 
> This is the longest recording I have made on this hardware.
> 
> I have this running now:
> + arecord -B 200000 -F 100000 -c 1 -r 44100 -f S16 -M -D hw:0,0 -v arec.wav

Ok, it seems something is definately funky with the driver in general,
and gets worse when we're using more than 2 periods per buffer.

If I use:

strace -tt -T -o record.log arecord -f S16 -r 44100 -c 1 -d 3600 \
	--buffer-size=32768 --period-size=16384 -v -t raw - > /dev/null

I don't have any overruns, nor does it go into the 10-second pause mode.
I do see an odd alternating pattern of one period taking 1.4ms to
capture, and the next taking 732ms. The period should be about 371ms, so
the lumpyness of the timing is likely making it easier to hit overruns.

Then, using:

strace -tt -T -o record.log arecord -f S16 -r 44100 -c 1 -d 3600 \
	--buffer-size=32768 --period-size=8192 -v -t raw - > /dev/null

I was able to push it into the 10-second pause failure mode, without
hitting any overruns. Initially it has a similar alternating pattern of
0.6ms then 363ms capture times until it drops into a 10 second pause
just after 42 minutes.

Now that I finally got my hardware going and can reproduce this, I'll
dig into it over the next few evenings.

Thanks for the report and help narrowing down the focus area,
Dave

