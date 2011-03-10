Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab1CJUZi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 15:25:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36517 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275Ab1CJUZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 15:25:37 -0500
Date: Thu, 10 Mar 2011 12:25:17 -0800
From: Tony Jones <tonyj@suse.de>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: PATCH [1/1]: audit: acquire creds selectively to reduce atomic
 op overhead
Message-ID: <20110310202516.GA16122@suse.de>
References: <20110307210656.GA1750@suse.de>
 <18893.1299607373@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18893.1299607373@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 08, 2011 at 06:02:53PM +0000, David Howells wrote:
> Tony Jones <tonyj@suse.de> wrote:
> 
> > Commit c69e8d9c01db added calls to get_task_cred and put_cred in
> > audit_filter_rules.  Profiling with a large number of audit rules active on
> > the exit chain shows that we are spending upto 48% in this routine for
> > syscall intensive tests, most of which is in the atomic ops.
> > 
> > The following patch acquires the cred if a rule requires it.  In our
> > particular case above, most rules had no cred requirement and this dropped
> > the time spent in audit_filter_rules down to ~12%.  An alternative would be
> > for the caller to acquire the cred just once for the whole chain and pass
> > into audit_filter_rules.  I can create an alternate patch doing this if
> > required.
> 
> There's no actual need to get a ref on the named task's creds.
> 
> If tsk == current, no locking is needed at all.
> 
> If tsk != current, the RCU read lock is sufficient.  See task_cred_xxx() in
> include/linux/cred.h.
> 
> Hmmm...  I wonder...  The audit filter uses tsk->real_cred, but is that
> correct?  Should it be using tsk->cred?  And is tsk always going to be
> current?

Hi David.

I'm not seeing the 'tsk->real_cred' usage, can you clarify?

I went through the call tree.  Assuming my analysis is correct the only case 
where it's not current is the calls from copy_process.  I believe there is no 
need for rcu in this case either.

Tony

------

audit_filter_rules
	<- audit_filter_task
		<- audit_alloc
			<- copy_process

	<- audit_filter_syscall
		<- audit_get_context 
			<- audit_free 
				<- copy_process (error path)
				<- do_exit (tsk == current)
			<- audit_syscall_exit (tsk == current)

		<- audit_syscall_entry (tsk == current)

	<- audit_filter_inodes
		<- audit_update_watch (tsk == current)
		<- audit_get_context (see above)
