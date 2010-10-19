Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757987Ab0JSVmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 17:42:39 -0400
Received: from shiva144.upmc.fr ([134.157.0.144]:50113 "EHLO shiva.upmc.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753247Ab0JSVmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 17:42:38 -0400
X-Ids: courriel2
Message-ID: <4CBE1179.2040003@upmc.fr>
Date: Tue, 19 Oct 2010 23:45:29 +0200
From: Bernard Pidoux <bernard.pidoux@upmc.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100919 Mandriva/3.0.8-0.1mdv2010.1 (2010.1) Thunderbird/3.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Bernard Pidoux <bpidoux@free.fr>
Subject: Re: booting "nosmp" kernel causing ACPI errors
References: <4CB9D69D.60203@upmc.fr>
In-Reply-To: <4CB9D69D.60203@upmc.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I needed to run Linux on UP mode in order to perform some application tests.
Using nosmp argument lead to bad interrupts set up.

I finally found the explanation I was looking for in this acpi-linux 
thread :
http://marc.info/?l=linux-acpi&m=118794015205199&w=4

  	maxcpus=	[SMP] Maximum number of processors that	an SMP kernel
			should make use of.  maxcpus=n : n>= 0 limits the
			kernel to using 'n' processors.  n=0 is a special case,
			it is equivalent to "nosmp", which also disables
			the IO APIC.

	nosmp		[SMP] Tells an SMP kernel to act as a UP kernel,
			and disable the IO APIC.  legacy for "maxcpus=0".


I understand that the reason why nosmp also disable IO APIC is for 
backward compatibility.
However this is not intuitive : one argument leading to two actions.

So, if I want to run my dual core CPU in UniProcessor mode I have to use
kernel argument maxcpus=1 in grub/menu.lst

Doing so, interrupts on my Linux system are correctly initialized and it 
is much more stable.

Bernard



Le 16/10/2010 18:45, Bernard Pidoux a écrit :
> Hi,
>
> I observed ACPI errors when booting 2.6.35.7 kernel with "nosmp" 
> argument.
> dmesg shows a warning message starting with :
> WARNING: at mm/page_alloc.c:1981 __alloc_pages_nodemask+0x5b4/0x6d0()
> +Hardware name: MS-7519
> +Modules linked in:
> +Pid: 1, comm: swapper Not tainted 2.6.35.7 #2
>
> This is followed by ACPI error messages and /proc/interrupts show that
> interrupts 0-15 are then handled by XT-PIC-XT
> instead of IO-APIC-edge and IO-APIC-fasteoi when runing smp kernel.
>
> Here is lspci dump :
>
> 00:00.0 Host bridge: Intel Corporation 4 Series Chipset DRAM 
> Controller (rev 03)
> 00:01.0 PCI bridge: Intel Corporation 4 Series Chipset PCI Express 
> Root Port (rev 03)
> 00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
> UHCI Controller #4
> 00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
> UHCI Controller #5
> 00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
> UHCI Controller #6
> 00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 
> EHCI Controller #2
> 00:1b.0 Audio device: Intel Corporation 82801JI (ICH10 Family) HD 
> Audio Controller
> 00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI 
> Express Root Port 1
> 00:1c.1 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI 
> Express Port 2
> 00:1c.5 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI 
> Express Root Port 6
> 00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
> UHCI Controller #1
> 00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
> UHCI Controller #2
> 00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB 
> UHCI Controller #3
> 00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 
> EHCI Controller #1
> 00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90)
> 00:1f.0 ISA bridge: Intel Corporation 82801JIB (ICH10) LPC Interface 
> Controller
> 00:1f.2 IDE interface: Intel Corporation 82801JI (ICH10 Family) 4 port 
> SATA IDE Controller #1
> 00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
> 00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10 Family) 2 port 
> SATA IDE Controller #2
> 01:00.0 VGA compatible controller: nVidia Corporation G98 [GeForce 
> 8400 GS] (rev a1)
> 02:00.0 IDE interface: JMicron Technology Corp. JMB368 IDE controller
> 04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
> RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 02)
>
> I observed the same issue with another machine with also an MSI 
> motherboard but using a PCI bridge VIA VT8237/VX700
> even when booting with "pci=use_crs" argument.
>
> Attached is diff -ruN file between 2.6.35.7 kernel without and with 
> "nosmp" boot argument.
>
> Bernard
>

