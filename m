Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757390Ab2HYTM0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 15:12:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59540 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab2HYTMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 15:12:25 -0400
Date: Sat, 25 Aug 2012 20:12:18 +0100
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
Message-ID: <20120825191218.GV23464@ZenIV.linux.org.uk>
References: <20120823104323.040550004@openvz.org>
 <20120823104725.592602491@openvz.org>
 <20120825171605.GT23464@ZenIV.linux.org.uk>
 <20120825173958.GC19184@moon>
 <20120825175504.GU23464@ZenIV.linux.org.uk>
 <20120825185829.GE19184@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120825185829.GE19184@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 25, 2012 at 10:58:29PM +0400, Cyrill Gorcunov wrote:
> On Sat, Aug 25, 2012 at 06:55:04PM +0100, Al Viro wrote:
> > > Well, this could be simplified indeed, if I understand you correctly
> > > you propose just save f_mode in flexible array and use it instead
> > > of struct file, right? (which will require to rewrite code a bit)
> > 
> > Yes.  FWIW, proc_fill_cache() is really atrocious ;-/  Not to mention
> 
> OK, thanks. I'm putting this cleanup task in my big todo list. Hope I'll
> manage on the next week with it.
> 
> > anything else, if we ever get a negative dentry there, we have a dentry
> > leak.  I don't think it's possible in practice, but...  Furthermore,
> 
> could you please elaborate, you mean this string?

I mean that if we get to that if (... || !child->d_inode) and end up
evaluating the last part at all, we have acquired a reference to that
struct dentry.  And if that last part ends up being true (i.e. if it's
a negative dentry), we'll return from function without having dropped
the reference we'd acquired.
