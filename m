Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759581Ab0EMW2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 18:28:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753228Ab0EMW2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 18:28:46 -0400
Date: Thu, 13 May 2010 15:25:01 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, Roland McGrath <roland@redhat.com>,
       Mel Gorman <mel@csn.ul.ie>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 7/11] Uprobes Implementation
In-Reply-To: <87tyqbbgd7.fsf@basil.nowhere.org>
Message-ID: <alpine.LFD.2.00.1005131516300.3711@i5.linux-foundation.org>
References: <20100413183537.GA17538@redhat.com> <20100415093506.GA2064@linux.vnet.ibm.com> <20100419193139.GA24080@redhat.com> <20100420124358.GA20675@linux.vnet.ibm.com> <20100420153023.GA9351@redhat.com> <20100421065948.GA5440@linux.vnet.ibm.com>
 <20100421160515.GA11321@redhat.com> <20100422133154.GA10776@linux.vnet.ibm.com> <20100422154059.GA5916@redhat.com> <1273610723.1810.105.camel@laptop> <20100513194034.GA11207@redhat.com> <alpine.LFD.2.00.1005131256050.3711@i5.linux-foundation.org>
 <87tyqbbgd7.fsf@basil.nowhere.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 14 May 2010, Andi Kleen wrote:
> 
> But isn't text usually shared?  I don't see how you could set any
> break points or jump probes on text pages with that restriction.

Text is usually private, and read-only. Not generally MAP_SHARED. The 
pages end up getting shared because nobody writes to them, but that's 
almost accidental.

If you write to them, you get a nice clean COW fault, and you are 
_supposed_ to get a nice clean COW fault. It's not changing any semantics: 
the write is not visible to outside users, and those "get a private page" 
semantics were what the mmap() was all about.

In contrast, if it's a MAP_SHARED mapping and writable, the write would 
actually be _visible_ outside the process. And that's clearly totally 
wrong on all levels. Tracing a process should _never_ cause visible damage 
outside that process (you'd hope it wouldn't be all that visibel to the 
tracee either, but that's still secondary).

The alternative, ie a MAP_SHARED but read-only mapping (which looks very 
much like a private mapping) if you use get_user_pages(.force=1), the 
kernel will actually end up forcing a COW break, because making the write 
visible outside would be a security issue (you don't even have the right 
to write to the thing).

Notice how the MAP_SHARED case - writable or not - ends up doing the wrong 
thing. Arguably it does the _even_worse_ thing in the writable case, but 
in either case it's not good. 

			Linus
