Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab2JWHwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:52:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64216 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab2JWHwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:52:08 -0400
Subject: Re: [PATCH v5] posix timers: allocate timer id per process
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: peterz@infradead.org, mingo@redhat.com, tglx@linutronix.de,
        devel@openvz.org, linux-kernel@vger.kernel.org, xemul@parallels.com
In-Reply-To: <20121023073913.23514.87934.stgit@localhost.localdomain>
References: <20121023073913.23514.87934.stgit@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Oct 2012 09:52:03 +0200
Message-ID: <1350978723.8609.1555.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 11:40 +0400, Stanislav Kinsbursky wrote:
> This patch is required CRIU project (www.criu.org).
> To migrate processes with posix timers we have to make sure, that we can
> restore posix timer with proper id.
> Currently, this is not true, because timer ids are allocated globally.
> So, this is precursor patch and it's purpose is make posix timer id to be
> allocated per process.
> 
> Patch replaces global idr with global hash table for posix timers and
> makes timer ids unique not globally, but per process. Next free timer id is
> type of integer and stored on signal struct (posix_timer_id). If free timer id
> reaches negative value on timer creation, it will be dropped to zero and
> -EAGAIN will be returned to user.
> 
> Hash table has 512 slots.
> Key is constructed as follows:
> key = hash_32(hash_32(current->signal) ^ posix_timer_id));
> 
> Note: with this patch, id, returned to user, is not the minimal free
> amymore. It means, that id, returned to user space in loop, listed below, will
> be increasing on each iteration till INT_MAX and then dropped to zero:
> 
> while(1) {
> 	id = timer_create(...);
> 	timer_delete(id);
> }
> 
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> 
> ---

SGTM

Signed-off-by: Eric Dumazet <edumazet@google.com>

Thanks !


