Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab1DOVaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 17:30:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60041 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757064Ab1DOVaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 17:30:22 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTimg+sVCAE17jLE9oz301oruVZbdbw@mail.gmail.com>
References: <20110415201652.GA5131@redhat.com> <BANLkTi=ctr7tQLArfbdHRU3uUvEPh6KbwQ@mail.gmail.com>
 <20110415205712.GA13049@infradead.org> <1302901766.2035.39.camel@laptop> <BANLkTimg+sVCAE17jLE9oz301oruVZbdbw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 15 Apr 2011 14:27:47 -0700
Message-ID: <BANLkTinSytqYA6ozOQEQ16VkRU4gFYpqvg@mail.gmail.com>
Subject: Re: hugetlb locking bug.
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        William Irwin <wli@holomorphy.com>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 2:19 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> (Warning: whitespace damage and TOTALLY UNTESTED)

Gaah. That won't work. Or rather, it probably may work, but while
working it will spam the logs with that

    WARN_ON(!(inode->i_state & I_NEW));

thing from unlock_new_inode.

So the sane thing to do would be apparently one of

 (a) ignore the whole thing, and just accept the false lockdep warning.

      which I'd be willing to do, but it might be hiding some real
ones, so we probably shouldn't.

 (b) just remove that WARN_ON(), and use the one-liner I suggested

 (c) extract the "set directory i_mutex key" logic into a new helper
function for the case of filesystems like hugetlbfs that don't want to
use unlock_new_inode() for one reason or another.

Personally, I don't have any really strong preferences and would
probably just go for (b) to keep the patch small and simple. Anybody?

                     Linus
