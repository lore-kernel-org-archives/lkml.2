Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab1F0FWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 01:22:31 -0400
Received: from cobra.newdream.net ([66.33.216.30]:35015 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172Ab1F0FWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 01:22:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=cfr17OL0D0B+RksuoM/HHh6dR
	E0WIHsQuq36V2ygJTpzFFyjjYH/c7D9zBPSeLIGTGT+N9MUO13FnQ7n2r9k7YPC5
	xaKE5FpqsFTkHVgtWgiVgMyW2IWjebltee/iiR3uUeEsBlJufE1sTGnkTYMLSYbs
	aeIWWKl0969qXw3K1w=
Date: Sun, 26 Jun 2011 22:24:59 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: WTF is ceph_lookup_open() doing with nd->intent.open.file?
In-Reply-To: <20110626004234.GB11013@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.1106262212360.11754@cobra.newdream.net>
References: <20110626004234.GB11013@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jun 2011, Al Viro wrote:
> ceph_lookup_open() does the following:
> 
>         struct file *file = nd->intent.open.file;
>         struct inode *parent_inode = get_dentry_parent_inode(file->f_dentry);
> 
> Note that at this point nd->intent.open.file is going to have NULL ->f_dentry.
> What's more, we end up calling ceph_init_file() on that struct file.  If
> open(2) fails *after* the call of that sucker, we'll end up leaking
> from ceph_file_cachep, since ->release() will *not* be called - VFS will
> have no damn indication that it needs to.  Not that calling ->i_fop->open()
> on something without ->f_op (and ->f_dentry, and...) would be a good idea...
> 
> What is that code supposed to do, anyway?  Looks like a bastardized
> variant of the atomic open tricks NFS is pulling off, without the
> proper use of lookup_instantiate_filp()...  The thing is,
> lookup_instantiate_filp() takes care to set ->f_path.dentry, which is
> what distinguishes struct file that had been through ->open() from
> ones that had not.  So no ->release() for you...
> 
> Moreover, what would you expect to set ->f_dentry by the time you call
> ->lookup()?  Looks like you expect that parent_inode to be the directory
> you are doing lookup in, so why not use the dir argument of ceph_lookup_open()?
> While we are at it, what's "locked_dir" and what is it for?  AFAICS,
> nothing has ever looked at it - not since the mainline merge...
> 
> Either I'm seriously confused, or that code is...

Yeah, it's the code.  This is all pre- ceph merge, so my memory is hazy, 
but as I recall the open intents worked, but never quite as I expected.  
Since I'm pretty sure this is the first time I've looked at 
lookup_instantiate_filp(), that's not surprising.

The f_dentry bit looks like it got copy/pasted from ceph_open way back 
when.  In the end it means we just pass a NULL value to 
ceph_mdsc_do_request(), but that's actually fine (and correct in this 
case).  I'll clean it up in the next window.  

As for lookup_instantiate_filp(), I have a patch that fixes this up and 
seems to work but want to spend some more time playing with it to make 
sure it's really doing the right thing here.  Since the only problem with 
the current behavior is a leaked filp in the error case (right?) that can 
wait for the next window too.

Thanks for the heads-up!
sage
