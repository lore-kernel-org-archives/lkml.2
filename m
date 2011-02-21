Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428Ab1BUKoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 05:44:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45060 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402Ab1BUKoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 05:44:09 -0500
Date: Mon, 21 Feb 2011 02:44:01 -0800
From: Joel Becker <jlbec@evilplan.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: npiggin@kernel.dk, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: OOPS in configfs when doing d_delete
Message-ID: <20110221104359.GA18538@noexit>
Mail-Followup-To: Jiri Slaby <jslaby@suse.cz>, npiggin@kernel.dk,
	Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Jiri Slaby <jirislaby@gmail.com>
References: <4D623C62.8030509@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D623C62.8030509@suse.cz>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 11:20:18AM +0100, Jiri Slaby wrote:
> when configfs_attach_group fails in configfs_register_subsystem:
>         dentry = d_alloc(configfs_sb->s_root, &name);
>         if (dentry) {
>                 d_add(dentry, NULL);
> 
>                 err = configfs_attach_group(sd->s_element, &group->cg_item,
>                                             dentry);
>                 if (err) {
>                         d_delete(dentry);
>                         dput(dentry);
> 
> 
> d_delete kills the kernel. I don't know what the actual bug is here, but
> d_delete looks broken anyway:
>         spin_lock(&dentry->d_lock);
>         inode = dentry->d_inode;
>         isdir = S_ISDIR(inode->i_mode);  <======== dereference
>         if (dentry->d_count == 1) {
>                 if (inode && !spin_trylock(&inode->i_lock)) {
>                     ^^^^^  <============= test
> 
> It seems like a superfluous test, not a potential null dereference to
> me, right?

	I think you're right about the superfluous test, but I need more
investigation to see what's going on.  Thanks for the report.
	What was causing attach_group() to fail?  Do you know?

Joel

-- 

Life's Little Instruction Book #444

	"Never underestimate the power of a kind word or deed."

			http://www.jlbec.org/
			jlbec@evilplan.org
