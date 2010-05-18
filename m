Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab0ERQ2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 12:28:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53813 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754213Ab0ERQ2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 12:28:30 -0400
Date: Tue, 18 May 2010 09:25:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
       Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: Unexpected splice "always copy" behavior observed
In-Reply-To: <1274199039.26328.758.camel@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.2.00.1005180918300.4195@i5.linux-foundation.org>
References: <20100518153440.GB7748@Krystal>  <1274197993.26328.755.camel@gandalf.stny.rr.com> <1274199039.26328.758.camel@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 18 May 2010, Steven Rostedt wrote:
> 
> Hopefully we can find a way to avoid the copy to file. But the splice
> code was created to avoid the copy to and from userspace, it did not
> guarantee no copy within the kernel itself.

Well, we always _wanted_ to splice directly to a file, but it's just not 
been done properly. It's not entirely trivial, since you need to worry 
about preexisting pages and generally just do the right thing wrt the 
filesystem.

And no, it should NOT use migration code. I suspect you could do something 
fairly simple like:

 - get the inode semaphore.
 - check if the splice is a pure "extend size" operation for that page
 - if so, just create the page cache entry and mark it dirty
 - otherwise, fall back to copying.

because the "extend file" case is the easiest one, and is likely the only 
one that matters in practice (if you are overwriting an existing file, 
things get _way_ hairier, and why the hell would anybody expect that to be 
fast anyway?)

But somebody needs to write the code..

		Linus
