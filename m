Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab1ALP4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 10:56:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37779 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276Ab1ALP4g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 10:56:36 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1101121324550.8212@casper.infradead.org>
References: <alpine.DEB.2.00.1101102250090.15019@skynet.skynet.ie>
 <4D2CE5C8.60601@de.ibm.com> <AANLkTimr4WX3Ay8vC23MKOM+dOcpV+Ca5rg_gcei38nk@mail.gmail.com>
 <4D2D8ED0.6080807@de.ibm.com> <alpine.LFD.2.00.1101121235360.8212@casper.infradead.org>
 <4D2DA6A7.4010609@de.ibm.com> <alpine.LFD.2.00.1101121324550.8212@casper.infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Jan 2011 07:55:42 -0800
Message-ID: <AANLkTik32TC_eMbe0rZ+g11hFy9Z2_yY38avzY0GbgPv@mail.gmail.com>
Subject: Re: [git pull] drm for rc1
To: James Simmons <jsimmons@infradead.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Dave Airlie <airlied@linux.ie>,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 5:32 AM, James Simmons <jsimmons@infradead.org> wrote:
>
> Okay. The nouveau driver also uses the pitch as well. It
> really should be using the pitch field from drm_framebuffer instead of the
> line_length from fb_fix_screeninfo. This patch is just to make sure this
> is the issue. I will submit another patch later that uses
> drm_fb_framebuffer's pitch field. As for the visual unfortunely their is
> no real mapping between drm and fbdev.

Why do you want to remove the drm_fb_helper_fill_fix() call? Quite
frankly, you're then replacing it with open-coding the function
partially:

> +       info->fix.visual = fb->depth == 8 ? FB_VISUAL_PSEUDOCOLOR :
> +                FB_VISUAL_TRUECOLOR;
> +       info->fix.line_length = fb->pitch;
>        drm_fb_helper_fill_var(info, &nfbdev->helper, sizes->fb_width, sizes->fb_height);

Which seems to be just a regression. Why not just call
"drm_fb_helper_fill_fix()" here like we used to?

IOW, I'm inclined to just do the revert. The "fix" clearly breaks
things, and now you're adding random parts of the function back rather
than just calling the "fill_fix()" function like things used to. Why?

The commit message in dfe63bb0ad98 doesn't support any of these hacks
- it just seems to say that drm_fb_helper_fill_fix() should also have
been called from setcolreg().

So why don't we just revert the commit and instead add that
drm_fb_helper_fill_fix() to setcolreg()?

                            Linus
