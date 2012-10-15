Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab2JOQes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 12:34:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42257 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab2JOQeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 12:34:46 -0400
Subject: Re: [RFC PATCH] posix timers: allocate timer id per task
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: peterz@infradead.org, mingo@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, devel@openvz.org
In-Reply-To: <20121015161559.7806.72762.stgit@localhost.localdomain>
References: <20121015161559.7806.72762.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Oct 2012 18:34:43 +0200
Message-ID: <1350318883.3954.321.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-15 at 20:17 +0400, Stanislav Kinsbursky wrote:
> This patch is required CRIU project (www.criu.org).
> To migrate processes with posix timers we have to make sure, that we can
> restore posix timer with proper id.
> Currently, this is not true, because timer ids are allocated globally.
> So, this is precursor patch and it's purpose is make posix timer id to be
> allocated per task.
> 
> Patch replaces global idr with global hash table for posix timers and
> makes timer ids unique not globally, but per task. Next free timer id is type
> of integer and stored on signal struct (posix_timer_id). If free timer id
> reaches negative value on timer creation, it will be dropped to zero and
> -EAGAIN will be returned to user.
> Hash table is size of page (4KB).
> Key is constructed as follows:
> key = hash_ptr(current->signal) ^ hash_32(posix_timer_id);
> 
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>


Hmm, it seems you removed idr, rcu friendly, and reinstated a fixed size
hash table, protected by a _single_ spinlock ? Oh well.

Please take a look at commit 8af088710d1e, and make sure you fix your
problem and keep performance as good as before.



