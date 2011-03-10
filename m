Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab1CJGTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 01:19:12 -0500
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.61]:52751 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1CJGTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 01:19:11 -0500
Date: Thu, 10 Mar 2011 01:18:31 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: Paul Menage <menage@google.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, akpm@linux-foundation.org,
        ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com,
        oleg@redhat.com, David Rientjes <rientjes@google.com>,
        Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH v8 3/3] cgroups: make procs file writable
Message-ID: <20110310061831.GA23736@ghc17.ghc.andrew.cmu.edu>
References: <20110208013542.GC31569@ghc17.ghc.andrew.cmu.edu>
 <20110208013950.GF31569@ghc17.ghc.andrew.cmu.edu>
 <AANLkTinEnNsu8=PEktXL_EECzGYqsgdf+uogGxe7k4W+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinEnNsu8=PEktXL_EECzGYqsgdf+uogGxe7k4W+@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.3.10.55419
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_5000_5999 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS , __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 03, 2011 at 10:38:58AM -0800, Paul Menage wrote:
> On Mon, Feb 7, 2011 at 5:39 PM, Ben Blum <bblum@andrew.cmu.edu> wrote:
> > Makes procs file writable to move all threads by tgid at once
> >
> > From: Ben Blum <bblum@andrew.cmu.edu>
> >
> > This patch adds functionality that enables users to move all threads in a
> > threadgroup at once to a cgroup by writing the tgid to the 'cgroup.procs'
> > file. This current implementation makes use of a per-threadgroup rwsem that's
> > taken for reading in the fork() path to prevent newly forking threads within
> > the threadgroup from "escaping" while the move is in progress.
> >
> > Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
> > ---
> > + ? ? ? /* remember the number of threads in the array for later. */
> > + ? ? ? BUG_ON(i == 0);
> 
> This BUG_ON() seems unnecessary, given the i++ directly above it.

It's meant to communicate that the loop must go through at least once,
so that 'struct cgroup *oldcgrp' will be initialised within a loop later
(setting it to NULL in the beginning is just to shut up the compiler.)

> 
> > + ? ? ? group_size = i;
> > + ? ? ? rcu_read_unlock();
> > +
> > + ? ? ? /*
> > + ? ? ? ?* step 1: check that we can legitimately attach to the cgroup.
> > + ? ? ? ?*/
> > + ? ? ? for_each_subsys(root, ss) {
> > + ? ? ? ? ? ? ? if (ss->can_attach) {
> > + ? ? ? ? ? ? ? ? ? ? ? retval = ss->can_attach(ss, cgrp, leader);
> > + ? ? ? ? ? ? ? ? ? ? ? if (retval) {
> > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? failed_ss = ss;
> > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? goto out_cancel_attach;
> > + ? ? ? ? ? ? ? ? ? ? ? }
> > + ? ? ? ? ? ? ? }
> > + ? ? ? ? ? ? ? /* a callback to be run on every thread in the threadgroup. */
> > + ? ? ? ? ? ? ? if (ss->can_attach_task) {
> > + ? ? ? ? ? ? ? ? ? ? ? /* run on each task in the threadgroup. */
> > + ? ? ? ? ? ? ? ? ? ? ? for (i = 0; i < group_size; i++) {
> > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? retval = ss->can_attach_task(cgrp, group[i]);
> > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? if (retval) {
> > + ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? failed_ss = ss;
> 
> Should we be setting failed_ss here? Doesn't that mean that if all
> subsystems pass the can_attach() check but the first one fails a
> can_attach_task() check, we don't call any cancel_attach() methods?
> 
> What are the rollback semantics for failing a can_attach_task() check?

They are not called in that order - it's for_each_subsys { can_attach();
can_attach_task(); }. Although if the deal is that cancel_attach reverts
the things that can_attach does (and can_attach_task is separate) (is
this the case? it should probably go in the documentation), then passing
a can_attach and failing a can_attach_task should cause cancel_attach to
get called for that subsystem, which in this code it doesn't. Something
like:

    retval = ss->can_attach();
    if (retval) {
        failed_ss = ss;
        goto out_cancel_attach;
    }
    retval = ss->can_attach_task();
    if (retval) {
        failed_ss = ss;
        cancel_extra_ss = true;
        goto out_cancel_attach;
    }
    ...
    out_cancel_attach:
    if (retval) {
        for_each_subsys(root, ss) {
            if (ss == failed_ss) {
                if (cancel_extra_ss)
                    ss->cancel_attach();
                break;
            }
            ss->cancel_attach();
        }
    }

> 
> > + ? ? ? ? ? ? ? if (threadgroup) {
> > + ? ? ? ? ? ? ? ? ? ? ? /*
> > + ? ? ? ? ? ? ? ? ? ? ? ?* it is safe to find group_leader because tsk was found
> > + ? ? ? ? ? ? ? ? ? ? ? ?* in the tid map, meaning it can't have been unhashed
> > + ? ? ? ? ? ? ? ? ? ? ? ?* by someone in de_thread changing the leadership.
> > + ? ? ? ? ? ? ? ? ? ? ? ?*/
> > + ? ? ? ? ? ? ? ? ? ? ? tsk = tsk->group_leader;
> > + ? ? ? ? ? ? ? ? ? ? ? BUG_ON(!thread_group_leader(tsk));
> 
> Can this race with an exiting/execing group leader?

No, rcu_read_lock() is held.

> 
> > + ? ? ? ? ? ? ? } else if (tsk->flags & PF_EXITING) {
> 
> The check for PF_EXITING doesn't apply to group leaders?

I remember discussing this bit a while back - the point that if the
leader is PF_EXITING, that we should still iterate over its group list.
(However, I did try to test it, and it looks like if a leader calls
sys_exit() then the whole group goes away; is this actually guaranteed?)

> 
> > + ? ? ? ? ? ? ? ? ? ? ? /* optimization for the single-task-only case */
> > + ? ? ? ? ? ? ? ? ? ? ? rcu_read_unlock();
> > + ? ? ? ? ? ? ? ? ? ? ? cgroup_unlock();
> > ? ? ? ? ? ? ? ? ? ? ? ?return -ESRCH;
> > ? ? ? ? ? ? ? ?}
> >
> > + ? ? ? ? ? ? ? /*
> > + ? ? ? ? ? ? ? ?* even if we're attaching all tasks in the thread group, we
> > + ? ? ? ? ? ? ? ?* only need to check permissions on one of them.
> > + ? ? ? ? ? ? ? ?*/
> > ? ? ? ? ? ? ? ?tcred = __task_cred(tsk);
> > ? ? ? ? ? ? ? ?if (cred->euid &&
> > ? ? ? ? ? ? ? ? ? ?cred->euid != tcred->uid &&
> > ? ? ? ? ? ? ? ? ? ?cred->euid != tcred->suid) {
> > ? ? ? ? ? ? ? ? ? ? ? ?rcu_read_unlock();
> > + ? ? ? ? ? ? ? ? ? ? ? cgroup_unlock();
> > ? ? ? ? ? ? ? ? ? ? ? ?return -EACCES;
> 
> Maybe turn these returns into "goto out;" statements and put the
> unlock after the out: label?
> 

Maybe; I didn't look too hard at that function. If I revise the patch I
can do this, though.

Thanks,
Ben
