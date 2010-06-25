Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab0FYMXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 08:23:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab0FYMXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 08:23:15 -0400
Date: Fri, 25 Jun 2010 14:21:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] pid_ns: Fix proc_flush_task() accessing freed
	proc_mnt
Message-ID: <20100625122118.GA5341@redhat.com>
References: <20100623203652.GA25298@redhat.com> <1277399329-18087-1-git-send-email-louis.rilling@kerlabs.com> <20100624191843.GA14205@redhat.com> <20100625102303.GG3773@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100625102303.GG3773@hawkmoon.kerlabs.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25, Louis Rilling wrote:
>
> On 24/06/10 21:18 +0200, Oleg Nesterov wrote:
> >
> > and this adds the extra code to alloc/free pidmap.
>
> Hopefully this is not much in alloc_pidmap() since we can expect that nr_pids
> and last_pid are in the same cache line.

This also adds atomic op. But I mostly dislike the pid-ns-specific
complications itself (including the mount-after-the-first-alloc_pid
dependancy), not the minor perfomance penalty.

But see below...

> > And, this subjective, yes, but it looks a bit strange that upid->nr
> > has a reference to proc_mnt.
>
> I presume that you wanted to say upid->ns.

I meant ns->nr_pids ;)

> This last point is what made me worry about your approach so far, although I did
> not take time to spot the precise issues. Unfortunately I don't see what the
> checks you added in proc_self_readlink(), proc_self_follow_link() and
> proc_pid_lookup() buy. What does prevent destroy_pid_namespace() from running
> concurrently? Maybe RCU could help in those cases?

Very good point. And the strong argument against this approach.

> Moreover, I think that proc_pid_readdir() should get some check too.

Well, it checks ->reaper != NULL, that is why I don't verify ns.

But yes, we have the same race (races) you pointed out here.

>     void pid_ns_release_proc(struct pid_namespace *ns)
>     {
> 	struct inode *root_inode;
>
> 	if (ns->proc_mnt) {
> 		root_inode = ns->proc_mnt->mnt_sb->s_root->d_inode;
>
> 		mutex_lock(&root_inode->i_mutex);
> 		ns->proc_mnt->mnt_sb->s_fs_info = NULL;
> 		PROC_I(root_inode)->pid = NULL;
> 		mutex_unlock(&root_inode->i_mutex);
>
> 		mntput(ns->proc_mnt);
> 	}
>     }
>
>   This would also solve the issue for proc_pid_lookup() btw.

Looks like you are right, but this doesn't help proc_self_readlink().

I think we can fix all these problems, but I no longer think this
approach can pretend to simplify the code. No, it will make the
code more complex/ugly and potentially more buggy.

Louis, thank you very much.

Oleg.

