Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967Ab0JVJlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 05:41:10 -0400
Received: from brent.tribalogic.net ([78.86.109.144]:40340 "EHLO
	summit.brent.tribalogic.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754639Ab0JVJlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 05:41:08 -0400
Message-ID: <4CC15C37.8060904@colin.guthr.ie>
Date: Fri, 22 Oct 2010 10:41:11 +0100
From: Colin Guthrie <gmane@colin.guthr.ie>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101020 Mandriva/3.1.5-1mdv2011.0 (2011.0) Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Jiri Slaby <jirislaby@gmail.com>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, clemens@ladisch.de,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org
Subject: Re: HDA: no sound [was: mmotm 2010-10-20-15-01 uploaded]
References: <201010202233.o9KMXNoL008303@imap1.linux-foundation.org>	<4CBFEE94.7020103@gmail.com>	<s5hlj5sc7do.wl%tiwai@suse.de>	<4CBFF25C.2080908@gmail.com>	<s5hfww0c6oj.wl%tiwai@suse.de>	<4CC085F5.9070905@gmail.com>	<s5heibjxsi4.wl%tiwai@suse.de>	<4CC092BC.9060504@gmail.com>	<s5h8w1rxrl3.wl%tiwai@suse.de>	<5220.1287692957@localhost>	<s5h39rzclx3.wl%tiwai@suse.de>	<8089.1287696264@localhost>	<s5hsjzzb5cf.wl%tiwai@suse.de>	<4CC0B3C1.9010106@gmail.com>	<4CC14F4E.4090509@colin.guthr.ie> <s5hmxq6bnwj.wl%tiwai@suse.de>
In-Reply-To: <s5hmxq6bnwj.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'Twas brillig, and Takashi Iwai at 22/10/10 10:02 did gyre and gimble:
> At Fri, 22 Oct 2010 09:46:06 +0100,
> Colin Guthrie wrote:
>> Just tested the latest kernel patch in a "proper" (i.e. patched in
>> kernel) build (as opposed to my previous out-of-tree builds).
>>
>> It's working great for me (stac9200)
>>
>> I tried without the userspace patch and things still work fine for me
>> under this setup - it's just that PAs flat volumes do not properly
>> control the Master+PCM pipeline (they both go to mute when master hits 0).
> 
> So, you mean it works without alsa-lib patch on your system?

Yeah everything still works OK, but the infamous "mute at 16%" issue is
obviously unresolved.

The difference with the kernel patch applied vs. not applied is that
alsamixer reports the device volume as "mute" when Master is at 0 with
the patch and it reports it as -46.5dB without the patch.

> The symptom was somehow related with the suspend or initialization.
> In the early post (sorry, this wasn't cited in the mail you added to
> Cc), Jiri mentioned:
> 
>   BUT, when I run pulse and it suspends the device (or whatever), all
>   the levels get down to 0 back again. When I raise it and run
>   mplayer, it gets to 0 immediately. If I raise it gets to 0 when
>   mplayer finishes and pulse writes 'protocol-native.c: Connection
>   died.'. It never raises automatically. And if I raise it during
>   playback, nothing plays at all.

Yeah, I did read that via the lklm archive. It's very odd that the
volumes change when pulse suspends the device... I could understand if
it changed when it opens them again (it will look at the product of the
mixers in the pipeline - e.g. Master+PCM - then work out the over all dB
then rearrange the sliders so that the same dB is ultimately obtained,
but perhaps via a different combination of mixer positions (e.g. it will
use all of Master first and only then adjust PCM). Overall the volume
itself should remain at the same dB tho'.

>> I'm no expert at the kernel side, but can't see much in the code that
>> would cause this.
>>
>> However, from Jiri's alsa-info, this looks a bit suspicious:
>>
>> Simple mixer control 'Master',0
>>   Capabilities: pvolume pvolume-joined pswitch pswitch-joined penum
>>   Playback channels: Mono
>>   Limits: Playback 0 - 64
>>   Mono: Playback 40 [62%] [1620.40dB] [on]
>>
>> 1620.40dB?? Really?
>>
>> Is perhaps the TLV fix for min-is-mute conflicting with a db range fix?
> 
> Well, it doesn't conflict but the old alsa-lib just takes the value
> as is -- i.e. the mute high bit is evaluated as a normal value.  So,
> obviously it passes a wrong value for the old alsa-lib.

Right. This actually probably explains things thinking about it...


Because the range is incorrectly reflected without the alsa-lib patch.
PA tries to set the volume to a "sensible" dB value.

This value would likely cause Master to be set to 0 (seeing as 1620.40dB
is 40, $sensible_dB is likely mapped to 0). When the device hits 0, the
kernel patch causes this to be properly reflected as "mute" (or -infdB?)
and thus PA notices this and sets both Master and PCM to 0 for that reason.

That might not be exactly what's going on, but it's probably some
similar variant thereof.


> The above result is likely because alsa-info was generated with the
> unpatched alsa-lib.  Jiri, could you regenerate alsa-info output with
> the fixed alsa-lib packages?  With the fixed alsa-lib, the dB value
> should be given correctly.


I'm surprised that the updated alsa-lib did not fix this problem. We're
now pushing out both the kernel and userspace fix, so I'll see if anyone
is affected by this in the same way as Jiri.

Jiri, when you tested the userspace updated package did you remember to
restart PA? If not then the test will not have worked as expected (the
fact that both your subsequent alsa-info's have sensible dB values for
Master suggests that the userspace fix is installed). Also when Takashi
asked for updated alsa-info script above, he meant to do it with both
the kernel and userspace patches applied.

> Anyway, judging from the fact above (giving a really wrong value), we
> will have to revert the commit...

Yes, sadly that seems so. Any bright idea on how to fix this in a less
invasive (i.e. backwards compatible) way?

Cheers

Col


-- 

Colin Guthrie
gmane(at)colin.guthr.ie
http://colin.guthr.ie/

Day Job:
  Tribalogic Limited [http://www.tribalogic.net/]
Open Source:
  Mageia Contributor [http://www.mageia.org/]
  PulseAudio Hacker [http://www.pulseaudio.org/]
  Trac Hacker [http://trac.edgewall.org/]
