Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab0LFRKQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 12:10:16 -0500
Received: from ist.d-labs.de ([213.239.218.44]:46986 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751815Ab0LFRKO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 12:10:14 -0500
Date: Mon, 6 Dec 2010 18:09:22 +0100
From: Florian Mickler <florian@mickler.org>
Cc: Prasad Joshi <prasadjoshi124@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, Joern <joern@logfs.org>,
        logfs@logfs.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] LogFS: Kernel BUG at readwrite.c:1193
Message-ID: <20101206180922.5f7fa3c1@schatten.dmk.lab>
In-Reply-To: <AANLkTikfu-AZNbZDrGqhca8hGXMrOwA1yJdZJRs0qq-Y@mail.gmail.com>
References: <AANLkTikfu-AZNbZDrGqhca8hGXMrOwA1yJdZJRs0qq-Y@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 16 Nov 2010 16:54:17 +0000
Prasad Joshi <prasadjoshi124@gmail.com> wrote:

> This happens when __logfs_create() tries to write a new inode to the
> disk which is full.
> 
> __logfs_create() associates the transaction pointer with inode. During
> the logfs_write_inode() function call chain this transaction pointer
> is moved from inode to page->private using function move_inode_to_page
> (do_write_inode() -> inode_to_page() -> move_inode_to_page)
> 
> When the write inode fails, the transaction is aborted and iput is
> called on the failed inode. During delete_inode the same transaction
> pointer associated with the page is getting used. Thus causing kernel
> BUG.
> 
> The patch checks for error in write_inode() and restores the
> page->private to NULL.
> 
> 



This fixes https://bugzilla.kernel.org/show_bug.cgi?id=20162 . Can
someone please review? Any comments?



> Signed-off-by: Prasad Joshi <prasadjoshi124@gmail.com>
> ---
> diff --git a/fs/logfs/readwrite.c b/fs/logfs/readwrite.c
> index 6127baf..ee99a9f 100644
> --- a/fs/logfs/readwrite.c
> +++ b/fs/logfs/readwrite.c
> @@ -1994,6 +1994,9 @@ static int do_write_inode(struct inode *inode)
> 
>         /* FIXME: transaction is part of logfs_block now.  Is that enough? */
>         err = logfs_write_buf(master_inode, page, 0);
> +       if (err)
> +               move_page_to_inode(inode, page);
> +
>         logfs_put_write_page(page);
>         return err;
>  }
> 
> 
> 
> ---------- Forwarded message ----------
> From:  <bugzilla-daemon@bugzilla.kernel.org>
> Date: Tue, Nov 16, 2010 at 3:20 PM
> Subject: [Bug 20162] [LogFS][2.6.36.rc7+] Kernel BUG at readwrite.c:1193
> To: prasadjoshi124@gmail.com
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=20162
> 
> 
> Florian Mickler <florian@mickler.org> changed:
> 
>           What    |Removed                     |Added
> ----------------------------------------------------------------------------
>             Status|NEW                         |RESOLVED
>                 CC|                            |florian@mickler.org
>         Resolution|                            |PATCH_ALREADY_AVAILABLE
> 
> 
> 
> 
> --- Comment #2 from Florian Mickler <florian@mickler.org>  2010-11-16
> 15:20:46 ---
> Can you submit that patch to lkml and cc the logfs maintainer and the logfs
> list?
> (Joern Engel <joern@logfs.org>, logfs@logfs.org, linux-kernel@vger.kernel.org)
> 
> See Documentation/SubmittingPatches
> 
> Patch: https://bugzilla.kernel.org/show_bug.cgi?id=20162#c1
> 
> --
> Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug.
