Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab1LHDZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 22:25:05 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:32872 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877Ab1LHDZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 22:25:03 -0500
Date: Wed, 7 Dec 2011 19:24:59 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Hugh Dickins <hughd@google.com>, Mel Gorman <mgorman@suse.de>,
        Pawel Sikora <pluto@agmk.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        jpiszcz@lucidpixels.com, arekm@pld-linux.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mremap: enforce rmap src/dst vma ordering in case of
 vma_merge succeeding in copy_vma
In-Reply-To: <1320512782-12209-1-git-send-email-aarcange@redhat.com>
Message-ID: <alpine.DEB.2.00.1112071924400.636@chino.kir.corp.google.com>
References: <alpine.LSU.2.00.1111041856530.22199@sister.anvils> <1320512782-12209-1-git-send-email-aarcange@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Nov 2011, Andrea Arcangeli wrote:

> migrate was doing a rmap_walk with speculative lock-less access on
> pagetables. That could lead it to not serialize properly against
> mremap PT locks. But a second problem remains in the order of vmas in
> the same_anon_vma list used by the rmap_walk.
> 
> If vma_merge would succeed in copy_vma, the src vma could be placed
> after the dst vma in the same_anon_vma list. That could still lead
> migrate to miss some pte.
> 
> This patch adds a anon_vma_moveto_tail() function to force the dst vma
> at the end of the list before mremap starts to solve the problem.
> 
> If the mremap is very large and there are a lots of parents or childs
> sharing the anon_vma root lock, this should still scale better than
> taking the anon_vma root lock around every pte copy practically for
> the whole duration of mremap.
> 
> Update: Hugh noticed special care is needed in the error path where
> move_page_tables goes in the reverse direction, a second
> anon_vma_moveto_tail() call is needed in the error path.
> 

Is this still needed?  It's missing in linux-next.
