Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab2CMMBk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:01:40 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49389
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751228Ab2CMMBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:01:38 -0400
Date: Tue, 13 Mar 2012 08:01:37 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Christoph Hellwig <hch@infradead.org>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Trond.Myklebust@netapp.com, sfrench@samba.org, sage@newdream.net,
        ericvh@gmail.com
Subject: Re: [PATCH 00/25] vfs: atomic open RFC
Message-ID: <20120313120137.GA21755@infradead.org>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
 <20120313095102.GA27480@infradead.org>
 <87y5r49362.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y5r49362.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 12:00:05PM +0100, Miklos Szeredi wrote:
> > Do we really need the opendata structure?
> >
> > It seems like we could just pass a struct path instead of the dentry
> > passed directly and the vfsmount in it.  There should be no need to
> > preallocate the file before calling into ->atomic_open, as it's only
> > used to pass around f_flags - but we already pass that one to
> > ->atomic_open directly and might as well pass it on to finish_open and
> > allocate the file there.
> 
> We really don't want to get into the situation where the open fails
> after a successful create(*).  Which means the file needs to be allocated
> prior to calling ->atomic_open and needs to be passed to finish_open()
> toghether with the vfsmount and dentry.
> 
> In the first version of the patch I set filp->f_path.mnt to nd->path.mnt
> and passed the half initialized filp to ->atomic_open.  But then decided
> that it's confusing for the filesystem code to deal with a half baked
> filp (does it need to be fput on error?  etc...)
> 
> Doing it with an opaque opendata makes this cleaner I think.

Make sense.  Can you throw in another cleanup patch to really just make
it a pass-through and not also use it as a boolean flag if open_flags
should be obeyed?  This probably will change sematincs for the various
filesystems, but given that they should behave the same way that's a
good thing.
