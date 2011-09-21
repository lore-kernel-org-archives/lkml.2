Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab1IUTMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 15:12:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46256 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab1IUTMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 15:12:46 -0400
Date: Wed, 21 Sep 2011 14:12:38 -0500
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, richard@nod.at,
        Andrew Morton <akpm@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
        serge@hallyn.com, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] user namespace: usb: make usb urbs user namespace aware
 (v2)
Message-ID: <20110921191238.GA16720@sergelap>
References: <20110919214531.GA18085@sergelap>
 <20110919214700.GA22300@sergelap>
 <20110920131738.GA29852@redhat.com>
 <20110921050127.GB6691@sergelap>
 <20110921183101.GB25590@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921183101.GB25590@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> On 09/21, Serge E. Hallyn wrote:
> >
> > Add to the dev_state and alloc_async structures the user namespace
> > corresponding to the uid and euid.  Pass these to kill_pid_info_as_uid(),
> > which can then implement a proper, user-namespace-aware uid check.
> 
> Looks correct.
> 
> 
> 
> But I have off-topic question. And in fact I am a bit confused,
> please help.
> 
> First of all, I assume that CLONE_NEWUSER is the only way to change
> ->user_ns, right?

Yes.

> And, looking at copy_creds() I think that cred->user_ns is always
> equal to cred->user->user_ns. However, grep shows a lot of
> cred->user->user_ns examples. Why?

Good question.  It's only because cred->user_ns is an optimization
recently introduced.  I think those can be safely switched over.

> > +static int kill_as_cred_perm(const struct cred *cred,
> > +			     struct task_struct *target)
> > +{
> > +	const struct cred *pcred = __task_cred(target);
> > +	if (cred->user_ns != pcred->user_ns)
> > +		return 0;
> 
> Should we really fail if cred->user_ns == pcred->user_ns->creator ?
> (or creator of creator, etc).
> 
> IOW, shouldn't this match kill_ok_by_cred() path which (at least
> cap_capable) checks the ->creator chain when ->user_ns differ?

I'm not sure.  We can relax that later if need be, but as this has to do
with usb urbs and userspace drivers, I don't think we'll want to.
Hopefully we can talk with Greg KH about it at some point.  But for now,
with this patch, all interactions between tasks in the initial user
namespace will continue as normal, and we're not allowing anything
untoward between user namespaces, so I think this is best.

Drat.  Greg, sorry about not Cc:ing you on the original patch.  Please
let me know if you'd like me to resend to you.

thanks,
-serge
