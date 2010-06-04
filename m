Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab0FDIi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 04:38:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36124 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab0FDIiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 04:38:24 -0400
Date: Fri, 4 Jun 2010 04:38:18 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Frank Mayhar <fmayhar@google.com>,
       John Stultz <johnstul@us.ibm.com>, Andi Kleen <ak@linux.intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [patch 1/4] fs: cleanup files_lock
Message-ID: <20100604083818.GA9987@infradead.org>
References: <20100604064307.737085373@suse.de> <20100604072618.227745945@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100604072618.227745945@suse.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 04:43:08PM +1000, Nick Piggin wrote:
> Lock tty_files with a new spinlock, tty_files_lock; provide helpers to
> manipulate the per-sb files list; unexport the files_lock spinlock.

I'm still not entirely happy with this.  You keep making the tty a
special case by removing it from the files per-sb files list while
nothing else in the system is removed from it.

Thinks would be much better if you could untangle the tty code from
abuse of file->f_u.fu_list entirely.  And from a naive look at the
tty code that actually seems pretty easy.  file->private for ttys
currently directly points to the tty struct.  If you add a tty_private
there which points back to the file, the tty and contains a list_head
the open files in tty code tracking code can be completely divorced
from the per-sb file tracking.  After that we can decide what to do
with the per-sb file tracking, where my favourite still is to get
rid of it entirely.

