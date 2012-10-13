Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab2JMPjT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 11:39:19 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40450 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab2JMPjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 11:39:16 -0400
Date: Sat, 13 Oct 2012 16:39:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Michael Cree <mcree@orcon.net.nz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, dl8bcu@dl8bcu.de,
        peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        linux-alpha@vger.kernel.org
Subject: Re: [PATCH 1/1] task_work: Add local_irq_enable() into
 task_work_run()
Message-ID: <20121013153900.GR2616@ZenIV.linux.org.uk>
References: <20121006204736.GA1830@ds20.borg.net>
 <20121012160359.GB30881@redhat.com>
 <CA+55aFwXiu1znTkksgSyxa7v1-3cPWZL5dvth_8hQygSKE1utw@mail.gmail.com>
 <201210132259.25791.mcree@orcon.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201210132259.25791.mcree@orcon.net.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2012 at 10:59:25PM +1300, Michael Cree wrote:

> Any chance that we could have the fixes backported to the stable queue, in 
> particular to the 3,2 kernel?  We should then be able to run the Debian built 
> SMP kernel on the autobuilders at Debian-Ports rather than having to run a 
> specially built kernel or a UP kernel.
> 
> BTW, the WARNING: at kernel/softirq.c:139 __local_bh_enable+0xe8/0x110() still 
> occurs when bringing up the CPUs.  Actually it happens twice now.  I've 
> attached my dmesg dump should you wish to check.

The obvious fix is to add local_irq_disable() into do_entInt(), just before
calling handle_ipi().  But I'm not sure if we wouldn't be better off just
doing it right in the beginning of do_entInt().  Take a look at that switch
in there: case 0 - we want local_irq_disable() done before handle_ipi().
case 1 - we do local_irq_disable() right there on SMP and do it almost
instantly in case of UP, since handle_irq() will do it a few insns after
entry anyway.  case 3 - ->device_interrupt() calls handle_irq() very soon
on all subarchitectures.  That leaves machine checks and perf_irq.  I have
no idea how hot those paths really are; do we spend enough time in there
to make blanket local_disable_irq() on those painful?  If not, we'd probably
be better off just lifting local_disable_irq() to the beginning of
do_entInt() and killing it in handle_irq() - that sucker is always called
from do_entInt(), directly or via ->device_interrupt().

Comments?
