Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab2HYRzL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 13:55:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41915 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954Ab2HYRzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 13:55:08 -0400
Date: Sat, 25 Aug 2012 18:55:04 +0100
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
Message-ID: <20120825175504.GU23464@ZenIV.linux.org.uk>
References: <20120823104323.040550004@openvz.org>
 <20120823104725.592602491@openvz.org>
 <20120825171605.GT23464@ZenIV.linux.org.uk>
 <20120825173958.GC19184@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120825173958.GC19184@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 09:39:58PM +0400, Cyrill Gorcunov wrote:
> On Sat, Aug 25, 2012 at 06:16:05PM +0100, Al Viro wrote:
> > On Thu, Aug 23, 2012 at 02:43:24PM +0400, Cyrill Gorcunov wrote:
> > > This patch prepares the ground for further extension of
> > > /proc/pid/fd[info] handling code by moving fdinfo handling
> > > code into fs/proc/fd.c.
> > > 
> > > I think such move makes both fs/proc/base.c and fs/proc/fd.c
> > > easier to read.
> > 
> > BTW, looking at the other stuff in fs/proc/base.c, why the hell is
> > struct file * grabbed in proc_map_files_readdir()?  All we do with
> > it is passing it to proc_fill_cache(), which passes it to
> > proc_map_files_instantiate(), which looks at two sodding bits
> > in file->f_mode.  Then we go and fput() all those struct file
> > references we'd been putting into the array...  What for?
> 
> Well, this could be simplified indeed, if I understand you correctly
> you propose just save f_mode in flexible array and use it instead
> of struct file, right? (which will require to rewrite code a bit)

Yes.  FWIW, proc_fill_cache() is really atrocious ;-/  Not to mention
anything else, if we ever get a negative dentry there, we have a dentry
leak.  I don't think it's possible in practice, but...  Furthermore,
        if (!child || IS_ERR(child) || !child->d_inode)
                goto end_instantiate;
        inode = child->d_inode;
        if (inode) {
                ino = inode->i_ino;
                type = inode->i_mode >> 12;
        }
        dput(child);
looks really weird - how can we possibly get !inode when we'd just
checked that child->inode is non-NULL?  Moreover, that find_inode_number()
a bit below is also as weird as it gets - in effect, we repeat
d_lookup() we'd just done earlier.  How *can* it get us anything?
