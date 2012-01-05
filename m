Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032Ab2AEXNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 18:13:33 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56009 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932235Ab2AEXNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 18:13:31 -0500
Subject: Re: [PATCH v3 1/1] vfs: iversion truncate bug fix
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Greg KH <greg@kroah.com>, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Date: Thu, 05 Jan 2012 18:09:53 -0500
In-Reply-To: <20120105143015.540ba7d7.akpm@linux-foundation.org>
References: <ba9643a815137d64301559f174f6f6bf3a552b16.1324551152.git.dmitry.kasatkin@intel.com>
		<1324560391.1964.8.camel@falcor>
		<20120104152801.d8f555ca.akpm@linux-foundation.org>
		<1325723630.13419.2.camel@falcor>
		<20120104164638.cc21fc2e.akpm@linux-foundation.org>
		<20120105020639.GA1161@kroah.com>	<1325737033.13419.43.camel@falcor>
		<20120105165412.GE26153@kroah.com>	<1325783951.23566.52.camel@falcor>
		<1325788781.2775.12.camel@dabdike.Larkspurhotels.com>
	 <20120105143015.540ba7d7.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1325804994.2062.63.camel@falcor.watson.ibm.com>
Mime-Version: 1.0
x-cbid: 12010523-5806-0000-0000-0000111AE36F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-05 at 14:30 -0800, Andrew Morton wrote:
> On Thu, 05 Jan 2012 10:39:41 -0800
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > > > Please, go read Documentation/stable_kernel_rules.txt for how to
> > > > properly submit patches to the stable kernel tree.  The information here
> > > > needs to be in the patch changelog itself, not in some random email
> > > > thread that will get lost instantly into my email-archive-from-hell
> > > > after I am done reading this.
> > > > 
> > > > greg k-h
> > > 
> > > Yes, I've read Documentation/stable_kernel_rules.txt and think this
> > > patch meets the criteria for being backported.
> > > 
> > > As far as I'm aware, this patch hasn't been upstreamed yet and is
> > > waiting for someone, besides myself, to Ack it.  Once Acked, either
> > > Dmitry or I can send a pull request with an updated patch description.
> > > Should this patch go in via the security tree?
> > 
> > If it hasn't been upstreamed yet, just make sure you put
> > 
> > cc: stable@kernel.org
> > 
> > In the signoffs of the patch you're sending upstream and the backport
> > will occur automatically when the patch is finally upstreamed.
> 
> Mimi didn't write or send the patch.

Thanks for explaining it to everyone and upstreaming the patch. 

Mimi

> This happily git-free maintainer simply goes in and edits the
> changelog.  I do this very very frequently.
> 
> Here's what I currently have.  I plan to send this to Rip Van Viro.
> 
> 
> 
> 
> From: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> Subject: vfs: increment iversion when a file is truncated
> 
> When a file is truncated with truncate()/ftruncate() and then closed,
> iversion is not updated.  This patch uses ATTR_SIZE flag as an indication
> to increment iversion.
> 
> Mimi said:
> 
> On fput(), i_version is used to detect and flag files that have changed
> and need to be re-measured in the IMA measurement policy.  When a file
> is truncated with truncate()/ftruncate() and then closed, i_version is
> not updated.  As a result, although the file has changed, it will not be
> re-measured and added to the IMA measurement list on subsequent access.
> 
> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> Acked-by: Mimi Zohar <zohar@us.ibm.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/attr.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff -puN fs/attr.c~vfs-increment-iversion-when-a-file-is-truncated fs/attr.c
> --- a/fs/attr.c~vfs-increment-iversion-when-a-file-is-truncated
> +++ a/fs/attr.c
> @@ -176,6 +176,11 @@ int notify_change(struct dentry * dentry
>  			return -EPERM;
>  	}
> 
> +	if ((ia_valid & ATTR_SIZE) && IS_I_VERSION(inode)) {
> +		if (attr->ia_size != inode->i_size)
> +			inode_inc_iversion(inode);
> +	}
> +
>  	if ((ia_valid & ATTR_MODE)) {
>  		umode_t amode = attr->ia_mode;
>  		/* Flag setting protected by i_mutex */
> _
> 


