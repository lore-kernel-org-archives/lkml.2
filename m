Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab0J3PkM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 11:40:12 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36499 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab0J3PkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 11:40:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DFKunQzMuiLs+9cHvAwCyH8K7uWjYs5M6ND8l35vOp2Nvt0gdMPkJY8uNQsOV06xwz
         nKfgUPdWynWZ7jfITVCUfbdSLYijk9JxvGgvUBqntP+RHlP+RNeIDxkfXJs9XX5tJVzs
         PaFI6Jx3tuAGRr1zJTW6ih+ul1xmOlrAggI/4=
Date: Sat, 30 Oct 2010 19:40:02 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipc: shm: fix information leak to userland
Message-ID: <20101030154002.GA14257@albatros>
References: <1288450677.3964.1.camel@dan>
 <1288450814.3964.3.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288450814.3964.3.camel@dan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Sat, Oct 30, 2010 at 11:00 -0400, Dan Rosenberg wrote:
> This one already got taken care of by Kees Cook:
> 
> http://lkml.org/lkml/2010/10/6/486

After 25 days it is still not in linux-next.  Also the second hunk is IMO odd
as all five fields are initialized:


	case IPC_OLD:
	    {
		struct shminfo out;

		if(in->shmmax > INT_MAX)
			out.shmmax = INT_MAX;
		else
			out.shmmax = (int)in->shmmax;

		out.shmmin	= in->shmmin;
		out.shmmni	= in->shmmni;
		out.shmseg	= in->shmseg;
		out.shmall	= in->shmall; 

		return copy_to_user(buf, &out, sizeof(out));
	    }

/* Obsolete, used only for backwards compatibility */
struct  shminfo {
        int shmmax;
        int shmmin;
        int shmmni;
        int shmseg;
        int shmall;
};

And I see no padding hole in shminfo.



> Thanks,
> Dan
> 
> > Structure shmid_ds is copied to userland with shm_unused{,2,3}
> > fields unitialized.  It leads to leaking of contents of kernel stack
> > memory.
> > Cc: stable@kernel.org
> > Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
> > Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> > ---
> >  Compile tested.
> >  ipc/shm.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > diff --git a/ipc/shm.c b/ipc/shm.c
> > index fd658a1..7d3bb22 100644
> > --- a/ipc/shm.c
> > +++ b/ipc/shm.c
> > @@ -479,6 +479,7 @@ static inline unsigned long copy_shmid_to_user(void __user *buf, struct shmid64_
> >  	    {
> >  		struct shmid_ds out;
> >  
> > +		memset(&out, 0, sizeof(out));
> >  		ipc64_perm_to_ipc_perm(&in->shm_perm, &out.shm_perm);
> >  		out.shm_segsz	= in->shm_segsz;
> >  		out.shm_atime	= in->shm_atime;
> 
> 

Thanks,

-- 
Vasiliy
