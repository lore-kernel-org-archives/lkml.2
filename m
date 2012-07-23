Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab2GWRMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 13:12:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40993 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab2GWRMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 13:12:20 -0400
Date: Mon, 23 Jul 2012 10:12:15 -0700
From: Tejun Heo <tj@kernel.org>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] kthread_worker: reimplement flush_kthread_work()
 to allow freeing the work item being executed
Message-ID: <20120723171215.GA5776@google.com>
References: <20120719211510.GA32763@google.com>
 <20120719211629.GC32763@google.com>
 <1342894814.2504.31.camel@palomino.walls.org>
 <20120722164953.GC5144@dhcp-172-17-108-109.mtv.corp.google.com>
 <1342990015.2487.19.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342990015.2487.19.camel@palomino.walls.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Jul 22, 2012 at 04:46:54PM -0400, Andy Walls wrote:
> Hmmm, I didn't know about the constraint about 'known to be alive' in
> the other email I just sent.
> 
> That might make calling flush_kthread_work() hard for a user to use, if
> the user lets the work get freed by another thread executing the work.

Umm... flushing a freed work item doesn't make any sense at all.  The
pointer itself loses the ability to identify anything.  What if it
gets recycled to another work item which happens to depend on the
flusher to make forward progress?  You now have a circular dependency
through a recycled memory area.  Good luck hunting that down.

For pretty much any API, allowing dangling pointers as argument is
insane.  If you want to flush self-freeing work items, flush the
kthread_worker.  That's how it is with workqueue and how it should be
with kthread_worker too.

Thanks.

-- 
tejun
