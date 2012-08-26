Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab2HZPF1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 11:05:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59693 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab2HZPFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 11:05:25 -0400
Date: Sun, 26 Aug 2012 16:05:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org
Subject: Re: [patch 2/9] procfs: Convert /proc/pid/fdinfo/ handling routines
 to seq-file v2
Message-ID: <20120826150520.GZ23464@ZenIV.linux.org.uk>
References: <20120823104323.040550004@openvz.org>
 <20120823104725.686586462@openvz.org>
 <20120826024653.GY23464@ZenIV.linux.org.uk>
 <20120826142820.GA16038@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120826142820.GA16038@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 06:28:20PM +0400, Cyrill Gorcunov wrote:
> On Sun, Aug 26, 2012 at 03:46:53AM +0100, Al Viro wrote:
> > 
> > IMO doing that at open() time is just a headache for no good reason -
> > resolving descriptor to struct file * at read() time as we do now
> > is much saner.  Better do that in your ->show(), since you are using
> > a single-shot iterator anyway...
> 
> Al, the updated version is below. I suppose I can grab proc inode then
> and lookup for file position and flags at show method. (I remember
> what you've said about O_CLOEXEC bit, but I'll address this in
> another patch).

Applied, with a couple of changes:
	* there's no need for those games with ihold/iput - opened file pins
its inode down just fine, TYVM.
	* struct fd_info is pointless in that form - the last argument
of single_open() will end up in seq_file ->private, so let's just pass
the inode there and use m->private in ->show().

I'll push that into vfs.git#master (along with the previous patch) in a few
hours.

O_CLOEXEC is taken care of in my tree.  FWIW, I'm consolidating descriptor
handling in general into fs/file.c (and I'm seriously tempted to rename
that sucker to something like fs/descriptors.c or fs/fdtable.c); some of
that stuff is already in #master.  I'm probably going to move some of the
code from your fs/proc/fd.c there as well...
