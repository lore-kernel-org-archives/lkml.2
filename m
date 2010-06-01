Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab0FAUjp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:39:45 -0400
Received: from smtp-out.google.com ([74.125.121.35]:40308 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab0FAUjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:39:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=YiImp1Cf1pLWKmTMeODPXUuDiQiF8ni5Sri5slhsg37tDhNpCQpQ7n10QKqa/JSY2
	iJSBx4xyZkflnilHVkuoQ==
Date: Tue, 1 Jun 2010 13:39:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 2/5] oom: select_bad_process: PF_EXITING check should
 take ->mm into account
In-Reply-To: <20100531183335.1846.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1006011337590.13136@chino.kir.corp.google.com>
References: <20100531182526.1843.A69D9226@jp.fujitsu.com> <20100531183335.1846.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 May 2010, KOSAKI Motohiro wrote:

> From: Oleg Nesterov <oleg@redhat.com>
> Subject: oom: select_bad_process: PF_EXITING check should take ->mm into account
> 
> select_bad_process() checks PF_EXITING to detect the task which is going
> to release its memory, but the logic is very wrong.
> 
> 	- a single process P with the dead group leader disables
> 	  select_bad_process() completely, it will always return
> 	  ERR_PTR() while P can live forever
> 
> 	- if the PF_EXITING task has already released its ->mm
> 	  it doesn't make sense to expect it is goiing to free
> 	  more memory (except task_struct/etc)
> 
> Change the code to ignore the PF_EXITING tasks without ->mm.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [rebase to latest -mm]

This is already pushed in my oom killer rewrite as patch 13/18 "oom: avoid 
race for oom killed tasks detaching mm prior to exit".

It's not vital to merge now because causing the oom killer to temporarily 
become a no-op before it can fully exit even though it has already 
detached its memory only delays killing another task until it exits and 
there's nothing in the way of that exiting while it's still under 
PF_EXITING.
