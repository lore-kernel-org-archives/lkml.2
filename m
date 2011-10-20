Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab1JTNBi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 09:01:38 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:48803 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752496Ab1JTNBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 09:01:37 -0400
Date: Thu, 20 Oct 2011 13:01:58 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        akpm@linux-foundation.org, oleg@redhat.com, richard@nod.at,
        mikevs@xs4all.net, segoon@openwall.com, gregkh@suse.de,
        dhowells@redhat.com, eparis@redhat.com,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: Re: [PATCH 5/9] user namespace: clamp down users of cap_raised
Message-ID: <20111020130158.GC1315@hallyn.com>
References: <1318974898-21431-1-git-send-email-serge@hallyn.com>
 <1318974898-21431-6-git-send-email-serge@hallyn.com>
 <CALQRfL51U=cuLdVUpFXTog++3WwMjJB+9S6T8gVibC5gdGa5JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALQRfL51U=cuLdVUpFXTog++3WwMjJB+9S6T8gVibC5gdGa5JQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew G. Morgan (morgan@kernel.org):
> On Tue, Oct 18, 2011 at 2:54 PM, Serge Hallyn <serge@hallyn.com> wrote:
> > From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
> >
> > A few modules are using cap_raised(current_cap(), cap) to authorize
> > actions.  This means that tasks which are privileged in non-initial
> > user namespaces will be deemed privileged.  The privilege should only
> > be granted if the task is in the initial user namespace.
> >
> > Switching the calls to capable() would change the behavior - it would
> > cause the LSM capable hooks to be called, and set PF_SUPERPRIV if
> > the capability was used.  So instead, put in an explicit check and
> > refuse privilege if the caller is not in init_user_ns.
> >
> > Vasiliy had suggested introducing a new helper for this.  I'm open
> > to suggestions, but for four callers and for a discouraged idiom,
> > I'd rather not pollute the capable* function namespace with a bad name.
> > (even has_capability goes through the LSM hooks)
> >
> > Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> > Cc: Eric W. Biederman <ebiederm@xmission.com>
> > Cc: Andrew Morgan <morgan@kernel.org>
> > Cc: Vasiliy Kulikov <segoon@openwall.com>
> > ---
> >  drivers/block/drbd/drbd_nl.c           |    5 +++++
> >  drivers/md/dm-log-userspace-transfer.c |    3 +++
> >  drivers/staging/pohmelfs/config.c      |    3 +++
> >  drivers/video/uvesafb.c                |    3 +++
> >  4 files changed, 14 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
> > index 0feab26..9a87a14 100644
> > --- a/drivers/block/drbd/drbd_nl.c
> > +++ b/drivers/block/drbd/drbd_nl.c
> > @@ -2297,6 +2297,11 @@ static void drbd_connector_callback(struct cn_msg *req, struct netlink_skb_parms
> >                return;
> >        }
> >
> > +       if (current_user_ns() != &init_user_ns) {
> 
> I'd feel much happier with this if it did use some inline or macro here.
> 
> #define NS_IS_NON_DEFAULT (current_user_ns() != &init_user_ns)
> 
> if (NS_IS_NON_DEFAULT || !cap_raised(current_cap(), CAP_SYS_ADMIN)) {
>         retcode = ERR_PERM;
>         goto fail;
> }

Thanks, I'll do something like this.

> Is it important to support the situation that NS support is not configured?

I'm not sure I understand your question right;  but if I do - when
NS support is not configured, that just means that all tasks are
in init_user_ns.  We sometimes want to shortcut the checks in that
case to speed things up, but NS_IS_NON_DEFAULT() is a valid check
without NS support.

-serge
