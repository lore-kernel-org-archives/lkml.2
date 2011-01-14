Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751636Ab1ANTvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 14:51:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab1ANTvD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 14:51:03 -0500
Subject: Re: [PATCH] System Wide Capability Bounding Set
From: Eric Paris <eparis@redhat.com>
To: "Serge E. Hallyn" <serge@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        sgrubb@redhat.com, Andrew Morgan <morgan@kernel.org>
Date: Fri, 14 Jan 2011 14:50:57 -0500
In-Reply-To: <20110111220201.GA6446@localhost>
References: <1294266337.3237.45.camel@localhost.localdomain>
	 <20110111220201.GA6446@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Message-ID: <1295034658.2816.16.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-11 at 16:02 -0600, Serge E. Hallyn wrote:
> Quoting Eric Paris (eparis@redhat.com):

> > @@ -305,6 +310,8 @@ static inline int bprm_caps_from_vfs_caps(struct cpu_vfs_cap_data *caps,
> >  		new->cap_permitted.cap[i] =
> >  			(new->cap_bset.cap[i] & permitted) |
> >  			(new->cap_inheritable.cap[i] & inheritable);
> > +		/* the global set is global damn it */
> > +		new->cap_permitted.cap[i] &= global_cap_bset.cap[i];
> 
> [ If I'm thinking right: ]
> 
> Global may be global, but you're changing the formula (here, for a
> non-root task executing a file with filecaps) from
> 
> 	pP' = (X & fP) | (pI & fI)
> 
> to
> 
> 	A  = (X & FP) | (pI & fI)
> 	pP'= Z & A                    // Z == global bounding set
> 
> In other words, you are not simply enforcing "the intersection of
> the global and per-process bounding sets".
> 
> Whereas,
> 
> >  		if (permitted & ~new->cap_permitted.cap[i])
> >  			/* insufficient to execute correctly */
> > @@ -438,6 +445,9 @@ int cap_bprm_set_creds(struct linux_binprm *bprm)
> >  		return ret;
> >  
> >  	if (!issecure(SECURE_NOROOT)) {
> > +		kernel_cap_t bset = cap_intersect(old->cap_bset,
> > +						  global_cap_bset);
> > +
> >  		/*
> >  		 * If the legacy file capability is set, then don't set privs
> >  		 * for a setuid root binary run by a non-root user.  Do set it
> > @@ -456,8 +466,7 @@ int cap_bprm_set_creds(struct linux_binprm *bprm)
> >  		 */
> >  		if (new->euid == 0 || new->uid == 0) {
> >  			/* pP' = (cap_bset & ~0) | (pI & ~0) */
> > -			new->cap_permitted = cap_combine(old->cap_bset,
> > -							 old->cap_inheritable);
> > +			new->cap_permitted = cap_combine(bset, old->cap_inheritable);
> 
> here (for a root task) you are using 
> 
> 	pP' = (Z & X) | pI
> 
> So the inheritable tasks get masked with the global bounding set for
> non-root tasks, but not for root tasks.

I believe you are thinking correctly and I am wrong.  Someone else has
some other issues with the patch but would prefer to keep that
conversation offline.  I will certainly be back with changes and
explanation of changes (hopefully shortly)

Thanks Serge!

-Eric

