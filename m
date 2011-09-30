Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab1I3WBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 18:01:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53879 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab1I3WBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 18:01:01 -0400
Date: Sat, 1 Oct 2011 00:01:36 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 18/21] drm/i915: Disable eDP VDD in a delayed work proc
 instead of synchronously
Message-ID: <20110930220136.GZ2859@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
 <1317344993-24945-19-git-send-email-keithp@keithp.com>
 <20110930184700.GV2859@phenom.ffwll.local>
 <yun4nzt7nrq.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yun4nzt7nrq.fsf@aiko.keithp.com>
X-Operating-System: Linux phenom 3.1.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 01:56:09PM -0700, Keith Packard wrote:
> On Fri, 30 Sep 2011 20:47:00 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:
> 
> > A cancel_work might be good here, not point in waking up the cpu for no
> > reason. And can you add "panel off timer: " to the deboug output?
> 
> No, that's not correct, this is run before turning the panel back on and
> must check that enough time has elapsed since it was turned off, which
> may have happened in the work proc.

You're right, I've got a bit confused between wait_panel_off and
vdd_panel_off.

> However, you are right in saying that I could call the cancel work
> function when the panel is forced off synchronously. I'll add that.

Sounds good.

> > Like Chris already mentioned, s/struct_mutex/mode_config.mutex/ Maybe also
> > move the intel_dp->want_panel_vdd check in here - we need it only here to
> > avoid a race with vdd_on. I've almost overlooked it and already started to
> > write the complaint about the race ;-)
> 
> With the right mutex held, there won't be a race, we just need to check the
> value somewhere. Do you still see a race condition that needs to be avoided?

Nope, with the right mutex protection the race is gone. And judging by
your other response my 2nd trial at formulating the issue I see seems to
have come out much better ;-)

> > > @@ -1111,10 +1175,10 @@ intel_dp_dpms(struct drm_encoder *encoder, int mode)
> > >  			intel_dp_start_link_train(intel_dp);
> > >  			if (is_edp(intel_dp))
> > >  				ironlake_edp_panel_on(intel_dp);
> > > -			ironlake_edp_panel_vdd_off(intel_dp);
> > > +			ironlake_edp_panel_vdd_off(intel_dp, true);
> > >  			intel_dp_complete_link_train(intel_dp);
> > >  		} else
> > > -			ironlake_edp_panel_vdd_off(intel_dp);
> > > +			ironlake_edp_panel_vdd_off(intel_dp, false);
> > 
> > Any reason why one vdd_off is sync while the other isn't?
> 
> After the panel is turned on, I want to synchronously turn off the VDD
> AUX bits, as that's what the driver did before. That's 'free' because
> the panel is on. In the other (failure) path, I don't want to impose a
> delay if the application wants to try the mode set again.

Ok, makes sense. Maybe add a comment explaining why the sync case is free
for dummies like me?
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
