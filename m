Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab1CXRfj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 13:35:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755111Ab1CXRfi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 13:35:38 -0400
MIME-Version: 1.0
In-Reply-To: <20110324171319.GA20182@redhat.com>
References: <20110315153801.3526.A69D9226@jp.fujitsu.com> <20110322194721.B05E.A69D9226@jp.fujitsu.com>
 <20110322200945.B06D.A69D9226@jp.fujitsu.com> <20110324171319.GA20182@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 24 Mar 2011 10:34:46 -0700
Message-ID: <AANLkTinsabm-AHTdc2X550jkAqb=TrBLfrk5CV-WEjGx@mail.gmail.com>
Subject: Re: [PATCH 5/5] x86,mm: make pagefault killable
To: Oleg Nesterov <oleg@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
        linux-mm <linux-mm@kvack.org>, Andrey Vagin <avagin@openvz.org>,
        Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 10:13 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> I am wondering, can't we set FAULT_FLAG_KILLABLE unconditionally
> but check PF_USER when we get VM_FAULT_RETRY? I mean,
>
>        if ((fault & VM_FAULT_RETRY) && fatal_signal_pending(current)) {
>                if (!(error_code & PF_USER))
>                        no_context(...);
>                return;
>        }

I agree, we should do this.

> Probably not... but I can't find any example of in-kernel fault which
> can be broken by -EFAULT if current was killed.

There's no way that can validly break anything, since any such
codepath has to be able to handle -EFAULT for other reasons anyway.

The only issue is whether we're ok with a regular write() system call
(for example) not being atomic in the presence of a fatal signal. So
it does change semantics, but I think it changes it in a good way
(technically POSIX requires atomicity, but on the other hand,
technically POSIX also doesn't talk about the process being killed,
and writes would still be atomic for the case where they actually
return. Not to mention NFS etc where writes have never been atomic
anyway, so a program that relies on strict "all or nothing" write
behavior is fundamentally broken to begin with).

                         Linus
