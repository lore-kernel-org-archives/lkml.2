Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab2CWO70 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 10:59:26 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:53075 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117Ab2CWO7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 10:59:22 -0400
Subject: Re: [PATCH v3 10/12] ima: defer calling __fput()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Matt Helsley <matt.helsley@gmail.com>, Mimi Zohar <zohar@us.ibm.com>
Date: Fri, 23 Mar 2012 10:55:18 -0400
In-Reply-To: <20120322150945.GW6589@ZenIV.linux.org.uk>
References: <1332356057-3356-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1332356057-3356-11-git-send-email-zohar@linux.vnet.ibm.com>
	 <20120322142212.GV6589@ZenIV.linux.org.uk>
	 <1332427986.2218.53.camel@falcor>
	 <20120322150945.GW6589@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1332514519.2199.25.camel@falcor>
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032314-5518-0000-0000-0000032ADF31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-22 at 15:09 +0000, Al Viro wrote:
> On Thu, Mar 22, 2012 at 10:53:04AM -0400, Mimi Zohar wrote:
> > > BTW, you've missed several other places in mm/* doing fput(), so it wouldn't
> > > be enough to paper over your problem anyway.
> > > 
> > > Final fput() *can* happen under mmap_sem.  Period.
> > 
> > I think I got that loud and clear; otherwise we wouldn't have come up
> > with deferring the __fput().  We have a very real problem here - writing
> > extended attributes requires taking the i_mutex.
> 
> Don't do it, then?  If you _must_ write to xattr on final fput, I'd suggest
> starting to figure out if xattr needs its protection to be ->i_mutex - it
> might make sense to introduce a separate mutex for xattr crap.  Or not - I'm
> not familiar enough with the guts of xattr handling in individual filesystems
> to tell if that would work (e.g. if it would need unpleasant changes to
> ->setattr() instances)...

After looking into this, the individual filesystems do their own xattr
locking.  The i_mutex, however, is currently required to access
inode->i_op->setxattr() (and the isec).  In addition, IMA-appraisal
requires the i_mutex in order to calculate the file hash.

Calling ima_file_free() after the mmap_sem is released, as opposed to
queueing the __fput(), won't work, as the file needs to be open in order
to calculate the file hash.

Calling ima_file_free() before taking the mmap_sem, could work, but at
that point we don't have access to the file handle. Do you see any other
options?

thanks,

Mimi

