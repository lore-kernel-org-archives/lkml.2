Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882Ab0K3L7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 06:59:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33816 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab0K3L7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 06:59:41 -0500
Date: Tue, 30 Nov 2010 12:58:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Marcus Meissner <meissner@suse.de>, linux-kernel@vger.kernel.org,
        tj@kernel.org, akpm@linux-foundation.org, hpa@zytor.com, w@1wt.eu
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
Message-ID: <20101130115851.GB9639@elte.hu>
References: <20101116104600.GA24015@suse.de>
 <20101119191906.GA31760@xanatos>
 <AANLkTi=OsWEdrfCOHKz+SAtqo7DmK0nNxku7Ev21f0Lh@mail.gmail.com>
 <20101126074809.GD19589@elte.hu>
 <20101129163308.GA2383@xanatos>
 <20101129233150.60a3c3af@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101129233150.60a3c3af@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > >  	/* Some debugging symbols have no name.  Ignore them. */
> > > -	if (!iter->name[0])
> > > +	if (!iter->name[0] || !capable(CAP_SYS_ADMIN))
> > >  		return 0;
> 
> This is hardcoding file permission policy into the kernel in a way the
> user cannot change - its bogus in the extreme. Use file permissions that
> way saner people can chmod them as they like. Indeed quite a few people
> *already* chmod chunks of /proc.

Peter already pointed that out and i agree.

The main goal here was to establish that a regression-free patch can be implemented 
by giving user-space a *empty /proc/kallsyms file* - that we older systems do not 
crash on bootup.

> It also means that things like SELinux and Tomoyo can be used to manage security 
> on it in clever ways - something that using a capability completely buggers up.

Frankly, our security interfaces are a mess - i did not even try to figure out the 
'right' way to do it. Modularization of security subsystem made it all distinctly 
worse.

Why dont we have coherent, easy to use (and hard to mess up) security interfaces to 
begin with? The moment a kernel developer has to think of:

        retval = -EPERM;
        if (capable(CAP_SETUID)) {
                new->suid = new->uid = uid;
                if (uid != old->uid) {
                        retval = set_user(new);
                        if (retval < 0)
                                goto error;
                }
        } else if (uid != old->uid && uid != new->suid) {
                goto error;
        }

        new->fsuid = new->euid = uid;

        retval = security_task_fix_setuid(new, old, LSM_SETID_ID);
        if (retval < 0)
                goto error;


As the 'secure' implementation of a piece of kernel logic we have lost the 
'security' battle ...

The current security callbacks are absolutely nonsensical random crap slapped all 
around the kernel. It increases our security complexity and has thus the opposite 
effect - it makes us _less_ secure.

Did no-one think of merging the capabilities checks and the security subsystem 
callbacks in some easy-to-use manner, which makes the default security policy 
apparent at first sight?

This code should be written in a simpler form, something like:

        retval = -EPERM;
	if (!security_allow_task_fix_setuid(new, old)) {
                new->suid = new->uid = uid;
                if (uid != old->uid) {
                        retval = set_user(new);
                        if (retval < 0)
                                goto error;
                }
        } else if (uid != old->uid && uid != new->suid) {
                goto error;
        }

        new->fsuid = new->euid = uid;

Where the default security_allow_task_fix_setuid() is basically a CAP_SETUID check - 
and we know this from the 'security_allow_task_fix_setuid' name already.

This way all those stupid, passive security callbacks become _active participants of 
the code_, and the code becomes more compact and easier to understand - and it 
becomes harder to mess up both compatibility details and permission details.

[ And yes, i realize that this isnt a 100% replacement of the existing callback,
  because some of the default logic cannot be turned off - but heck, that's a 
  feature not a bug! We dont want to allow security modules to make things _less_ 
  secure, or break legacies, right? So they should be shaped as _additional_
  restrictions on the coarse default semantics.

  And dont get me started about the idiocy of LSM_SETID_ID. Why isnt that detail put 
  into the callback name? What's wrong with security_task_fix_setuid_id(new, old)? ]

Whoever allowed security modules to be added in their current form needs some 
talking to.

Thanks,

	Ingo
