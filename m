Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab1IWBXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 21:23:33 -0400
Received: from smtp-out.google.com ([216.239.44.51]:24148 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519Ab1IWBXa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 21:23:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=UnKCVK19Iua7v5grYZziZCLKGP37VFblaW0ip4Ty2ubjWIZysO9uDrAX/wtGWRqqI
	7HTcd8pz8wqVomBBr3etA==
MIME-Version: 1.0
In-Reply-To: <20110922161325.f94f9c9e.akpm@google.com>
References: <1316230753-8693-1-git-send-email-walken@google.com>
	<20110922161325.f94f9c9e.akpm@google.com>
Date: Thu, 22 Sep 2011 18:23:27 -0700
Message-ID: <CANN689Gpn6hx0jXx1bzf_m_x9-ZQ4Uienfxcsyr=wV7ucZQXnQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] idle page tracking / working set estimation
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Wolf <mjwolf@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 4:13 PM, Andrew Morton <akpm@google.com> wrote:
> On Fri, 16 Sep 2011 20:39:05 -0700
> Michel Lespinasse <walken@google.com> wrote:
>
>> Please comment on the following patches (which are against the v3.0 kernel).
>> We are using these to collect memory utilization statistics for each cgroup
>> accross many machines, and optimize job placement accordingly.
>
> Please consider updating /proc/kpageflags with the three new page
> flags.  If "yes": update.  If "no": explain/justify.

The PG_stale flag should probably be exported that way. I'll make sure
to add this, thanks for the suggestion!

I am not sure about PG_young and PG_idle since they indicate young
bits have been cleared in PTE(s) pointing to the page since the last
page_referenced() call. This seems rather internal - we don't export
PTE young bits in kpageflags currently, nor do we export anything that
would depend on when page_referenced() was last called.

> Which prompts the obvious: the whole feature could have been mostly
> implemented in userspace, using kpageflags.  Some additional kernel
> support would presumably be needed, but I'm not sure how much.
>
> If you haven't already done so, please sketch down what that
> infrastructure would look like and have a think about which approach is
> preferable?

kpageflags does not currently do a page_referenced() call to export
PTE young flags. For a userspace approach, we would have to add that.
Also we would want to actually clear the PTE young bits so that the
page doesn't show up as young again on the next kpageflags read - and,
we wouldn't want to affect the normal LRU algorithms while doing this,
so we'd end up introducing the same PG_young and PG_idle flags. The
next issue would be to find out which cgroup an idle page belongs to -
this could be done by adding a new kpagecgroup file, I suppose. Given
the above, we'd have the necessary components for a userspace approach
- but, the only part that we would really be able to remove from the
kernel side is the loop that scans physical pages and tallies the idle
ones into a per-cgroup count.

> What bugs me a bit about the proposal is its cgroups-centricity.  The
> question "how much memory is my application really using" comes up
> again and again.  It predates cgroups.  One way to answer that question
> is to force a massive amount of swapout on the entire machine, then let
> the system recover and take a look at your app's RSS two minutes later.
> This is very lame.
>
> It's a legitimate requirement, and the kstaled infrastructure puts a
> lot of things in place to answer it well.  But as far as I can tell it
> doesn't quite get over the line.  Then again, maybe it _does_ get
> there: put the application into a memcg all of its own, just for
> instrumentation purposes and then use kstaled to monitor it?

Yes, this is what I would recomment in this situation - create a
memory cgroup to move the application in, and see what kstaled
reports.

> <later> OK, I'm surprised to discover that kstaled is doing a physical
> scan and not a virtual one.  I assume it works, but I don't know why.
> But it makes the above requirement harder, methinks.

The reason for the physical scan is that a virtual scan would have
some limitations:
- it would only report memory that's virtually mapped - we do want
file pages to be classified as idle or not, regardless of how the file
gets accessed
- it may not work well with jobs that involve short lived processes.

> How does all this code get along with hugepages, btw?

They should get along now that Andreas updated get_page and
get_page_unless_zero to avoid the race with THP tail page splitting.

However, you're reminding me that I forgot to include the patch that
would make the accounting correct when we encounter a THP page (we
want to report the entire page as idle rather than just the first 4K,
and increment pfn appropriately for the page size)...

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
