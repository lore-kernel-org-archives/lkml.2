Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab0ENFmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 01:42:55 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:52579 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab0ENFmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 01:42:53 -0400
Date: Fri, 14 May 2010 11:12:43 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
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
Message-ID: <20100514054243.GQ7426@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100419193139.GA24080@redhat.com>
 <20100420124358.GA20675@linux.vnet.ibm.com>
 <20100420153023.GA9351@redhat.com>
 <20100421065948.GA5440@linux.vnet.ibm.com>
 <20100421160515.GA11321@redhat.com>
 <20100422133154.GA10776@linux.vnet.ibm.com>
 <20100422154059.GA5916@redhat.com>
 <1273610723.1810.105.camel@laptop>
 <20100513194034.GA11207@redhat.com>
 <alpine.LFD.2.00.1005131256050.3711@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005131256050.3711@i5.linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> On Thu, 13 May 2010, Oleg Nesterov wrote:
> > 
> > But I still think this doesn't actually matter, replace_page() shouldn't
> > preserve the mapping, it should always install the anonymous page. I can
> > be wrong, of course.
> 
> Well, if I reasd the patches right, uprobes will use "copy_to_user()" for 
> the self-probing case. So that would definitely just modify a shared 
> mapping.


Uprobes uses copy_to_user() to write data/stack and never to write to
instruction addresses.

To write an instruction uprobes either used access_process_vm or the
replace_page() based background page replacement method. This is true
even if the process was probing itself.

Soon to be posted v4 will revert to background page replacement method
on the lines illustrated by Peter in one of his mails.

> 
> Of course, arguably, who really cares? As long as it's not a security 
> issue (and it isn't - since the person could just have written to the 
> thing directly instead), I guess it doesn't much matter. But it's a bit 
> sad when a probing feature either
> 
>  - changes a global mapping that may be executed by other non-related 
>    processes that the prober isn't even _aware_ of.
> 
>  - changes semantics by creating a non-coherent private page

Do you see these concerns even when uprobes uses background page replacement?

> 
> so arguably it would be good to just make the rule be that you cannot 
> probe a shared mapping. Because whatever you do, it's always the wrong 
> thing.
> 

Yes, I will be adding a check to discard probing if the vma has
VM_SHARED flag set. I have already committed to Oleg on this issue.
I didnt include this check in v3 patchset, because uprobes was using
access_process_vm in v3 patchset and I thought access_process_vm would
do the right thing even if VM_SHARED is set.

--
Thanks and Regards
Srikar
