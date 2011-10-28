Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab1J1CNe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 22:13:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab1J1CNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 22:13:33 -0400
From: Thomas Renninger <trenn@suse.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: kernel panic
Date: Fri, 28 Oct 2011 04:13:50 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5-5.99.12.5343e5f-desktop; KDE/4.4.4; x86_64; ; )
Cc: nick bray <nick.bray1@ntlworld.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lenb@kernel.org,
        Zhao Yakui <yakui.zhao@intel.com>, Zhang Rui <rui.zhang@intel.com>
References: <4EA549C3.4080206@ntlworld.com> <4EA83F5D.20001@ntlworld.com> <CAErSpo4_epbHEAH3Ah=07NZFjqQedUcMXh+cxTSJ4Mp9KhvfPw@mail.gmail.com>
In-Reply-To: <CAErSpo4_epbHEAH3Ah=07NZFjqQedUcMXh+cxTSJ4Mp9KhvfPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110280413.51751.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 October 2011 20:10:07 Bjorn Helgaas wrote:
> On Wed, Oct 26, 2011 at 11:11 AM, nick bray <nick.bray1@ntlworld.com> wrote:
...
> ...
> Brought up 2 CPUs
> ...
> ACPI: Power Button [PWRF]
> BUG: unable to handle kernel paging request at 00010282
> IP: [<00010282>] 0x10281
> *pde = 00000000
> Oops: 0000 [#1] SMP
> ...
> Pid: 1, comm: swapper Not tainted 3.0.0-12-generic #20-Ubuntu
> EIP: 0060:[<00010282>] EFLAGS: 00010282 CPU: 1
> ...
>   ? resched_task+0x22/0x70
>   ? __kmalloc+0x189/0x1e0
>   acpi_ns_evaluate+0x3a/0x18d
>   acpi_evaluate_object+0xd6/0x1c5
>   ? try_to_wake_up+0x140/0x190
>   acpi_processor_get_power_info_cst+0x53/0x297
>   ? wait_for_completion+0x17/0x20
>   ? default_spin_lock_flags+0x8/0x10
>   ? _raw_spin_lock+0xd/0x10
>   ? task_rq_lock+0x49/0x80
>   ? set_cpus_allowed_ptr+0x53/0x110
>   ? acpi_processor_get_throttling_fadt+0x72/0x7a
>   acpi_processor_get_power_info+0x24/0x10c
>   acpi_processor_power_init+0xdc/0x10c
>   acpi_processor_add+0x131/0x1d2
>   acpi_device_probe+0x41/0xf5
> 
> I found a report with a serial console log showing a very similar
> backtrace here:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/807164
> 
> Seems pretty clearly related to acpi_processor_get_power_info();
> hopefully an expert in that area will jump in and help out.
This is really strange..., it happens when trying to evaluate
_CST on a processor object.
But processor objects are declared:
    Scope (\_PR)
    {
        Processor (CPU1, 0x01, 0x00000410, 0x06) {}
        Processor (CPU2, 0x02, 0x00000410, 0x06) {}
    }
and do not have a _CST func. I got the DSDT from the Ubuntu
bug, you may want to double check:
acpidump >acpidump
acpixtract -a acpidump
iasl *.dat
grep _CST *.dsl

If you have a processor object with _CST function you could
try to reproduce this in userspace by using acpiexec from the
acpica utilities.
acpiexec DSDT.dat
-> methods shows you the available ones
-> execute \_PR.CPU1._CST (or similar possibly triggers some mem corruption?)

Ah, maybe an older acpidump got used and the _CST method of the
object is in a not exported, dynamically loaded SSDT.
This is very likely.

Please use a very recent acpidump:
Hm, Len's ftp directory on kernel.org where latest acpidump was
located is gone?
Latest openSUSE acpica package has everything mentioned above included :)
Could get a problem to feed acpiexec with the DSDT and SSDT.., you may
have to glue them (better ask again then). Best is you run it with valgrind.
bugzilla.kernel.org is still down?

   Thomas
