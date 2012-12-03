Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab2LCQu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 11:50:58 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:37923 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab2LCQu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 11:50:57 -0500
MIME-Version: 1.0
X-Originating-IP: [121.7.72.46]
In-Reply-To: <s5ha9tvyuio.wl%tiwai@suse.de>
References: <CAMVG2st4KZOYk9qMK6FFRnJt0bCEz-0nFsQAa4zXc+sed_eVhQ@mail.gmail.com>
	<s5hwqx69kuk.wl%tiwai@suse.de>
	<s5ha9tv1j2a.wl%tiwai@suse.de>
	<CAMVG2svAdYxJqj=7oA8XpYfaV6MP14Ff_DR3ZwVG0cm-FV_0sA@mail.gmail.com>
	<s5hip8jyza2.wl%tiwai@suse.de>
	<CAMVG2suWOAXJYWJb+QrLH2KV3CJw+Ut6fRRuy0U_F6-9oV9YyA@mail.gmail.com>
	<s5ha9tvyuio.wl%tiwai@suse.de>
Date: Tue, 4 Dec 2012 00:50:56 +0800
Message-ID: <CAMVG2svjXk-dbhjuiAX4SpTctNbwPkyzOa47n9vA2o1rLiWbBw@mail.gmail.com>
Subject: Re: switcheroo registration vs switching race...
From: Daniel J Blueman <daniel@quora.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Seth Forshee <seth.forshee@canonical.com>, Dave Airlie <airlied@linux.ie>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 December 2012 00:23, Takashi Iwai <tiwai@suse.de> wrote:
> At Mon, 3 Dec 2012 23:08:28 +0800,
> Daniel J Blueman wrote:
>>
>> On 3 December 2012 22:40, Takashi Iwai <tiwai@suse.de> wrote:
>> > At Mon, 3 Dec 2012 22:25:52 +0800,
>> > Daniel J Blueman wrote:
>> >>
>> >> On 3 December 2012 19:17, Takashi Iwai <tiwai@suse.de> wrote:
>> >> > At Wed, 28 Nov 2012 09:45:39 +0100,
>> >> > Takashi Iwai wrote:
>> >> >>
>> >> >> At Wed, 28 Nov 2012 11:45:07 +0800,
>> >> >> Daniel J Blueman wrote:
>> >> >> >
>> >> >> > Hi Seth, Dave, Takashi,
>> >> >> >
>> >> >> > If I power down the unused discrete GPU before lightdm starts by
>> >> >> > fiddling with the sysfs file [1] in the upstart script, I see a race
>> >> >> > manifesting as the discrete GPU's HDA controller timing out to
>> >> >> > commands [2].
>> >> >> >
>> >> >> > Adding some debug, I see that the registered audio devices are put
>> >> >> > into D3 before the GPU is, but it turns out that the discrete (and
>> >> >> > internal) GPU's HDA controller gets registered a bit later, so the
>> >> >> > list is empty. The symptom is since the HDA driver it's talking to
>> >> >> > hardware which is now in D3.
>> >> >> >
>> >> >> > We could add a mutex to nouveau to allow us to wait for the DGPU HDA
>> >> >> > controller, but perhaps this should be solved at a higher level in the
>> >> >> > vgaswitcheroo code; what do you think?
>> >> >>
>> >> >> Maybe it's a side effect for the recent effort to fix another race in
>> >> >> the probe.  A part of them problem is that the registration is done at
>> >> >> the very last of probing.
>> >> >>
>> >> >> Instead of delaying the registration, how about the patch below?
>> >> >
>> >> > Ping.  If this really works, I'd like to queue it for 3.8 merge, at
>> >> > least...
>> >>
>> >> Ping ack; I was trying to find time to understand another race that
>> >> occurs with GPU probing after switching, but is separate from the
>> >> situation before switching, here.
>> >>
>> >> In the context of writing the switch, it looks like struct azx isn't
>> >> allocated by the time azx_vs_set_state accesses it [1,2]; racing with
>> >> azx_codec_create?
>> >
>> > It was allocated, but it wasn't assigned properly in pci drvdata.
>> >
>> > Below is the revised patch.  Just moved pci_set_drvdata() before
>> > register_vga_switcheroo().  Could you retest with it?
>>
>> Superb; this addresses the oops.
>
> OK, I'll queue it to sound tree for 3.8 kernel with Cc to stable.
>
>> ~1 second after the DGPU is put into D3, I still often see "hda-intel:
>> spurious response 0x0:0x0, last cmd=0x170500":
>> http://quora.org/2012/hda-switch-spurious.txt
>
> Hm, it's not clear who triggers these messages.  I'll try to check the
> code paths.
>
>> Presumably this implies the read of the ring-buffer pointer returned
>> 0xffffffff, so the HDA driver understands the pointer to have wrapped
>> and processes the 191 unwritten entries?
>
> Good point.  Actually there is one bug that looks obviously wrong
> (writing 32bit value to CORBWP).  Maybe it has been working just
> because writing CORBRP doesn't influence except for the reset bit.
>
> Reading CORBWP as a byte is OK, but this could be better in a word so
> that we can check 0xffff as invalid.
>
> A test patch is below.  Hopefully this improves the situation...

I'll check this out tomorrow and also instrument the code to get a
backtrace, since there may still be an underlying race with the
previous patches:

[    8.203827] snd_hda_intel 0000:00:1b.0: enabling device (0000 -> 0002)
[    8.203936] snd_hda_intel 0000:00:1b.0: irq 51 for MSI/MSI-X
[   10.981297] VGA switcheroo: switched nouveau off
[   10.981383] nouveau  [     DRM] suspending fbcon...
[   10.981388] nouveau  [     DRM] suspending display...
[   10.981687] nouveau  [     DRM] unpinning framebuffer(s)...
[   10.981825] nouveau  [     DRM] evicting buffers...
[   10.992948] nouveau  [     DRM] suspending client object trees...
[   11.310697] hda-intel: azx_get_response timeout, switching to
polling mode: last cmd=0x000f0000
[   12.320236] hda-intel: No response from codec, disabling MSI: last
cmd=0x000f0000
[   13.329721] hda-intel: Codec #0 probe error; disabling it...
[   14.419163] hda_intel: azx_get_response timeout, switching to
single_cmd mode: last cmd=0x000f0000
[   14.419855] hda-intel: no codecs initialized
[   14.459150] snd_hda_intel 0000:01:00.1: Refused to change power
state, currently in D3
[   14.459176] hda-intel: 0000:01:00.1: Handle VGA-switcheroo audio client
[   14.459183] hda-intel: VGA controller for 0000:01:00.1 is disabled
[   14.459184] hda-intel: Delaying initialization

Full log at: http://quora.org/2012/hda-switch-spurious2.txt

The first response timeout message plausibly could be from the CS4206
(0:1b.0) or Nvidia DGPU (1:0.1); either way, there are no audio
devices after. Also, we see that checking for master abort in one
place won't be sufficient.

Stay tuned for backtraces tomorrow.

Thanks again so far!
  Daniel
--
Daniel J Blueman
