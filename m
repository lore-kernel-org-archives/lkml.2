Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220Ab0IAEFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 00:05:53 -0400
Received: from mx2.netapp.com ([216.240.18.37]:24566 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704Ab0IAEFw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 00:05:52 -0400
X-IronPort-AV: E=Sophos;i="4.56,301,1280732400"; 
   d="scan'208";a="440324046"
Subject: Re: [PATCH 0/5] hybrid union filesystem prototype
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, jblunck@suse.de, hch@infradead.org
In-Reply-To: <20100901015616.GD5759@shell>
References: <20100827170551.19616048@notabene>
	 <E1Ooub5-0007Wh-SQ@pomaz-ex.szeredi.hu> <20100827213502.31af4a4c@notabene>
	 <E1Op2BV-0008Ut-BR@pomaz-ex.szeredi.hu> <20100829144207.4fbf2713@notabene>
	 <E1Oq1RL-0003zF-Tw@pomaz-ex.szeredi.hu> <20100830214027.77e197f5@notabene>
	 <E1Oq3Lz-0004D8-MP@pomaz-ex.szeredi.hu> <20100831191846.GA5759@shell>
	 <1283285987.7914.9.camel@heimdal.trondhjem.org>
	 <20100901015616.GD5759@shell>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Wed, 01 Sep 2010 00:04:49 -0400
Message-ID: <1283313889.5220.16.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
X-OriginalArrivalTime: 01 Sep 2010 04:05:22.0454 (UTC) FILETIME=[E6137360:01CB498A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-31 at 21:56 -0400, Valerie Aurora wrote:
> On Tue, Aug 31, 2010 at 04:19:47PM -0400, Trond Myklebust wrote:
> > On Tue, 2010-08-31 at 15:18 -0400, Valerie Aurora wrote:
> > > On Mon, Aug 30, 2010 at 02:20:47PM +0200, Miklos Szeredi wrote:
> > > > On Mon, 30 Aug 2010, Neil Brown wrote:
> > > > 
> > > > > Val has been following that approach and asking if it is possible to make an
> > > > > NFS filesystem really-truly read-only. i.e. no changes.
> > > > > I don't believe it is.
> > > > 
> > > > Perhaps it doesn't matter.  The nasty cases can be prevented by just
> > > > disallowing local modification.  For the rest NFS will return ESTALE:
> > > > "though luck, why didn't you follow the rules?"
> > > 
> > > I agree: Ask the server to keep it read-only, but also detect if it
> > > lied to prevent kernel bugs on the client.
> > > 
> > > Is detecting ESTALE and failing the mount sufficient to detect all
> > > cases of a cached directory being altered?
> > 
> > No. Files can be altered without being unlinked.
> 
> Argh.  Do generation numbers and/or mtime help us here?

Up to a point. ext2/3 still has 1 second mtime resolution. There is no
way that can detect all modifications. The i_version can work for ext4,
if people remember to turn it on, and if they use NFSv4.

> > >   I keep trying to trap an
> > > NFS developer and beat the answer out of him but they usually get hung
> > > up on the impossibility of 100% enforcement of the read-only server
> > > option. (Agreed, impossible, just give the sysadmin a mount option so
> > > that it doesn't happen accidentally.)
> > 
> > Remind me again why mounting the filesystem '-oro' on the server (and
> > possibly exporting it 'ro') isn't an option?
> 
> The "hard read only" export option is to, at minimum, make it
> difficult to *accidentally* remount the file system on the server as
> read-write while it is exported as a union lower layer.
> 
> True, the NFS server can mount the file system "-o ro" - and then any
> random other mount(8) on the server can come along and "-o
> remount,rw".  So if we have an NFS server option that uses the new
> hard read-only feature, this at least makes the admin go change the
> NFS mount options or unexport it before writing to the exported union
> lower layer and hosing all the union mount clients.
> 
> It's the difference between:
> 
> # mount -o remount,rw /exports/union_mount_root
>  [thousands of union mounted clients hang]
> 
> And:
> 
> # mount -o remount,rw /exports/union_mount_root
> mount: /exports/union_mount_root is hard read-only
> # emacs /etc/exports
>   [edit out union/hard readonly option]
> # exportfs -r
>  [thousands of union mounted clients hang]
> 
> But heck, system administration is hard, what's a little more rope?
> Here, hold this gun while I position your foot...

...quite.

The point we keep making is that this can work if administrators do the
right thing. If they don't, then there is pretty much nothing we can do
to stop them from podiatric self-mutilation...

Just tell them what they are supposed to do, and if they don't then
they're on their own.

   Trond
