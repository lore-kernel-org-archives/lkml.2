Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab0ESOmm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 10:42:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44408 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441Ab0ESOmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 10:42:40 -0400
Date: Wed, 19 May 2010 07:39:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
cc: Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pierre Tardy <tardyp@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>, Paul Mackerras <paulus@samba.org>,
       linux-kernel@vger.kernel.org, arjan@infradead.org,
       ziga.mahkovec@gmail.com, davem <davem@davemloft.net>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Unexpected splice "always copy" behavior observed
In-Reply-To: <20100519063116.GR2516@laptop>
Message-ID: <alpine.LFD.2.00.1005190736370.23538@i5.linux-foundation.org>
References: <20100518153440.GB7748@Krystal> <1274197993.26328.755.camel@gandalf.stny.rr.com> <1274199039.26328.758.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1005180918300.4195@i5.linux-foundation.org> <20100519063116.GR2516@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 May 2010, Nick Piggin wrote:
> 
> We can possibly do an attempt to invalidate existing pagecache and
> then try to install the new page.

Yes, but that's going to be rather hairier. We need to make sure that the 
filesystem doesn't have some kind of dirty pointers to the old page etc. 
Although I guess that should always show up in the page counters, so I 
guess we can always handle the case of page_count() being 1 (only page 
cache) and the page being unlocked.

So I'd much rather just handle the "append to the end".

The real limitation is likely always going to be the fact that it has to 
be page-aligned and a full page. For a lot of splice inputs, that simply 
won't be the case, and you'll end up copying for alignment reasons anyway.

		Linus
