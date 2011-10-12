Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab1JLWmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 18:42:03 -0400
Received: from smtp-out.google.com ([74.125.121.67]:15685 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753349Ab1JLWmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 18:42:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=BJCM6NENW3rT8voh9Gqe73d5TAO0ODMjkmqlgA38C79/c973m8ul/lZxONshUWROi
	DLO2s5bzHe3udQpdGtMaA==
Date: Wed, 12 Oct 2011 15:41:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Satoru Moriya <satoru.moriya@hds.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Satoru Moriya <smoriya@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "lwoodman@redhat.com" <lwoodman@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        "hughd@google.com" <hughd@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>
Subject: RE: [PATCH -v2 -mm] add extra free kbytes tunable
In-Reply-To: <65795E11DBF1E645A09CEC7EAEE94B9CB516D055@USINDEVS02.corp.hds.com>
Message-ID: <alpine.DEB.2.00.1110121537380.16286@chino.kir.corp.google.com>
References: <20110901105208.3849a8ff@annuminas.surriel.com> <20110901100650.6d884589.rdunlap@xenotime.net> <20110901152650.7a63cb8b@annuminas.surriel.com> <alpine.DEB.2.00.1110072001070.13992@chino.kir.corp.google.com> <20111010153723.6397924f.akpm@linux-foundation.org>
 <65795E11DBF1E645A09CEC7EAEE94B9CB516CBC4@USINDEVS02.corp.hds.com> <20111011125419.2702b5dc.akpm@linux-foundation.org> <65795E11DBF1E645A09CEC7EAEE94B9CB516CBFE@USINDEVS02.corp.hds.com> <20111011135445.f580749b.akpm@linux-foundation.org>
 <65795E11DBF1E645A09CEC7EAEE94B9CB516D055@USINDEVS02.corp.hds.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Oct 2011, Satoru Moriya wrote:

> >> Also, if we increase the free-page reserves a.k.a min_free_kbytes, 
> >> the possibility of direct reclaim on other workloads increases.
> >> I think it's a bad side effect.
> > 
> > extra_free_kbytes has the same side-effect.
> 
> I don't think so. If we make low watermark bigger to increase
> free-page reserves by extra_free_kbytes, the possibility of
> direct reclaim on other workload does not increase directly
> because min watermark is not changed. 

I think the point was that extra_free_kbytes needs to be tuned to cover at 
least the amount of memory of the largest allocation burst or it doesn't 
help to prevent latencies for rt threads and, depending on how the 
implementation of the VM evolves, that value may change significantly over 
time from kernel release to kernel release.

For example, if we were to merge Con's patch so kswapd operates at a much 
higher priority for rt threads later on for another issue, it may 
significantly reduce the need for extra_free_kbytes to be set as high as 
it is.  Everybody who is setting this in init scripts, though, will 
continue to set the value because they have no reason to believe it should 
be changed.  Then, we have users who start to use the tunable after Con's 
patch has been merged and now we have widely different settings for the 
same tunable and it can never be obsoleted because everybody is using it 
but for different historic reasons.

This is why I nack'd the patch originally: it will never be removed, it 
is widely misunderstood, and is tied directly to the implementation of 
reclaim which will change over time.
