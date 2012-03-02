Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240Ab2CBTxt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 14:53:49 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:39903 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756594Ab2CBTxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 14:53:48 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: q24X1SkVM1lsAocR05cxWKLSQNZusr_DxmYlCcNKxHCrZn5
 ietD8P3NvIWyiM7j6AYk4XiJk.dXPk0_lc6boyLLNGJfBZqpDO.ljtlT.f.A
 qumlakJUnQFgBI2UJ_NjEA2rbqn7NTdvCwCEWiDy0sUCNNpxA02M99IIQ.lj
 _rdp_3nlGsjYsyhrqgA3z5roLeueEEST74wt3v_0YHSYY8hyciN6O7xdjaJZ
 IafyzS2l3uqYPKo2xelPsvi25R3iztCM7_lHS_2VABDPvqVV2G2N34D1eSj1
 C97iJ9lBceBqx.UxpojRTUhJlrzYRF9hXpT1VYj3.mAQkNB5lgsU9GLACQWU
 EruFMWqXvfE4u7lmEmXhNSDWzslYzE.akzcS3a8Ja17ErGPX2Ha1p1zzal4E
 hdXFLlZP1MiMtjz58zzGOJswFe5Qr58KQN0J1
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Fri, 2 Mar 2012 13:53:45 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>, Miao Xie <miaox@cn.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpuset: mm: Remove memory barrier damage from the page
 allocator
In-Reply-To: <20120302174349.GB3481@suse.de>
Message-ID: <alpine.DEB.2.00.1203021349020.18523@router.home>
References: <20120302112358.GA3481@suse.de> <alpine.DEB.2.00.1203021018130.15125@router.home> <20120302174349.GB3481@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2012, Mel Gorman wrote:

> I considered using a seqlock but it isn't cheap. The read side is heavy
> with the possibility that it starts spinning and incurs a read barrier
> (looking at read_seqbegin()) here. The retry block incurs another read
> barrier so basically it would not be no better than what is there currently
> (which at a 4% performance hit, sucks)

Oh. You dont have a read barrier? So your approach is buggy? We could have
read a state before someone else incremented the seq counter, then cached
it, then we read the counter, did the processing and found that the
sequid was not changed?

> In the case of seqlocks, a reader will backoff if a writer is in progress
> but the page allocator doesn't need that which is why I felt it was ok

You can just not use the writer section if you think that is ok. Doubt it
but lets at least start using a known serialization construct that would
allow us to fix it up if we find that we need to update multiple variables
protected by the seqlock.

> Allocation failure is an unusual situation that can trigger application
> exit or an OOM so it's ok to treat it as a slow path. A normal seqlock
> would retry unconditionally and potentially have to handle the case
> where it needs to free the page before retrying which is pointless.

It will only retry as long as the writer hold the "lock". Like a spinlock
the holdoff times depends on the size of the critical section and
initially you could just avoid having write sections.

