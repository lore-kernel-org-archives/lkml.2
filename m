Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0K1XhQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 18:37:16 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44615 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab0K1XhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 18:37:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=AU7d77MQA3DQNArv7VNmq6F7AfEEaDy434wixsVeY8TcYw3WP8h/AKTumPwU97vRXE
         +IRjpywo5MLs1TlAMwzmuRZ2WaJZDafS/gTYo239ASx1YJmztfYnBFCaWLBQBljN9AFW
         TVliF2evzxFB4kxVJcgjtG6cHx/PUtcDPtYI0=
Subject: Re: [PATCH] kthread: NUMA aware kthread_create_on_cpu()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <20101128230146.GB12300@basil.fritz.box>
References: <1290972833.29196.90.camel@edumazet-laptop>
	 <20101128224024.GA12300@basil.fritz.box>
	 <1290984712.29196.100.camel@edumazet-laptop>
	 <20101128230146.GB12300@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Nov 2010 00:37:04 +0100
Message-ID: <1290987424.29196.128.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 29 novembre 2010 à 00:01 +0100, Andi Kleen a écrit :
> On Sun, Nov 28, 2010 at 11:51:51PM +0100, Eric Dumazet wrote:
> > > Also this messes up the policy of the caller process. You really
> > > need to save/restore it.
> > 
> > Well, caller process duty is to create kthreads in a loop.
> 
> In this case any other allocations it may do
>  are still on those
> nodes.

As I said, it does only create_kthread() calls, and no "other
allocations".

while (!list_empty(&kthread_create_list)) {
      struct kthread_create_info *create;

      create = list_entry(kthread_create_list.next,
                          struct kthread_create_info, list);
      list_del_init(&create->list);
      spin_unlock(&kthread_create_lock);

      create_kthread(create);

      spin_lock(&kthread_create_lock);
}





> 
> > > Problem is that this ends up in architecture specific code
> > > for the stack, so may be a larger patch.
> > 
> > I suggest arches that need slab to allocate kthread stacks do the
> > appropriate changes, because I am not able to make them myself.
> > 
> > On x86, we use page allocator only, so NUMA mempolicy is used.
> 
> task_struct is always allocated from slab.

Hmm, I meant stack (the thing that might be trashed a lot in ksoftirqd),
so it is included in struct thread_info

And this one uses __get_free_pages(GFP_KERNEL, THREAD_SIZE_ORDER) from
alloc_thread_info()


By the way, I re-tested my original patch (MPOL_BIND) on x86_32

# cat /proc/buddyinfo 
Node 0, zone      DMA      0      1      0      1      2      1      1      0      1      1      3 
Node 0, zone   Normal     22     14     10      3      2      3      4      2      3      2    165 
Node 0, zone  HighMem     41     35    346    223    124    140     40     19      2      0    143 
Node 1, zone  HighMem     21      7      8      4    217     97     33     11      3      1    415 

And got correct stacks. Are you sure we must use PREFERRED ?



