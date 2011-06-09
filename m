Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab1FISmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 14:42:25 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51171 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab1FISmY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 14:42:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=IBkrIETgbToPH3YI1QzOu9VSy47Oo8Dn4uA2tvi9LPIuqNzwZ+CHcaUyjkxsYj/QcP
         hnTbclDi7Ukz5TH4h4ew==
MIME-Version: 1.0
In-Reply-To: <1307621668.9218.37.camel@gandalf.stny.rr.com>
References: <1307490088-8612-1-git-send-email-vnagarnaik@google.com>
 <1307491302-9236-1-git-send-email-vnagarnaik@google.com> <4DF0B097.7010805@jp.fujitsu.com>
 <1307621668.9218.37.camel@gandalf.stny.rr.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Thu, 9 Jun 2011 11:41:50 -0700
Message-ID: <BANLkTinrc-OE0v2KonbsvmF6GTLP3kFY57HnXnDYhYj619TALA@mail.gmail.com>
Subject: Re: [PATCH v2] trace: Set __GFP_NORETRY flag for ring buffer
 allocating process
To: Steven Rostedt <rostedt@goodmis.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-09 at 20:37 +0900, KOSAKI Motohiro wrote:
> Unfortunately, __GFP_NORETRY is racy and don't work as expected.
> If free memory is not enough, the thread may start to reclaim and
> another thread can steal the reclaimed memory. And thread0 don't retry.
>
> Then, thread0's alloc page may fail even though system have enough reclaimable
> memory.
>
>         thread0                                        thread1
>         ---------------------------------------------------------------
>         alloc_pages()
>            get_page_from_freelist() -> fail
>            try_to_free_pages()
>                                                     alloc_pages()
>                                                        get_page_from_freelist() -> success
>            get_page_from_freelist() -> fail again
>
> I think this is mm issue, and afaik, Minchan and some developers are
> working on fixing it. but _now_ your patch doesn't work.

Thanks. I was not aware of this condition. I discussed it with the mm-
team and it seems this is a well known problem. Though it it is not that
bad for order 0 allocations, which is what ring buffer uses.

Also, it happens in tight memory conditions, at which point allocating
ring buffer might make it worse. I think providing the user a
notification of this is better than just worsening the situation by
allocating ring buffer.

On Thu, Jun 9, 2011 at 5:14 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> Have you seen this fail in practice?

Not in my normal test cases. I haven't stressed it though, but that
doesn't make sense for this patch. The idea is that ring buffer should
be able to allocate memory as long as it doesn't impact the system too
much.


Vaibhav Nagarnaik
