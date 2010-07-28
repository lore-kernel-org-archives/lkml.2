Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0G1Iao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 04:30:44 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.61]:53821 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428Ab0G1Ial (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 04:30:41 -0400
Date: Wed, 28 Jul 2010 04:29:53 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        akpm@linux-foundation.org, ebiederm@xmission.com, lizf@cn.fujitsu.com,
        matthltc@us.ibm.com, menage@google.com, oleg@redhat.com
Subject: Re: [RFC] [PATCH v3 1/2] cgroups: read-write lock CLONE_THREAD
 forking per threadgroup
Message-ID: <20100728082953.GA15455@ghc01.ghc.andrew.cmu.edu>
References: <20100625054541.GA20610@ghc01.ghc.andrew.cmu.edu>
 <20100625054654.GB20610@ghc01.ghc.andrew.cmu.edu>
 <20100628161031.a8c71fce.kamezawa.hiroyu@jp.fujitsu.com>
 <20100628154359.GA24629@ghc01.ghc.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100628154359.GA24629@ghc01.ghc.andrew.cmu.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.7.28.81815
X-SMTP-Spam-Clean: 8% (
 FROM_SAME_AS_TO 0.05, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1400_1499 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __FRAUD_MONEY 0, __FRAUD_MONEY_VALUE 0, __FROM_SAME_AS_TO2 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 11:43:59AM -0400, Ben Blum wrote:
> On Mon, Jun 28, 2010 at 04:10:31PM +0900, KAMEZAWA Hiroyuki wrote:
> > By the way, IMHO, hiding lock in cgroup_fork() and cgroup_post_fork() doesn't
> > seem good idea. How about a code like this ?
> > 
> >   read_lock_thread_clone(current);
> >   cgroup_fork();
> >  .....
> >   cgroup_post_fork();
> >   read_unlock_thrad_clone(current);
> > 
> > We may have chances to move these lock to better position if cgroup is
> > an only user.
> 
> I didn't do that out of a desire to change fork.c as little as possible,
> but that does look better than what I've got. Those two functions should
> be in fork.c under #ifdef CONFIG_CGROUPS.

I'm looking at this now and am not sure where the best place to put
these is:

1) Don't make new functions, just put:

    #ifdef CONFIG_CGROUPS
        if (clone_flags & CLONE_THREAD)
            down/up_read(...);
    #endif

directly in copy_process() in fork.c. Simplest, but uglifies the code.

2) Make static helper functions in fork.c. Good, but not consistent with
directly using the lock in write-side (attach_proc).

3) Define inline functions under #ifdef CONFIG_CGROUPS in sched.h, just
under the declaration of the lock. Most robust, but I'm hesitant to add
unneeded stuff to such a popular header file.

Any opinions?

-- Ben

> 
> > 
> > Thanks,
> > -Kame
> 
> Thanks,
> -- Ben
> 
