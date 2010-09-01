Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829Ab0IAB4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 21:56:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508Ab0IAB4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 21:56:44 -0400
Date: Tue, 31 Aug 2010 21:56:16 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
Message-ID: <20100901015616.GD5759@shell>
References: <20100827170551.19616048@notabene> <E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu> <20100827213502.31af4a4c@notabene> <E1Op2BV-0008Ut-BR@pomaz-ex.szeredi.hu> <20100829144207.4fbf2713@notabene> <E1Oq1RL-0003zF-Tw@pomaz-ex.szeredi.hu> <20100830214027.77e197f5@notabene> <E1Oq3Lz-0004D8-MP@pomaz-ex.szeredi.hu> <20100831191846.GA5759@shell> <1283285987.7914.9.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283285987.7914.9.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 31, 2010 at 04:19:47PM -0400, Trond Myklebust wrote:
> On Tue, 2010-08-31 at 15:18 -0400, Valerie Aurora wrote:
> > On Mon, Aug 30, 2010 at 02:20:47PM +0200, Miklos Szeredi wrote:
> > > On Mon, 30 Aug 2010, Neil Brown wrote:
> > > 
> > > > Val has been following that approach and asking if it is possible to make an
> > > > NFS filesystem really-truly read-only. i.e. no changes.
> > > > I don't believe it is.
> > > 
> > > Perhaps it doesn't matter.  The nasty cases can be prevented by just
> > > disallowing local modification.  For the rest NFS will return ESTALE:
> > > "though luck, why didn't you follow the rules?"
> > 
> > I agree: Ask the server to keep it read-only, but also detect if it
> > lied to prevent kernel bugs on the client.
> > 
> > Is detecting ESTALE and failing the mount sufficient to detect all
> > cases of a cached directory being altered?
> 
> No. Files can be altered without being unlinked.

Argh.  Do generation numbers and/or mtime help us here?

> >   I keep trying to trap an
> > NFS developer and beat the answer out of him but they usually get hung
> > up on the impossibility of 100% enforcement of the read-only server
> > option. (Agreed, impossible, just give the sysadmin a mount option so
> > that it doesn't happen accidentally.)
> 
> Remind me again why mounting the filesystem '-oro' on the server (and
> possibly exporting it 'ro') isn't an option?

The "hard read only" export option is to, at minimum, make it
difficult to *accidentally* remount the file system on the server as
read-write while it is exported as a union lower layer.

True, the NFS server can mount the file system "-o ro" - and then any
random other mount(8) on the server can come along and "-o
remount,rw".  So if we have an NFS server option that uses the new
hard read-only feature, this at least makes the admin go change the
NFS mount options or unexport it before writing to the exported union
lower layer and hosing all the union mount clients.

It's the difference between:

# mount -o remount,rw /exports/union_mount_root
 [thousands of union mounted clients hang]

And:

# mount -o remount,rw /exports/union_mount_root
mount: /exports/union_mount_root is hard read-only
# emacs /etc/exports
  [edit out union/hard readonly option]
# exportfs -r
 [thousands of union mounted clients hang]

But heck, system administration is hard, what's a little more rope?
Here, hold this gun while I position your foot...

-VAL
