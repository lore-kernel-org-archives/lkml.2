Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab1BXAys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 19:54:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753854Ab1BXAyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 19:54:46 -0500
Date: Wed, 23 Feb 2011 16:54:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
Subject: Re: [PATCH 4/9] allow killing tasks in your own or child userns
Message-Id: <20110223165430.863753f4.akpm@linux-foundation.org>
In-Reply-To: <20110224004818.GA11822@mail.hallyn.com>
References: <20110217150224.GA26334@mail.hallyn.com>
	<20110217150325.GD26395@mail.hallyn.com>
	<20110218155921.440f1137.akpm@linux-foundation.org>
	<20110224004818.GA11822@mail.hallyn.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011 00:48:18 +0000
"Serge E. Hallyn" <serge@hallyn.com> wrote:

> Quoting Andrew Morton (akpm@linux-foundation.org):
> > On Thu, 17 Feb 2011 15:03:25 +0000
> > "Serge E. Hallyn" <serge@hallyn.com> wrote:
> > 
> > >  /*
> > > + * called with RCU read lock from check_kill_permission()
> > > + */
> > > +static inline int kill_ok_by_cred(struct task_struct *t)
> > > +{
> > > +	const struct cred *cred = current_cred();
> > > +	const struct cred *tcred = __task_cred(t);
> > > +
> > > +	if (cred->user->user_ns == tcred->user->user_ns &&
> > > +	    (cred->euid == tcred->suid ||
> > > +	     cred->euid == tcred->uid ||
> > > +	     cred->uid  == tcred->suid ||
> > > +	     cred->uid  == tcred->uid))
> > > +		return 1;
> > > +
> > > +	if (ns_capable(tcred->user->user_ns, CAP_KILL))
> > > +		return 1;
> > > +
> > > +	return 0;
> > > +}
> > 
> > The compiler will inline this for us.
> 
> Is that simply true with everything (worth inlining) nowadays, or is
> there a particular implicit hint to the compiler that'll make that
> happen?

We've basically stopped inlining things nowadays.  gcc inlines
aggressively and sometimes we have to use noinline to stop it.  Also,
modern gcc's like to ignore the inline directive anwyay, so we have to
resort to __always_inline when we disagree.


