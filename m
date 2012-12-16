Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab2LPT6c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 14:58:32 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39296 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab2LPT6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 14:58:31 -0500
MIME-Version: 1.0
In-Reply-To: <2e91ea19fbd30fa17718cb293473ae207ee8fd0f.1355536006.git.luto@amacapital.net>
References: <3b624af48f4ba4affd78466b73b6afe0e2f66549.1355463438.git.luto@amacapital.net>
 <2e91ea19fbd30fa17718cb293473ae207ee8fd0f.1355536006.git.luto@amacapital.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 16 Dec 2012 11:58:09 -0800
X-Google-Sender-Auth: ElUi8B41cSHcKHAQZEN_eluHnOs
Message-ID: <CA+55aFyzjvq=qQM1sNcyqt06u_05zyYv4RyCx+n8vZ4RLu7R5g@mail.gmail.com>
Subject: Re: [PATCH v2] mm: Downgrade mmap_sem before locking or populating on mmap
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@kernel.org>,
        Michel Lespinasse <walken@google.com>, Hugh Dickins <hughd@google.com>,
        =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 6:17 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> This is a serious cause of mmap_sem contention.  MAP_POPULATE
> and MCL_FUTURE, in particular, are disastrous in multithreaded programs.
>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Ugh. This patch is just too ugly.

Conditional locking like this is just too disgusting for words. And
this v2 is worse, with that whole disgusting 'downgraded' pointer
thing.

I'm not applying disgusting hacks like this. I suspect you can clean
it up by moving the mlock/populate logic into the (few) callers
instead (first as a separate patch that doesn't do the downgrading)
and then a separate patch that does the downgrade in the callers,
possibly using a "finish_mmap" helper function that releases the lock.

No "if (write) up_write() else up_read()" crap. Instead, make the
finish_mmap helper do something like

  if (!populate_r_mlock) {
    up_write(mmap_sem);
    return;
  }
  downgrade(mmap_sem);
  .. populate and mlock ..
  up_read(mmap_sem);

and you never have any odd "now I'm holding it for writing" state
variable with conditional locking rules etc.

           Linus
