Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761997Ab2FHQWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 12:22:41 -0400
Received: from fieldses.org ([174.143.236.118]:45281 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755824Ab2FHQWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 12:22:39 -0400
Date: Fri, 8 Jun 2012 12:22:34 -0400
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sage Weil <sage@newdream.net>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120608162234.GB17251@fieldses.org>
References: <20120606194233.GA1537@redhat.com>
 <CA+55aFwxFVLPk4-dp73uccKXepKwjpGFgh0NW1u8d0zYzr=hBA@mail.gmail.com>
 <20120606230040.GA18089@redhat.com>
 <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <20120606235403.GC30000@ZenIV.linux.org.uk>
 <20120607002914.GB22223@redhat.com>
 <CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
 <20120607011915.GA17566@redhat.com>
 <20120607012900.GE30000@ZenIV.linux.org.uk>
 <20120607193607.GI30000@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120607193607.GI30000@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 08:36:07PM +0100, Al Viro wrote:
> 	* d_splice_alias() - broken.  Called without any locking on the
> old directory, nevermind ->s_vfs_rename_mutex.

I was assuming that the callers were in lookup, held i_mutex on a
parent, and that in the case of a directory, existence of an alias with
a different parent could only result from a filesystem bug.

> I really believe that this pair of commits needs to be reverted.  The
> earlier code used to guarantee that alias would be detached.

In the case that prompted that first commit, the directory in question
had an alias that was detached (which I'm taking to mean IS_ROOT(dentry)
was true?), but not flagged DISCONNECTED.  The particular case was only
reproduceable on an older kernel, and I couldn't find a similar
reproducer on recent upstream, but I also couldn't convince myself it
was impossible.

So, maybe the correct thing is to revert that change.  Or maybe it
should be picking an IS_ROOT dentry instead of a DISCONNECTED one?

There's some previous discussion at

	http://marc.info/?i=<20110310105821.GE22723@ZenIV.linux.org.uk>

(in particular a long post from Neil:

	http://marc.info/?i=<20110311150749.2fa2be66@notabene.brown>

that I should review.)

--b.
