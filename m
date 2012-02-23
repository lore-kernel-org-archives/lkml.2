Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab2BWUgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:36:52 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:40850 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529Ab2BWUgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:36:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.216.137.165 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <CA+55aFyAUgY5BBLA+eVF4bFTFkooxQneKE-0BWy1nrjUni=vxg@mail.gmail.com>
References: <CA+55aFxO27oa+WAtDLuWtr-NFNmKb2T0V6pccn=AE+g5PePPUg@mail.gmail.com>
 <1330026771-19937-1-git-send-email-chris@chris-wilson.co.uk> <CA+55aFyAUgY5BBLA+eVF4bFTFkooxQneKE-0BWy1nrjUni=vxg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Feb 2012 12:36:30 -0800
X-Google-Sender-Auth: hLLzoj9SBRw7K-d__6VvzpKaiIs
Message-ID: <CA+55aFz-z72adma1F=b8WL2XZ9=F9mWdt1XC7QGH0-Wc3tYunA@mail.gmail.com>
Subject: Re: [PATCH] drm: Reduce the number of retries whilst reading EDIDs
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Dave Airlie <airlied@redhat.com>, Alex Deucher <alexdeucher@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 12:15 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Sadly, this doesn't seem to make any difference to my case. My xrandr
> stays at 0.555s even with this patch.

Btw, profiling with call chains seems to say that it all comes from
intel_sdvo_get_analog_edid() (about half from  intel_sdvo_get_modes()
and half from intel_sdvo_tmds_sink_detect()).

All called through drm_ioctl() -> drm_mode_getconnector() ->
drm_helper_probe_single_connector_modes().

Which I guess isn't anything interesting, but that
intel_sdvo_get_analog_edid() thing seems to be very much a Mac mini
hack. There's a comment about that in the sources too:

        /*
         * Mac mini hack.  On this device, the DVI-I connector shares one DDC
         * link between analog and digital outputs. So, if the regular SDVO
         * DDC fails, check to see if the analog output is disconnected, in
         * which case we'll look there for the digital DDC data.
         */

and maybe that mac mini hack ends up interacting badly with something
else? I'll happily test patches if people have any ideas.

                  Linus
