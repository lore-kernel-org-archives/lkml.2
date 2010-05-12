Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756729Ab0ELWSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 18:18:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637Ab0ELWSp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 18:18:45 -0400
Message-ID: <4BEB2923.8030200@redhat.com>
Date: Wed, 12 May 2010 18:18:11 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Linux-MM <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] always lock the root (oldest) anon_vma
References: <20100512133815.0d048a86@annuminas.surriel.com> <20100512134029.36c286c4@annuminas.surriel.com> <alpine.LFD.2.00.1005121441350.3711@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005121441350.3711@i5.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2010 05:55 PM, Linus Torvalds wrote:

> Wouldn't it be sufficient to do
>
> 	if (atomic_dec_and_test(&anon_vma->ksm_refcount)) {
> 		anon_vma_lock(anon_vma);
>
> instead? The "atomic_dec_and_lock()" semantics are _much_ stricter than a
> regular "decrement and test and then lock", and that strictness means that
> it's way more complicated and expensive. So if you don't need the
> semantics, you shouldn't use them.

I suspect the atomic_dec_and_lock in the KVM code is being used
to prevent the following race:

1) KSM code reduces the refcount to 0

2)                               munmap on other CPU frees the anon_vma

3) KSM code takes the anon_vma lock,
    which now lives in freed memory

Am I totally confused by this and can we use a nicer approach?

-- 
All rights reversed
