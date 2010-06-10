Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab0FJGeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 02:34:36 -0400
Received: from mail.tnnet.fi ([217.112.240.26]:54517 "EHLO mail.tnnet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab0FJGef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 02:34:35 -0400
Message-ID: <4C108778.71545BCF@users.sourceforge.net>
Date: Thu, 10 Jun 2010 09:34:32 +0300
From: Jari Ruusu <jariruusu@users.sourceforge.net>
To: Tejun Heo <tj@kernel.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.35-rc2 module reference counting broken
References: <4C0C819E.EA5D6A18@users.sourceforge.net> <20100607064412.GK31073@ZenIV.linux.org.uk> <20100608234814.GA19826@ZenIV.linux.org.uk> <4C0F3C66.1020601@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> On 06/09/2010 01:48 AM, Al Viro wrote:
> > Yeah...  bd_start_claiming() grabs a reference to gendisk and we never
> > let it go.  There's your leak...
> 
> Eh, I thought you were cc'd.  Sorry.  This was fixed sometime back by
> Nick and queued in block tree (delayed due to mail misdelivery).
> 
>   http://thread.gmane.org/gmane.linux.file-systems/40655

That one liner patch makes module refcount mismatch go away.

However, I am not sure if that is the right place to insert that
module_put(). The problem with Nick Piggin's (2010-05-25 15:50:21 GMT) patch
is that it makes module refcount temporarily drop to zero.

I added this line right after that "module_put(disk->fops->owner);" fix:

 if(disk->fops->owner){printk("bd_start_claiming: module_refcount=%u\n", module_refcount(disk->fops->owner));}

And that said "module_refcount=0" when I tried it with my silly floppy
module mount+umount test.

Later in the mount system call handling the module refrence count is
incremented. But to me that looks like there is a window of opportunity for
things to go wrong. What is there to prevent module from being removed at
zero refcount?

-- 
Jari Ruusu  1024R/3A220F51 5B 4B F9 BB D3 3F 52 E9  DB 1D EB E3 24 0E A9 DD
