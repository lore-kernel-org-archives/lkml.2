Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab2HVDaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 23:30:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144Ab2HVDaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 23:30:08 -0400
Message-ID: <50345232.4090002@redhat.com>
Date: Tue, 21 Aug 2012 23:29:54 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Hugh Dickins <hughd@google.com>,
        Daniel Forrest <dan.forrest@ssec.wisc.edu>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH] Re: Repeated fork() causes SLAB to grow without bound
References: <20120816024610.GA5350@evergreen.ssec.wisc.edu> <502D42E5.7090403@redhat.com> <20120818000312.GA4262@evergreen.ssec.wisc.edu> <502F100A.1080401@redhat.com> <alpine.LSU.2.00.1208200032450.24855@eggly.anvils> <CANN689Ej7XLh8VKuaPrTttDrtDGQbXuYJgS2uKnZL2EYVTM3Dg@mail.gmail.com> <20120822032057.GA30871@google.com>
In-Reply-To: <20120822032057.GA30871@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2012 11:20 PM, Michel Lespinasse wrote:
> On Mon, Aug 20, 2012 at 02:39:26AM -0700, Michel Lespinasse wrote:
>> Instead of adding an atomic count for page references, we could limit
>> the anon_vma stacking depth. In fork, we would only clone anon_vmas
>> that have a low enough generation count. I think that's not great
>> (adds a special case for the deep-fork-without-exec behavior), but
>> still better than the atomic page reference counter.
>
> Here is an attached patch to demonstrate the idea.
>
> anon_vma_clone() is modified to return the length of the existing same_vma
> anon vma chain, and we create a new anon_vma in the child only on the first
> fork (this could be tweaked to allow up to a set number of forks, but
> I think the first fork would cover all the common forking server cases).

I suspect we need 2 or 3.

Some forking servers first fork off one child, and have
the original parent exit, in order to "background the server".
That first child then becomes the parent to the real child
processes that do the work.

It is conceivable that we might need an extra level for
processes that do something special with privilege dropping,
namespace changing, etc...

Even setting the threshold to 5 should be totally harmless,
since the problem does not kick in until we have really
long chains, like in Dan's bug report.

-- 
All rights reversed
