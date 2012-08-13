Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474Ab2HMPJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 11:09:36 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55270 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab2HMPJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 11:09:34 -0400
Date: Mon, 13 Aug 2012 17:09:55 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Mihai Moldovan <ionic@ionic.de>
Cc: Jani Nikula <jani.nikula@intel.com>, daniel@ffwll.ch,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] hopefully fix null pointer dereference on i915 load
Message-ID: <20120813150955.GD5248@phenom.ffwll.local>
Mail-Followup-To: Mihai Moldovan <ionic@ionic.de>,
	Jani Nikula <jani.nikula@intel.com>,
	intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <50254887.6030209@ionic.de>
 <cover.1344867962.git.jani.nikula@intel.com>
 <5029173C.90709@ionic.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5029173C.90709@ionic.de>
X-Operating-System: Linux phenom 3.4.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 05:03:24PM +0200, Mihai Moldovan wrote:
> Hi Jani,
> 
> * On 13.08.2012 04:33 PM, Jani Nikula wrote:
> > Hi Mihai, could you test the following patch to see if it fixes the problem,
> > please?
> >
> > BR,
> > Jani.
> >
> >
> > Jani Nikula (1):
> >   drm/i915: ensure i2c adapter is all set before adding it
> >
> >  drivers/gpu/drm/i915/intel_i2c.c |    7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >
> 
> The reason sounds sane to me, but while looking through the code, I have seen a
> few other problems, too.
> 
> To my understanding, we should use port for dev_priv->gmbus[], not the pin
> mapping (which is only used for gmbus_ports[]).
> Don't forget to add the +1 for pin -> port mapping to the error case.
> 
> Also, intel_gmbus_get_adapter is already accepting a port value (I made sure to
> look at the calls in other files too), so don't map the port back to a pin.
> 
> Keep the same in mind for the intel_teardown_gmbus "destructor".
> 
> The current code adds the gmbus algorithm (gmbus_xfer) to gmbus port 0, which is
> known as "disabled" and shouldn't be used (previously has_gpio was set to false
> for those ports to not do any transfer on those ports.)
> 
> I may be wrong, could you review this and maybe add it to your patch?

This seems to essentially undo

commit 2ed06c93a1fce057808894d73167aae03c76deaf
Author: Daniel Kurtz <djkurtz@chromium.org>
Date:   Wed Mar 28 02:36:15 2012 +0800

    drm/i915/intel_i2c: gmbus disabled and reserved ports are invalid

Note that port numbers start at 1, whereas the array is 0-index based. So
you patch here would blow up if you don't extend the dev_priv->gmbus
array.

Yours, Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
