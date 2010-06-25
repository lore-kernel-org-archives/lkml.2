Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab0FYQxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 12:53:11 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.122]:53512 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932187Ab0FYQxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 12:53:09 -0400
X-Authority-Analysis: v=1.0 c=1 a=iVNVO0OCT3kA:10 a=yQWWgrYGNuUA:10 a=kj9zAlcOel0A:10 a=20KFwNOVAAAA:8 a=hGzw-44bAAAA:8 a=f0L6POiToRdS6aViIA4A:9 a=tdNtT7bw1iHNm6ggrCkIte35EhAA:4 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=0kPLrQdw3YYA:10 a=dowx1zmaLagA:10 a=00U40p1LBqVLw4jT:21 a=gh7LVOPznGai4vo_:21
X-Cloudmark-Score: 0
X-Originating-IP: 71.70.153.3
Date: Fri, 25 Jun 2010 12:53:06 -0400
From: Jeff Layton <jlayton@samba.org>
To: David Howells <dhowells@redhat.com>
Cc: Suresh Jayaraman <sjayaraman@suse.de>, Steve French <smfrench@gmail.com>,
       linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, samba-technical@lists.samba.org
Subject: Re: [RFC][PATCH 06/10] cifs: define inode-level cache object and
 register them
Message-ID: <20100625125306.7f9b1966@tlielax.poochiereds.net>
In-Reply-To: <22697.1277470549@redhat.com>
References: <4C24A606.5040001@suse.de>
	<1277220214-3597-1-git-send-email-sjayaraman@suse.de>
	<yes>
	<9822.1277312573@redhat.com>
	<22697.1277470549@redhat.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jun 2010 13:55:49 +0100
David Howells <dhowells@redhat.com> wrote:

> Suresh Jayaraman <sjayaraman@suse.de> wrote:
> 
> > I think the creation time is currently being ignored as we won't be able
> > to accomodate in POSIX stat struct.
> 
> The FS-Cache interface doesn't use the POSIX stat struct, but it could be
> really useful to save it and use it for cache coherency inside the kernel.
> 
> Out of interest, what does Samba do when it comes to generating a creation time
> for UNIX where one does not exist?
> 

(cc'ing samba-technical since we're talking about the create time)

Looks like it mostly uses the ctime. IMO, the mtime would be a better
choice since it changes less frequently, but I don't guess that it
matters very much.

I have a few patches that make the cifs_iget code do more stringent
checks. One of those makes it use the create time like an i_generation
field to guard against matching inodes that have the same number but
that have undergone a delete/create cycle. They need a bit more testing
but I'm planning to post them in time for 2.6.36.

Because of how samba generates this number, it could be somewhat
problematic to do this. What may save us though is that Linux<->Samba
mostly uses unix extensions unless someone has specifically disabled
them on either end. The unix extension calls don't generally send any
sort of create time field, so we can't rely on it in those codepaths
anyway.

-- 
Jeff Layton <jlayton@samba.org>
