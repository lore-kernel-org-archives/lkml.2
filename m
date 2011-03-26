Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab1CZQQK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 12:16:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab1CZQQJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 12:16:09 -0400
Date: Sat, 26 Mar 2011 12:11:31 -0400
From: Josef Bacik <josef@redhat.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Josef Bacik <josef@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [34/35] fs: call security_d_instantiate in d_obtain_alias V2
Message-ID: <20110326161130.GA2233@localhost.localdomain>
References: <20110326000459.388812559@clark.kroah.org>
 <4D8D3258.5090804@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8D3258.5090804@schaufler-ca.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 05:24:56PM -0700, Casey Schaufler wrote:
> On 3/25/2011 5:04 PM, Greg KH wrote:
> > 2.6.33-longterm review patch.  If anyone has any objections, please let us know.
> >
> > ------------------
> >
> > From: Josef Bacik <josef@redhat.com>
> >
> > commit 24ff6663ccfdaf088dfa7acae489cb11ed4f43c4 upstream.
> >
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
> > security_d_instantiate.
> >
> > Usually we are protected from getting a hashed dentry that hasn't yet run
> > security_d_instantiate() by the parent's i_mutex, but obviously this isn't an
> > option there, so in order to deal with the case that a second thread comes in
> > and finds our new dentry before we get to run security_d_instantiate(), we go
> > ahead and call it if we find a dentry already.  Eric assures me that this is ok
> > as the code checks to see if the dentry has been initialized already so calling
> > security_d_instantiate() against the same dentry multiple times is ok.  With
> > this patch I'm no longer getting errant -EACCESS values.
> 
> Not to be a bother, but did you try this with Smack as well as SELinux?
> Smack should be fine with the change, but if you're not going to try
> Smack I need to know.
> 

I only tested SELinux since it's on by default in fedora.  Thanks,

Josef
