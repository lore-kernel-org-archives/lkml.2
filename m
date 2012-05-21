Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758197Ab2EUO7M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:59:12 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33713 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173Ab2EUO7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:59:09 -0400
Date: Mon, 21 May 2012 16:59:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/3] x86: x2apic/cluster: Make use of lowest priority
 delivery mode
Message-ID: <20120521145904.GA7068@gmail.com>
References: <20120518102640.GB31517@dhcp-26-207.brq.redhat.com>
 <20120521082240.GA31407@gmail.com>
 <20120521093648.GC28930@dhcp-26-207.brq.redhat.com>
 <20120521124025.GC17065@gmail.com>
 <20120521144812.GD28930@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120521144812.GD28930@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexander Gordeev <agordeev@redhat.com> wrote:

> > So I think we need to tread carefully here.
> 
> Kernel parameter? IRQ line flag? Totally opposed? :)

Undecided and sceptical, because: -ENONUMBERS :-)

The kernel actually tries to have as much locality as we can 
hide from the user.

For example we don't execute tasks for 100 usecs on one CPU, 
then jump to another CPU and execute 100 usecs there, then to 
yet another CPU to create an 'absolutely balanced use of CPU 
resources'. Why? Because the cache-misses would be killing us.

When a device is generating ten thousand irqs a second then 
round-robining the IRQs is equivalent to switching a CPU every 
100 usecs.

There's another cost: tasks tend to try to migrate to sources of 
wakeups. So if an IRQ wakes up a task then we will try to 
execute the task locally, to have locality of access between the 
data that the IRQ handler has touched, and the task that makes 
use of it. Round-robining the IRQ in that situations means that 
the task either follows the IRQ and round-robins (bad), or that 
it stays remote to the IRQ data (not good either).

So, I'm sceptical :-/

Your other two patches looked sensible - will they apply fine 
after each other, without the round-robin patch which is still 
under discussion, or is there a dependency?

Thanks,

	Ingo
