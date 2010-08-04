Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab0HDAjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 20:39:48 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:55405 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932233Ab0HDAjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 20:39:46 -0400
Message-Id: <201008040038.o740cg2E031196@www262.sakura.ne.jp>
Subject: Re: [PATCH 2/2] CRED: Fix __task_cred()'s lockdep check and banner comment
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: dhowells@redhat.com
Cc: paulmck@linux.vnet.ibm.com, torvalds@osdl.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        jolsa@redhat.com
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Aug 2010 09:38:42 +0900
References: <201008030055.o730tgXK091413@www262.sakura.ne.jp> <20100729114549.29508.44899.stgit@warthog.procyon.org.uk> <20100729114555.29508.4525.stgit@warthog.procyon.org.uk> <20100802204000.GH2405@linux.vnet.ibm.com> <30552.1280828047@redhat.com>
In-Reply-To: <30552.1280828047@redhat.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 27072010 #3944634, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Tetsuo Handa wrote:
> 
> > I got below warning. Is this related to this patch?
> > 
> > [  140.173556] ===================================================
> > [  140.215379] [ INFO: suspicious rcu_dereference_check() usage. ]
> > [  140.216461] ---------------------------------------------------
> > [  140.217530] kernel/signal.c:660 invoked rcu_dereference_check() without protection!
> 
> Yes.  The patch has uncovered a case of where we should be holding a lock, but
> aren't.
> 
> Can you try the attached patch?
> 
> David
> ---
> From: David Howells <dhowells@redhat.com>
> Subject: [PATCH] CRED: Fix RCU warning due to previous patch fixing __task_cred()'s checks
> 
> A previous patch:
> 
> 	commit 8f92054e7ca1d3a3ae50fb42d2253ac8730d9b2a
> 	Author: David Howells <dhowells@redhat.com>
> 	Date:   Thu Jul 29 12:45:55 2010 +0100
> 	Subject: CRED: Fix __task_cred()'s lockdep check and banner comment
> 
> fixed the lockdep checks on __task_cred().  This has shown up a place in the
> signalling code where a lock should be held - namely that
> check_kill_permission() requires its callers to hold the RCU lock.
> 
> It's may be that it would be better to add RCU read lock calls in
> group_send_sig_info() only, around the call to check_kill_permission().  On the
> other hand, some of the callers are either holding the RCU read lock already,
> or have disabled interrupts, in which case, it's just extra overhead to do it
> in g_s_s_i().

That patch solved the warning. Thank you.
