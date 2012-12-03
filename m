Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab2LCPIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:08:31 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:63946 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab2LCPI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:08:29 -0500
MIME-Version: 1.0
X-Originating-IP: [121.7.72.46]
In-Reply-To: <s5hip8jyza2.wl%tiwai@suse.de>
References: <CAMVG2st4KZOYk9qMK6FFRnJt0bCEz-0nFsQAa4zXc+sed_eVhQ@mail.gmail.com>
	<s5hwqx69kuk.wl%tiwai@suse.de>
	<s5ha9tv1j2a.wl%tiwai@suse.de>
	<CAMVG2svAdYxJqj=7oA8XpYfaV6MP14Ff_DR3ZwVG0cm-FV_0sA@mail.gmail.com>
	<s5hip8jyza2.wl%tiwai@suse.de>
Date: Mon, 3 Dec 2012 23:08:28 +0800
Message-ID: <CAMVG2suWOAXJYWJb+QrLH2KV3CJw+Ut6fRRuy0U_F6-9oV9YyA@mail.gmail.com>
Subject: Re: switcheroo registration vs switching race...
From: Daniel J Blueman <daniel@quora.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Seth Forshee <seth.forshee@canonical.com>, Dave Airlie <airlied@linux.ie>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 December 2012 22:40, Takashi Iwai <tiwai@suse.de> wrote:
> At Mon, 3 Dec 2012 22:25:52 +0800,
> Daniel J Blueman wrote:
>>
>> On 3 December 2012 19:17, Takashi Iwai <tiwai@suse.de> wrote:
>> > At Wed, 28 Nov 2012 09:45:39 +0100,
>> > Takashi Iwai wrote:
>> >>
>> >> At Wed, 28 Nov 2012 11:45:07 +0800,
>> >> Daniel J Blueman wrote:
>> >> >
>> >> > Hi Seth, Dave, Takashi,
>> >> >
>> >> > If I power down the unused discrete GPU before lightdm starts by
>> >> > fiddling with the sysfs file [1] in the upstart script, I see a race
>> >> > manifesting as the discrete GPU's HDA controller timing out to
>> >> > commands [2].
>> >> >
>> >> > Adding some debug, I see that the registered audio devices are put
>> >> > into D3 before the GPU is, but it turns out that the discrete (and
>> >> > internal) GPU's HDA controller gets registered a bit later, so the
>> >> > list is empty. The symptom is since the HDA driver it's talking to
>> >> > hardware which is now in D3.
>> >> >
>> >> > We could add a mutex to nouveau to allow us to wait for the DGPU HDA
>> >> > controller, but perhaps this should be solved at a higher level in the
>> >> > vgaswitcheroo code; what do you think?
>> >>
>> >> Maybe it's a side effect for the recent effort to fix another race in
>> >> the probe.  A part of them problem is that the registration is done at
>> >> the very last of probing.
>> >>
>> >> Instead of delaying the registration, how about the patch below?
>> >
>> > Ping.  If this really works, I'd like to queue it for 3.8 merge, at
>> > least...
>>
>> Ping ack; I was trying to find time to understand another race that
>> occurs with GPU probing after switching, but is separate from the
>> situation before switching, here.
>>
>> In the context of writing the switch, it looks like struct azx isn't
>> allocated by the time azx_vs_set_state accesses it [1,2]; racing with
>> azx_codec_create?
>
> It was allocated, but it wasn't assigned properly in pci drvdata.
>
> Below is the revised patch.  Just moved pci_set_drvdata() before
> register_vga_switcheroo().  Could you retest with it?

Superb; this addresses the oops.

~1 second after the DGPU is put into D3, I still often see "hda-intel:
spurious response 0x0:0x0, last cmd=0x170500":
http://quora.org/2012/hda-switch-spurious.txt

Presumably this implies the read of the ring-buffer pointer returned
0xffffffff, so the HDA driver understands the pointer to have wrapped
and processes the 191 unwritten entries?

Daniel
--
Daniel J Blueman
