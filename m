Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab0LGWo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 17:44:27 -0500
Received: from smtp-out.google.com ([74.125.121.35]:44103 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063Ab0LGWoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 17:44:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=P7xvI9IBB2Pl0GsH5xAM3E525JpmiPuTyqEZHmEUr74etEltF9/NT7xWuqhy2uuf8d
         krfhb2hZf0O5C5di+6sA==
MIME-Version: 1.0
In-Reply-To: <1291427008.16223.7.camel@gandalf.stny.rr.com>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
 <1291421609-14665-4-git-send-email-dhsharp@google.com> <1291427008.16223.7.camel@gandalf.stny.rr.com>
From: David Sharp <dhsharp@google.com>
Date: Tue, 7 Dec 2010 14:44:01 -0800
Message-ID: <AANLkTimEcb9k=0_gSH7SdjHg=hywKfNjq=4p7HnUFJFZ@mail.gmail.com>
Subject: Re: [PATCH 03/15] ring_buffer: Align buffer_page struct allocations
 only to fit the flags.
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, mrubin@google.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 3, 2010 at 5:43 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2010-12-03 at 16:13 -0800, David Sharp wrote:
>> buffer_page structs need to be aligned to 4 byte boundaries because the page
>> flags are stored in the two least-significant bits of the pointers in the page
>> list. Aligning to cache lines is sufficient, but doesn't seem to be necessary.
>> Reducing the alignement to only 4 bytes may improve cache efficiency.
>
> The reason for the cache line boundaries because the bpages are per cpu,
> and if they are allocated next to some variable that gets change
> globally or even another bpage that is used for another cpu buffer, then
> I would expect we would get some cache line bouncing.

I see. That makes sense. I'm not attached to this patch, we can drop it.

> Perhaps we should make bpage have its own slab allocation
> (kmem_cache_alloc). And perhaps even try to keep all bpages that share
> the same cache line on the same cpu buffer.

Maybe. Although, I was thinking of some patches to keep pages in a
free-pool, so that when a cpu buffer needs a new page, it takes from
the pool, and when a reader is done with a page, it returns to the
free-pool. (This helps with the situation where more events occur on
one CPU than others: pages are not locked to a CPU that isn't
producing events.) In that case, it would be impossible to predict
what cpu a bpage belongs to. But since this is theoretical, maybe it's
not relevant.
