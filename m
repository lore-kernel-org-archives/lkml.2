Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758774Ab1COVPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:15:24 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.61]:44231 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab1COVPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:15:22 -0400
Date: Tue, 15 Mar 2011 17:13:53 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Paul Menage <menage@google.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, akpm@linux-foundation.org,
        ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com,
        oleg@redhat.com, David Rientjes <rientjes@google.com>,
        Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH v8 3/3] cgroups: make procs file writable
Message-ID: <20110315211353.GA9992@ghc17.ghc.andrew.cmu.edu>
References: <20110208013542.GC31569@ghc17.ghc.andrew.cmu.edu>
 <20110208013950.GF31569@ghc17.ghc.andrew.cmu.edu>
 <AANLkTinEnNsu8=PEktXL_EECzGYqsgdf+uogGxe7k4W+@mail.gmail.com>
 <20110310061831.GA23736@ghc17.ghc.andrew.cmu.edu>
 <AANLkTikkmfwk0nV0p=omz2ddrw+ZqWF1Lx3EfO6dTjEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikkmfwk0nV0p=omz2ddrw+ZqWF1Lx3EfO6dTjEQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.3.15.205416
X-SMTP-Spam-Clean: 8% (
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS , __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 12:01:29PM -0800, Paul Menage wrote:
> On Wed, Mar 9, 2011 at 10:18 PM, Ben Blum <bblum@andrew.cmu.edu> wrote:
> >> This BUG_ON() seems unnecessary, given the i++ directly above it.
> >
> > It's meant to communicate that the loop must go through at least once,
> > so that 'struct cgroup *oldcgrp' will be initialised within a loop later
> > (setting it to NULL in the beginning is just to shut up the compiler.)
> 
> Right, but it's a do {} while() loop with no break in it - it's
> impossible to not go through at least once...

OK; I guess it can go.

> > Although if the deal is that cancel_attach reverts
> > the things that can_attach does (and can_attach_task is separate) (is
> > this the case? it should probably go in the documentation), then passing
> > a can_attach and failing a can_attach_task should cause cancel_attach to
> > get called for that subsystem, which in this code it doesn't. Something
> > like:
> >
> > ? ?retval = ss->can_attach();
> > ? ?if (retval) {
> > ? ? ? ?failed_ss = ss;
> > ? ? ? ?goto out_cancel_attach;
> > ? ?}
> > ? ?retval = ss->can_attach_task();
> > ? ?if (retval) {
> > ? ? ? ?failed_ss = ss;
> > ? ? ? ?cancel_extra_ss = true;
> > ? ? ? ?goto out_cancel_attach;
> > ? ?}
> 
> Yes, but maybe call the flag cancel_failed_ss? Slightly more obvious,
> to me at least.

Sounds good.

> >> > + ? ? ? ? ? ? ? ? ? ? ? BUG_ON(!thread_group_leader(tsk));
> >>
> >> Can this race with an exiting/execing group leader?
> >
> > No, rcu_read_lock() is held.
> >
> 
> But rcu_read_lock() doesn't stop any actions - it just stops the data
> structures from going away. Can't leadership change during an
> execve()?

Hmm, you may be right; my understanding of RCU is not complete. But
actually I think the BUG_ON should just be removed, since we're about to
drop locks before handing off to cgroup_attach_proc anyway (so at no
important part is the assertion guaranteed), which will detect and
EAGAIN if such a race happened.

> > (However, I did try to test it, and it looks like if a leader calls
> > sys_exit() then the whole group goes away; is this actually guaranteed?)
> 
> I think so, but maybe not instantaneously.
> 
> Paul
> 

Hmm, well, should I make this assumption, then? The code would not be
more complicated either way, really. I kind of prefer it as it is...

-- Ben
