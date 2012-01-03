Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab2ACP3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 10:29:19 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:41105 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab2ACP3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 10:29:18 -0500
Subject: Re: Reiserfs.c bug in 3.2-rc5
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        haiyangz@microsoft.com, hjanssen@microsoft.com,
        "'Rafael J. Wysocki'" <rjw@sisk.pl>, James Morris <jmorris@namei.org>,
        Jorge Bastos <mysql.jorge@decimal.pt>, Mark Fasheh <mfasheh@suse.com>,
        Joel Becker <jlbec@evilplan.org>
Date: Tue, 03 Jan 2012 10:25:55 -0500
In-Reply-To: <20120103123841.GA31457@quack.suse.cz>
References: <43556.213.228.140.150.1323560920.squirrel@webmail.decimal.pt>
	 <20111213180707.GI11747@quack.suse.cz>
	 <!&!AAAAAAAAAAAYAAAAAAAAAKCACr8ZwetPrGXZsycJodKihAAAEAAAAGPJDX4w3wxIo8Onu2+q/xMBAAAAAA==@decimal.pt>
	 <20120102115222.GA3626@quack.suse.cz>
	 <005301ccc998$201c9da0$6055d8e0$@jorge@decimal.pt>
	 <20120103010826.GF3626@quack.suse.cz>
	 <000701ccc9fa$74df73f0$5e9e5bd0$@jorge@decimal.pt>
	 <20120103123841.GA31457@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1325604356.2095.23.camel@falcor>
Mime-Version: 1.0
x-cbid: 12010315-6148-0000-0000-0000025E300F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-03 at 13:38 +0100, Jan Kara wrote:
> Hell,
> 
> On Tue 03-01-12 09:31:22, Jorge Bastos wrote:
> > >   Yes, thanks! So we see that reiserfs_security_init() returned bogus
> > >   number 790797. This is caused by security_old_inode_init_security()
> > >   either returning some bogus number or setting sec->length to
> > >   something bogus.  In any case it's some security module problem so
> > >   I'm adding Mimi Zohar who did the changes in this code recently to
> > >   CC. I'm also adding Rafael since this is a regression.
> > > 
> > >   Also I think he might use your kernel config so can you please send
> > > it?
> > > Thanks.
> > 
> > Sure,
> > Please grab it here:
> > 
> > http://neotrix.decimal.pt/bugs/config-3.2-rc7.txt 
> > 
> > Let me know when the fix gets commited git master.
>   Thanks! So I've managed to reproduce the problem and I now understand
> what is the problem. Commit 1e39f384bb01b0395b69cb70c2cacae65012f203 makes
> security_old_inode_init_security() return 0 when CONFIG_SECURITY is not
> set. But that makes caller such as reiserfs_security_init() assume that
> security_old_inode_init_security() has set name, value, and len arguments
> properly (which is IMO correct assumption). But they were left
> uninitialized which makes things break in an interesting ways... The fix is
> below.
> 
> Mimi, James, Linus, this patch fixes a regression from 3.1 and should make
> it to 3.2 if possible.
> 
> 								Honza

Commit fb88c2b changed the security_old_inode_init_security() return
code for S_PRIVATE inodes. As long as -EOPNOTSUPP is expected, probably
should revert that as well.

(I'm cc'ing the ocfs2 maintainers.)

thanks,

Mimi

> ----
> 
> From 5bcd17065fa27d5f27756e24a98331f796ff2481 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Tue, 3 Jan 2012 13:14:29 +0100
> Subject: [PATCH] security: Fix security_old_inode_init_security() when CONFIG_SECURITY is not set
> 
> Commit 1e39f384bb01b0395b69cb70c2cacae65012f203 makes
> security_old_inode_init_security() return 0 when CONFIG_SECURITY is not set.
> But that makes callers such as reiserfs_security_init() assume that
> security_old_inode_init_security() has set name, value, and len arguments
> properly. But security_old_inode_init_security() left them uninitialized
> which then results in interesting failures.
> 
> Revert security_old_inode_init_security() to the old behavior of returning
> EOPNOTSUPP since both callers (reiserfs and ocfs2) handle this just fine.
> 
> Reported-by: Jorge Bastos <mysql.jorge@decimal.pt>
> CC: James Morris <jmorris@namei.org>
> CC: Mimi Zohar <zohar@us.ibm.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  include/linux/security.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 19d8e04..e8c619d 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -2056,7 +2056,7 @@ static inline int security_old_inode_init_security(struct inode *inode,
>  						   char **name, void **value,
>  						   size_t *len)
>  {
> -	return 0;
> +	return -EOPNOTSUPP;
>  }
> 
>  static inline int security_inode_create(struct inode *dir,


