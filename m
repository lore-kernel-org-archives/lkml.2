Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab2HYXUA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 19:20:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57803 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab2HYXT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 19:19:57 -0400
Date: Sun, 26 Aug 2012 00:19:52 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 1/9] procfs: Move /proc/pid/fd[info] handling code to
 fd.[ch]
Message-ID: <20120825231952.GX23464@ZenIV.linux.org.uk>
References: <20120823104323.040550004@openvz.org>
 <20120823104725.592602491@openvz.org>
 <20120825171605.GT23464@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120825171605.GT23464@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 06:16:05PM +0100, Al Viro wrote:
> On Thu, Aug 23, 2012 at 02:43:24PM +0400, Cyrill Gorcunov wrote:
> > This patch prepares the ground for further extension of
> > /proc/pid/fd[info] handling code by moving fdinfo handling
> > code into fs/proc/fd.c.
> > 
> > I think such move makes both fs/proc/base.c and fs/proc/fd.c
> > easier to read.
> 
> BTW, looking at the other stuff in fs/proc/base.c, why the hell is
> struct file * grabbed in proc_map_files_readdir()?  All we do with
> it is passing it to proc_fill_cache(), which passes it to
> proc_map_files_instantiate(), which looks at two sodding bits
> in file->f_mode.  Then we go and fput() all those struct file
> references we'd been putting into the array...  What for?

Another thing:
			f_flags = fd_file->f_flags & ~O_CLOEXEC;
in there is really wrong; we shouldn't leak that bit into ->f_flags
at all (which is properly fixed in fs/open.c).  Close-on-exec is
a property of descriptor, not of file...

tid_fd_revalidate(): these dances with get_files_struct()/put_files_struct()
are pointless.  We really only need "is it opened" + f_mode if it is.
Extracting that information is cheap enough to have it done right under
task_lock() (see what get_files_struct() is doing); no need to mess with
files_struct refcount, etc.

proc_fd_link() and seq_fd_open(): ditto.

As the matter of fact, the only place in there where get_files_struct() is
warranted is proc_readfd_common().

intantiate callback: sodding atrocity; as the absolute minimum it should
lose its "dir" argument.  dentry->d_parent->d_inode is stable (we are
holding ->i_mutex on parent in all callers) and it's equal to dir in all
cases.
