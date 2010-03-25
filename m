Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0CYOFA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:05:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59426 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab0CYOE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:04:59 -0400
Date: Thu, 25 Mar 2010 14:04:57 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Benny Halevy <bhalevy@panasas.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Doug Nazar <nazard.lkml@gmail.com>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
Message-ID: <20100325140457.GB30031@ZenIV.linux.org.uk>
References: <20100324185604.GT30031@ZenIV.linux.org.uk>
 <4BAB2F5A.30409@panasas.com>
 <20100325101231.GU30031@ZenIV.linux.org.uk>
 <20100325105406.GW30031@ZenIV.linux.org.uk>
 <4BAB51F5.609@panasas.com>
 <4BAB54B0.3080109@panasas.com>
 <20100325130610.GZ30031@ZenIV.linux.org.uk>
 <4BAB656E.8020204@panasas.com>
 <20100325133746.GA30031@ZenIV.linux.org.uk>
 <4BAB6911.5020009@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAB6911.5020009@panasas.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 03:45:53PM +0200, Boaz Harrosh wrote:
> > Does open() of directory _without_ O_DIRECTORY work in e.g. vanilla 2.6.33?
> > It certainly does for local filesystems and it does for NFSv3; does it work
> > for NFSv4?
> 
> In my tests. Every thing is the same safe the client with the above change.
> 
> So I guess NFSv4 does something different when asked for directory lookup
> as opposed to files lookup. I guess there is something added/removed to
> the compound depending on that flag. But I wouldn't know, I am not familiar 
> with this code. NFSv4 someone?

OK, what happens if you do the following:

mount the same fs from two clients
on one client:
mkdir /mnt/weird_name_69
on another:
echo 'main() {open("/mnt/weird_name_69", 0);}' >/tmp/a.c
gcc /tmp/a.c
strace ./a.out
ls -l /mnt/weird_name_69
strace ./a.out

Will the first strace show EISDIR and the second succeed?

>From my reading of that code (2.6.33, before all that stuff got merged),
we have different behaviour depending on which codepath do we hit.
If we go through ->d_revalidate(), it sees that it's not S_ISREG() and
doesn't try to play with atomic open.  If we go through ->lookup(), we
tell the server to open it, and when it tells us to bugger off (it's a
directory, NFSv4 doesn't support atomic open for those), -EISDIR is
passed to caller.  Which leads to open() failing.

It definitely looks like a bug.  Masked by O_DIRECTORY in 2.6.33.  Bug
in fs/namei.c patch has exposed that crap both for O_DIRECTORY and !O_DIRECTORY
cases.

So immediate fix will need to be along the lines of "add LOOKUP_DIRECTORY
even on the last step if we have *want_dir" (and I'd probably get rid of
want_dir then and just abuse nd->flags), but there's a real NFS bug as
well.
