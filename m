Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab2FYMD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 08:03:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:43445 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab2FYMD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 08:03:28 -0400
Subject: Re: deferring __fput()
From: Peter Zijlstra <peterz@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, David Miller <davem@davemloft.net>
In-Reply-To: <20120623205755.GJ14083@ZenIV.linux.org.uk>
References: <1340369098.2464.20.camel@falcor>
	 <20120623092049.GH14083@ZenIV.linux.org.uk>
	 <20120623194505.GI14083@ZenIV.linux.org.uk>
	 <20120623205755.GJ14083@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jun 2012 14:03:25 +0200
Message-ID: <1340625805.2507.56.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-06-23 at 21:57 +0100, Al Viro wrote:
> 3) at that point task_work is equal in size (and layout, BTW) to rcu_head.  So we can add it
> into the same union in struct file where we already have list_head and rcu_head.  No space
> eaten up.  fput() would, once the counter reaches 0, remove the file from list (the only
> place walking that list skips the ones with zero refcount anyway) and, if we are in a normal
> process, use task_work_add() to have __fput() done to it.  If we are in kernel thread or
> atomic context, just move the sucker to global list and use schedule_work() to have said
> list emptied and everything in it fed to __fput(). 

So we're now Ok with doing fput() async?

Last time I remember this coming up people thought this wasn't such a
hot idea.

  https://lkml.org/lkml/2010/1/5/208



