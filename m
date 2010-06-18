Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab0FRVGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 17:06:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab0FRVGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 17:06:30 -0400
Date: Fri, 18 Jun 2010 17:06:12 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 17/38] union-mount: Union mounts documentation
Message-ID: <20100618210612.GB24188@shell>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-18-git-send-email-vaurora@redhat.com> <AANLkTilNAGzn3ZC5eN2ZQMqNhcSWnT-mi_y2TkIkdeUU@mail.gmail.com> <20100617183912.GA14389@shell> <AANLkTilUbzQjEBiZ9LHEvugLXbsaZoEyt9S-v3KQgUQB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilUbzQjEBiZ9LHEvugLXbsaZoEyt9S-v3KQgUQB@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 10:32:09PM +0200, Alex Riesen wrote:
> On Thu, Jun 17, 2010 at 20:39, Valerie Aurora <vaurora@redhat.com> wrote:
> > On Thu, Jun 17, 2010 at 10:01:30AM +0200, Alex Riesen wrote:
> >> On Tue, Jun 15, 2010 at 20:39, Valerie Aurora <vaurora@redhat.com> wrote:
> >> > +git://git.kernel.org/pub/scm/fs/ext2/val/e2fsprogs.git
> >> > +
> >> > +Currently, whiteout directory entries are not returned to userland.
> >> > +While the directory type for whiteouts, DT_WHT, has been defined for
> >> > +many years, very little userland code handles them. ??Userland will
> >> > +never see fallthru directory entries.
> >>
> >> This may be a dumb question (I must admit I did only very little research),
> >> but how does one cleanup the topmost layer of whiteouts and fallthroughs,
> >> so that the entries of lower layer(s) can be made visible again?
> >
> > I'm not sure how best to do this. ??We don't want to add more system
> > calls. ??One thought of mine has been to do this offline, when the file
> > system is unmounted.
> 
> But that means that if the topmost filesystem is getting full of whiteouts
> and fallthroughs there will be no way to free up the space without taking
> the volume offline! That makes operation of union mount on always-on
> systems difficult. Many personal electronics are always-on today, it
> will be annoying to have to shutdown them on reconfigurations or just
> to free up some space.

Whiteouts and fallthrus go away when a directory is deleted.  So, "rm
-rf /trash/" will actually free up disk space.  You can also move the
files you want to keep to a temp directory, rmdir the old one, and
move that dir back.

Unfortunately, union mounts runs into a lot of bizarre ENOSPC
problems.  But in the degenerate case in which you delete every single
file from the lower layer file system, that information will take up
only one whiteout per top-level subdir.  You don't keep whiteouts for
anything below a deleted directory.

> >??... For example, e2fsck could add a feature to
> > delete whiteouts and fallthrus. ...
> 
> That makes me think that the cleanup operation will be topmost
> filesystem specific. Maybe this even means that one have to
> have the filesystem specific tools installed on every system
> which happens to use union mounts.

Any union mount utilities would be distributed as part of the normal
file system utilities package.

> >??Another option is to add a flag to an existing system call.
> 
> Or calls, if the whiteouts (or even fallthroughs) are to be read
> through directory file handles. unlinkat(2) ? It already has
> dirfd and flags arguments.

Yeah, unlinkat() looks promising.

-VAL
