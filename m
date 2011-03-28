Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab1C1IDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 04:03:38 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:55665 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751111Ab1C1IDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 04:03:35 -0400
X-Greylist: delayed 378 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Mar 2011 04:03:35 EDT
Date: Mon, 28 Mar 2011 08:56:54 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: __lock_task_sighand() and RCU
Message-ID: <20110328085654.26a75db6@mfleming-mobl1.ger.corp.intel.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

I've been reading __lock_task_sighand() and I can't quite wrap my head
around what the rcu_read_lock()/rcu_read_unlock() is protecting in
there.

Initially I assumed that it was protecting the 'tsk' argument, but
realised that can't be right because all rcu_read_lock() guarantees is
that if tsk is valid when we enter the read section, it will remain
valid throughout the rcu read side section. It doesn't guarantee that
when we enter the read side section 'tsk' _will_ be valid; the callers
are required to lookup and verify the value of 'tsk' before they call
__lock_task_sighand() (possibly by calling __lock_task_sighand() from
within an rcu_read_lock() section).

Then I wondered if it was protecting the sighand from being freed from
under us while we're trying to lock it. But sighands aren't freed via
rcu, it's just a simple refcnt and kmem_cache_free() deal in
__cleanup_sighand() with all synchronization done via the siglock.

So what does that rcu_read_lock() protect?

I'm most likely missing some obvious detail but if you could help me
out I'd appreciate it!

-- 
Matt Fleming, Intel Open Source Technology Center
