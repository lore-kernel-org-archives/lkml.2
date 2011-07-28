Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab1G1Xva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:51:30 -0400
Received: from adelie.canonical.com ([91.189.90.139]:58504 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab1G1Xv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:51:28 -0400
Date: Thu, 28 Jul 2011 18:51:19 -0500
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Vasiliy Kulikov <segooon@gmail.com>
Cc: Serge Hallyn <serge@hallyn.com>, dhowells@redhat.com,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [PATCH 05/14] userns: clamp down users of cap_raised
Message-ID: <20110728235119.GA8167@sergelap>
References: <1311706717-7398-1-git-send-email-serge@hallyn.com>
 <1311706717-7398-6-git-send-email-serge@hallyn.com>
 <20110728232337.GA9186@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110728232337.GA9186@albatros>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Vasiliy Kulikov (segooon@gmail.com):
> On Tue, Jul 26, 2011 at 18:58 +0000, Serge Hallyn wrote:
> > From: Serge E. Hallyn <serge.hallyn@canonical.com>
> > 
> > A few modules are using cap_raised(current_cap(), cap) to authorize
> > actions, but the privilege should be applicable against the initial
> > user namespace.  Refuse privilege if the caller is not in init_user_ns.
> > 
> > Signed-off-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> > Cc: Eric W. Biederman <ebiederm@xmission.com>
> > ---
> >  drivers/block/drbd/drbd_nl.c           |    5 +++++
> >  drivers/md/dm-log-userspace-transfer.c |    3 +++
> >  drivers/staging/pohmelfs/config.c      |    3 +++
> >  drivers/video/uvesafb.c                |    3 +++
> >  4 files changed, 14 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
> > index 515bcd9..7717f8a 100644
> > --- a/drivers/block/drbd/drbd_nl.c
> > +++ b/drivers/block/drbd/drbd_nl.c
> > @@ -2297,6 +2297,11 @@ static void drbd_connector_callback(struct cn_msg *req, struct netlink_skb_parms
> >  		return;
> >  	}
> >  
> > +	if (current_user_ns() != &init_user_ns) {
> [...]
> >  	if (!cap_raised(current_cap(), CAP_SYS_ADMIN)) {
> [...]
> 
> Looks like it is an often pattern.  Maybe move both checks to a
> function?

This pattern is used 4 times (IIRC).  The reason I didn't break it out is
that it's very close to just 'capable(CAP_SYS_ADMIN)', which also checks
for CAP_SYS_ADMIN to the init_user_ns.  But the above, rightly or wrongly,
does not set the PF_SUPERPRIV task flag.  I don't want to advocate usage
of the above, and creating a helper for the above would both further
pollute the capability-related function namespace, and make the above
look more legitimate than I think it is.

Imo 'cap-raised(current_cap(), X)' should not be used at all.  But I
didn't want to deal with that here, just make it user-ns safe.

-serge
