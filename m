Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab2C2B2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 21:28:52 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56418 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758027Ab2C2B2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 21:28:44 -0400
Message-ID: <1332984523.30775.12.camel@joe2Laptop>
Subject: Re: suppress page allocation failure warnings from sys_listxattr
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Dave Chinner <david@fromorbit.com>,
        viro@zeniv.linux.org.uk, Linux Kernel <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Date: Wed, 28 Mar 2012 18:28:43 -0700
In-Reply-To: <20120328181023.274401d1.akpm@linux-foundation.org>
References: <20120313182220.GA11500@redhat.com>
	 <20120327155149.d41a235b.akpm@linux-foundation.org>
	 <20120328001550.GA3077@redhat.com> <20120328043951.GA32741@dastard>
	 <20120328164720.d1aea752.akpm@linux-foundation.org>
	 <20120329005442.GB16008@redhat.com>
	 <20120328181023.274401d1.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-28 at 18:10 -0700, Andrew Morton wrote:
> On Wed, 28 Mar 2012 20:54:42 -0400 Dave Jones <davej@redhat.com> wrote:
> >  > Yup.  How does the below look?
> > Don't see anything immediately wrong with it.
> > Any thoughts on what to do about the similar problem in setxattr ? (memdup_user)
[]
> diff -puN fs/xattr.c~fs-xattrc-setxattr-improve-handling-of-allocation-failures fs/xattr.c
[]
> @@ -334,13 +335,25 @@ setxattr(struct dentry *d, const char __
[]
> +		kvalue = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
> +		if (!kvalue) {
> +			vvalue = vmalloc(size);
[]
> +	if (vvalue)
> +		vfree(vvalue);
> +	else
> +		kfree(kvalue);
>  	return error;

These patterns are pretty common, maybe create a standard helper?

