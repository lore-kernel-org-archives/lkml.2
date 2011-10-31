Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933815Ab1JaSWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 14:22:51 -0400
Received: from smtp-out.google.com ([216.239.44.51]:49172 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933655Ab1JaSWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 14:22:50 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=aRNb+LsTlxLRBEZq6epukQig/PF7S3ae/BXXrYSlYiVWih+6niA4im4VPuLyQFqK6
	ZmwrlwXrj+NY+kUD5RQZQ==
Date: Mon, 31 Oct 2011 11:22:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Frantisek Hrbata <fhrbata@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        stable@kernel.org, eteo@redhat.com, pmatouse@redhat.com
Subject: Re: [PATCH v2] oom: fix integer overflow of points in oom_badness
In-Reply-To: <1320076569-23872-1-git-send-email-fhrbata@redhat.com>
Message-ID: <alpine.DEB.2.00.1110311120280.7271@chino.kir.corp.google.com>
References: <1320048865-13175-1-git-send-email-fhrbata@redhat.com> <1320076569-23872-1-git-send-email-fhrbata@redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Oct 2011, Frantisek Hrbata wrote:

> An integer overflow will happen on 64bit archs if task's sum of rss, swapents
> and nr_ptes exceeds (2^31)/1000 value. This was introduced by commit
> 
> f755a04 oom: use pte pages in OOM score
> 

This commit was introduced in 2.6.39 but also backported to stable since 
2.6.36, so presumably we'd need to mark this for stable as well going back 
that far.

> where the oom score computation was divided into several steps and it's no
> longer computed as one expression in unsigned long(rss, swapents, nr_pte are
> unsigned long), where the result value assigned to points(int) is in
> range(1..1000). So there could be an int overflow while computing
> 
> 176          points *= 1000;
> 
> and points may have negative value. Meaning the oom score for a mem hog task
> will be one.
> 
> 196          if (points <= 0)
> 197                  return 1;
> 
> For example:
> [ 3366]     0  3366 35390480 24303939   5       0             0 oom01
> Out of memory: Kill process 3366 (oom01) score 1 or sacrifice child
> 
> Here the oom1 process consumes more than 24303939(rss)*4096~=92GB physical
> memory, but it's oom score is one.
> 
> In this situation the mem hog task is skipped and oom killer kills another and
> most probably innocent task with oom score greater than one.
> 
> The points variable should be of type long instead of int to prevent the int
> overflow.
> 
> Signed-off-by: Frantisek Hrbata <fhrbata@redhat.com>

Acked-by: David Rientjes <rientjes@google.com>
Cc: stable@kernel.org [2.6.36+]
