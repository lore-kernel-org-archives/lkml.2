Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab1CaHVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 03:21:16 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:61601 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044Ab1CaHVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 03:21:14 -0400
Date: Thu, 31 Mar 2011 03:21:09 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@x980
To: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: x86@kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH 0/9] x86 idle cruft removal - v2
In-reply-to: <4D942191.2080408@linux.vnet.ibm.com>
Message-id: <alpine.LFD.2.02.1103310309120.8774@x980>
References: <1300950508-22746-1-git-send-email-lenb@kernel.org>
 <1301551404-8263-1-git-send-email-lenb@kernel.org>
 <4D942191.2080408@linux.vnet.ibm.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > What is next:
> > 
> > handle c1e_idle() vs default_idle()
> > 	run-time check for AMD workaround enable as part of default_idle?
> > give xen_arch_setup default_idle() w/o having it touch pm_idle
> > 	perhaps it can simply set a flag to disable cpuidle...
> > 		which is what would run if the xen kernel were
> > 		booted on raw iron.  Or can we handle this
> > 		at compile time?
> 
> I guess it may be good to have a method to override cpuidle and
> force it to call default_idle from inside cpuidle_idle_call(). This
> could be useful for users other than xen in future. Ofcourse this override
> should not touch pm_idle (which would be removed anyway).

Actually what I was thinking was the ability to disable cpuidle
altogether via cmdline.  ie a run-time equivalent of CONFIG_CPU_IDLE=n.
eg. "cpuidle=0"  In that case cpu_idle_call() would return error
and we'd have:

cpu_idle()
	if (cpu_idle_call())
		default_idle()

This is also a clean way for CONFIG_CPU_IDLE=n to work.

> Provision is already there to call default_idle from inside
> cpuidle_idle_call(); we can use that after checking a flag?? Can
> we use something like boot_option_idle_override? Or set/unset
> flag through an API?

I think it is strange for cpuidle to turn around and
call back to default_idle().  I'd like to see if we can
keep knowledge of default_idle() inside process.c.
If cpuidle can't do better than default_idle()
then it sholdn't be running...

> > delete pm_idle
> > 	x86 will then use default_idle or cpuidle
> > allow cpuidle to use default_idle to handle the period
> > 	where it polls because cpus have not yet registered
> 
> If we remove pm_idle and directly call cpuidle, the
> check already exists to call default_idle until a cpuidle
> driver (and cpus) is registered.

it isn't working.
If it were, then we'd not see any polling in the cpuidle stats.

cheers,
-Len

