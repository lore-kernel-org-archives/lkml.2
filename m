Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab1ESNmZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:42:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48104 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756944Ab1ESNmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:42:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=fgZ1lSUc74PmJfDSMgfZ+9xISXlNjrZhLmHmoeYMg7+GIJuTL/uJWUwogALBT4GZ/K
         xGQDNKtoO4I8uPvutuSgqqL9TXesd2/dhkMS5MqY6pDsTx2hwhOIDKFNgEePGRfyhh+t
         rQDES1aMSy0f7wyhXnxjPDuyPFMs52cIOrWMc=
Date: Thu, 19 May 2011 15:42:18 +0200
From: Tejun Heo <tj@kernel.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: early kernel crash when kmemleak is enabled
Message-ID: <20110519134218.GH627@htj.dyndns.org>
References: <20110515105505.GA21631@joi.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110515105505.GA21631@joi.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, May 15, 2011 at 12:55:05PM +0200, Marcin Slusarz wrote:
> [    0.100047] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [    0.101416] IP: [<ffffffff810854d1>] __queue_work+0x29/0x41a
...
> [    0.110000] Call Trace:
> [    0.110000]  <IRQ> 
> [    0.110000]  [<ffffffff81085910>] queue_work_on+0x16/0x1d
> [    0.110000]  [<ffffffff81085abc>] queue_work+0x29/0x55
> [    0.110000]  [<ffffffff81085afb>] schedule_work+0x13/0x15
> [    0.110000]  [<ffffffff81242de1>] free_object+0x90/0x95
> [    0.110000]  [<ffffffff81242f6d>] debug_check_no_obj_freed+0x187/0x1d3
> [    0.110000]  [<ffffffff814b6504>] ? _raw_spin_unlock_irqrestore+0x30/0x4d
> [    0.110000]  [<ffffffff8110bd14>] ? free_object_rcu+0x68/0x6d
> [    0.110000]  [<ffffffff8110890c>] kmem_cache_free+0x64/0x12c
> [    0.110000]  [<ffffffff8110bd14>] free_object_rcu+0x68/0x6d
> [    0.110000]  [<ffffffff810b58bc>] __rcu_process_callbacks+0x1b6/0x2d9
> [    0.110000]  [<ffffffff81095c9f>] ? tick_handle_periodic+0x1f/0x6c
> [    0.110000]  [<ffffffff810b5a5a>] rcu_process_callbacks+0x7b/0x83
> [    0.110000]  [<ffffffff810733b2>] __do_softirq+0x117/0x207
> [    0.110000]  [<ffffffff810b05d3>] ? handle_irq_event+0x47/0x5c
> [    0.110000]  [<ffffffff814bd0cc>] call_softirq+0x1c/0x30
> [    0.110000]  [<ffffffff81034bc4>] do_softirq+0x38/0x80
> [    0.110000]  [<ffffffff810730ed>] irq_exit+0x4e/0xa0
> [    0.110000]  [<ffffffff8103429a>] do_IRQ+0x97/0xae
> [    0.110000]  [<ffffffff814b6853>] common_interrupt+0x13/0x13

I can reproduce this reliably with your config too.  From a quick
glance, the cause seems to be debug objects using RCU callback
free_object() to free objects, which ends up being called before
workqueue is initialized.  The offending object type is "rcu_head" and
turning off CONFIG_DEBUG_OBJECTS_RCU_HEAD makes the problem go away.

Any ideas on how to fix this?

Thanks.

-- 
tejun
