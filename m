Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850Ab0LUQg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 11:36:57 -0500
Received: from adelie.canonical.com ([91.189.90.139]:53573 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab0LUQgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 11:36:55 -0500
Message-ID: <4D10D75D.80400@canonical.com>
Date: Tue, 21 Dec 2010 11:35:41 -0500
From: Chase Douglas <chase.douglas@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Henrik Rydberg <rydberg@euromail.se>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Takashi Iwai <tiwai@suse.de>, Chris Bagwell <chris@cnpbagwell.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] Input: synaptics - add multi-finger and semi-mt support
References: <1292852364-19127-1-git-send-email-rydberg@euromail.se> <1292852364-19127-3-git-send-email-rydberg@euromail.se>
In-Reply-To: <1292852364-19127-3-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2010 08:39 AM, Henrik Rydberg wrote:
> The Synaptics 2.7 series of touchpads support a mode for reporting two
> sets of X/Y/Pressure data (advanced gesture mode). By default, these
> devices report only single finger data, depriving userspace of the
> nowadays ubiquitous two-finger scroll gesture.
> 
> Enabling advanced gesture mode also enables the multi-finger report,
> although the device does not claim that capability. Up to three
> fingers can be reported this way.
> 
> While two or three fingers are touching, the normal packet is
> prepended by a reduced finger packet of lower resolution. From the two
> packets (which do not represent the actual fingers), the bounding
> rectangle of the individual contacts can be extracted.  This
> information is sufficient to perform scaling gestures and a limited
> form of rotation gesture. The behavior has been coined semi-mt
> capability, and is signaled to userspace via the INPUT_PROP_SEMI_MT
> device property.
> 
> Work to decode the advanced gesture packet: Takashi Iwai.
> Cleanup and testing of the original patch: Chase Douglas.
> Minor cleanup and testing: Chris Bagwell.
> Finalization and semi-mt support: Henrik Rydberg.
> 
> Reported-by: Tobyn Bertram
> Not-yet-signed-off-by: Takashi Iwai <tiwai@suse.de>
> Not-yet-signed-off-by: Chase Douglas <chase.douglas@canonical.com>
> Not-yet-signed-off-by: Chris Bagwell <chris@cnpbagwell.com>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

You can keep my SOB.

> +static void set_slot(struct input_dev *dev, int slot, bool active, int x, int y)
> +{
> +	input_mt_slot(dev, slot);
> +	input_mt_report_slot_state(dev, MT_TOOL_FINGER, active);
> +	if (active) {
> +		input_report_abs(dev, ABS_MT_POSITION_X, x);
> +		input_report_abs(dev, ABS_MT_POSITION_Y,
> +				 YMAX_NOMINAL + YMIN_NOMINAL - y);
> +	}
> +}

I take it that you feel MT_TOOL_FINGER should always be set, even if
it's always the same as BTN_TOOL_*? I just want to be sure this is
intended so we document it appropriately.

> @@ -623,6 +686,7 @@ static void set_input_params(struct input_dev *dev, struct synaptics_data *priv)
>  	int i;
>  
>  	__set_bit(INPUT_PROP_POINTER, dev->propbit);
> +	__set_bit(INPUT_PROP_SEMI_MT, dev->propbit);

Shouldn't this only be set when SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) is
true?

Thanks,

-- Chase
