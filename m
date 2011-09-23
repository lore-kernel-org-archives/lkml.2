Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab1IWKSW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 06:18:22 -0400
Received: from smtp-out.google.com ([74.125.121.67]:44281 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab1IWKST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 06:18:19 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=w2DuISSNBCBkaVLy1MuJO+HXWnwfC3eRLqgU8MfXflg5pvawY3B22ZP4KBerzI9yf
	tlgKWRwj/inbzO0YQLQfA==
MIME-Version: 1.0
In-Reply-To: <20110922161523.f5b2193f.akpm@google.com>
References: <1316230753-8693-1-git-send-email-walken@google.com>
	<1316230753-8693-7-git-send-email-walken@google.com>
	<20110922161523.f5b2193f.akpm@google.com>
Date: Fri, 23 Sep 2011 03:18:13 -0700
Message-ID: <CANN689GtH_vf-iOJyNjhet8-DXd=ermbmUykNJfKvg0yw=FiWQ@mail.gmail.com>
Subject: Re: [PATCH 6/8] kstaled: rate limit pages scanned per second.
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

On Thu, Sep 22, 2011 at 4:15 PM, Andrew Morton <akpm@google.com> wrote:
> On Fri, 16 Sep 2011 20:39:11 -0700
> Michel Lespinasse <walken@google.com> wrote:
>
>> Scan some number of pages from each node every second, instead of trying to
>> scan the entime memory at once and being idle for the rest of the configured
>> interval.
>
> Well...  why?  The amount of work done per scan interval is the same
> (actually, it will be slightly increased due to cache evictions).
>
> I think we should see a good explanation of what observed problem this
> hackery^Wtweak is trying to solve.  Once that is revealed, we can
> compare the proposed solution with one based on thread policy/priority
> (for example).

There are two aspects to this:

- some people might find it nicer to have a small amount of load
during the entire scan interval, rather than some spike when we
trigger the scanning and some idle time afterwards. That part is
highly debatable and there are probably better ways to achieve this.

- jitter reduction - if we were to scan the entire memory at once
without sleeping, the pages that are scanned first would have a fairly
constant interval between times they are looked at; however if the
time to scan pages is not constant (it could vary depending on CPU
load and pages getting allocated and freed) the pages that are scanned
towards the end of each scan would have a bit more jitter. This effect
is reduced by trying to scan a fixed number of pages per second.

> This is all rather unpleasing.

Yeah, this is not my favourite patch in the series :/

Would it help if I reordered it last in the series, as it seems more
controversial & the later ones don't functionally depend on it ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
