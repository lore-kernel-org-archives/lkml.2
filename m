Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab0KBMWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 08:22:13 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:51243 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab0KBMWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 08:22:09 -0400
Subject: Re: [PATCH v1.1 2/5] IMA: define readcount functions
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, jmorris@namei.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        eparis@redhat.com, viro@zeniv.linux.org.uk,
        Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20101102004545.GQ2715@dastard>
References: <1288640739-3246-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1288640739-3246-3-git-send-email-zohar@linux.vnet.ibm.com>
	 <20101102004545.GQ2715@dastard>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Nov 2010 08:22:05 -0400
Message-ID: <1288700525.16939.25.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-02 at 11:45 +1100, Dave Chinner wrote:
> On Mon, Nov 01, 2010 at 03:45:36PM -0400, Mimi Zohar wrote:
> > Define iget/iput_readcount() functions to be called from the VFS layer.
> 
> Can't say I like the function names. i_readcount_{inc,dec} seem more
> appropriate, especially so they don't get confused with inode
> reference counting...
> 
> Cheers,
> 
> Dave.

Definitely better naming. thanks!

> > +void iput_readcount(struct inode *inode)
> > +{
> > +	spin_lock(&inode->i_lock);
> > +	if (unlikely((atomic_read(&inode->i_readcount) == 0)))
> > +		printk(KERN_INFO "i_readcount: imbalance ino %ld\n",
> > +		       inode->i_ino);
> > +	else
> > +		atomic_dec(&inode->i_readcount);
> > +	spin_unlock(&inode->i_lock);
> > +}
> 
> No need for the lock just to indicate an imbalance. You could just
> use:
> 
> 	if (atomic_dec_return(&inode->i_readcount) < 0) {
> 		.....
> 	}
> 
> Given this is an integrity subsystem, I suspect the correct thing to
> do here is BUG(), not just issue an informational message that
> something is wrong with the integrity tracking....
> 
> Cheers,
> 
> Dave.

Yes, as Eric explained, the testing is a remnant from IMA, when it
wasn't fully integrated in the kernel.

thanks,

Mimi

