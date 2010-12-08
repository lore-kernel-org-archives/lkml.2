Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab0LHXmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:42:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753668Ab0LHXmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:42:43 -0500
Date: Wed, 8 Dec 2010 15:42:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Nick Piggin <npiggin@kernel.dk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 5/6] mlock: do not hold mmap_sem for extended periods of
 time
Message-Id: <20101208154218.4a497920.akpm@linux-foundation.org>
In-Reply-To: <1291335412-16231-6-git-send-email-walken@google.com>
References: <1291335412-16231-1-git-send-email-walken@google.com>
	<1291335412-16231-6-git-send-email-walken@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  2 Dec 2010 16:16:51 -0800
Michel Lespinasse <walken@google.com> wrote:

> __get_user_pages gets a new 'nonblocking' parameter to signal that the
> caller is prepared to re-acquire mmap_sem and retry the operation if needed.
> This is used to split off long operations if they are going to block on
> a disk transfer, or when we detect contention on the mmap_sem.

Doesn't apply to linux-next because the KVM guys snuck in a new
FAULT_FLAG_MINOR (who knew?).  With a bonus, undocumented,
exported-to-modules get_user_pages_noio().

I liked your code better so I munged __get_user_pages() together thusly:


			cond_resched();
			while (!(page = follow_page(vma, start, foll_flags))) {
				int ret;
				unsigned int fault_flags = 0;

				if (foll_flags & FOLL_WRITE)
					fault_flags |= FAULT_FLAG_WRITE;
				if (nonblocking)
					fault_flags |= FAULT_FLAG_ALLOW_RETRY;
				if (foll_flags & FOLL_MINOR)
					fault_flags |= FAULT_FLAG_MINOR;

				ret = handle_mm_fault(mm, vma, start,
							fault_flags);


please review the end result..
