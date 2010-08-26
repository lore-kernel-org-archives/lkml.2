Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab0HZS7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:59:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34947
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886Ab0HZS7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:59:47 -0400
Date: Thu, 26 Aug 2010 12:00:02 -0700 (PDT)
Message-Id: <20100826.120002.59671031.davem@davemloft.net>
To: hughd@google.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, riel@redhat.com,
        aarcange@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: fix hang on anon_vma->root->lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTik8cHD_qsey8NBw-YWsoibwMM5RNP9SeKom2VtC@mail.gmail.com>
References: <alpine.LSU.2.00.1008252305540.19107@sister.anvils>
	<20100825.234149.189710316.davem@davemloft.net>
	<AANLkTik8cHD_qsey8NBw-YWsoibwMM5RNP9SeKom2VtC@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Date: Thu, 26 Aug 2010 03:54:28 -0700

> On Wed, Aug 25, 2010 at 11:41 PM, David Miller <davem@davemloft.net> wrote:
>> From: Hugh Dickins <hughd@google.com>
>> Date: Wed, 25 Aug 2010 23:12:54 -0700 (PDT)
>>
>>> After several hours, kbuild tests hang with anon_vma_prepare() spinning on
>>> a newly allocated anon_vma's lock - on a box with CONFIG_TREE_PREEMPT_RCU=y
>>> (which makes this very much more likely, but it could happen without).
>>>
>>> The ever-subtle page_lock_anon_vma() now needs a further twist: since
>>> anon_vma_prepare() and anon_vma_fork() are liable to change the ->root
>>> of a reused anon_vma structure at any moment, page_lock_anon_vma()
>>> needs to check page_mapped() again before succeeding, otherwise
>>> page_unlock_anon_vma() might address a different root->lock.
>>>
>>> Signed-off-by: Hugh Dickins <hughd@google.com>
>>
>> Interesting, is the condition which allows this to trigger specific
>> to this merge window or was it always possible?
> 
> Just specific to this merge window, which started using
> anon_vma->root->lock in place of anon_vma->lock (anon_vma->root is
> often anon_vma itself, but not always).

Ok, because I've been seeing mysterious hangs recently on one of my
sparc64 boxes and I was wondering if this might explain them :-)

