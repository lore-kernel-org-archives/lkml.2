Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab2C0PdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 11:33:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786Ab2C0PdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 11:33:10 -0400
Date: Tue, 27 Mar 2012 17:25:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: Re: [rfc] fcntl: Add F_GETOWNER_UIDS option
Message-ID: <20120327152534.GA18478@redhat.com>
References: <20120326150924.GG19395@moon> <20120326164347.GA24394@redhat.com> <20120326183330.GM19395@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120326183330.GM19395@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26, Cyrill Gorcunov wrote:
>
> On Mon, Mar 26, 2012 at 06:43:47PM +0200, Oleg Nesterov wrote:
> > On 03/26, Cyrill Gorcunov wrote:
> > >
> > > +#ifdef CONFIG_CHECKPOINT_RESTORE
> > > +static int f_getowner_uids(struct file *filp, unsigned long arg)
> > > +{
> > > +	struct user_namespace *user_ns = current_user_ns();
> > > +	const struct cred *cred = current_cred();
> > > +	uid_t * __user dst = (void * __user)arg;
> > > +	uid_t src[2];
> > > +	int err;
> > > +
> > > +	read_lock(&filp->f_owner.lock);
> > > +	src[0] = filp->f_owner.uid;
> > > +	src[1] = filp->f_owner.euid;
> > > +	read_unlock(&filp->f_owner.lock);
> > > +
> > > +	src[0] = user_ns_map_uid(user_ns, cred, src[0]);
> > > +	src[1] = user_ns_map_uid(user_ns, cred, src[1]);
> >
> > Why?
> >
> > In this case user_ns_map_uid() is "nop", it should always return
> > the last arg, no?
>
> Yes, but I wanted to be on safe side, and if one day user_ns_map_uid
> get changed this function won't be security hole.

Can't understand.

user_ns_map_uid() should translate uid_t from one namespace to another,
in this case the namespace is the same.

user_ns_map_uid(cred->user_ns, cred) must be the identical mapping,
no matter how we change the implementation.

What I think you need is
user_ns_map_uid(current_user_ns(), filp->f_owner.cred), the only
problem is that f_owner.cred doesn't exist.

> Or I miss something
> in general?

Or me. Add Serge, may be I missed something.

Oleg.

