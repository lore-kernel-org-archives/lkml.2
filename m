Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab1AMCJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 21:09:19 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:36604 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab1AMCJR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 21:09:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bhu7F6tP3iCgkoo8WwYYIwh5qL9E3bQvNfzfXQo+ZKZLOpxFcHa1WHAiz8/EBWoE+D
         Qo4Jb+fr1q/0Q3iaQfhH2UDtgRlBNiaLbPSJmZtY2oUabTnvZ+TV3uCF3R/cFSA+ws9R
         z7EDMxdKCOOeEVgqWIZi+816KR5uyeYSc3OvE=
MIME-Version: 1.0
In-Reply-To: <AANLkTikUtGSJSaG=wsW8i0LzX66F3YwD_MroD-36jr1f@mail.gmail.com>
References: <AANLkTikUtGSJSaG=wsW8i0LzX66F3YwD_MroD-36jr1f@mail.gmail.com>
Date: Thu, 13 Jan 2011 13:09:16 +1100
Message-ID: <AANLkTinyah4tBCLYh6FMsmc0mt4CLcXyFgBdrK2SZ15d@mail.gmail.com>
Subject: Re: rcu: hlist_bl_set_first_rcu hangs
From: Nick Piggin <npiggin@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 6:17 PM, Po-Yu Chuang <ratbert.chuang@gmail.com> wrote:
> Dear Nick,
>
> I am porting arm-based platform from 2.6.35 to current mainline.
> The compiler is gcc-4.4.0.
>
> While booting, the kernel (mainline) hangs after
> "RPC: Registered tcp NFSv4.1 backchannel transport module "
> with similar configurations to 2.6.35.
> Then I found that there is an infinite loop in hlist_bl_set_first_rcu hangs().
>
> The call sequence is:
>
> _d_rehash @fs/dcache.c
> __d_rehash @fs/dcache.c
> hlist_bl_add_head_rcu @include/linux/rculist_bl.h
> hlist_bl_set_first_rcu @include/linux/rculist_bl.h
>
> Current implementation of hlist_bl_set_first_rcu:
>
> static inline void hlist_bl_set_first_rcu(struct hlist_bl_head *h,
>                                        struct hlist_bl_node *n)
> {
>        LIST_BL_BUG_ON((unsigned long)n & LIST_BL_LOCKMASK);
>        LIST_BL_BUG_ON(!((unsigned long)h->first & LIST_BL_LOCKMASK));
>        rcu_assign_pointer(h->first,
>                (struct hlist_bl_node *)((unsigned long)n | LIST_BL_LOCKMASK));
> }
>
> The infinite loop is caused by:
>        LIST_BL_BUG_ON(!((unsigned long)h->first & LIST_BL_LOCKMASK));
> If I comment out this line, the kernel boots well.
>
> The problem looks like that LIST_BL_LOCKMASK is 0 if CONFIG_SMP=n
> and CONFIG_DEBUG_SPINLOCK=n.
>
> #if defined(CONFIG_SMP) || defined(CONFIG_DEBUG_SPINLOCK)
> #define LIST_BL_LOCKMASK        1UL
> #else
> #define LIST_BL_LOCKMASK        0UL
> #endif
>
> Therefore !((unsigned long)h->first & LIST_BL_LOCKMASK) is always true.
>
> I also have CONFIG_DEBUG_LIST=y, so boom! Kernel dies.

Ah, that's a silly error! Thanks for the great debugging work, I'll patch it
up.

Thanks,
Nick
