Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450Ab0FAPf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 11:35:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756924Ab0FAPfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 11:35:54 -0400
Subject: Re: [PATCH v2] fs: block cross-uid sticky symlinks
From: Eric Paris <eparis@redhat.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
In-Reply-To: <20100601145251.GP4098@outflux.net>
References: <20100531030402.GQ6056@outflux.net>
	 <20100531103510.GA30021@infradead.org> <20100531175733.GD4098@outflux.net>
	 <alpine.LRH.2.00.1006010904190.675@tundra.namei.org>
	 <20100601032423.GL4098@outflux.net> <20100601075529.GA11397@infradead.org>
	 <1275393302.2690.13.camel@localhost>  <20100601145251.GP4098@outflux.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Jun 2010 11:34:37 -0400
Message-ID: <1275406477.2690.56.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-01 at 07:52 -0700, Kees Cook wrote:
> On Tue, Jun 01, 2010 at 07:55:02AM -0400, Eric Paris wrote:
> > On Tue, 2010-06-01 at 03:55 -0400, Christoph Hellwig wrote:
> > > On Mon, May 31, 2010 at 08:24:23PM -0700, Kees Cook wrote:
> > 
> > > > My rationale is that if it's in commoncaps, it's effective for everyone, so
> > > > it might as well be in core VFS.  If the VFS objections really do boil down
> > > > to "not in fs/" then I'm curious if doing this in commoncaps is acceptable.
> > > 
> > > If you think the objection is about having things in fs/ you're smoking
> > > some really bad stuff.
> > 
> > Sounds to me like we should probably follow the same path as
> > mmap_min_addr.  We should add these hooks right in the VFS where they
> > belong (much like mmap_min_addr hooks into the vm) and control them 2
> > ways.
> > 
> > 1) a Kconfig so distros can choose to turn it on or off by default
> > 2) a /proc interface so root can turn it off
> > 
> > Nothing about that precludes additional similar checks inside an LSM
> > (like CONFIG_LSM_MMAP_MIN_ADDR) which can be more finely controlled.  So
> > maybe we want to follow up with the core VFS check with new checks in
> > SELinux (and maybe apparmour).  This allows the user to disable the
> > general check and still be provided with some modicum of protection.
> > You might ask why not ONLY do the check in SELinux and drop the generic
> > check, but we have seen with mmap_min_addr that the SELinux unconfined
> > user can do damn well anything it wants to, so having a non-LSM version
> > of appropriate security checks is highly regarded.
> 
> Would a CONFIG for this be overkill?  mmap_min_addr is a little different
> in that there was desire to control a bottom limit on it, etc.  Given this
> is either "on" or "off", I think just a sysctl is needed?

Seems like one of Alan's main arguments is that you should not turn it
on 'by default.'  I assume most distros will want it on by default.
Alan made the same argument against mmap_min_addr (known to break dos
emu) but I think most major distros have it on by default these days
even if it does break those weird obscure use cases.  I guess distros
can do it through sysctl but Fedora, at least, likes to keep those
default if possible, which is why I suggested the CONFIG.  In any case,
putting this right square in the VFS where it happens makes the most
sense to me.

I'd also like to point out that I don't buy the argument that per
user /tmp/ is a 'better' solution for the general case.  Any application
that would be broken by this change will also be broken by per
user /tmp.  Now, if we used filesystem namespaces regularly for years
and users, administrators, and developers dealt with them often I agree
that would probably be the preferred solution.  It would solve this
issue, but in introduces a whole host of other problems that are even
more obvious and even likely to bite people.

I probably would move the security hook down into __do_follow_link and
put this check down there as well, but I think you still have a problem
with d_parent.  I don't see what keeps d_parent from being freed while
you are using it....

-Eric

