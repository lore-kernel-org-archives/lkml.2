Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758184Ab1DMT0b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:26:31 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:45599 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757978Ab1DMT0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:26:30 -0400
Message-ID: <4DA5F8FE.6000105@metafoo.de>
Date: Wed, 13 Apr 2011 21:26:54 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] ASoC: Call snd_soc_new_widgets() after registering
 cards DAPM widgets
References: <1302629465-21315-1-git-send-email-lars@metafoo.de> <1302629465-21315-2-git-send-email-lars@metafoo.de> <20110413003847.GC24267@opensource.wolfsonmicro.com> <4DA597E3.807@metafoo.de> <20110413173249.GC18008@opensource.wolfsonmicro.com>
In-Reply-To: <20110413173249.GC18008@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 07:32 PM, Mark Brown wrote:
> On Wed, Apr 13, 2011 at 02:32:35PM +0200, Lars-Peter Clausen wrote:
> 
>> But snd_soc_dapm_new_widgets also calls dapm_power_widgets which operates on
>> the passed dapm_context, will it be without any effect on the DAPM context,
>> when it is called on a newly allocated context?
> 
> Yup.

Ok. I'll add a snd_soc_dapm_init_widgets(struct snd_soc_card *card) which will
basically do what snd_soc_dapm_new_widgets does except for calling
dapm_power_widgets.


> 
>> Otherwise I would say call snd_soc_dapm_new_widgets once for the cards
>> dapm_context and snd_soc_dapm_sync for each codec context.
> 
> There's no point in repeatedly syncing - it may cause audible issues if
> we power things off due to incomplete information.  If the sync isn't
> propagating over the entire system we should fix that.

The dapm context is really only used to see if it is widget-less context. In
which case the event type is used to see whether it should be powered or not.
But I wonder if that shouldn't really be done for all widget less contexts.
Since widget-less contexts dev_power is not set to 0 at the beginning of
dapm_power_widgets and all dapm contexts are forced into the same power state,
effectively that cause a system with a widget-less context to be stuck in a
powered state.
Since right now the cards dapm context is almost always widget-less this would
affect almost all systems.
This is what happens on such a system:
Playback starts, codec is powered up, card dapm context is forced to on,
playback stops, codec is powered down but card context is still on and will
force the codec on again.

And it is also used for passing the update struct around. But is there any
reason as to why to pass as a member of the dapm context instead of as a simple
parameter for dapm_power_widgets()? If not I would like to change it to the latter.

- Lars
