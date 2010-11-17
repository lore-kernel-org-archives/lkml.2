Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935402Ab0KQT2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 14:28:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37363 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758075Ab0KQT2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 14:28:30 -0500
Date: Wed, 17 Nov 2010 14:28:22 -0500
From: Josef Bacik <josef@redhat.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
        eparis@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: call security_d_instantiate in d_obtain_alias
Message-ID: <20101117192822.GB3818@localhost.localdomain>
References: <1290016263-1637-1-git-send-email-josef@redhat.com> <20101117191817.GA26575@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117191817.GA26575@fieldses.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 02:18:17PM -0500, J. Bruce Fields wrote:
> On Wed, Nov 17, 2010 at 12:51:03PM -0500, Josef Bacik wrote:
> > While trying to track down some NFS problems with BTRFS, I kept noticing I was
> > getting -EACCESS for no apparent reason.  Eric Paris and printk() helped me
> > figure out that it was SELinux that was giving me grief, with the following
> > denial
> > 
> > type=AVC msg=audit(1290013638.413:95): avc:  denied  { 0x800000 } for  pid=1772
> > comm="nfsd" name="" dev=sda1 ino=256 scontext=system_u:system_r:kernel_t:s0
> > tcontext=system_u:object_r:unlabeled_t:s0 tclass=file
> > 
> > Turns out this is because in d_obtain_alias if we can't find an alias we create
> > one and do all the normal instantiation stuff, but we don't do the
> > security_d_instantiate.  With this patch I'm no longer seeing these errant
> > -EACCESS return values.  Thanks,
> 
> Possibly dumb question: Is there still a small race here?  Is it
> possible for another nfsd thread to find the new alias on the list while
> this thread is still:
> 
> > 
> > Signed-off-by: Josef Bacik <josef@redhat.com>
> > ---
> >  fs/dcache.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/dcache.c b/fs/dcache.c
> > index 23702a9..890a59e 100644
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -1201,6 +1201,7 @@ struct dentry *d_obtain_alias(struct inode *inode)
> >  	spin_unlock(&tmp->d_lock);
> >  
> >  	spin_unlock(&dcache_lock);
> 
> ... right here, so that that other nfsd thread still ends up trying to
> do something with a dentry that hasn't had security_d_instantiate called
> on it yet?
> 
> > +	security_d_instantiate(tmp, inode);
> >  	return tmp;
> >  
> >   out_iput:
> > -- 
> 
> Or does something else prevent that?
> 

That's a good question, I have no idea actually.  Every other consumer of
security_d_instantiate seems to hold the i_mutex of the parent directory inode,
tho I'm not sure if that is appropriate for d_obtain_alias, maybe somebody else
has an idea?  Thanks,

Josef
