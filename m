Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab0JEWo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 18:44:27 -0400
Received: from smtp-out.google.com ([74.125.121.35]:29817 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab0JEWo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 18:44:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=j0ckm+L80O0PsD3BbrwPy2PFHEz9lISPzfOJqeNHYAGWU+7YL51O2ziHXHFQB9eDvU
         i4qcQ+GucymICqD+PAtA==
MIME-Version: 1.0
In-Reply-To: <4CAB628D.3030205@redhat.com>
References: <1286265215-9025-1-git-send-email-walken@google.com>
	<1286265215-9025-3-git-send-email-walken@google.com>
	<4CAB628D.3030205@redhat.com>
Date: Tue, 5 Oct 2010 15:44:22 -0700
Message-ID: <AANLkTimdACZ9Xm01DM2+E64+T5XfLffrkFBhf7CJ286p@mail.gmail.com>
Subject: Re: [PATCH 2/3] Retry page fault when blocking on disk transfer.
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Ying Han <yinghan@google.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 5, 2010 at 10:38 AM, Rik van Riel <riel@redhat.com> wrote:
> On 10/05/2010 03:53 AM, Michel Lespinasse wrote:
>>
>> This change reduces mmap_sem hold times that are caused by waiting for
>> disk transfers when accessing file mapped VMAs. It introduces the
>> VM_FAULT_ALLOW_RETRY flag, which indicates that the call site wants
>> mmap_sem to be released if blocking on a pending disk transfer.
>> In that case, filemap_fault() returns the VM_FAULT_RETRY status bit
>> and do_page_fault() will then re-acquire mmap_sem and retry the page
>> fault.
>> It is expected that the retry will hit the same page which will now be
>> cached, and thus it will complete with a low mmap_sem hold time.
>>
>> Signed-off-by: Michel Lespinasse<walken@google.com>
>
> Acked-by: Rik van Riel <riel@redhat.com>
>
> Looks like it should be relatively easy to do something
> similar in do_swap_page also.

Good idea. We don't make use of swap too much, which is probably why
we didn't have that in our kernel, but it seems like a good idea just
for uniformity. I'll add this in a follow-on patch.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
