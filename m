Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab2JBQlJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:41:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095Ab2JBQlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:41:00 -0400
Date: Tue, 2 Oct 2012 12:40:50 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@ZenIV.linux.org.uk, eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: Re: [PATCH v7 02/49] audit: pass in dentry to audit_copy_inode
 wherever possible
Message-ID: <20121002124050.58ebe279@tlielax.poochiereds.net>
In-Reply-To: <20121002155338.GB22698@infradead.org>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
	<1349137018-21948-3-git-send-email-jlayton@redhat.com>
	<20121002155338.GB22698@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2012 11:53:38 -0400
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Oct 01, 2012 at 08:16:11PM -0400, Jeff Layton wrote:
> > In some cases, we were passing in NULL even when we have a dentry.
> > 
> > Reported-by: Eric Paris <eparis@redhat.com>
> > Signed-off-by: Jeff Layton <jlayton@redhat.com>
> > ---
> >  kernel/auditsc.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index 4b96415..5c45b9b 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -2226,7 +2226,7 @@ void __audit_inode_child(const struct dentry *dentry,
> >  		if (!strcmp(dname, n->name) ||
> >  		     !audit_compare_dname_path(dname, n->name, &dirlen)) {
> >  			if (inode)
> > -				audit_copy_inode(n, NULL, inode);
> > +				audit_copy_inode(n, dentry, inode);
> 
> Btw, the calling conventions here also seems fairly ugly.
> 
> Instead of the optional dentry parameter I'd have a audit_copy_inode
> that takes just the name and the inode, and an optional direct  call
> to audit_copy_fcaps for those callers that have a dentry.  That would
> also allow removing the branch for the dentry == NULL case in
> audit_copy_fcaps.
> 

[...]

> On Mon, Oct 01, 2012 at 08:16:12PM -0400, Jeff Layton wrote:
> > If name is NULL then the condition in the loop will never be true. Also,
> > with this change, we can eliminate the check for n->name == NULL since
> > the equivalence check will never be true if it is.
> 
> Given that name == NULL is a static condition it seems like these
> should be two different calls, E.g. audit_dentry and audit_path.
> 

Thanks Christoph,

Both of the above are good suggestions, but I'd prefer not to have to
respin this whole set to implement them. I believe what I have here is
an improvement on what's there now. Do you have any objection to doing
the above in a separate set on top of this series?

-- 
Jeff Layton <jlayton@redhat.com>
