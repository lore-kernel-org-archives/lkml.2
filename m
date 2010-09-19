Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab0ISUQH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 16:16:07 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:58910 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab0ISUQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 16:16:05 -0400
To: paulmck@linux.vnet.ibm.com
CC: benh@kernel.crashing.org, miklos@szeredi.hu,
        James.Bottomley@HansenPartnership.com, dhowells@redhat.com,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
In-reply-to: <20100919152638.GF3060@linux.vnet.ibm.com>
	(paulmck@linux.vnet.ibm.com)
Subject: Re: memory barrier question
References: <6383.1284647456@redhat.com>
 <20100916150356.GD2462@linux.vnet.ibm.com>
 <E1OwGz7-0007Cu-CC@pomaz-ex.szeredi.hu>
 <20100916163708.GG2462@linux.vnet.ibm.com>
 <E1OwHkg-0007IX-DH@pomaz-ex.szeredi.hu>
 <1284656978.26423.11.camel@mulgrave.site>
 <E1OwI5H-0007LR-DC@pomaz-ex.szeredi.hu>
 <1284760148.30449.107.camel@pasglop>
 <20100917231222.GA3060@linux.vnet.ibm.com>
 <1284864421.30449.113.camel@pasglop> <20100919152638.GF3060@linux.vnet.ibm.com>
Message-Id: <E1OxQIg-0005Nw-WE@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sun, 19 Sep 2010 22:15:51 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Sep 2010, Paul E. McKenney wrote:
> Give it a few years.  There are reportedly already other compilers that do
> this, which is not too surprising given that the perception of insanity
> is limited to lockless parallel code.  If you have single-threaded code,
> such as code and data under a lock (where the data is never accessed
> without holding that lock), then this sort of optimization is pretty safe.
> I still don't like it, but the compiler guys would argue that this is
> because I am one of those insane parallel-programming guys.
> 
> Furthermore, there are other ways to get into trouble.  If the code
> continued as follows:
> 
>    LOAD inode = next.dentry->inode
>    if (inode != NULL)
>    	LOAD inode->f_op
> 	do_something_using_lots_of_registers();
> 	LOAD inode->some_other_field
> 
> and if the code expected ->f_op and ->some_other_field to be from the
> same inode structure, severe disappointment could ensue.  This is because
> the compiler is within its rights to reload from next.dentry->inode,
> especially given register pressure.  In fact, the compiler would be within
> its rights to reload from next.dentry->inode in the "LOAD inode->f_op"
> statement.  And it might well get NULL from such a reload.

Except the VFS doesn't allow that.  dentry->inode can go from NULL to
non-NULL anytime but will only go from non-NULL to NULL when there are
no possible external references to the dentry.

The compiler and the CPU cannot move the "LOAD inode->some_field"
before the "LOAD dentry->inode", because of the conditional, right?

Thanks,
Miklos
