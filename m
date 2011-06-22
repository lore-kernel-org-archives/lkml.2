Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299Ab1FVW7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 18:59:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52148 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1FVW7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 18:59:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=mpzdfLDgCHBzz9B7eMbuFwLk0G0iz9jLMfWKt++yHxD8o0XZaTyJYN6/Jg2Ae/hAlX
         QH1eov3W2GoiClkk8fxQ==
Date: Wed, 22 Jun 2011 15:59:40 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com
Subject: Re: [PATCH 2/6] oom: improve dump_tasks() show items
In-Reply-To: <4E01C82A.7070702@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1106221558160.11759@chino.kir.corp.google.com>
References: <4E01C7D5.3060603@jp.fujitsu.com> <4E01C82A.7070702@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jun 2011, KOSAKI Motohiro wrote:

> Recently, oom internal logic was dramatically changed. Thus
> dump_tasks() doesn't show enough information for bug report
> analysis. it has some meaningless items and don't have some
> oom socre related items.
> 
> This patch adapt displaying fields to new oom logic.
> 
> details
> --------
> removed: pid (we always kill process. don't need thread id),
>          signal->oom_adj (we no longer uses it internally)
> 	 cpu (we no longer uses it)
> added:  ppid (we often kill sacrifice child process)
>         swap (it's accounted)
> modify: RSS (account mm->nr_ptes too)
> 
> <old>
> [ pid ]   uid  tgid total_vm      rss cpu oom_adj oom_score_adj name
> [ 3886]     0  3886     2893      441   1       0             0 bash
> [ 3905]     0  3905    29361    25833   0       0             0 memtoy
> 
> <new>
> [   pid]   ppid   uid euid total_vm      rss     swap score_adj name
> [   417]      1     0    0     3298       12      184     -1000 udevd
> [   830]      1     0    0     1776       11       16         0 system-setup-ke
> [   973]      1     0    0    61179       35      116         0 rsyslogd
> [  1733]   1732     0    0  1052337   958582        0         0 memtoy
> 

I like this very much!  I'm always supportive of providing additional 
information that will allow users to investigate oom conditions more 
thoroughly.

I'm not sure that we should be exporting the euid, however, since I 
disagreed with using it in the badness heuristic of the first patch.  
Let's talk about it there and then perhaps it can be removed from the 
tasklist dump if we don't actually end up using it?

Otherwise, it looks good!
