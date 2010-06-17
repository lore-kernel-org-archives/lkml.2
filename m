Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307Ab0FQCEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 22:04:50 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37845 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756755Ab0FQCEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 22:04:48 -0400
X-Sasl-enc: jdz4Xkkeajy7WE8BvARyRJ4OA2sNAUZ0sOJolQBKYfcW 1276740287
Subject: Re: [autofs] [PATCH 04/38] autofs4: Save autofs trigger's vfsmount
 in super block info
From: Ian Kent <raven@themaw.net>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, autofs@linux.kernel.org,
       Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>
In-Reply-To: <20100616231421.GD13908@shell>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
	 <1276627208-17242-5-git-send-email-vaurora@redhat.com>
	 <1276661043.2339.35.camel@localhost>  <20100616231421.GD13908@shell>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Jun 2010 10:04:41 +0800
Message-ID: <1276740281.2236.26.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-06-16 at 19:14 -0400, Valerie Aurora wrote:
> On Wed, Jun 16, 2010 at 12:04:03PM +0800, Ian Kent wrote:
> > On Tue, 2010-06-15 at 11:39 -0700, Valerie Aurora wrote:
> > > From: Jan Blunck <jblunck@suse.de>
> > > 
> > > XXX - This is broken and included just to make union mounts work.  See
> > > discussion at:
> > > 
> > > http://kerneltrap.org/mailarchive/linux-fsdevel/2010/1/15/6708053/thread
> > 
> > Instead of saving the vfsmount we could save a pointer to the dentry of
> > the mount point in the autofs super block info struct. I think that's
> > the bit I don't have so it would be sufficient for a lookup_mnt() for
> > the needed vfsmount in ->follow_mount().
> > 
> > Objections?
> > Suggestions?
> 
> I'm not sure... it seems like it would have the same problem that Al
> described with pinning the vfsmount forever.  But I don't know autofs
> at all.

That's why I asked.
But I don't see how the dentry can go away since it's covered by the
mount for the life of the mount.

> 
> Could you run through a quick example of the case that triggers this
> problem in the first place?  The problem is when you have a symlink
> that triggers an automount, and you are trying to get from the target
> of the symlink to the vfsmount of the file system containing the
> symlink in the first place?  Or do I have that wrong?

Ha!

Yes, you would think we were talking about a symlink but this dentry is
a directory, a trigger for a mount that uses ->follow_mount() to do the
mount, similar to the way the NFS client mounts nohide mounts when they
crossed.

In the autofs case we have:

<path in fs>/dir
      <autofs fs (with type direct or offset) mounted on>/dir

When ->follow_link() is called the nameidata has the vfsmount of the
once removed mount because it hasn't yet been updated in (say)
link_path_walk(), but the dentry passed to ->follow_link() is the global
root of the autofs fs so we have no way of discovering the vfsmount or
the dentry upon which the autofs trigger mount is mounted. Which of
course prevents us from mounting and following the trigger.

The example is rather poor, sorry, hope it is sufficient.

