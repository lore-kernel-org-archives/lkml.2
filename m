Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab2BWUPZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 15:15:25 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:45241 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012Ab2BWUPY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 15:15:24 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.8.164 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330026771-19937-1-git-send-email-chris@chris-wilson.co.uk>
References: <CA+55aFxO27oa+WAtDLuWtr-NFNmKb2T0V6pccn=AE+g5PePPUg@mail.gmail.com>
 <1330026771-19937-1-git-send-email-chris@chris-wilson.co.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 23 Feb 2012 12:15:03 -0800
X-Google-Sender-Auth: f4Ssv0gw_xwfPBpLqOdR5XYRtfg
Message-ID: <CA+55aFyAUgY5BBLA+eVF4bFTFkooxQneKE-0BWy1nrjUni=vxg@mail.gmail.com>
Subject: Re: [PATCH] drm: Reduce the number of retries whilst reading EDIDs
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Dave Airlie <airlied@redhat.com>, Alex Deucher <alexdeucher@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 11:52 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>
> i2c retries if sees an EGAIN, drm_do_probe_ddc_edid retries until it
> gets a result and *then* drm_do_get_edid retries until it gets a result
> it is happy with. All in all, that is a lot of processor intensive
> looping in cases where we do not expect and cannot get valid data - for
> example on Intel with disconnected hardware we will busy-spin until we
> hit the i2c timeout. This is then repeated for every connector when
> querying the current status of outputs.

Sadly, this doesn't seem to make any difference to my case. My xrandr
stays at 0.555s even with this patch.

So apparently the Apple Mac Mini issue is not about retries. But maybe
this fixes the problem Stephan Bärwolf reported?  The Apple Mac Mini
is known for doing things oddly, so ..

You didn't include Stephan on the cc for that patch, though.

Btw, clearly X does *not* cache the EDID results, at least not for
this case. So the explicit xrandr example is probably pretty close to
what wine does. Maybe the proper fix is to just make X.org force
caching when clients do this (because it's definitely X that does the
drm_mode_getconnector() thing - xrandr itself spends zero time on
this, it just does an X request and waits for the result).

The fact that EDID takes half a second to get is not a problem per se.
It's a problem only when X does it over and over again because some
client does something unexpected.

                      Linus
