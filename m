Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100Ab1IHAAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 20:00:32 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.96]:34112 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742Ab1IHAAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 20:00:30 -0400
Date: Wed, 7 Sep 2011 19:59:31 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ben Blum <bblum@andrew.cmu.edu>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, neilb@suse.de,
        paul@paulmenage.org, paulmck@linux.vnet.ibm.com
Subject: Re: +
 cgroups-more-safe-tasklist-locking-in-cgroup_attach_proc.patch added to
 -mm tree
Message-ID: <20110907235931.GA22545@unix33.andrew.cmu.edu>
References: <201109012108.p81L8X0b029484@imap1.linux-foundation.org>
 <20110902123706.GB26764@redhat.com>
 <20110902140015.GA31530@redhat.com>
 <20110902141550.GA24012@unix33.andrew.cmu.edu>
 <20110902155534.GA4595@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902155534.GA4595@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2010.4.9.4220
X-SMTP-Spam-Clean: 8% (
 BODY_SIZE_1800_1899 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 02, 2011 at 05:55:34PM +0200, Oleg Nesterov wrote:
> On 09/02, Ben Blum wrote:
> >
> > On Fri, Sep 02, 2011 at 04:00:15PM +0200, Oleg Nesterov wrote:
> > > Forgot to mention, sorry...
> > >
> > > That said, I believe the patch is correct and should fix the problem.
> >
> > Thanks!
> >
> > But I don't think the check becomes pointless? If a sub-thread execs
> > right before read_lock(&tasklist_lock) (but after the find_task_by_vpid
> > in attach_task_by_pid), that causes the case that the comment refers to.
> 
> How so? The comment says:
> 
> 	* a race with de_thread from another thread's exec() may strip
> 	* us of our leadership, making while_each_thread unsafe
> 
> This is not true.

Sorry, the comment is unclear. The reason I think this is necessary is
if de_thread happens, the leader would fall off the thread-group list:

de_thread()
=> release_task(leader)
=> __exit_signal(leader)
=> __unhash_process(leader, false)
=> list_del_rcu(&leader->thread_group)

which is the same list that while_each_thread() iterates over.

and this looks like an unconditionally taken path?

> 
> And. Given that ->group_leader can be changed right after we drop tasklist
> this check is pointless. Yes, it can detect the case when this task_struct
> has nothing to do with this process sometimes, but not in general. (This
> connects to other problems I mentioned).

I agree there is a problem later with the ss->attach(leader) calls.

If the above reasoning is right, though, it's necessary here, and also
guarantees that that the later iteration (in cgroup_attach_proc's "step
3") accurately reflects all threads in the group.

Thanks,
Ben

> 
> IOW, personally I think it would be better to update the patch. But I
> won't insist.
> 
> Oleg.
> 
> 


