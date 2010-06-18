Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab0FRPpw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 11:45:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab0FRPpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 11:45:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <201006180308.o5I38O34094551@www262.sakura.ne.jp>
References: <201006180308.o5I38O34094551@www262.sakura.ne.jp>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2.6.29.6 - 2.6.35-rc3] CRED: Release spinlock before commit_creds().
Date: Fri, 18 Jun 2010 16:45:43 +0100
Message-ID: <21796.1276875943@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp> wrote:

> reparent_to_kthreadd() is calling commit_creds() with tasklist_lock held.
> But commit_creds() calls
> key_fsuid_changed()/key_fsgid_changed()/proc_id_connector() which may sleep.
> Release tasklist_lock before calling commit_creds().

Hmmm...  Does this change leave a hole in which the thread can be accessed as
it's not locked away, but still has the old credentials?

I wonder if we should have an internal CLONE_KTHREAD flag to achieve this in
do_fork() rather than daemonize()'ing the thread later.

Also, key_fsuid_changed() and key_fsgid_changed() should be skipped in
commit_creds() if the thread-keyring pointer in the new creds is not the same
as that in the old creds (as will be the case if we're shifting to init_cred),
so they shouldn't really be a problem.

However, I can't see an easy way around proc_id_connector() sleeping - unless
we just don't call it if new == &init_cred in commit_creds().

I suppose it also leaves a hole if we call commit_creds() first, before
getting the write_lock()... :-/

David
