Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132Ab0E0VyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 17:54:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932535Ab0E0VyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 17:54:14 -0400
Message-ID: <4BFEE9F3.8040200@redhat.com>
Date: Thu, 27 May 2010 11:53:55 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Bernhard Schmidt <berni@birkenwald.de>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Clock jumps
References: <loom.20100524T171038-56@post.gmane.org> <20100525062100.GP22163@redhat.com> <4BFD5616.6070302@cora.nwra.com> <4D7E210A-4694-4B6E-B721-6024CE96ABC0@suse.de> <htmdsk$9kn$1@dough.gmane.org>
In-Reply-To: <htmdsk$9kn$1@dough.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2010 08:32 AM, Bernhard Schmidt wrote:
> Alexander Graf<agraf@suse.de>  wrote:
>
> Hi,
>
>    
>> Do you have ntpd running inside the guest? I have a bug report lying
>> around about 2.6.33 with kvm-clock jumping in time when ntpd is used:
>> https://bugzilla.novell.com/show_bug.cgi?id=582260
>>      
> I want to chime in here, I have a very similar problem, but not with
> ntpd in the guest.
>
> The host was a HP ProLiant DL320 G5p with a Dualcore Xeon3075. System
> was a Debian Lenny with a custom 2.6.33 host kernel and a custom
> qemu-kvm 0.11.0 .deb ported from Ubuntu. The host is synced with ntpd.
>
> The guests are various Debian Lenny/Squeeze VMs, with a custom kernel
> (2.6.33 at the moment) with kvm-clock. Exclusively amd64 guest
> kernels, but one system has i386 userland.
>
> With this setup once in a while (maybe every other week) one VM would
> have a sudden clock jump, 6-12 hours into the future. No kernel messages
> or other log entries than applications complaining about the clock jump
> after the fact. Other VMs were unaffected.
>
> Yesterday I did an upgrade to Debian Squeeze. This involved a new
> qemu-kvm (0.12.4), but not a new host kernel. I also upgraded the guest
> kernels from 2.6.33 to 2.6.33.4.
>
> First of all, after the reboot the host clock was totally unreliable. I
> had a constant skew of up to five seconds per minute in the host clock,
> which of course affected the VMs as well.  This problem went away when I
> changed from tsc into hpet on the host. The host does CPU frequency
> scaling which is, as far as I know, known to affect TSC stability. I
> think I remember messages about tsc being unstable in earlier boots,
> maybe the detection did just not work this time.
>
> Worse, the clock jump issues in the guest appeared much more often than
> before. The higher loaded VMs did not survive ten minutes without
> jumping several hours ahead.
>
> Situation has stabilized after setting clocksource hpet in the guest
> immediately after boot. So it seems kvm-clock has some issues here.
>
> I've seen a preliminary patch floating around on the ML by Zachary
> Amsden, but I haven't tried it yet. It talks of backward warps, but so
> far I've only seen forward warps (the VM time suddenly jumps into the
> future), so it might be unrelated.
>    

I have an AMD Turion TL-52 machine with unreliable TSC.  It varies with 
CPU frequency, which is okay, we can compensate for that, but worse, it 
has broken clocking when in C1E idle.  Apparently, it divides down the 
clock input to an idle core, so it only runs at 1/16 or whatever of the 
rate, and adds a multiplier to the TSC increment, so it scales by 16 
instead of by 1 (whatever the actual numbers are I don't know, but this 
illustrates the point).  When it wakes up to service a cache probe from 
another core, it now runs with full clock rate ... and still uses the 
multiplier for the TSC increment.

The effect is that idle CPUs have TSC which may increase faster than 
running CPUs.  Given time, this delta can add to a very large number (in 
theory, it's a random walk, but it can go very far off).  If a VM is 
running on this CPU and happens to match the idle pattern without 
switching CPUs, time can effectively run accelerated on that VM, and 
very rapidly things are going to get confused.

Newer kernels should detect the host clock being unreliable quite 
quickly; my F13 machine detects it right away at boot.

I have server side fixes for this kvm-clock which seem to give me a 
stable clock on this machine, but for true SMP stability, you will need 
Glauber's guest side changes to kvmclock as well.  It is impossible to 
guarantee strictly monotonic clocksource across multiple CPUs when 
frequency is dynamically changing (and also because of the C1E idle 
problems).

There is one remaining problem to fix, the reset of TSC on reboot in SMP 
will destabilize the TSCs again, but now I've actually got VMs running 
again (different bug), that shouldn't be long.

Zach
