Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920Ab2IFKaV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 06:30:21 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:50041 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754428Ab2IFKaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 06:30:20 -0400
Date: Thu, 6 Sep 2012 12:30:16 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Daniel Mack <zonque@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Subject: Re: snd-usb: "delay: estimated 0, actual 352"
Message-ID: <20120906103016.GA257@x4>
References: <s5hmx1526mg.wl%tiwai@suse.de>
 <20120906060220.GA252@x4>
 <504843BA.2040808@gmail.com>
 <s5hehmfir46.wl%tiwai@suse.de>
 <20120906065340.GA257@x4>
 <50484BEB.4020103@gmail.com>
 <20120906071757.GB257@x4>
 <s5h627rioxt.wl%tiwai@suse.de>
 <50487A0C.4080204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50487A0C.4080204@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.09.06 at 12:25 +0200, Daniel Mack wrote:
> On 06.09.2012 09:35, Takashi Iwai wrote:
> > At Thu, 6 Sep 2012 09:17:57 +0200,
> > Markus Trippelsdorf wrote:
> >>
> >> On 2012.09.06 at 09:08 +0200, Daniel Mack wrote:
> >>> On 06.09.2012 08:53, Markus Trippelsdorf wrote:
> >>>> On 2012.09.06 at 08:48 +0200, Takashi Iwai wrote:
> >>>>> At Thu, 06 Sep 2012 08:33:30 +0200,
> >>>>> Daniel Mack wrote:
> >>>>>>
> >>>>>> On 06.09.2012 08:02, Markus Trippelsdorf wrote:
> >>>>>>> On 2012.09.04 at 16:40 +0200, Takashi Iwai wrote:
> >>>>>>>> ----------------------------------------------------------------
> >>>>>>>> Sound fixes for 3.6-rc5
> >>>>>>>>
> >>>>>>>> There are nothing scaring, contains only small fixes for HD-audio and
> >>>>>>>> USB-audio:
> >>>>>>>> - EPSS regression fix and GPIO fix for HD-audio IDT codecs
> >>>>>>>> - A series of USB-audio regression fixes that are found since 3.5 kernel
> >>>>>>>>
> >>>>>>>> ----------------------------------------------------------------
> >>>>>>>> Daniel Mack (4):
> >>>>>>>>       ALSA: snd-usb: Fix URB cancellation at stream start
> >>>>>>>>       ALSA: snd-usb: restore delay information
> >>>>>>>         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
> >>>>>>> The commit fbcfbf5f above causes the following lines to be printed
> >>>>>>> whenever I start a new song:
> >>>>>>
> >>>>>> Copied Pierre-Louis Bossart - he wrote the code in 294c4fb8 which this
> >>>>>> patch (fbcfbf5f) brings back now.
> >>>>>>
> >>>>>>> delay: estimated 0, actual 352
> >>>>>>> delay: estimated 353, actual 705
> >>>>>>>
> >>>>>>> (44.1 * 8 = 352.8)
> >>>>>>>
> >>>>>>> This happens with an USB-DAC that identifies itself as "C-Media USB
> >>>>>>> Headphone Set".
> >>>>>>
> >>>>>> And you didn't you see these lines with 3.4?
> >>>>>
> >>>>> Maybe the difference of start condition?
> >>>>>
> >>>>> Markus, does the patch below fix anything?
> >>>>
> >>>> Unfortunately no.
> >>>> However reverting the following fixes the problem:
> >>>>
> >>>> commit 245baf983cc39524cce39c24d01b276e6e653c9e
> >>>> Author: Daniel Mack <zonque@gmail.com>
> >>>> Date:   Thu Aug 30 18:52:30 2012 +0200
> >>>>
> >>>>     ALSA: snd-usb: fix calls to next_packet_size
> >>>>
> >>>
> >>> No, this one certainly fixes a problem and does the right thing by
> >>> restoring the original code.
> >>>
> >>> If you wouldn't state that you didn't see the same effect with 3.4(!),
> >>> before the refactoring done in 3.5, I would believe the device is simply
> >>> slightly off in its feedback rate and the tighter delay code complains
> >>> about it while compensating, just as it did before.
> >>>
> >>> Are there any more than these two lines? And is audio working at all? Is
> >>> it distorted in any way?
> >>
> >> There are only these two lines (printed whenever sound starts). Audio is
> >> working just fine with no distortions.
> >>
> >> I did see similar lines before when the system load was very high
> >> (happend during "make check" when building glibc).
> >>
> >> Here is what Pierre-Louis wrote in November 2011:
> >>
> >> Â»This was supposed to be an informational message, I thought it was only
> >> enabled for debug. Regular users don't really need to know.Â«
> > 
> > I guess the problem is that the new endpoint scheme doesn't count the
> > last_delay update unless the stream is triggered.  In the old code,
> > retire_playback_urb is always called even before the trigger(START) is
> > set.  And, there retire_playback_urb() does nothing but updating the
> > delay information.
> > 
> > In the new code, retire_playback_urb is set only at
> > snd_usb_substream_playback_trigger().  Thus at the very first shot,
> > the delay account got confused.
> 
> In that case, I'd say we can also safely remove the debug output then.
> Let's wait for Pierre-Louis' judgement here.

v3.5 and v3.6-rc4 with commit fbcfbf5f67 (restore delay information)
applied on top are both fine.

-- 
Markus
