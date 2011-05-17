Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753295Ab1EQJCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 05:02:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35309 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab1EQJCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 05:02:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=qNwgpbcVTAN/ILHY9GuRP0tBJLbzE2o7APfUAH6ClT8TcfilKX5zL0GRSwQGFzOin+
         86bai0/UcOM4nWOymRBsZbqheUNCUgsF3qLVL9RueR0aKxef0damveF6UdIJfwXAMty5
         vwo5SE7UJ8LI7Sq+YYyCkRfaip0bBE96fWbzY=
Subject: Re: [patch v3 2/3] percpu_counter: use atomic64 for counter in SMP
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, tj@kernel.org,
        cl@linux.com
In-Reply-To: <20110517084419.602635499@sli10-conroe.sh.intel.com>
References: <20110517084117.572970726@sli10-conroe.sh.intel.com>
	 <20110517084419.602635499@sli10-conroe.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 May 2011 11:02:32 +0200
Message-ID: <1305622952.2850.23.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 17 mai 2011 à 16:41 +0800, Shaohua Li a écrit :
> pièce jointe document texte brut (percpu-counter-atomic.patch)
> Uses atomic64 for percpu_counter, because it is cheaper than spinlock.
> This doesn't slow fast path (percpu_counter_read). atomic64_read
> equals to read fbc->count for 64-bit system, or equals to
> spin_lock-read-spin_unlock for 32-bit system. Note, originally
> the percpu_counter_read for 32-bit system doesn't hold spin_lock,
> but that is buggy and might cause very wrong value accessed. This
> patch fixes the issue.
> 
> We use sum_start and add_start to make sure _sum doesn't see deviation
> when _add slow path is running. When _sum is running, _add will wait
> _sum finish. This is scaring that _add is slow down, but actually not,
> because _sum is called very rare. We could make _sum waits _add finish,
> but since _add is called frequently, this will make _sum run very slow.
> 
> This can also improve some workloads with percpu_counter->lock heavily
> contented. For example, vm_committed_as sometimes causes the contention.
> We should tune the batch count, but if we can make percpu_counter better,
> why not? In a 24 CPUs system and 24 processes, each runs:
> while (1) {
> 	mmap(128M);
> 	munmap(128M);
> }
> we then measure how many loops each process can take:
> The atomic method gives 4x faster.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> --

I NACK this patch, its not necessary, since percpu_counter doesnt
provide a precise count api anyway.

Please resubmit your original patches, without the bloat.

Thanks


