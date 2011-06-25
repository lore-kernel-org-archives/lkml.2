Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab1FYPLP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 11:11:15 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62409 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1FYPLJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 11:11:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=YkY2TxYiXiKlfD3ZRnSrkZHP0NU3zY6TL25Pe7non1V0KqgffFGAffRWUUjO5rqD0+
         cfKADyZsLOQkj0z8rLeQbQTmqU5XiwoqZiYTqpvdWXw7KD1igYow7NxBiSSCssLfdt/Z
         vJzq9CDVISJLagsoaQWBS0ZIXlY6Bvg4Hhw3c=
MIME-Version: 1.0
In-Reply-To: <4E052DC3.6000902@linux.intel.com>
References: <20110623194949.GA2083@BohrerMBP.rgmadvisors.com>
 <1308931186-28707-1-git-send-email-sbohrer@rgmadvisors.com> <4E052DC3.6000902@linux.intel.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Sun, 26 Jun 2011 00:10:48 +0900
X-Google-Sender-Auth: N3GGxUGNJoBumUAa3kq9FT0m1Jw
Message-ID: <BANLkTin1ENdh-TUmycZp_gn5kjHvcSGUfQ@mail.gmail.com>
Subject: Re: [PATCH v2] futex: Fix regression with read only mappings
To: Darren Hart <dvhart@linux.intel.com>
Cc: Shawn Bohrer <sbohrer@rgmadvisors.com>, peterz@infradead.org,
        eric.dumazet@gmail.com, david@rgmadvisors.com,
        linux-kernel@vger.kernel.org, zvonler@rgmadvisors.com,
        hughd@google.com, tglx@linutronix.de, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> commit 7485d0d3758e8e6491a5c9468114e74dc050785d (futexes: Remove rw
>> parameter from get_futex_key()) in 2.6.33 introduced a user-mode
>> regression in that it additionally prevented futex operations on a
>> region within a read only memory mapped file.  For example this breaks
>> workloads that have one or more reader processes doing a FUTEX_WAIT on a
>> futex within a read only shared mapping, and a writer processes that has
>> a writable mapping issuing the FUTEX_WAKE.
>>
>> This fixes the regression for futex operations that should be valid on
>> RO mappings by trying a RO get_user_pages_fast() when the RW
>> get_user_pages_fast() fails so as not to slow down the common path of
>> writable anonymous maps and bailing when we used the RO path on
>> anonymous memory.
>
> The goal here is to bail with EFAULT when we use a RO MAP_PRIVATE
> mapping on file-backed memory correct?

The problem is, mapping knowledge is contained vma and it's required mma_sem
(ie performance hurt). Therefore we have only three ways, maybe.

1) always take mmap_sem and walk vma,  likes 2.6.18. (cons. slow)
2) prefault, likes current linus-tree. (cons don't work RO mappings)
3) combination prefault and mmap_sem. likes my previous post.
  http://groups.google.com/group/linux.kernel/msg/c41c819207e519c2?dmode=source

In other words, you hope to care RO private mapping thing, you can't avoid
mmap_sem anymore. unfortunatelly. So, we have to select either cons.

> Final concern:
> Are shared memory segments (shmget, etc.) considered "file backed?

It's another corner case. It similar with shared file mapping, but,

   PageSwapBacked(page) => 1
   PageAnon(page) => 0

Thanks.
