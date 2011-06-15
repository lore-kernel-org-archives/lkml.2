Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab1FOANL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 20:13:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:33644 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab1FOANJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 20:13:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=DZ+PvWpgzYXOCfox2Q4YINo3vqDyMoO839dEOdO/4gC3OBmfwkPU+VckPDr58qsY6r
         vBprjyW9C33Js4OoO5Rg==
Date: Tue, 14 Jun 2011 17:13:04 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Chris Fowler <cfowler@opsdc.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Panic on OOM
In-Reply-To: <1308058276.2074.295.camel@compaq-desktop>
Message-ID: <alpine.DEB.2.00.1106141656220.31202@chino.kir.corp.google.com>
References: <1308058276.2074.295.camel@compaq-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jun 2011, Chris Fowler wrote:

> I'm running into a problem in 2.6.38 where the kernel is not doing what
> I'm expecting it to do.  I'm guessing that some things have changed and
> that is what it going on.
> 
> First,  The tune at boot:
> 
>         f.open("/proc/sys/vm/panic_on_oom", std::ios::out);
>         f << "1";
>         f.close();
> 
>         f.open("/proc/sys/kernel/panic", std::ios::out);
>         f << "10";
>         f.close();
> 

Hmm, you don't check that the writes to the sysctls actually succeed?

Using /proc/sys/vm/panic_on_oom also won't panic the machine if you happen 
to use a cpuset or mempolicy.  You'll want to write '2' instead if you 
want to panic in all possible oom conditions.

> I want the kernel to panic on out of memory.  I then want it to wait 10s
> before doing a reboot.
> 
> This program will consume all memory and make the box unresponsive
> 
> #!/usr/bin/perl
> 
> my @mem = ()
> while(1) {
>   push @mem, "########################";
> }
> 
> It does not take long to fill up 1G of space.  There is NO swap on this
> device and never will be.  I did notice that after a long period of time
> (I've not timed it) I finally do see a panic and I do see "rebooting in
> 10 seconds..." .  It does not reboot.
> 

Ok, it seems like the oom killer is being called correctly and respecting 
your panic_on_oom setting because it is a system-wide oom condition (your 
perl script wasn't bound to any cpuset or mempolicy).

So that leaves the panic() not rebooting properly when the timeout is set.  
You would only see the "Rebooting in 10 seconds..." message if the write 
to /proc/sys/kernel/panic suceeded, and there's this little comment in 
kernel/panic.c:

	/*
	 * This will not be a clean reboot, with everything
	 * shutting down.  But if there is a chance of
	 * rebooting the system it will be rebooted.
	 */

with a call to emergency_restart().  You didn't specify your architecture, 
but assuming you're using x86 without a hypervisor and didn't specify a 
reboot= parameter on the command line, it should suceed although there are 
some hardware dependencies.  Does using

	reboot=force

on the command line help?

Either way, could you send your /proc/cpuinfo and .config?
