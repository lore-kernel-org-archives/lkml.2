Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab2HYS6h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 14:58:37 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:43527 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041Ab2HYS6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 14:58:33 -0400
Date: Sat, 25 Aug 2012 22:58:29 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 1/9] procfs: Move /proc/pid/fd[info] handling code to
 fd.[ch]
Message-ID: <20120825185829.GE19184@moon>
References: <20120823104323.040550004@openvz.org>
 <20120823104725.592602491@openvz.org>
 <20120825171605.GT23464@ZenIV.linux.org.uk>
 <20120825173958.GC19184@moon>
 <20120825175504.GU23464@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120825175504.GU23464@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 06:55:04PM +0100, Al Viro wrote:
> > Well, this could be simplified indeed, if I understand you correctly
> > you propose just save f_mode in flexible array and use it instead
> > of struct file, right? (which will require to rewrite code a bit)
> 
> Yes.  FWIW, proc_fill_cache() is really atrocious ;-/  Not to mention

OK, thanks. I'm putting this cleanup task in my big todo list. Hope I'll
manage on the next week with it.

> anything else, if we ever get a negative dentry there, we have a dentry
> leak.  I don't think it's possible in practice, but...  Furthermore,

could you please elaborate, you mean this string?

	struct dentry *child, *dir = filp->f_path.dentry;

>         if (!child || IS_ERR(child) || !child->d_inode)
>                 goto end_instantiate;

this could be IS_ERR_OR_NULL i guess

>         inode = child->d_inode;
>         if (inode) {
>                 ino = inode->i_ino;
>                 type = inode->i_mode >> 12;
>         }
>         dput(child);
> looks really weird - how can we possibly get !inode when we'd just
> checked that child->inode is non-NULL?  Moreover, that find_inode_number()
> a bit below is also as weird as it gets - in effect, we repeat
> d_lookup() we'd just done earlier.  How *can* it get us anything?

to be fair -- I don't know ;) I mean I didn't invent this function
but it definitely could be cleaned up. That was partly a reason
why I've moved fd related code to fd.c|h (base.c is really big
in content already and it's always a problem at least for me to
follow big "c" files).

I can try to clean this code up, but not in this patch series,
just to not mess the series even more.

	Cyrill
