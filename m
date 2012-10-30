Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab2J3HjB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 03:39:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:50531 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973Ab2J3Hi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 03:38:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,677,1344236400"; 
   d="scan'208";a="162268999"
From: Jani Nikula <jani.nikula@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] i915: failure to interoperate with HP ZR30w using an X230
In-Reply-To: <nsxa9v4ssgz.fsf@closure.thunk.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <nsxa9v4ssgz.fsf@closure.thunk.org>
User-Agent: Notmuch/0.14+49~gd2c7aec (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 30 Oct 2012 09:44:20 +0200
Message-ID: <87hapcqu97.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ted -

On Tue, 30 Oct 2012, Theodore Ts'o <tytso@mit.edu> wrote:
> I recently upgraded to 3.6.3, and my Lenovo X230 has stopped being able
> to work with an HP ZR30w 30" 2560x1600 display.   I saw the following
> messages in the dmesg:
>
> [drm:ivb_manual_fdi_link_train] *ERROR* FDI train 1 fail!
> [drm:ivb_manual_fdi_link_train] *ERROR* FDI train 2 fail!
>
> .. which I didn't see before; the exact same mini-displayport to
> displayport cable connecting the same Lenovo X230 laptop to exactly the
> same ZRW 30 display worked just fine with the 3.6.0 kernel.
>
> So I bisected the problem, and found the following commit.  Reverting
> this commit made the problem go away.   Maybe we should revert
> 0c96c65b48fb in mainline?

Thanks for bisecting. However, the commit does fix a bug for some people
out there, which is why it's been backported to stable. Without it, we
fail to dither when there is not enough bandwidth in the DP link. My
guess is that this brings up another bug that affects you, and IMHO we'd
be better off debugging this than reverting.

> Let me know if you'd like me to do any further debugging.

Something to try would be the latest i915.ko driver [1], which I believe
has some link training changes, and/or posting the dmesg with
drm.debug=0xe module parameter.

BR,
Jani.


[1] drm-intel-next-queued branch at git://people.freedesktop.org/~danvet/drm-intel


>
> Thanks,
>
>                                                 - Ted
>
> commit 6c34ed3be47036c173f7f43df112f93fbd89026f
> Author: Jani Nikula <jani.nikula@intel.com>
> Date:   Wed Sep 26 18:43:10 2012 +0300
>
>     drm/i915: use adjusted_mode instead of mode for checking the 6bpc force flag
>     
>     commit 0c96c65b48fba3ffe9822a554cbc0cd610765cd5 upstream.
>     
>     The dithering introduced in
>     
>     commit 3b5c78a35cf7511c15e09a9b0ffab290a42d9bcf
>     Author: Adam Jackson <ajax@redhat.com>
>     Date:   Tue Dec 13 15:41:00 2011 -0800
>     
>         drm/i915/dp: Dither down to 6bpc if it makes the mode fit
>     
>     stores the INTEL_MODE_DP_FORCE_6BPC flag in the private_flags of the
>     adjusted mode, while i9xx_crtc_mode_set() and ironlake_crtc_mode_set() use
>     the original mode, without the flag, so it would never have any
>     effect. However, the BPC was clamped by VBT settings, making things work by
>     coincidence, until that part was removed in
>     
>     commit 4344b813f105a19f793f1fd93ad775b784648b95
>     Author: Daniel Vetter <daniel.vetter@ffwll.ch>
>     Date:   Fri Aug 10 11:10:20 2012 +0200
>     
>     Use adjusted_mode instead of mode when checking for
>     INTEL_MODE_DP_FORCE_6BPC to make the flag have effect.
>     
>     v2: Don't forget to fix this in i9xx_crtc_mode_set() also, pointed out by
>     Daniel both before and after sending the first patch.
>     
>     Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=47621
>     CC: Adam Jackson <ajax@redhat.com>
>     Signed-off-by: Jani Nikula <jani.nikula@intel.com>
>     Reviewed-by: Adam Jackson <ajax@redhat.com>
>     Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
>                                                 - Ted
