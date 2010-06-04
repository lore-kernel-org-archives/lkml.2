Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab0FDOU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 10:20:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52749 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849Ab0FDOU4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 10:20:56 -0400
Date: Sat, 5 Jun 2010 00:20:52 +1000
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Frank Mayhar <fmayhar@google.com>,
       John Stultz <johnstul@us.ibm.com>, Andi Kleen <ak@linux.intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 1/4] fs: cleanup files_lock
Message-ID: <20100604142052.GD26335@laptop>
References: <20100604064307.737085373@suse.de>
 <20100604072618.227745945@suse.de>
 <20100604083818.GA9987@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100604083818.GA9987@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 04:38:18AM -0400, Christoph Hellwig wrote:
> On Fri, Jun 04, 2010 at 04:43:08PM +1000, Nick Piggin wrote:
> > Lock tty_files with a new spinlock, tty_files_lock; provide helpers to
> > manipulate the per-sb files list; unexport the files_lock spinlock.
> 
> I'm still not entirely happy with this.  You keep making the tty a
> special case by removing it from the files per-sb files list while
> nothing else in the system is removed from it.
> 
> Thinks would be much better if you could untangle the tty code from
> abuse of file->f_u.fu_list entirely.  And from a naive look at the
> tty code that actually seems pretty easy.  file->private for ttys
> currently directly points to the tty struct.  If you add a tty_private
> there which points back to the file, the tty and contains a list_head
> the open files in tty code tracking code can be completely divorced
> from the per-sb file tracking.

Well it is already a special case, I just switched it to using a
different lock for its private list. I wanted to keep surgery to
a minimum.


>  After that we can decide what to do
> with the per-sb file tracking, where my favourite still is to get
> rid of it entirely.

Again, this would be nice, but I didn't see an easy way to do it.
Even if refcounting obsoleted may_remount_ro, we still have
mark_files_ro. It's no more complex to rip this all out after my
patch. I don't see the problem in doing this patch. It has good
numbers.

