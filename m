Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab2FWVdX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 17:33:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45274 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab2FWVdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 17:33:21 -0400
Date: Sat, 23 Jun 2012 22:33:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, David Miller <davem@davemloft.net>
Subject: Re: deferring __fput()
Message-ID: <20120623213317.GM14083@ZenIV.linux.org.uk>
References: <1340369098.2464.20.camel@falcor>
 <20120623092049.GH14083@ZenIV.linux.org.uk>
 <20120623194505.GI14083@ZenIV.linux.org.uk>
 <20120623205755.GJ14083@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120623205755.GJ14083@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 09:57:55PM +0100, Al Viro wrote:

> 3) at that point task_work is equal in size (and layout, BTW) to rcu_head.  So we can add it
> into the same union in struct file where we already have list_head and rcu_head.  No space
> eaten up.  fput() would, once the counter reaches 0, remove the file from list (the only
> place walking that list skips the ones with zero refcount anyway) and, if we are in a normal
> process, use task_work_add() to have __fput() done to it.  If we are in kernel thread or
> atomic context, just move the sucker to global list and use schedule_work() to have said

Only that's probably s/atomic/interrupt/

> list emptied and everything in it fed to __fput().
