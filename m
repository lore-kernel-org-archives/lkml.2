Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969Ab1AMS6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 13:58:46 -0500
Received: from smtp-out.google.com ([74.125.121.67]:42570 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756690Ab1AMS6n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 13:58:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZkV2o/1O+wXaCyWh6zJkiRy/V5LB6cNYf/0XB9YrMxcOtVCQTcZwM47NULcPnHKgXE
         K/phxFd8kX08o/rPhcUw==
MIME-Version: 1.0
In-Reply-To: <AANLkTimi9ZfO+8rGuBSKdSiXSZmQfvs8eceYRgdpdO6s@mail.gmail.com>
References: <4D2ACFA7.6000502@redhat.com>
	<AANLkTimOOUjXa7WCTirHRrrLfiev4T9iD7spb2VrB_ET@mail.gmail.com>
	<4D2C21FE.3000406@redhat.com>
	<4D2E1010.4080706@redhat.com>
	<AANLkTimLJnV9oJwnaN+jdvNus4cxuqvgUqHUwi7vpqBe@mail.gmail.com>
	<20110113125308.GJ14750@redhat.com>
	<AANLkTimi9ZfO+8rGuBSKdSiXSZmQfvs8eceYRgdpdO6s@mail.gmail.com>
Date: Thu, 13 Jan 2011 10:58:40 -0800
Message-ID: <AANLkTi=6+NdnkjAQhxE-PYKOpnoy6zV6z-JGR0u2tqPT@mail.gmail.com>
Subject: Re: [GIT PULL] KVM updates for the 2.6.38 merge window
From: Hugh Dickins <hughd@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Gleb Natapov <gleb@redhat.com>, Rik van Riel <riel@redhat.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 7:43 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jan 13, 2011 at 4:53 AM, Gleb Natapov <gleb@redhat.com> wrote:
>>
>> I implemented get_user_pages_nowait() on top of your patch. In my testing
>> it works as expected when used inside KVM. Does this looks OK to you?
>
> It looks reasonable, although I suspect the subtle behavior wrt the
> mmap_sem means that you should not expose the magic bare
> FAULT_FLAG_ALLOW_RETRY flag to the __get_user_pages() thing. It's just
> too easy to introduce bugs, methinks.
>
> So I'd suggest
>
>  - drop FOLL_RETRY
>
>  -  make FOLL_NOWAIT set both (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_NOWAIT)
>
> and that way the get_user_pages() thing will never release the
> mmap_sem, and you never have any subtle locking issues for that
> particular interface.
>
> But some other VM person should look at it too.

I haven't been following and am not really looking yet, but should
express a preference: that Gleb keep it as he had it (if that works),
rather than making FOLL_NOWAIT do a combination.

A couple of months ago I needed to add a FOLL flag myself, and made a
patch to use the same space for FOLL flags and FAULT_FLAGs, to end
such ugliness as you see in this patch:

+                                       ((foll_flags & FOLL_WRITE) ?
+                                       FAULT_FLAG_WRITE : 0) |
+                                       ((foll_flags & FOLL_RETRY) ?
+                                       FAULT_FLAG_ALLOW_RETRY : 0) |
+                                       ((foll_flags & FOLL_NOWAIT) ?
+                                       FAULT_FLAG_RETRY_NOWAIT : 0));

But I missed my window, I think several have been added since, with
more on the way: I intend to put it together again for mmotm once the
dust has settled a little.

__get_user_pages already has wrappers for friendly usage, I think it's
okay for the wrappers to have special knowledge of what's needed.

Hugh
