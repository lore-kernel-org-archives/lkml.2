Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab2JBPxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:53:41 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60000
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754134Ab2JBPxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:53:39 -0400
Date: Tue, 2 Oct 2012 11:53:38 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: viro@ZenIV.linux.org.uk, eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: Re: [PATCH v7 02/49] audit: pass in dentry to audit_copy_inode
 wherever possible
Message-ID: <20121002155338.GB22698@infradead.org>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
 <1349137018-21948-3-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349137018-21948-3-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 08:16:11PM -0400, Jeff Layton wrote:
> In some cases, we were passing in NULL even when we have a dentry.
> 
> Reported-by: Eric Paris <eparis@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  kernel/auditsc.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 4b96415..5c45b9b 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -2226,7 +2226,7 @@ void __audit_inode_child(const struct dentry *dentry,
>  		if (!strcmp(dname, n->name) ||
>  		     !audit_compare_dname_path(dname, n->name, &dirlen)) {
>  			if (inode)
> -				audit_copy_inode(n, NULL, inode);
> +				audit_copy_inode(n, dentry, inode);

Btw, the calling conventions here also seems fairly ugly.

Instead of the optional dentry parameter I'd have a audit_copy_inode
that takes just the name and the inode, and an optional direct  call
to audit_copy_fcaps for those callers that have a dentry.  That would
also allow removing the branch for the dentry == NULL case in
audit_copy_fcaps.

