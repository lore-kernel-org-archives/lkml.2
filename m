Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775Ab1CVFIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 01:08:47 -0400
Received: from SMTP.ANDREW.CMU.EDU ([128.2.11.61]:34746 "EHLO
	smtp.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab1CVFIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 01:08:45 -0400
Date: Tue, 22 Mar 2011 01:08:21 -0400
From: Ben Blum <bblum@andrew.cmu.edu>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, akpm@linux-foundation.org,
        ebiederm@xmission.com, lizf@cn.fujitsu.com, matthltc@us.ibm.com,
        oleg@redhat.com, David Rientjes <rientjes@google.com>,
        Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH v8 3/3] cgroups: make procs file writable
Message-ID: <20110322050821.GA11447@ghc17.ghc.andrew.cmu.edu>
References: <20110208013542.GC31569@ghc17.ghc.andrew.cmu.edu>
 <20110208013950.GF31569@ghc17.ghc.andrew.cmu.edu>
 <AANLkTinEnNsu8=PEktXL_EECzGYqsgdf+uogGxe7k4W+@mail.gmail.com>
 <20110310061831.GA23736@ghc17.ghc.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110310061831.GA23736@ghc17.ghc.andrew.cmu.edu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-PMX-Version: 5.5.9.388399, Antispam-Engine: 2.7.2.376379, Antispam-Data: 2011.3.18.170322
X-SMTP-Spam-Clean: 8% (
 FROM_SAME_AS_TO 0.05, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_1300_1399 0, BODY_SIZE_2000_LESS 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CD 0, __CT 0, __CT_TEXT_PLAIN 0, __FROM_SAME_AS_TO2 0, __HAS_MSGID 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0, __TO_MALFORMED_2 0, __USER_AGENT 0)
X-SMTP-Spam-Score: 8%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 01:18:31AM -0500, Ben Blum wrote:
> > > + ? ? ? ? ? ? ? ? ? ? ? /* optimization for the single-task-only case */
> > > + ? ? ? ? ? ? ? ? ? ? ? rcu_read_unlock();
> > > + ? ? ? ? ? ? ? ? ? ? ? cgroup_unlock();
> > > ? ? ? ? ? ? ? ? ? ? ? ?return -ESRCH;
> > > ? ? ? ? ? ? ? ?}
> > >
> > > + ? ? ? ? ? ? ? /*
> > > + ? ? ? ? ? ? ? ?* even if we're attaching all tasks in the thread group, we
> > > + ? ? ? ? ? ? ? ?* only need to check permissions on one of them.
> > > + ? ? ? ? ? ? ? ?*/
> > > ? ? ? ? ? ? ? ?tcred = __task_cred(tsk);
> > > ? ? ? ? ? ? ? ?if (cred->euid &&
> > > ? ? ? ? ? ? ? ? ? ?cred->euid != tcred->uid &&
> > > ? ? ? ? ? ? ? ? ? ?cred->euid != tcred->suid) {
> > > ? ? ? ? ? ? ? ? ? ? ? ?rcu_read_unlock();
> > > + ? ? ? ? ? ? ? ? ? ? ? cgroup_unlock();
> > > ? ? ? ? ? ? ? ? ? ? ? ?return -EACCES;
> > 
> > Maybe turn these returns into "goto out;" statements and put the
> > unlock after the out: label?
> > 
> 
> Maybe; I didn't look too hard at that function. If I revise the patch I
> can do this, though.

Looking back, I think I like it the way it is. Coalescing those unlock
paths would make it less clear... rcu_read is unlocked in the middle of
the function (on the success path), so having a bailout path moves the
failure path far removed from where it's relevant.

-- Ben
