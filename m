Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab1GZShP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 14:37:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57747 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751620Ab1GZShM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 14:37:12 -0400
MIME-Version: 1.0
In-Reply-To: <20110726181418.GA27993@quack.suse.cz>
References: <20110726181418.GA27993@quack.suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 Jul 2011 11:36:29 -0700
Message-ID: <CA+55aFwYsdyE4KxFW70c_FfTb41m+EwchYvNJU-eUEw4usRkUw@mail.gmail.com>
Subject: Re: [PULL REQUEST] ext3, jbd, ext2, and quota fixes for 3.1-rc1
To: Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        Josef Bacik <josef@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 11:14 AM, Jan Kara <jack@suse.cz> wrote:
>
>  could you please pull from
>
> git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs-2.6.git for_linus

Ok, this clashed with the fsync mutex pushdown, and the whole addition
of fixed tracepoints.

Quite frankly, I think the fixed tracepoints are broken and make the
code unreadable (why have them?) but I fixed it up.

Somebody should really double-check the resolve. That's especially
true since the whole i_mutex thing is *also* rather dubious. The
comment that moved that down says:

+       /*
+        * Taking the mutex here just to keep consistent with how fsync was
+        * called previously, however it looks like we don't need to take
+        * i_mutex at all.
+        */

but in fact it is *not* consistent with how fsync() used to be called,
since we then drop the mutex *before* doing

    return ext3_force_commit(inode->i_sb);

for the should_journal_data case.

See commit 02c24a82187 ("fs: push i_mutex and filemap_write_and_wait
down into ->fsync() handlers").

I resolved it with the mutex still dropped early (especially since the
comment implies it may not matter at all), but quite frankly,
everything I did around that resolve made me go "that code is just
WRONG". Both wrt the tracepoints and wrt the i_mutex.

So I think my resolution is "correct" from a merge standpoint, but I
think the code is total crap. I also wonder whether you can really do
that

    J_ASSERT(ext3_journal_current_handle() == NULL);

without holding the i_mutex, so I moved that back down again.

So I *really* want people to take a look at that ext3_sync_file()
function. Please?

                      Linus
