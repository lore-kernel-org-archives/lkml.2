Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab2DZIgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 04:36:15 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38652 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754481Ab2DZIgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 04:36:09 -0400
X-Sasl-enc: mdy3n/WGDNvXEfHx7fa2279eXSQxy85tQoTp4BtpCUzO7dXECynKaLs8dQ 1335429368
Message-ID: <1335429364.6702.37.camel@perseus.themaw.net>
Subject: Re: [PATCH] unbreak automount daemon after fixing autofs5 ABI
From: Ian Kent <raven@themaw.net>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Meyer <thomas@m3y3r.de>, stable@kernel.org,
        autofs@vger.kernel.org
Date: Thu, 26 Apr 2012 16:36:04 +0800
In-Reply-To: <1335428498.6702.33.camel@perseus.themaw.net>
References: <1335421594-10499-1-git-send-email-mjt@msgid.tls.msk.ru>
	 <1335428498.6702.33.camel@perseus.themaw.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-26 at 16:21 +0800, Ian Kent wrote:
> On Thu, 2012-04-26 at 10:26 +0400, Michael Tokarev wrote:
> > Patch 499f286dc02cde6b668e2d757dfe100cb0c43445, comitted
> > in Feb-2012, fixed a kernel<=>user interface which was
> > broken for mixed 32/64 user/kernel environment since its
> > introduction in 2006 by commit 5c0a32fc2cd0.  The problem
> > with this fix is that it broke userspace which were adopted
> > to the initial bug a year after its introduction, in
> > autofs-5.0.1.  So patch 499f286dc02cde6b broke a working
> > userspace.  This has been done because another user of
> > this interface emerged, systemd, which had the same prob
> > as old automount (<5.0.1) had.  So the end result was a
> > breakage of an old, widely used -- by all current and
> > previous distribution -- software (autofs5) in order to
> > unbreak a new not yet widely adopted software (systemd).
> > 
> > The real fix for this issue, in my opinion, is to adopt
> > the same fix in systemd as has been done in autofs5, and/or
> > to have a new interface without a bug wich both userspace
> > implementations will use.
> > 
> > Alternative is to find a way on the kernel side to see
> > which variant of userspace we're dealing with, by seeing
> > how many bytes for the structure in question the userspace
> > requests in read operation.  But since autofs uses regular
> > pipe code to read the data from kernel, and the said pipe
> > is opened in userspace before connecting it with the autofs
> > module, reads are not seen by autofs module directly, they're
> > seen by the pipe code.
> > 
> > So for now, below is a minimal quick fix which should sort
> > current mess.
> > 
> > Change 499f286dc02cde6b tries to fix the original interface
> > bug for 32bit userspace running on 64bit kernel.  But the
> > issue is that autofs5 already has a workaround for it, so
> > the end result is that the two (kernel & user) disagree
> > again.  "Fix" this by applying the in-kernel fix only if
> > the process is not named "automount" -- which is how autofs5
> > daemon is named.
> 
> No, you cannot be sure the autofs binary is named automount.
> Not only that, this approach makes an unpleasant change even more
> unpleasant.
> 
> I still think that my original proposed patches were the better approach
> to handling this problem.

Actually, just to give credit (or blame) where it is due, while this was
my preferred way to handle this, Thomas wrote the original patch which I
changed a little before proposing.

> 
> My recommendation was that the major autofs kernel protocol version be
> bumped and a packed structure used from that version on. That allows
> user space to request that protocol version for communication at mount
> time. If systemd doesn't want to support earlier protocol versions then
> it can complain, instructing the user to update to a later kernel.
> 
> I understand why that proposal was not well accepted but the fact
> remains, I did make a mistake and I did chose to work around it in user
> space rather than cope with the pain at the time. In hind site that may
> have been the wrong thing to do but that's history. So I believe the
> most sensible thing to do now is to take the approach that minimizes
> breakage.
> 
> > 
> > This change should be applied to all 3.x stable series too,
> > since it breaks existing userspace for these kernels.
> > 
> > Signed-off-by: Michael Tokarev <mjt@tls.msk.ru>
> > Cc: Ian Kent <raven@themaw.net>
> > Cc: Thomas Meyer <thomas@m3y3r.de>
> > Cc: stable@kernel.org
> > Cc: autofs@vger.kernel.org
> > ---
> >  fs/autofs4/dev-ioctl.c |    3 ++-
> >  fs/autofs4/inode.c     |    3 ++-
> >  2 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
> > index 9dacb85..d5a4cb6 100644
> > --- a/fs/autofs4/dev-ioctl.c
> > +++ b/fs/autofs4/dev-ioctl.c
> > @@ -385,7 +385,8 @@ static int autofs_dev_ioctl_setpipefd(struct file *fp,
> >  		sbi->pipefd = pipefd;
> >  		sbi->pipe = pipe;
> >  		sbi->catatonic = 0;
> > -		sbi->compat_daemon = is_compat_task();
> > +		sbi->compat_daemon =
> > +			is_compat_task() && strcmp(current->comm, "automount");
> 
> If this approach is used it might be better to use a length limited
> comparison so that if a distribution needs to have multiple packages
> side by side, perhaps v4 or 32 and 64 bit, they would most likely append
> something on the end of the binary name.
>  
> >  	}
> >  out:
> >  	mutex_unlock(&sbi->wq_mutex);
> > diff --git a/fs/autofs4/inode.c b/fs/autofs4/inode.c
> > index d8dc002..b59f6a0 100644
> > --- a/fs/autofs4/inode.c
> > +++ b/fs/autofs4/inode.c
> > @@ -225,7 +225,8 @@ int autofs4_fill_super(struct super_block *s, void *data, int silent)
> >  	set_autofs_type_indirect(&sbi->type);
> >  	sbi->min_proto = 0;
> >  	sbi->max_proto = 0;
> > -	sbi->compat_daemon = is_compat_task();
> > +	sbi->compat_daemon =
> > +		is_compat_task() && strcmp(current->comm, "automount");
> >  	mutex_init(&sbi->wq_mutex);
> >  	mutex_init(&sbi->pipe_mutex);
> >  	spin_lock_init(&sbi->fs_lock);
> 


