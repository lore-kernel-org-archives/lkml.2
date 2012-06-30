Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab2F3GZE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 02:25:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53651 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab2F3GZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 02:25:02 -0400
Date: Sat, 30 Jun 2012 07:24:53 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 0/4] Was: deferring __fput()
Message-ID: <20120630062453.GA14083@ZenIV.linux.org.uk>
References: <20120623203800.GA10306@redhat.com>
 <20120623210141.GK14083@ZenIV.linux.org.uk>
 <20120624041652.GN14083@ZenIV.linux.org.uk>
 <20120624153310.GB24596@redhat.com>
 <20120625060357.GT14083@ZenIV.linux.org.uk>
 <20120625151812.GA16062@redhat.com>
 <20120627183721.GA23086@redhat.com>
 <20120628043836.GW14083@ZenIV.linux.org.uk>
 <20120628162253.GA25357@redhat.com>
 <20120628164539.GA26350@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120628164539.GA26350@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 28, 2012 at 06:45:39PM +0200, Oleg Nesterov wrote:
> Forgot to mention...
> 
> And I still think that task_work_add() should not succeed unconditionally,
> it synchronize with exit_task_work(). Otherwise keyctl_session_to_parent()
> is broken.

Hmm...  Look: if nothing else, we have
        /* the parent mustn't be init and mustn't be a kernel thread */
        if (parent->pid <= 1 || !parent->mm)
                goto unlock;
in the caller.  OTOH, on the exit side we have exit_mm() done first.  And
that will have ->mm set to NULL.  So we are closing a very narrow race to start
with.  So why not do the following and be done with that?

diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 0291b3f..f1b59ae 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1486,6 +1486,7 @@ long keyctl_session_to_parent(void)
 	oldwork = NULL;
 	parent = me->real_parent;
 
+	task_lock(parent);
 	/* the parent mustn't be init and mustn't be a kernel thread */
 	if (parent->pid <= 1 || !parent->mm)
 		goto unlock;
@@ -1529,6 +1530,7 @@ long keyctl_session_to_parent(void)
 	if (!ret)
 		newwork = NULL;
 unlock:
+	task_unlock(parent);
 	write_unlock_irq(&tasklist_lock);
 	rcu_read_unlock();
 	if (oldwork)
