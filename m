Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab1COEuk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 00:50:40 -0400
Received: from smtp-out.google.com ([74.125.121.67]:61472 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1COEui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 00:50:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=CY3h3h7LhN5mrvyt5L9vLSLvJbcu7b6H54jnyfAv9zaoFj3jsq4jN017uttZjUsAAS
         7YRa64qt9AvNUbPnWmbA==
Date: Mon, 14 Mar 2011 21:50:24 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: Linux 2.6.38
In-Reply-To: <20110314213331.24229139.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1103142137020.13734@chino.kir.corp.google.com>
References: <AANLkTi=_cZRNPU29+MJkt9u6zDSLo153CKqLqg1+t7O6@mail.gmail.com> <alpine.DEB.2.00.1103142011550.16032@chino.kir.corp.google.com> <20110314213331.24229139.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011, Andrew Morton wrote:

> > once oom-prevent-unnecessary-oom-kills-or-kernel-panics.patch is merged 
> > from -mm
> 
> Please (re)send the patches which you believe should be merged into
> 2.6.38 to address the problems which Oleg found, and any other critical
> problems.  Not in a huge rush - let's get this right.
> 

In my testing, Oleg's three test cases that he sent to the security list 
and cc'd us on get appropriately oom killed once swap is exhausted or 
swapoff -a is used on mmotm-2011-03-10-16-42 because of these two patches:

	oom-prevent-unnecessary-oom-kills-or-kernel-panics.patch
	oom-skip-zombies-when-iterating-tasklist.patch

He also presented a test case on linux-mm that caused the oom killer to 
avoid acting if a thread is ptracing a thread in the exit path with 
PTRACE_O_TRACEEXIT.  That should be fixed with

	http://marc.info/?l=linux-mm&m=129997893430351

that has yet to see -mm.  There are no other test cases that have been 
presented that cause undesired behavior.

That said, my approach to doing this has been to avoid arbitrary 
heuristics for special cases and address known issues by adding the 
appropriate logic in the oom killer.  For example, the ptrace problem that 
Oleg presented showed that the oom killer logic incorrectly deferred doing 
anything when an eligible thread was PF_EXITING.  It had done that 
believing that nothing would stop the thread from exiting or current 
would be given access to memory reserves itself and that assumption was 
broken for PTRACE_O_TRACEEXIT.  My patch above, in combination with 
Andrey's patch that only considers threads with valid mm's, fixes that 
issue because we'll now only defer if you still have an attached mm, are 
PF_EXITING, and are not being traced.

If, at some point, there is another gap in the exit code where a thread 
may hold PF_EXITING with a valid mm for an indefinite period, we'll need 
to address that in the oom killer as well.  We use PF_EXITING specifically 
in the oom killer to identify tasks that are going to exit soon and need 
handling for any case where that isn't guaranteed.  Anything else results 
in needlessly killing other tasks or, in the worst case, panicking when 
there is nothing left that is eligible.
