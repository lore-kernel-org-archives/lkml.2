Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab2JEQrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 12:47:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59443 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756843Ab2JEQq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 12:46:58 -0400
Date: Fri, 5 Oct 2012 11:46:48 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, criu@openvz.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Andrew Vagin <avagin@openvz.org>
Subject: Re: [PATCH] proc: don't show nonexistent capabilities
Message-ID: <20121005164648.GA19850@sergelap>
References: <1349209832-279922-1-git-send-email-avagin@openvz.org>
 <20121005140519.GA28890@mail.hallyn.com>
 <CALQRfL5ViSfmqG=UdRWquUq26WCp1pZMpUXJ8EgspGW0n32Fkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALQRfL5ViSfmqG=UdRWquUq26WCp1pZMpUXJ8EgspGW0n32Fkg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drat, thanks Andrew, I thought I had a testcase for that in LTP, but
apparently not.

capsh --caps="all=eip" -- -c /bin/bash

indeed fails with this patch (and succeeds without).

So

Nacked-by: Serge Hallyn <serge.hallyn@canonical.com>

since this is a much more common idiom, enough so that I'm not willing
to say userspace should work around it (which indeed it could).

Note that /proc/self/status is a slow path anyway, so updating that
file to output only valid capabilities might be a workable alternative.

-serge

Quoting Andrew G. Morgan (morgan@kernel.org):
> I like the sentiment but have you considered the implications for a
> default system root user trying to set all=eip ? Existing code can do
> this because all bits are accessible by default. If you set the
> bounding set to something less than ~0, then any code that currently
> does this will start to fail in the common case.
> 
> Cheers
> 
> Andrew
> 
> On Oct 5, 2012 7:13 AM, "Serge E. Hallyn" <serge@hallyn.com> wrote:
> >
> > Quoting Andrew Vagin (avagin@openvz.org):
> > > Without this patch it is really hard to interpret a bounding set,
> > > if CAP_LAST_CAP is unknown for a current kernel.
> >
> > To be clear, note that you *can* figure it out using
> > prctl(PR_CAPBSET_DROP).  But this is a nice improvement.
> >
> > > Non-existant capabilities can not be deleted from a bounding set
> > > with help of prctl.
> > >
> > > E.g.: Here are two examples without/with this patch.
> > > CapBnd:       ffffffe0fdecffff
> > > CapBnd:       00000000fdecffff
> > >
> > > I suggest to hide non-existent capabilities. Here is two reasons.
> > > * It's logically and easier for using.
> > > * It helps to checkpoint-restore capabilities of tasks, because tasks
> > > can be restored on another kernel, where CAP_LAST_CAP is bigger.
> > >
> > > Cc: Serge Hallyn <serge.hallyn@canonical.com>
> >
> > Thanks, Andrew.  I saw your other email about having run LTP, I didn't
> > see any problems from userspace either.  Great idea!
> >
> > Reviewed-by: Serge Hallyn <serge.hallyn@canonical.com>
> >
> > Still it's been like that for so long that, just to be safe, I'm cc:ing
> > Andrew Morgan - can you see any problems with this?
> >
> > > Cc: Pavel Emelyanov <xemul@parallels.com>
> > > Signed-off-by: Andrew Vagin <avagin@openvz.org>
> > > ---
> > >  include/linux/capability.h |    3 ++-
> > >  1 files changed, 2 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/include/linux/capability.h b/include/linux/capability.h
> > > index d10b7ed..1642778 100644
> > > --- a/include/linux/capability.h
> > > +++ b/include/linux/capability.h
> > > @@ -420,7 +420,8 @@ extern const kernel_cap_t __cap_init_eff_set;
> > >  #else /* HAND-CODED capability initializers */
> > >
> > >  # define CAP_EMPTY_SET    ((kernel_cap_t){{ 0, 0 }})
> > > -# define CAP_FULL_SET     ((kernel_cap_t){{ ~0, ~0 }})
> > > +# define CAP_FULL_SET     ((kernel_cap_t){{ ~0, \
> > > +                                     CAP_TO_MASK(CAP_LAST_CAP + 1) - 1 } })
> > >  # define CAP_FS_SET       ((kernel_cap_t){{ CAP_FS_MASK_B0 \
> > >                                   | CAP_TO_MASK(CAP_LINUX_IMMUTABLE), \
> > >                                   CAP_FS_MASK_B1 } })
> > > --
> > > 1.7.1
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
