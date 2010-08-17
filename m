Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750962Ab0HQVOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 17:14:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51850 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750705Ab0HQVOE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 17:14:04 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTinO5yip7agVO3Lq3YLjDYmkB9MP14xjt3TusMfW@mail.gmail.com>
References: <20100816.211218.189709876.davem@davemloft.net>
 <AANLkTikDXoRMRL0y_Y_7qVS=9LOw_yLS9MuUgq2dTCZf@mail.gmail.com>
 <AANLkTi=ZdrtWSYE0BEXJ-YDoxjta3h7RMR7Y8Z6Hu-Hc@mail.gmail.com> <AANLkTinO5yip7agVO3Lq3YLjDYmkB9MP14xjt3TusMfW@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Aug 2010 14:08:33 -0700
Message-ID: <AANLkTik9qUf_F0NDoW2SBjWGHk2=ZdvkLrCORu3gGa2o@mail.gmail.com>
Subject: Re: tasks getting stuck on mmap_sem?
To: Tony Luck <tony.luck@intel.com>
Cc: David Miller <davem@davemloft.net>, Michel Lespinasse <walken@google.com>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 1:46 PM, Tony Luck <tony.luck@intel.com> wrote:
>
> Setting up for "git pull" would have been messy - but "git grep" is
> multi-threaded in newer versions of git. So I've set a loop to keep
> running "git grep" over and over.  Load average is above 7, so
> there must be some threading going on, even though I only see
> one "git" process in "top(1)".  Seems to be running fine so far.

I'm not sure how page-fault intensive that 'git grep' thing is - I
think it does mainly open/read/close on the files and probably doesn't
take that many faults once malloc() has created the main heap. In
contrast, the delta compute code (that david hit) is probably going to
do a lot more page faults due to being way more data-intensive (many
more mmap/munmap calls - it's how git tends to like to map git
objects).

So a more fault-intensive - and still threaded and all local - git
load is likely to do something like

   git repack -adf

and do it on something smaller than the whole kernel (git itself is
probably a good test-case, and probably isn't that far off from a
medium-sized kernel "pull" request).

                 Linus
