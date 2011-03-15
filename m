Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536Ab1COMCk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 08:02:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:54243 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757496Ab1COMCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 08:02:39 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH V4 1/1] rcu: introduce kfree_rcu()
Date: Tue, 15 Mar 2011 13:02:09 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Manfred Spraul <manfred@colorfullife.com>
References: <4D7F356C.8020903@cn.fujitsu.com> <201103151115.54426.arnd@arndb.de> <20110315112734.GA2167@linux.vnet.ibm.com>
In-Reply-To: <20110315112734.GA2167@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103151302.09381.arnd@arndb.de>
X-Provags-ID: V02:K0:61rvJxcYEJ50/yJKTYQl7XrYMLKsRTJfoSzaz6+CQxY
 vbxMaodA4Q4nBxX4JFAVYhDQWviwkzI71vUyX/MIVLfyhRs3kR
 p7q6CsInH5TtyV2YM/0zQENxsSwMGyTrqYh/c2pZdwfsrFxtnq
 E+gDrCBzlIR9SG2gb2UoIfvDq2hVAeVi0a/9jpH2/xPFCmOV/K
 ZgGGRnczN6IA/d4C+2NPA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 15 March 2011, Paul E. McKenney wrote:
> > Another alternative might be to encode the difference between a
> > function pointer and an offset in one of the lower bits of the address.
> 
> We discussed this some time back, and it turned out that there were
> CPUs that could legitimately have any combination of low-order bits
> set -- functions could start at any byte address.
> 
> If this has changed, I would prefer to use the low-order bits, but
> if it has not, we can't.  :-(

Ok, I see.

I just had another idea, which may or may not have new problems:

static inline void *kzalloc_rcu(size_t len, gfp_t flags)
{
	struct rcu_head *head = kzalloc(len + sizeof (struct rcu_head), flags);
	return head + 1;
}

void __kfree_rcu(struct rcu_head *head)
{
	kfree(head);
}

static inline void kfree_rcu(void *p)
{
	struct rcu_head *head = p - sizeof (struct rcu_head);
	call_rcu(head, __kfree_rcu);
}

The only disadvantage I can see right now is that it messes
with the alignment of the structure.

	Arnd
