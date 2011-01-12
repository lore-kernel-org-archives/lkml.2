Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab1ALHRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 02:17:34 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41821 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab1ALHRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 02:17:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=WnTm1DKIs3H/p03ls+gWJMNqwhJUurHYkbqz/fJbMkUXzuljuD9X7OX08lwBaXCQTR
         +dK6AgzA2lmMzDvPkWBe3qW5JfE+LskRcmFvSctMWCs/re5n2LW+RYHtbOwTfMiW5eE5
         FFTbNrJro1hfoN/UBS2Lod0/zpTQesHLPULC0=
MIME-Version: 1.0
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Wed, 12 Jan 2011 15:17:09 +0800
Message-ID: <AANLkTikUtGSJSaG=wsW8i0LzX66F3YwD_MroD-36jr1f@mail.gmail.com>
Subject: rcu: hlist_bl_set_first_rcu hangs
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Nick,

I am porting arm-based platform from 2.6.35 to current mainline.
The compiler is gcc-4.4.0.

While booting, the kernel (mainline) hangs after
"RPC: Registered tcp NFSv4.1 backchannel transport module "
with similar configurations to 2.6.35.
Then I found that there is an infinite loop in hlist_bl_set_first_rcu hangs().

The call sequence is:

_d_rehash @fs/dcache.c
__d_rehash @fs/dcache.c
hlist_bl_add_head_rcu @include/linux/rculist_bl.h
hlist_bl_set_first_rcu @include/linux/rculist_bl.h

Current implementation of hlist_bl_set_first_rcu:

static inline void hlist_bl_set_first_rcu(struct hlist_bl_head *h,
                                        struct hlist_bl_node *n)
{
        LIST_BL_BUG_ON((unsigned long)n & LIST_BL_LOCKMASK);
        LIST_BL_BUG_ON(!((unsigned long)h->first & LIST_BL_LOCKMASK));
        rcu_assign_pointer(h->first,
                (struct hlist_bl_node *)((unsigned long)n | LIST_BL_LOCKMASK));
}

The infinite loop is caused by:
        LIST_BL_BUG_ON(!((unsigned long)h->first & LIST_BL_LOCKMASK));
If I comment out this line, the kernel boots well.

The problem looks like that LIST_BL_LOCKMASK is 0 if CONFIG_SMP=n
and CONFIG_DEBUG_SPINLOCK=n.

#if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
#define LIST_BL_LOCKMASK        1UL
#else
#define LIST_BL_LOCKMASK        0UL
#endif

Therefore !((unsigned long)h->first & LIST_BL_LOCKMASK) is always true.

I also have CONFIG_DEBUG_LIST=y, so boom! Kernel dies.

best regards,
Po-Yu Chuang
