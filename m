Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab0CYOGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:06:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48822 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab0CYOGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:06:08 -0400
Date: Thu, 25 Mar 2010 14:06:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Benny Halevy <bhalevy@panasas.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Doug Nazar <nazard.lkml@gmail.com>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [pnfs] [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT
 case to use of do_last()
Message-ID: <20100325140605.GC30031@ZenIV.linux.org.uk>
References: <20100324185604.GT30031@ZenIV.linux.org.uk>
 <4BAB2F5A.30409@panasas.com>
 <20100325101231.GU30031@ZenIV.linux.org.uk>
 <20100325105406.GW30031@ZenIV.linux.org.uk>
 <4BAB51F5.609@panasas.com>
 <4BAB54B0.3080109@panasas.com>
 <20100325130610.GZ30031@ZenIV.linux.org.uk>
 <4BAB656E.8020204@panasas.com>
 <20100325133746.GA30031@ZenIV.linux.org.uk>
 <4BAB6A99.5070209@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BAB6A99.5070209@panasas.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 03:52:25PM +0200, Benny Halevy wrote:
> On Mar. 25, 2010, 15:37 +0200, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> > On Thu, Mar 25, 2010 at 03:30:22PM +0200, Boaz Harrosh wrote:
> >>> Let's try this: before do_lookup() call there add
> >>> 	if (*want_dir)
> >>> 		nd->flags |= LOOKUP_DIRECTORY;
> >> Yes this fixes it!!
> >> 2.6.34-rc2 plus above, now works, horay. (diff attached)
> >>
> >>> and see how does it behave.
> >>>
> >>> However, even if it does help, it doesn't explain everything.  Normal
> >>> open() on a directory without O_DIRECTORY if flags shouldn't fail with
> >>> -EISDIR.  How did that manage to avoid it all along?
> > 
> > Does open() of directory _without_ O_DIRECTORY work in e.g. vanilla 2.6.33?
> > It certainly does for local filesystems and it does for NFSv3; does it work
> > for NFSv4?
> 
> No, it doesn't.
> 
> # mount localhost:/usr0/nfs4export /mnt/localhost; strace cat /mnt/localhost/server 2>&1 | grep 'open.*server'; umount /mnt/localhost
> open("/mnt/localhost/server", O_RDONLY) = 3
> 
> # mount -t nfs4 localhost:/ /mnt/localhost; strace cat /mnt/localhost/server 2>&1 | grep 'open.*server'; umount /mnt/localhost
> open("/mnt/localhost/server", O_RDONLY) = -1 EISDIR (Is a directory)

Gets better - if you do ls -l /mnt/localhost/server and then repeat that
open(), it'll succeed.
