Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752246Ab2J3AkE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 20:40:04 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:58362 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629Ab2J3AkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 20:40:00 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>
Subject: [REGRESSION] i915: failure to interoperate with HP ZR30w using an X230
Date: Mon, 29 Oct 2012 20:39:56 -0400
Message-ID: <nsxa9v4ssgz.fsf@closure.thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I recently upgraded to 3.6.3, and my Lenovo X230 has stopped being able
to work with an HP ZR30w 30" 2560x1600 display.   I saw the following
messages in the dmesg:

[drm:ivb_manual_fdi_link_train] *ERROR* FDI train 1 fail!
[drm:ivb_manual_fdi_link_train] *ERROR* FDI train 2 fail!

.. which I didn't see before; the exact same mini-displayport to
displayport cable connecting the same Lenovo X230 laptop to exactly the
same ZRW 30 display worked just fine with the 3.6.0 kernel.

So I bisected the problem, and found the following commit.  Reverting
this commit made the problem go away.   Maybe we should revert
0c96c65b48fb in mainline?

Let me know if you'd like me to do any further debugging.

Thanks,

                                                - Ted

commit 6c34ed3be47036c173f7f43df112f93fbd89026f
Author: Jani Nikula <jani.nikula@intel.com>
Date:   Wed Sep 26 18:43:10 2012 +0300

    drm/i915: use adjusted_mode instead of mode for checking the 6bpc force flag
    
    commit 0c96c65b48fba3ffe9822a554cbc0cd610765cd5 upstream.
    
    The dithering introduced in
    
    commit 3b5c78a35cf7511c15e09a9b0ffab290a42d9bcf
    Author: Adam Jackson <ajax@redhat.com>
    Date:   Tue Dec 13 15:41:00 2011 -0800
    
        drm/i915/dp: Dither down to 6bpc if it makes the mode fit
    
    stores the INTEL_MODE_DP_FORCE_6BPC flag in the private_flags of the
    adjusted mode, while i9xx_crtc_mode_set() and ironlake_crtc_mode_set() use
    the original mode, without the flag, so it would never have any
    effect. However, the BPC was clamped by VBT settings, making things work by
    coincidence, until that part was removed in
    
    commit 4344b813f105a19f793f1fd93ad775b784648b95
    Author: Daniel Vetter <daniel.vetter@ffwll.ch>
    Date:   Fri Aug 10 11:10:20 2012 +0200
    
    Use adjusted_mode instead of mode when checking for
    INTEL_MODE_DP_FORCE_6BPC to make the flag have effect.
    
    v2: Don't forget to fix this in i9xx_crtc_mode_set() also, pointed out by
    Daniel both before and after sending the first patch.
    
    Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=47621
    CC: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Jani Nikula <jani.nikula@intel.com>
    Reviewed-by: Adam Jackson <ajax@redhat.com>
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

                                                - Ted
