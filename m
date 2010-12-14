Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887Ab0LNB06 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 20:26:58 -0500
Received: from smtp-out.google.com ([74.125.121.35]:21893 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758834Ab0LNB04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 20:26:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PLqJ9T2lXUML2O3IVG5L8LNapg0JGr84vswNb8o9qa5MSbIBlgBdot1mkMf3qF6zHJ
         jwPsgudrKWbJu59/KZsQ==
MIME-Version: 1.0
In-Reply-To: <20101213170526.3b010058.akpm@linux-foundation.org>
References: <1291335412-16231-1-git-send-email-walken@google.com>
	<1291335412-16231-2-git-send-email-walken@google.com>
	<20101208152740.ac449c3d.akpm@linux-foundation.org>
	<AANLkTikYZi0=c+yM1p8H18u+9WVbsQXjAinUWyNt7x+t@mail.gmail.com>
	<AANLkTinY0pcTcd+OxPLyvsJgHgh=cTaB1-8VbEA2tstb@mail.gmail.com>
	<20101214005140.GA29904@google.com>
	<20101213170526.3b010058.akpm@linux-foundation.org>
Date: Mon, 13 Dec 2010 17:26:27 -0800
Message-ID: <AANLkTin4-u8aA-KBA60xAmeBDg9BUvRp2sUieTkDcRhb@mail.gmail.com>
Subject: Re: [PATCH 1/6] mlock: only hold mmap_sem in shared mode when
 faulting in pages
From: Michel Lespinasse <walken@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 5:05 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 13 Dec 2010 16:51:40 -0800
> Michel Lespinasse <walken@google.com> wrote:
>> Andrew, should I amend my patches to remove the rwsem_is_contended() code ?
>> This would involve:
>> - remove rwsem-implement-rwsem_is_contended.patch and
>>   x86-rwsem-more-precise-rwsem_is_contended-implementation.patch
>> - in mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch,
>>   drop the one hunk making use of rwsem_is_contended (rest of the patch
>>   would still work without it)
>
> I think I fixed all that up.

Thanks!

>> - optionally, follow up patch to limit batch size to a constant
>>   in do_mlock_pages():
[... diff snipped ...]
>> I don't really prefer using a constant, but I'm not sure how else to make
>> Linus happy :)
>
> rwsem_is_contended() didn't seem so bad to me.
>
> Reading 1024 pages can still take a long time.  I can't immediately
> think of a better approach though.

Note that we're only concerned page cache hist here, as
__get_user_pages with non-NULL nonblocking argument will release
mmap_sem when blocking on disk. So time per page is somewhat constant
- we don't need to worry about disk seeks at least.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
