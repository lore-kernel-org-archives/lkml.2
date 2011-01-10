Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab1AJWwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:52:08 -0500
Received: from adelie.canonical.com ([91.189.90.139]:44097 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab1AJWwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:52:06 -0500
Date: Mon, 10 Jan 2011 16:51:51 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Bastian Blank <bastian@waldi.eu.org>, "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <kees.cook@canonical.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 4/7] allow killing tasks in your own or child userns
Message-ID: <20110110225151.GA18944@localhost>
References: <20110110211135.GA22446@mail.hallyn.com>
 <20110110211334.GD22564@mail.hallyn.com>
 <20110110215240.GA21351@wavehammer.waldi.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110110215240.GA21351@wavehammer.waldi.eu.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Bastian Blank (bastian@waldi.eu.org):
> On Mon, Jan 10, 2011 at 09:13:34PM +0000, Serge E. Hallyn wrote:
> > +	const struct cred *cred = current_cred();
> > +	const struct cred *tcred = __task_cred(t);
> > +
> > +	if (cred->user->user_ns != tcred->user->user_ns) {
> > +		/* userids are not equivalent - either you have the
> > +		   capability to the target user ns or you don't */
> > +		if (ns_capable(tcred->user->user_ns, CAP_KILL))
> > +			return 1;
> > +		return 0;
> > +	}
> > +
> > +	/* same user namespace - usual credentials checks apply */
> > +	if ((cred->euid ^ tcred->suid) &&
> > +	    (cred->euid ^ tcred->uid) &&
> > +	    (cred->uid  ^ tcred->suid) &&
> > +	    (cred->uid  ^ tcred->uid) &&
> > +	    !ns_capable(tcred->user->user_ns, CAP_KILL))
> > +		return 0;
> > +
> > +	return 1;
> 
> Isn't that equal to this?
> 
> 	if (ns_capable(tcred->user->user_ns, CAP_KILL))
> 		return 1;
> 
> 	if (cred->user->user_ns == tcred->user->user_ns &&
> 	    (cred->euid == tcred->suid ||
> 	     cred->euid == tcred->uid ||
> 	     cred->uid == tcred->suid ||
> 	     cred->uid == tcred->uid))
> 		return 1;
> 
> 	return 0;
> 
> I would consider this much easier to read.

Unfortunately, it's actually not equivalent.  when capable()
returns success, then it sets the current->flags |= PF_SUPERPRIV.
If permission is granted based on userids and the capability
isn't needed, then we don't want to needlessly set PF_SUPERPRIV.

That's why I'm going to such lengths to call capable() as a last
resort.

I'm definately open to any ideas that'll get the code cleaner.

thanks,
-serge
