Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab1DBVMG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 17:12:06 -0400
Received: from toro.web-alm.net ([62.245.132.31]:50395 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756731Ab1DBVME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 17:12:04 -0400
Message-ID: <4D97904B.7000100@osadl.org>
Date: Sat, 02 Apr 2011 23:08:27 +0200
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL)
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Asit Mallick <asit.k.mallick@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Linux 2.6.33.8
References: <20110321204104.GA2702@kroah.com>  <4D94C666.3060206@osadl.org> <1301632555.4766.5.camel@marge.simson.net> <4D96E90D.9000905@osadl.org>
In-Reply-To: <4D96E90D.9000905@osadl.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2011 11:14 AM, Carsten Emde wrote:
> [..]
> CPU info:
> vendor_id : GenuineIntel
> cpu family : 6
> model : 44
> model name : Intel(R) Core(TM) i7 CPU X 980 @ 3.33GHz
> stepping : 2
>
> This is the situation:
>
> 1. Without commit ea53069231f9317062910d6e772cca4ce93de8c8:
> Everything is fine. The system correctly powers off.
>
> 2. With commit ea53069231f9317062910d6e772cca4ce93de8c8:
> a) Frequency scaling never enabled (acpi_cpufreq not loaded,
> cpufreq_ondemand not loaded):
> Everything is fine. The system correctly powers off.
> b) Frequency scaling enabled (acpi_cpufreq loaded, cpufreq_ondemand
> loaded) or
> c) Frequency scaling enabled and disabled (acpi_cpufreq still loaded
> since it cannot be removed easily, cpufreq_ondemand no longer
> loaded) or
> d) Frequency scaling enabled and disabled (acpi_cpufreq unloaded
> with force, cpufreq_ondemand no longer loaded):
> Not powering off, message:
> ACPI: Preparing to enter system sleep state S5
> Disabling non-boot CPUs ...
>
> In a next step, I will debug arch/x86/kernel/smpboot.c to find out why
> mwait_play_dead() returns when frequency scaling was not enabled and why
> it does not after it was enabled.
This assumption was incorrect. After inserting a number of debug outputs 
to kernel_power_off(), native_play_dead() and mwait_play_dead(), it 
turns out that the initial code path in case of the correct poweroff and 
the failed poweroff is identical:

     Frequency scaling                      Frequency scaling
       never enabled                      enabled and disabled

      kernel_power_off()                  kernel_power_off()
      "ACPI: Preparing to enter           "ACPI: Preparing to enter
        system sleep state S5"              system sleep state S5"
      kernel_power_off()                  kernel_power_off()
      "Disabling non-boot CPUs ..."       "Disabling non-boot CPUs ..."

1    native_play_dead()              1   native_play_dead()
      mwait_play_dead()                   mwait_play_dead()

2    native_play_dead()              2   native_play_dead()
      mwait_play_dead()                   mwait_play_dead()

3    native_play_dead()              3   native_play_dead()
      mwait_play_dead()                   mwait_play_dead()

4    native_play_dead()              4   native_play_dead()
      mwait_play_dead()                   mwait_play_dead()

5    native_play_dead()              5   native_play_dead()
      mwait_play_dead()                   mwait_play_dead()

6    native_play_dead()              6   native_play_dead()
      mwait_play_dead()                   mwait_play_dead()

7    native_play_dead()              7   native_play_dead()
      mwait_play_dead()                   mwait_play_dead()

8    native_play_dead()              8   native_play_dead()
      mwait_play_dead()                   mwait_play_dead()

9    native_play_dead()
      mwait_play_dead()

10   native_play_dead()
      mwait_play_dead()

11   native_play_dead()
      mwait_play_dead()

      kernel_power_off()
      "PM: Calling mce_shutdown"
      "PM: Calling i8259A_shutdown"
      kernel_power_off()
      "Power down."
      kernel_power_off()

Apparently, the system hangs after eight CPUs have been disabled. I'll 
try to provide some more debugging information. Does anybody out there 
have any idea what's going on?

	-Carsten.
