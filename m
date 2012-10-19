Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069Ab2JSH4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 03:56:49 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39902 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816Ab2JSH4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 03:56:48 -0400
Subject: Re: [PATCH v4] posix timers: allocate timer id per process
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: peterz@infradead.org, mingo@redhat.com, tglx@linutronix.de,
        devel@openvz.org, linux-kernel@vger.kernel.org, xemul@parallels.com
In-Reply-To: <20121019074912.10745.339.stgit@localhost.localdomain>
References: <20121019074912.10745.339.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 19 Oct 2012 09:56:40 +0200
Message-ID: <1350633401.2293.245.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-19 at 11:50 +0400, Stanislav Kinsbursky wrote:
> v4:
> 1) a couple of coding style fixes (lines over 80 characters)
> 
> v3:
> 1) hash calculation simlified to improve perfomance.
> 
> v2:
> 1) Hash table become RCU-friendly. Hash table search now done under RCU lock
> protection.

This should not be in the changelog, only after the --- separator.

> I've tested scalability on KVM with 4 CPU. The testing environment was build
> of 10 processes, each had 512 posix timers running (SIGSEV_NONE) and was
> calling timer_gettime() in loop. With all this stuff being running, I was
> measuring time of calling of syscall timer_gettime() 10000 times.
> 
> Without this patch: ~7ms
> With this patch   : ~7ms
> 
> This patch is required CRIU project (www.criu.org).
> To migrate processes with posix timers we have to make sure, that we can
> restore posix timer with proper id.
> Currently, this is not true, because timer ids are allocated globally.
> So, this is precursor patch and it's purpose is make posix timer id to be
> allocated per process.
> 
> Patch replaces global idr with global hash table for posix timers and
> makes timer ids unique not globally, but per task. Next free timer id is type
> of integer and stored on signal struct (posix_timer_id). If free timer id
> reaches negative value on timer creation, it will be dropped to zero and
> -EAGAIN will be returned to user.

I wonder if some applications relied on our idr, assuming they would get
low values for their timer id.
(We could imagine some applications use a table indexed by the timer id)

> Hash table is size of page (4KB).

Only on x86_64. Why not instead saying hashtable has 512 slots ?

> Key is constructed as follows:
> key = hash_32(current->signal) ^ hash_32(posix_timer_id);

This is outdated.

> 
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> ---

Thanks



