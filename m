Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935301Ab0KQWFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:05:35 -0500
Received: from smtp-out.google.com ([74.125.121.35]:9212 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab0KQWFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:05:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=B5ePRFe245tyNTHJS8b2RAHpadt655MxVIjFIJybo1JKi5h+6Ko4XQyF93CvMiCPPH
         T6UVDncWWL5FTOnmG6ZQ==
MIME-Version: 1.0
In-Reply-To: <1290007734.2109.941.camel@laptop>
References: <1289996638-21439-1-git-send-email-walken@google.com>
	<1289996638-21439-4-git-send-email-walken@google.com>
	<20101117125756.GA5576@amd>
	<1290007734.2109.941.camel@laptop>
Date: Wed, 17 Nov 2010 14:05:30 -0800
Message-ID: <AANLkTim4tO_aKzXLXJm-N-iEQ9rNSa0=HGJVDAz33kY6@mail.gmail.com>
Subject: Re: [PATCH 3/3] mlock: avoid dirtying pages and triggering writeback
From: Michel Lespinasse <walken@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <npiggin@kernel.dk>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Theodore Tso <tytso@google.com>, Michael Rubin <mrubin@google.com>,
        Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 7:28 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2010-11-17 at 23:57 +1100, Nick Piggin wrote:
>> On Wed, Nov 17, 2010 at 04:23:58AM -0800, Michel Lespinasse wrote:
>> > When faulting in pages for mlock(), we want to break COW for anonymous
>> > or file pages within VM_WRITABLE, non-VM_SHARED vmas. However, there is
>> > no need to write-fault into VM_SHARED vmas since shared file pages can
>> > be mlocked first and dirtied later, when/if they actually get written to.
>> > Skipping the write fault is desirable, as we don't want to unnecessarily
>> > cause these pages to be dirtied and queued for writeback.
>>
>> It's not just to break COW, but to do block allocation and such
>> (filesystem's page_mkwrite op). That needs to at least be explained
>> in the changelog.
>
> Agreed, the 0/3 description actually does mention this.
>
>> Filesystem doesn't have a good way to fully pin required things
>> according to mlock, but page_mkwrite provides some reasonable things
>> (like block allocation / reservation).
>
> Right, but marking all pages dirty isn't really sane. I can imagine
> making the reservation but not marking things dirty solution, although
> it might be lots harder to implement, esp since some filesystems don't
> actually have a page_mkwrite() implementation.

Really, my understanding is that not pre-allocating filesystem blocks
is just fine. This is, after all, what happens with ext3 and it's
never been reported as a bug (that I know of).

If filesystem people's feedback is that they really want mlock() to
continue pre-allocating blocks, maybe we can just do it using
fallocate() rather than page_mkwrite() callbacks ?

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
