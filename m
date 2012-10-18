Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab2JRHqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 03:46:43 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48421 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab2JRHql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 03:46:41 -0400
Subject: Re: [PATCH] procfs: Improve Scaling in proc
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, paulmck@linux.vnet.ibm.com
In-Reply-To: <1350505538-22733-1-git-send-email-nzimmer@sgi.com>
References: <1350505538-22733-1-git-send-email-nzimmer@sgi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Oct 2012 09:46:38 +0200
Message-ID: <1350546398.26103.1133.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-17 at 15:25 -0500, Nathan Zimmer wrote:
> I am currently tracking a hotlock reported by a customer on a large, 512 cores,
> system, I am currently running 3.7.0 rc1 but the issue looks like it has been
> this way for a very long time.
> The offending lock is proc_dir_entry->pde_unload_lock.
> 
> This patch converts the replaces the lock with the rcu. It is a refresh of what
> was orignally suggested by Eric Dumazet.  I refreshed it to the 3.7.
> 
> Supporting numbers, lower is better, they are from the test I posted earlier.
> cpuinfo baseline        Rcu
> tasks   read-sec        read-sec
> 1       0.0141          0.0141
> 2       0.0140          0.0142
> 4       0.0140          0.0141
> 8       0.0145          0.0140
> 16      0.0553          0.0168
> 32      0.1688          0.0549
> 64      0.5017          0.1690
> 128     1.7005          0.5038
> 256     5.2513          2.0804
> 512     8.0529          3.0162
> 
> 
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>


Hmm, this patch had several issues and I had no time yet to work on a
new version. I probably wont have time in a near future.

Paul sent me some comments about it, I hope he doesnt mind I copy them
here, if you want to polish the patch.

Thanks !

On Wed, 2012-10-03 at 10:56 -0700, Paul E. McKenney wrote: 
> Finally getting back to this...  :-/
> 
> Why not set the initial value of the reference counter to 1
> (rather than zero), continue acquiring with atomic_inc(), but
> use atomic_dec_and_test() to decrement?  Put a completion in
> the data structure, so if the atomic_dec_and_test() indicates that
> the counter is now zero, do a complete().
> 
> Then to free the object, remove it from the data structure, do a
> synchronize_rcu(), do an atomic_dec_and_test() to remove the initial
> value, again doing a complete() if the counter is now zero.  The do
> a wait_for_completion().
> 
> This would get rid of the polling loop.
> 
> So, what am I missing here?  ;-)
> 
> 							Thanx, Paul
> 

