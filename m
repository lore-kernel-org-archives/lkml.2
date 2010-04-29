Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab0D2A22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 20:28:28 -0400
Received: from mail-iw0-f182.google.com ([209.85.223.182]:39313 "EHLO
	mail-iw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab0D2A20 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 20:28:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AabrYjJsgvo6v1x5IYL6kLXw2UrCcD//uzCez8YvSUvZg9ZCO++LcTpzYOtMnyp+0m
         3m3KkPZKhYkuTiVvu6qikrpAfDQqjQG/C7I1A/i+t788BNBOlo6ddsR7Ba/ULQ6hbz+1
         eFEDh+yq5ThccTGlelWNfX+Sm1X4yDM/a9qRA=
MIME-Version: 1.0
In-Reply-To: <20100428165734.6541bab3@annuminas.surriel.com>
References: <1272403852-10479-1-git-send-email-mel@csn.ul.ie>
	 <20100427231007.GA510@random.random>
	 <20100428091555.GB15815@csn.ul.ie>
	 <20100428153525.GR510@random.random>
	 <20100428155558.GI15815@csn.ul.ie>
	 <20100428162305.GX510@random.random>
	 <20100428134719.32e8011b@annuminas.surriel.com>
	 <20100428142510.09984e15@annuminas.surriel.com>
	 <20100428161711.5a815fa8@annuminas.surriel.com>
	 <20100428165734.6541bab3@annuminas.surriel.com>
Date: Thu, 29 Apr 2010 09:28:25 +0900
Message-ID: <y2s28c262361004281728we31e3b9fsd2427aacdc76a9e7@mail.gmail.com>
Subject: Re: [RFC PATCH -v3] take all anon_vma locks in anon_vma_lock
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Christoph Lameter <cl@linux.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 5:57 AM, Rik van Riel <riel@redhat.com> wrote:
> Take all the locks for all the anon_vmas in anon_vma_lock, this properly
> excludes migration and the transparent hugepage code from VMA changes done
> by mmap/munmap/mprotect/expand_stack/etc...
>
> Unfortunately, this requires adding a new lock (mm->anon_vma_chain_lock),
> otherwise we have an unavoidable lock ordering conflict.  This changes the
> locking rules for the "same_vma" list to be either mm->mmap_sem for write,
> or mm->mmap_sem for read plus the new mm->anon_vma_chain lock.  This limits
> the place where the new lock is taken to 2 locations - anon_vma_prepare and
> expand_downwards.
>
> Document the locking rules for the same_vma list in the anon_vma_chain and
> remove the anon_vma_lock call from expand_upwards, which does not need it.
>
> Signed-off-by: Rik van Riel <riel@redhat.com>

This patch makes things simple. So I like this.
Actually, I wanted this all-at-once locks approach.
But I was worried about that how the patch affects AIM 7 workload
which is cause of anon_vma_chain about scalability by Rik.
But now Rik himself is sending the patch. So I assume the patch
couldn't decrease scalability of the workload heavily.

Let's wait result of test if Rik doesn't have a problem of AIM7.

-- 
Kind regards,
Minchan Kim
