Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab1FMSX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 14:23:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33841 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab1FMSX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 14:23:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=AlJkBNvVuBGleHSTuIFJTMaXjeGqW8aHQhLGXkamsFmUkvaSYPBdDHssHM/Lg68O8E
         ygJsKPXRGSTCWQD1+SDK/MKxDNeNQ1a40xAIqjByfvbaoqjoNUAoivdMFwHvkTKV3TSy
         KW00dQi1IuXi32xAD0iQrN6L0IA7pE7lCWRiY=
Message-ID: <4DF655B5.8040903@gmail.com>
Date: Mon, 13 Jun 2011 20:23:49 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Yinghai Lu <yinghai@kernel.org>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <4DED8752.5070005@kernel.org> <4DEDEA73.7010900@gmail.com> <20110610164706.GB25774@srcf.ucam.org> <4DF259B2.9070403@gmail.com> <20110610175429.GA28500@srcf.ucam.org> <4DF29E7E.50908@gmail.com> <20110613164712.GA23343@srcf.ucam.org> <4DF64E6A.70700@gmail.com> <20110613180006.GA24902@srcf.ucam.org> <4DF65372.7090307@gmail.com> <20110613181750.GA25372@srcf.ucam.org>
In-Reply-To: <20110613181750.GA25372@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 13-06-11 20:17, Matthew Garrett schreef:
> On Mon, Jun 13, 2011 at 08:14:10PM +0200, Maarten Lankhorst wrote:
>> Op 13-06-11 20:00, Matthew Garrett schreef:
>>> On Mon, Jun 13, 2011 at 07:52:42PM +0200, Maarten Lankhorst wrote:
>>>>> +		 */
>>>>> +
>>>>> +		if ((start <= virt_to_phys(_etext)-1 && end >= virt_to_phys(_text)) ||
>>>>> +		    (start <= virt_to_phys(_edata)-1 && end >= virt_to_phys(_etext)) ||
>>>> _etext -> _sdata perhaps?
>>> _etext is used for the resource allocation earlier, which seems like 
>>> it's probably the relevant thing to be copying.
>> I meant the second comparison, start <= edata && end >= _etext
> I know:
>
>         data_resource.start = virt_to_phys(_etext);
>         data_resource.end = virt_to_phys(_edata)-1;
>
> (from kernel/setup.c)
Ah, in that case wouldn't 2 comparisons instead of 4 be enough?

>>>>>  		memblock_x86_reserve_range(start, start + size, "EFI Boot");
>>>>>  	}
>>>>>  }
>>>> Will test though. It might also be appropriate to put a WARN when that condition happens.
>>> That'd end up triggering even in cases that are absolutely safe (ie, the 
>>> firmware doesn't have this bug). The amount of suck here is incredible.
>> Still a crapload of swapper BUGs in free_init_pages, maybe you should just give up on this approach,
>> and call SetVirtualAddressMap before anything of importance runs. :-/
> Not straightforward, sadly. Can I have the dmesg and iomem?
>
/proc/iomem:
00000000-0000ffff : reserved
00010000-0009ffff : System RAM
000a0000-000bffff : PCI Bus 0000:00
000c0000-000c7fff : Video ROM
000c8000-000dffff : PCI Bus 0000:00
000f0000-000fffff : System ROM
00100000-bf35bfff : System RAM
  01000000-01580278 : Kernel code
  01580279-01aa4cff : Kernel data
  01b6c000-01c68fff : Kernel bss
bf35c000-bf3acfff : ACPI Non-volatile Storage
bf3ad000-bf60bfff : reserved
bf60c000-bf60cfff : System RAM
bf60d000-bf60dfff : ACPI Tables
bf60e000-bf617fff : ACPI Non-volatile Storage
bf618000-bf63cfff : reserved
bf63d000-bf67ffff : ACPI Non-volatile Storage
bf680000-bf7fffff : System RAM
bf800000-bfffffff : RAM buffer
c0000000-ffffffff : PCI Bus 0000:00
  d0000000-dbffffff : PCI Bus 0000:01
    d0000000-d7ffffff : 0000:01:00.0
    d8000000-dbffffff : 0000:01:00.0
      d9000000-d92fffff : efifb
  dc100000-dc1fffff : PCI Bus 0000:06
    dc100000-dc1fffff : PCI Bus 0000:07
      dc100000-dc100fff : 0000:07:00.1
      dc101000-dc101fff : 0000:07:00.0
        dc101000-dc101fff : bttv0
  dc200000-dc2fffff : PCI Bus 0000:03
    dc200000-dc203fff : 0000:03:00.0
      dc200000-dc203fff : r8169
    dc204000-dc204fff : 0000:03:00.0                                                                                                                                            
      dc204000-dc204fff : r8169                                                                                                                                                 
  e0000000-efffffff : PCI MMCONFIG 0000 [bus 00-ff]                                                                                                                             
    e0000000-efffffff : pnp 00:01                                                                                                                                               
  f8000000-fa0fffff : PCI Bus 0000:01                                                                                                                                           
    f8000000-f9ffffff : 0000:01:00.0                                                                                                                                            
      f8000000-f9ffffff : nvidia                                                                                                                                                
    fa000000-fa07ffff : 0000:01:00.0                                                                                                                                            
    fa080000-fa083fff : 0000:01:00.1                                                                                                                                            
      fa080000-fa083fff : ICH HD audio                                                                                                                                          
  fa100000-fa1fffff : PCI Bus 0000:04                                                                                                                                           
    fa100000-fa107fff : 0000:04:00.0                                                                                                                                            
      fa100000-fa107fff : xhci_hcd                                                                                                                                              
  fa200000-fa203fff : 0000:00:1b.0                                                                                                                                              
    fa200000-fa203fff : ICH HD audio                                                                                                                                            
  fa204000-fa2040ff : 0000:00:1f.3                                                                                                                                              
  fa205000-fa2057ff : 0000:00:1f.2                                                                                                                                              
    fa205000-fa2057ff : ahci                                                                                                                                                    
  fa206000-fa2063ff : 0000:00:1d.0                                                                                                                                              
    fa206000-fa2063ff : ehci_hcd                                                                                                                                                
  fa207000-fa2073ff : 0000:00:1a.0                                                                                                                                              
    fa207000-fa2073ff : ehci_hcd                                                                                                                                                
  fa208000-fa20800f : 0000:00:16.0                                                                                                                                              
    fa208000-fa20800f : mei                                                                                                                                                     
  fec00000-fec003ff : IOAPIC 0                                                                                                                                                  
  fed00000-fed003ff : HPET 0                                                                                                                                                    
  fed08000-fed08fff : pnp 00:08                                                                                                                                                 
  fed10000-fed19fff : pnp 00:01                                                                                                                                                 
  fed1c000-fed3ffff : reserved                                                                                                                                                  
    fed1c000-fed1ffff : pnp 00:08                                                                                                                                               
    fed20000-fed3ffff : pnp 00:01                                                                                                                                               
  fed90000-fed93fff : pnp 00:01                                                                                                                                                 
  fee00000-fee0ffff : pnp 00:01                                                                                                                                                 
    fee00000-fee00fff : Local APIC                                                                                                                                              
  ff000000-ffffffff : reserved                                                                                                                                                  
    ff000000-ffffffff : pnp 00:08
100000000-23f7fffff : System RAM
23f800000-23fffffff : RAM buffer

dmesg:
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.0.0-rc2-patser+ (mlankhorst@patser.local) (gcc version 4.5.2 (Ubuntu/Linaro 4.5.2-8ubuntu4) ) #39 SMP PREEMPT Mon Jun 13 19:51:37 CEST 2011
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.0.0-rc2-patser+ root=/dev/sdb2 ro rootflags=ssd,discard root=/dev/sdb2 devtmpfs.mount=1 video=efifb reboot=a,e,p init=/init quiet splash vt.handoff=7
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 00000000000a0000 (usable)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf35c000 (usable)
[    0.000000]  BIOS-e820: 00000000bf35c000 - 00000000bf3ad000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf3ad000 - 00000000bf60c000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf60c000 - 00000000bf60d000 (usable)
[    0.000000]  BIOS-e820: 00000000bf60d000 - 00000000bf60e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000bf60e000 - 00000000bf618000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf618000 - 00000000bf63d000 (reserved)
[    0.000000]  BIOS-e820: 00000000bf63d000 - 00000000bf680000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000bf680000 - 00000000bf800000 (usable)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed40000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000023f800000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] EFI v2.00 by American Megatrends
[    0.000000]  SMBIOS=0xbf63bc98  ACPI=0xbf3a5000  ACPI 2.0=0xbf3a5000  MPS=0xfcbf0
[    0.000000] Kernel-defined memdesc doesn't match the one from EFI!
[    0.000000] EFI: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000008000) (0MB)
[    0.000000] EFI: mem01: type=7, attr=0xf, range=[0x0000000000008000-0x0000000000077000) (0MB)
[    0.000000] EFI: mem02: type=4, attr=0xf, range=[0x0000000000077000-0x0000000000078000) (0MB)
[    0.000000] EFI: mem03: type=3, attr=0xf, range=[0x0000000000078000-0x00000000000a0000) (0MB)
[    0.000000] EFI: mem04: type=2, attr=0xf, range=[0x0000000000100000-0x00000000003f9000) (2MB)
[    0.000000] EFI: mem05: type=7, attr=0xf, range=[0x00000000003f9000-0x0000000001000000) (12MB)
[    0.000000] EFI: mem06: type=2, attr=0xf, range=[0x0000000001000000-0x0000000001100000) (1MB)
[    0.000000] EFI: mem07: type=4, attr=0xf, range=[0x0000000001100000-0x0000000001337000) (2MB)
[    0.000000] EFI: mem08: type=3, attr=0xf, range=[0x0000000001337000-0x0000000001339000) (0MB)
[    0.000000] EFI: mem09: type=4, attr=0xf, range=[0x0000000001339000-0x0000000001341000) (0MB)
[    0.000000] EFI: mem10: type=3, attr=0xf, range=[0x0000000001341000-0x0000000001345000) (0MB)
[    0.000000] EFI: mem11: type=4, attr=0xf, range=[0x0000000001345000-0x0000000001375000) (0MB)
[    0.000000] EFI: mem12: type=3, attr=0xf, range=[0x0000000001375000-0x0000000001378000) (0MB)
[    0.000000] EFI: mem13: type=4, attr=0xf, range=[0x0000000001378000-0x000000000137a000) (0MB)
[    0.000000] EFI: mem14: type=3, attr=0xf, range=[0x000000000137a000-0x0000000001384000) (0MB)
[    0.000000] EFI: mem15: type=4, attr=0xf, range=[0x0000000001384000-0x0000000001387000) (0MB)
[    0.000000] EFI: mem16: type=3, attr=0xf, range=[0x0000000001387000-0x0000000001388000) (0MB)
[    0.000000] EFI: mem17: type=4, attr=0xf, range=[0x0000000001388000-0x000000000138a000) (0MB)
[    0.000000] EFI: mem18: type=3, attr=0xf, range=[0x000000000138a000-0x000000000138d000) (0MB)
[    0.000000] EFI: mem19: type=4, attr=0xf, range=[0x000000000138d000-0x000000000138f000) (0MB)
[    0.000000] EFI: mem20: type=3, attr=0xf, range=[0x000000000138f000-0x0000000001391000) (0MB)
[    0.000000] EFI: mem21: type=4, attr=0xf, range=[0x0000000001391000-0x0000000001393000) (0MB)
[    0.000000] EFI: mem22: type=3, attr=0xf, range=[0x0000000001393000-0x0000000001395000) (0MB)
[    0.000000] EFI: mem23: type=4, attr=0xf, range=[0x0000000001395000-0x0000000001396000) (0MB)
[    0.000000] EFI: mem24: type=3, attr=0xf, range=[0x0000000001396000-0x0000000001397000) (0MB)
[    0.000000] EFI: mem25: type=4, attr=0xf, range=[0x0000000001397000-0x00000000013a7000) (0MB)
[    0.000000] EFI: mem26: type=3, attr=0xf, range=[0x00000000013a7000-0x00000000013a9000) (0MB)
[    0.000000] EFI: mem27: type=4, attr=0xf, range=[0x00000000013a9000-0x00000000013ad000) (0MB)
[    0.000000] EFI: mem28: type=3, attr=0xf, range=[0x00000000013ad000-0x00000000013b5000) (0MB)
[    0.000000] EFI: mem29: type=4, attr=0xf, range=[0x00000000013b5000-0x00000000013c8000) (0MB)
[    0.000000] EFI: mem30: type=3, attr=0xf, range=[0x00000000013c8000-0x00000000013ca000) (0MB)
[    0.000000] EFI: mem31: type=4, attr=0xf, range=[0x00000000013ca000-0x00000000013d1000) (0MB)
[    0.000000] EFI: mem32: type=3, attr=0xf, range=[0x00000000013d1000-0x00000000013de000) (0MB)
[    0.000000] EFI: mem33: type=4, attr=0xf, range=[0x00000000013de000-0x00000000013e0000) (0MB)
[    0.000000] EFI: mem34: type=3, attr=0xf, range=[0x00000000013e0000-0x00000000013e8000) (0MB)
[    0.000000] EFI: mem35: type=4, attr=0xf, range=[0x00000000013e8000-0x00000000013f3000) (0MB)
[    0.000000] EFI: mem36: type=3, attr=0xf, range=[0x00000000013f3000-0x00000000013f4000) (0MB)
[    0.000000] EFI: mem37: type=4, attr=0xf, range=[0x00000000013f4000-0x00000000013f6000) (0MB)
[    0.000000] EFI: mem38: type=3, attr=0xf, range=[0x00000000013f6000-0x00000000013f7000) (0MB)
[    0.000000] EFI: mem39: type=4, attr=0xf, range=[0x00000000013f7000-0x00000000013fa000) (0MB)
[    0.000000] EFI: mem40: type=3, attr=0xf, range=[0x00000000013fa000-0x00000000013fc000) (0MB)
[    0.000000] EFI: mem41: type=4, attr=0xf, range=[0x00000000013fc000-0x000000000179a000) (3MB)
[    0.000000] EFI: mem42: type=3, attr=0xf, range=[0x000000000179a000-0x000000000179e000) (0MB)
[    0.000000] EFI: mem43: type=4, attr=0xf, range=[0x000000000179e000-0x000000000179f000) (0MB)
[    0.000000] EFI: mem44: type=3, attr=0xf, range=[0x000000000179f000-0x00000000017ae000) (0MB)
[    0.000000] EFI: mem45: type=4, attr=0xf, range=[0x00000000017ae000-0x00000000017b3000) (0MB)
[    0.000000] EFI: mem46: type=3, attr=0xf, range=[0x00000000017b3000-0x00000000017be000) (0MB)
[    0.000000] EFI: mem47: type=4, attr=0xf, range=[0x00000000017be000-0x00000000017c6000) (0MB)
[    0.000000] EFI: mem48: type=3, attr=0xf, range=[0x00000000017c6000-0x00000000017c8000) (0MB)
[    0.000000] EFI: mem49: type=4, attr=0xf, range=[0x00000000017c8000-0x00000000017ca000) (0MB)
[    0.000000] EFI: mem50: type=3, attr=0xf, range=[0x00000000017ca000-0x00000000017cd000) (0MB)
[    0.000000] EFI: mem51: type=4, attr=0xf, range=[0x00000000017cd000-0x00000000017d1000) (0MB)
[    0.000000] EFI: mem52: type=3, attr=0xf, range=[0x00000000017d1000-0x00000000017d4000) (0MB)
[    0.000000] EFI: mem53: type=4, attr=0xf, range=[0x00000000017d4000-0x00000000017e6000) (0MB)
[    0.000000] EFI: mem54: type=3, attr=0xf, range=[0x00000000017e6000-0x00000000017e8000) (0MB)
[    0.000000] EFI: mem55: type=4, attr=0xf, range=[0x00000000017e8000-0x00000000017e9000) (0MB)
[    0.000000] EFI: mem56: type=3, attr=0xf, range=[0x00000000017e9000-0x00000000017f1000) (0MB)
[    0.000000] EFI: mem57: type=4, attr=0xf, range=[0x00000000017f1000-0x00000000017f9000) (0MB)
[    0.000000] EFI: mem58: type=3, attr=0xf, range=[0x00000000017f9000-0x00000000017fa000) (0MB)
[    0.000000] EFI: mem59: type=4, attr=0xf, range=[0x00000000017fa000-0x00000000017fb000) (0MB)
[    0.000000] EFI: mem60: type=3, attr=0xf, range=[0x00000000017fb000-0x00000000017fd000) (0MB)
[    0.000000] EFI: mem61: type=4, attr=0xf, range=[0x00000000017fd000-0x00000000017fe000) (0MB)
[    0.000000] EFI: mem62: type=3, attr=0xf, range=[0x00000000017fe000-0x0000000001803000) (0MB)
[    0.000000] EFI: mem63: type=4, attr=0xf, range=[0x0000000001803000-0x0000000001809000) (0MB)
[    0.000000] EFI: mem64: type=3, attr=0xf, range=[0x0000000001809000-0x0000000001811000) (0MB)
[    0.000000] EFI: mem65: type=4, attr=0xf, range=[0x0000000001811000-0x0000000001814000) (0MB)
[    0.000000] EFI: mem66: type=3, attr=0xf, range=[0x0000000001814000-0x0000000001819000) (0MB)
[    0.000000] EFI: mem67: type=4, attr=0xf, range=[0x0000000001819000-0x0000000001850000) (0MB)
[    0.000000] EFI: mem68: type=3, attr=0xf, range=[0x0000000001850000-0x000000000186a000) (0MB)
[    0.000000] EFI: mem69: type=4, attr=0xf, range=[0x000000000186a000-0x000000000187e000) (0MB)
[    0.000000] EFI: mem70: type=3, attr=0xf, range=[0x000000000187e000-0x0000000001889000) (0MB)
[    0.000000] EFI: mem71: type=4, attr=0xf, range=[0x0000000001889000-0x000000000188c000) (0MB)
[    0.000000] EFI: mem72: type=3, attr=0xf, range=[0x000000000188c000-0x0000000001893000) (0MB)
[    0.000000] EFI: mem73: type=4, attr=0xf, range=[0x0000000001893000-0x00000000018a1000) (0MB)
[    0.000000] EFI: mem74: type=3, attr=0xf, range=[0x00000000018a1000-0x00000000018a5000) (0MB)
[    0.000000] EFI: mem75: type=4, attr=0xf, range=[0x00000000018a5000-0x00000000018ae000) (0MB)
[    0.000000] EFI: mem76: type=3, attr=0xf, range=[0x00000000018ae000-0x00000000018b6000) (0MB)
[    0.000000] EFI: mem77: type=4, attr=0xf, range=[0x00000000018b6000-0x00000000018b7000) (0MB)
[    0.000000] EFI: mem78: type=3, attr=0xf, range=[0x00000000018b7000-0x00000000018c0000) (0MB)
[    0.000000] EFI: mem79: type=4, attr=0xf, range=[0x00000000018c0000-0x00000000018cc000) (0MB)
[    0.000000] EFI: mem80: type=3, attr=0xf, range=[0x00000000018cc000-0x0000000001918000) (0MB)
[    0.000000] EFI: mem81: type=4, attr=0xf, range=[0x0000000001918000-0x0000000001d9f000) (4MB)
[    0.000000] EFI: mem82: type=3, attr=0xf, range=[0x0000000001d9f000-0x0000000001da3000) (0MB)
[    0.000000] EFI: mem83: type=4, attr=0xf, range=[0x0000000001da3000-0x0000000001dac000) (0MB)
[    0.000000] EFI: mem84: type=3, attr=0xf, range=[0x0000000001dac000-0x0000000001daf000) (0MB)
[    0.000000] EFI: mem85: type=4, attr=0xf, range=[0x0000000001daf000-0x0000000001db1000) (0MB)
[    0.000000] EFI: mem86: type=3, attr=0xf, range=[0x0000000001db1000-0x0000000001db3000) (0MB)
[    0.000000] EFI: mem87: type=4, attr=0xf, range=[0x0000000001db3000-0x0000000001db5000) (0MB)
[    0.000000] EFI: mem88: type=3, attr=0xf, range=[0x0000000001db5000-0x0000000001db7000) (0MB)
[    0.000000] EFI: mem89: type=4, attr=0xf, range=[0x0000000001db7000-0x0000000001db9000) (0MB)
[    0.000000] EFI: mem90: type=3, attr=0xf, range=[0x0000000001db9000-0x0000000001dbb000) (0MB)
[    0.000000] EFI: mem91: type=4, attr=0xf, range=[0x0000000001dbb000-0x0000000001dc5000) (0MB)
[    0.000000] EFI: mem92: type=3, attr=0xf, range=[0x0000000001dc5000-0x0000000001dc7000) (0MB)
[    0.000000] EFI: mem93: type=4, attr=0xf, range=[0x0000000001dc7000-0x0000000001dc8000) (0MB)
[    0.000000] EFI: mem94: type=3, attr=0xf, range=[0x0000000001dc8000-0x0000000001dcd000) (0MB)
[    0.000000] EFI: mem95: type=4, attr=0xf, range=[0x0000000001dcd000-0x0000000001dd3000) (0MB)
[    0.000000] EFI: mem96: type=3, attr=0xf, range=[0x0000000001dd3000-0x0000000001dd6000) (0MB)
[    0.000000] EFI: mem97: type=4, attr=0xf, range=[0x0000000001dd6000-0x0000000001ddc000) (0MB)
[    0.000000] EFI: mem98: type=3, attr=0xf, range=[0x0000000001ddc000-0x0000000001ddf000) (0MB)
[    0.000000] EFI: mem99: type=4, attr=0xf, range=[0x0000000001ddf000-0x0000000001de1000) (0MB)
[    0.000000] EFI: mem100: type=3, attr=0xf, range=[0x0000000001de1000-0x0000000001de3000) (0MB)
[    0.000000] EFI: mem101: type=4, attr=0xf, range=[0x0000000001de3000-0x0000000001de5000) (0MB)
[    0.000000] EFI: mem102: type=3, attr=0xf, range=[0x0000000001de5000-0x0000000001de7000) (0MB)
[    0.000000] EFI: mem103: type=4, attr=0xf, range=[0x0000000001de7000-0x0000000001ded000) (0MB)
[    0.000000] EFI: mem104: type=3, attr=0xf, range=[0x0000000001ded000-0x0000000001df0000) (0MB)
[    0.000000] EFI: mem105: type=4, attr=0xf, range=[0x0000000001df0000-0x0000000001df2000) (0MB)
[    0.000000] EFI: mem106: type=3, attr=0xf, range=[0x0000000001df2000-0x0000000001df4000) (0MB)
[    0.000000] EFI: mem107: type=4, attr=0xf, range=[0x0000000001df4000-0x0000000001df6000) (0MB)
[    0.000000] EFI: mem108: type=3, attr=0xf, range=[0x0000000001df6000-0x0000000001df8000) (0MB)
[    0.000000] EFI: mem109: type=4, attr=0xf, range=[0x0000000001df8000-0x0000000001dfc000) (0MB)
[    0.000000] EFI: mem110: type=3, attr=0xf, range=[0x0000000001dfc000-0x0000000001dfe000) (0MB)
[    0.000000] EFI: mem111: type=4, attr=0xf, range=[0x0000000001dfe000-0x0000000001e0e000) (0MB)
[    0.000000] EFI: mem112: type=3, attr=0xf, range=[0x0000000001e0e000-0x0000000001e10000) (0MB)
[    0.000000] EFI: mem113: type=4, attr=0xf, range=[0x0000000001e10000-0x0000000001e12000) (0MB)
[    0.000000] EFI: mem114: type=3, attr=0xf, range=[0x0000000001e12000-0x0000000001e1f000) (0MB)
[    0.000000] EFI: mem115: type=4, attr=0xf, range=[0x0000000001e1f000-0x0000000001e21000) (0MB)
[    0.000000] EFI: mem116: type=3, attr=0xf, range=[0x0000000001e21000-0x0000000001e23000) (0MB)
[    0.000000] EFI: mem117: type=4, attr=0xf, range=[0x0000000001e23000-0x0000000001e25000) (0MB)
[    0.000000] EFI: mem118: type=3, attr=0xf, range=[0x0000000001e25000-0x0000000001e29000) (0MB)
[    0.000000] EFI: mem119: type=4, attr=0xf, range=[0x0000000001e29000-0x0000000001e2b000) (0MB)
[    0.000000] EFI: mem120: type=3, attr=0xf, range=[0x0000000001e2b000-0x0000000001e2d000) (0MB)
[    0.000000] EFI: mem121: type=4, attr=0xf, range=[0x0000000001e2d000-0x0000000001e35000) (0MB)
[    0.000000] EFI: mem122: type=3, attr=0xf, range=[0x0000000001e35000-0x0000000001e37000) (0MB)
[    0.000000] EFI: mem123: type=4, attr=0xf, range=[0x0000000001e37000-0x0000000001e3d000) (0MB)
[    0.000000] EFI: mem124: type=3, attr=0xf, range=[0x0000000001e3d000-0x0000000001e40000) (0MB)
[    0.000000] EFI: mem125: type=4, attr=0xf, range=[0x0000000001e40000-0x0000000001e48000) (0MB)
[    0.000000] EFI: mem126: type=3, attr=0xf, range=[0x0000000001e48000-0x0000000001e4a000) (0MB)
[    0.000000] EFI: mem127: type=4, attr=0xf, range=[0x0000000001e4a000-0x0000000001e4c000) (0MB)
[    0.000000] EFI: mem128: type=3, attr=0xf, range=[0x0000000001e4c000-0x0000000001e51000) (0MB)
[    0.000000] EFI: mem129: type=4, attr=0xf, range=[0x0000000001e51000-0x0000000001e57000) (0MB)
[    0.000000] EFI: mem130: type=3, attr=0xf, range=[0x0000000001e57000-0x0000000001e5a000) (0MB)
[    0.000000] EFI: mem131: type=4, attr=0xf, range=[0x0000000001e5a000-0x0000000001e76000) (0MB)
[    0.000000] EFI: mem132: type=3, attr=0xf, range=[0x0000000001e76000-0x0000000001e84000) (0MB)
[    0.000000] EFI: mem133: type=4, attr=0xf, range=[0x0000000001e84000-0x00000000021c2000) (3MB)
[    0.000000] EFI: mem134: type=7, attr=0xf, range=[0x00000000021c2000-0x00000000021c5000) (0MB)
[    0.000000] EFI: mem135: type=4, attr=0xf, range=[0x00000000021c5000-0x00000000021ed000) (0MB)
[    0.000000] EFI: mem136: type=3, attr=0xf, range=[0x00000000021ed000-0x00000000021ef000) (0MB)
[    0.000000] EFI: mem137: type=4, attr=0xf, range=[0x00000000021ef000-0x000000000220e000) (0MB)
[    0.000000] EFI: mem138: type=3, attr=0xf, range=[0x000000000220e000-0x0000000002217000) (0MB)
[    0.000000] EFI: mem139: type=4, attr=0xf, range=[0x0000000002217000-0x0000000002219000) (0MB)
[    0.000000] EFI: mem140: type=7, attr=0xf, range=[0x0000000002219000-0x000000000222d000) (0MB)
[    0.000000] EFI: mem141: type=4, attr=0xf, range=[0x000000000222d000-0x0000000002780000) (5MB)
[    0.000000] EFI: mem142: type=7, attr=0xf, range=[0x0000000002780000-0x00000000027ee000) (0MB)
[    0.000000] EFI: mem143: type=1, attr=0xf, range=[0x00000000027ee000-0x000000000285c000) (0MB)
[    0.000000] EFI: mem144: type=7, attr=0xf, range=[0x000000000285c000-0x000000008fcbc000) (2260MB)
[    0.000000] EFI: mem145: type=2, attr=0xf, range=[0x000000008fcbc000-0x00000000bf35c000) (758MB)
[    0.000000] EFI: mem146: type=10, attr=0xf, range=[0x00000000bf35c000-0x00000000bf3ad000) (0MB)
[    0.000000] EFI: mem147: type=6, attr=0x800000000000000f, range=[0x00000000bf3ad000-0x00000000bf3b0000) (0MB)
[    0.000000] EFI: mem148: type=0, attr=0xf, range=[0x00000000bf3b0000-0x00000000bf60a000) (2MB)
[    0.000000] EFI: mem149: type=5, attr=0x800000000000000f, range=[0x00000000bf60a000-0x00000000bf60b000) (0MB)
[    0.000000] EFI: mem150: type=6, attr=0x800000000000000f, range=[0x00000000bf60b000-0x00000000bf60c000) (0MB)
[    0.000000] EFI: mem151: type=7, attr=0xf, range=[0x00000000bf60c000-0x00000000bf60d000) (0MB)
[    0.000000] EFI: mem152: type=9, attr=0xf, range=[0x00000000bf60d000-0x00000000bf60e000) (0MB)
[    0.000000] EFI: mem153: type=10, attr=0xf, range=[0x00000000bf60e000-0x00000000bf618000) (0MB)
[    0.000000] EFI: mem154: type=5, attr=0x800000000000000f, range=[0x00000000bf618000-0x00000000bf61c000) (0MB)
[    0.000000] EFI: mem155: type=6, attr=0x800000000000000f, range=[0x00000000bf61c000-0x00000000bf62d000) (0MB)
[    0.000000] EFI: mem156: type=5, attr=0x800000000000000f, range=[0x00000000bf62d000-0x00000000bf63a000) (0MB)
[    0.000000] EFI: mem157: type=6, attr=0x800000000000000f, range=[0x00000000bf63a000-0x00000000bf63d000) (0MB)
[    0.000000] EFI: mem158: type=10, attr=0xf, range=[0x00000000bf63d000-0x00000000bf680000) (0MB)
[    0.000000] EFI: mem159: type=3, attr=0xf, range=[0x00000000bf680000-0x00000000bf7f4000) (1MB)
[    0.000000] EFI: mem160: type=4, attr=0xf, range=[0x00000000bf7f4000-0x00000000bf7f7000) (0MB)
[    0.000000] EFI: mem161: type=3, attr=0xf, range=[0x00000000bf7f7000-0x00000000bf800000) (0MB)
[    0.000000] EFI: mem162: type=7, attr=0xf, range=[0x0000000100000000-0x000000023f800000) (5112MB)
[    0.000000] EFI: mem163: type=11, attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
[    0.000000] EFI: mem164: type=11, attr=0x8000000000000001, range=[0x00000000fed20000-0x00000000fed40000) (0MB)
[    0.000000] EFI: mem165: type=11, attr=0x8000000000000001, range=[0x00000000ff000000-0x0000000100000000) (16MB)
[    0.000000] DMI 2.6 present.
[    0.000000] DMI: To Be Filled By O.E.M. To Be Filled By O.E.M./P67 Pro3, BIOS P1.80 02/15/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x23f800 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CFFFF write-protect
[    0.000000]   D0000-DFFFF uncachable
[    0.000000]   E0000-E7FFF write-through
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask E00000000 write-back
[    0.000000]   1 base 200000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FC0000000 uncachable
[    0.000000]   3 base 23F800000 mask FFF800000 uncachable
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000c0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xbf800 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000fcf50] fcf50
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff880000073000] 73000 size 20480
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf800000
[    0.000000]  0000000000 - 00bf800000 page 2M
[    0.000000] kernel direct mapping tables up to bf800000 @ bf358000-bf35c000
[    0.000000] init_memory_mapping: 0000000100000000-000000023f800000
[    0.000000]  0100000000 - 023f800000 page 2M
[    0.000000] kernel direct mapping tables up to 23f800000 @ 23f7f6000-23f800000
[    0.000000] ACPI: RSDP 00000000bf3a5000 00024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 00000000bf3a5068 00054 (v01 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: FACP 00000000bf3ac040 000F4 (v04 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 00000000bf3a5150 06EED (v02 ALASKA    A M I 00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf60ff80 00040
[    0.000000] ACPI: APIC 00000000bf3ac138 00072 (v03 ALASKA    A M I 01072009 AMI  00010013)
[    0.000000] ACPI: SSDT 00000000bf3ac1b0 00102 (v01 AMICPU     PROC 00000001 MSFT 03000001)
[    0.000000] ACPI: MCFG 00000000bf3ac2b8 0003C (v01 ALASKA    A M I 01072009 MSFT 00000097)
[    0.000000] ACPI: AAFT 00000000bf3ac2f8 0006F (v01 ALASKA OEMAAFT  01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000bf3ac368 00038 (v01 ALASKA    A M I 01072009 AMI. 00000004)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000023f800000
[    0.000000] Initmem setup node 0 0000000000000000-000000023f800000
[    0.000000]   NODE_DATA [000000023f7fb000 - 000000023f7fffff]
[    0.000000]  [ffffea0000000000-ffffea0007dfffff] PMD -> [ffff880236e00000-ffff88023ddfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x0023f800
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[5] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x000000a0
[    0.000000]     0: 0x00000100 -> 0x000bf35c
[    0.000000]     0: 0x000bf60c -> 0x000bf60d
[    0.000000]     0: 0x000bf680 -> 0x000bf800
[    0.000000]     0: 0x00100000 -> 0x0023f800
[    0.000000] On node 0 totalpages: 2092141
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 45 pages reserved
[    0.000000]   DMA zone: 3883 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 765205 pages, LIFO batch:31
[    0.000000]   Normal zone: 17892 pages used for memmap
[    0.000000]   Normal zone: 1290780 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000bf35c000 - 00000000bf3ad000
[    0.000000] PM: Registered nosave memory: 00000000bf3ad000 - 00000000bf60c000
[    0.000000] PM: Registered nosave memory: 00000000bf60d000 - 00000000bf60e000
[    0.000000] PM: Registered nosave memory: 00000000bf60e000 - 00000000bf618000
[    0.000000] PM: Registered nosave memory: 00000000bf618000 - 00000000bf63d000
[    0.000000] PM: Registered nosave memory: 00000000bf63d000 - 00000000bf680000
[    0.000000] PM: Registered nosave memory: 00000000bf800000 - 00000000fed1c000
[    0.000000] PM: Registered nosave memory: 00000000fed1c000 - 00000000fed40000
[    0.000000] PM: Registered nosave memory: 00000000fed40000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at bf800000 (gap: bf800000:3f51c000)
[    0.000000] setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 25 pages/cpu @ffff88023f400000 s71872 r8192 d22336 u524288
[    0.000000] pcpu-alloc: s71872 r8192 d22336 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2059868
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.0.0-rc2-patser+ root=/dev/sdb2 ro rootflags=ssd,discard root=/dev/sdb2 devtmpfs.mount=1 video=efifb reboot=a,e,p init=/init quiet splash vt.handoff=7
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave/xrstor: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Memory: 8172384k/9428992k available (5632k kernel code, 1060428k absent, 196180k reserved, 5266k data, 768k init)
[    0.000000] SLUB: Genslabs=15, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000] NR_IRQS:512
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 67108864 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.001000] Detected 3292.386 MHz processor.
[    0.000001] Calibrating delay loop (skipped), value calculated using timer frequency.. 6584.77 BogoMIPS (lpj=3292386)
[    0.000004] pid_max: default: 32768 minimum: 301
[    0.002773] Security Framework initialized
[    0.002781] SELinux:  Initializing.
[    0.002785] SELinux:  Starting in permissive mode
[    0.003153] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.005457] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.006514] Mount-cache hash table entries: 256
[    0.006612] Initializing cgroup subsys debug
[    0.006614] Initializing cgroup subsys cpuacct
[    0.006617] Initializing cgroup subsys memory
[    0.006622] Initializing cgroup subsys devices
[    0.006623] Initializing cgroup subsys freezer
[    0.006624] Initializing cgroup subsys net_cls
[    0.006625] Initializing cgroup subsys blkio
[    0.006642] CPU: Physical Processor ID: 0
[    0.006642] CPU: Processor Core ID: 0
[    0.006645] mce: CPU supports 9 MCE banks
[    0.006653] CPU0: Thermal monitoring enabled (TM1)
[    0.006658] using mwait in idle threads.
[    0.006705] ACPI: Core revision 20110413
[    0.012227] ftrace: allocating 20291 entries in 80 pages
[    0.017271] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.027272] CPU0: Intel(R) Core(TM) i5-2500K CPU @ 3.30GHz stepping 07
[    0.128379] Performance Events: PEBS fmt1+, SandyBridge events, Intel PMU driver.
[    0.128383] ... version:                3
[    0.128384] ... bit width:              48
[    0.128384] ... generic registers:      8
[    0.128385] ... value mask:             0000ffffffffffff
[    0.128386] ... max period:             000000007fffffff
[    0.128386] ... fixed-purpose events:   3
[    0.128387] ... event mask:             00000007000000ff
[    0.144393] Booting Node   0, Processors  #1
[    0.144397] smpboot cpu 1: start_ip = 73000
[    0.167375] calibrate_delay_direct() timer_rate_max=3292100 timer_rate_min=3292067 pre_start=33719376247 pre_end=33752297073
[    0.179370] calibrate_delay_direct() timer_rate_max=3292094 timer_rate_min=3292067 pre_start=33758881203 pre_end=33791802023
[    0.191368] calibrate_delay_direct() timer_rate_max=3292088 timer_rate_min=3292071 pre_start=33798386165 pre_end=33831306951
[    0.203366] calibrate_delay_direct() timer_rate_max=3292087 timer_rate_min=3292065 pre_start=33837891141 pre_end=33870811919
[    0.215364] calibrate_delay_direct() timer_rate_max=3292092 timer_rate_min=3292068 pre_start=33877396089 pre_end=33910316887
[    0.241388]  #2
[    0.241392] smpboot cpu 2: start_ip = 73000
[    0.264359] calibrate_delay_direct() timer_rate_max=3292099 timer_rate_min=3292075 pre_start=34038708054 pre_end=34071628928
[    0.276354] calibrate_delay_direct() timer_rate_max=3292092 timer_rate_min=3292068 pre_start=34078213080 pre_end=34111133886
[    0.288352] calibrate_delay_direct() timer_rate_max=3292094 timer_rate_min=3292068 pre_start=34117718030 pre_end=34150638824
[    0.300350] calibrate_delay_direct() timer_rate_max=3292094 timer_rate_min=3292069 pre_start=34157222988 pre_end=34190143806
[    0.312348] calibrate_delay_direct() timer_rate_max=3292094 timer_rate_min=3292067 pre_start=34196727938 pre_end=34229648732
[    0.338370]  #3 Ok.
[    0.338374] smpboot cpu 3: start_ip = 73000
[    0.361344] calibrate_delay_direct() timer_rate_max=3292098 timer_rate_min=3292071 pre_start=34358039851 pre_end=34390960689
[    0.373339] calibrate_delay_direct() timer_rate_max=3292091 timer_rate_min=3292067 pre_start=34397544819 pre_end=34430465611
[    0.385337] calibrate_delay_direct() timer_rate_max=3292097 timer_rate_min=3292066 pre_start=34437049761 pre_end=34469970569
[    0.397335] calibrate_delay_direct() timer_rate_max=3292091 timer_rate_min=3292067 pre_start=34476554739 pre_end=34509475529
[    0.409333] calibrate_delay_direct() timer_rate_max=3292086 timer_rate_min=3292063 pre_start=34516059741 pre_end=34548980491
[    0.429467] Brought up 4 CPUs
[    0.429469] Total of 4 processors activated (26337.32 BogoMIPS).
[    0.430554] devtmpfs: initialized
[    0.430631] PM: Registering ACPI NVS region at bf35c000 (331776 bytes)
[    0.430635] PM: Registering ACPI NVS region at bf60e000 (40960 bytes)
[    0.430636] PM: Registering ACPI NVS region at bf63d000 (274432 bytes)
[    0.430698] NET: Registered protocol family 16
[    0.430773] ACPI: bus type pci registered
[    0.430796] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.430797] PCI: not using MMCONFIG
[    0.430798] PCI: Using configuration type 1 for base access
[    0.431093] bio: create slab <bio-0> at 0
[    0.431832] ACPI: EC: Look up EC in DSDT
[    0.432551] ACPI: Executed 1 blocks of module-level executable AML code
[    0.433928] ACPI: SSDT 00000000bf60ec18 0038C (v01    AMI      IST 00000001 MSFT 03000001)
[    0.434118] ACPI: Dynamic OEM Table Load:
[    0.434119] ACPI: SSDT           (null) 0038C (v01    AMI      IST 00000001 MSFT 03000001)
[    0.434130] ACPI: SSDT 00000000bf60fe18 00084 (v01    AMI      CST 00000001 MSFT 03000001)
[    0.434297] ACPI: Dynamic OEM Table Load:
[    0.434298] ACPI: SSDT           (null) 00084 (v01    AMI      CST 00000001 MSFT 03000001)
[    0.434511] ACPI: Interpreter enabled
[    0.434513] ACPI: (supports S0 S1 S3 S4 S5)
[    0.434522] ACPI: Using IOAPIC for interrupt routing
[    0.434533] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.434562] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.459727] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.461734] ACPI: No dock devices found.
[    0.461735] HEST: Table not found.
[    0.461736] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.461819] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.461910] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    0.461911] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    0.461913] pci_root PNP0A08:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.461914] pci_root PNP0A08:00: host bridge window [mem 0x000c8000-0x000dffff]
[    0.461915] pci_root PNP0A08:00: host bridge window [mem 0xc0000000-0xffffffff]
[    0.461921] pci 0000:00:00.0: [8086:0100] type 0 class 0x000600
[    0.461943] pci 0000:00:01.0: [8086:0101] type 1 class 0x000604
[    0.461957] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.461959] pci 0000:00:01.0: PME# disabled
[    0.462011] pci 0000:00:16.0: [8086:1c3a] type 0 class 0x000780
[    0.462040] pci 0000:00:16.0: reg 10: [mem 0xfa208000-0xfa20800f 64bit]
[    0.462121] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.462125] pci 0000:00:16.0: PME# disabled
[    0.462165] pci 0000:00:1a.0: [8086:1c2d] type 0 class 0x000c03
[    0.462192] pci 0000:00:1a.0: reg 10: [mem 0xfa207000-0xfa2073ff]
[    0.462289] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.462293] pci 0000:00:1a.0: PME# disabled
[    0.462321] pci 0000:00:1b.0: [8086:1c20] type 0 class 0x000403
[    0.462345] pci 0000:00:1b.0: reg 10: [mem 0xfa200000-0xfa203fff 64bit]
[    0.462420] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.462423] pci 0000:00:1b.0: PME# disabled
[    0.462447] pci 0000:00:1c.0: [8086:1c10] type 1 class 0x000604
[    0.462532] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.462535] pci 0000:00:1c.0: PME# disabled
[    0.462567] pci 0000:00:1c.4: [8086:1c18] type 1 class 0x000604
[    0.462651] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.462654] pci 0000:00:1c.4: PME# disabled
[    0.462682] pci 0000:00:1c.5: [8086:1c1a] type 1 class 0x000604
[    0.462767] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.462770] pci 0000:00:1c.5: PME# disabled
[    0.462798] pci 0000:00:1c.6: [8086:1c1c] type 1 class 0x000604
[    0.462882] pci 0000:00:1c.6: PME# supported from D0 D3hot D3cold
[    0.462885] pci 0000:00:1c.6: PME# disabled
[    0.462913] pci 0000:00:1c.7: [8086:244e] type 1 class 0x000604
[    0.462997] pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
[    0.463001] pci 0000:00:1c.7: PME# disabled
[    0.463035] pci 0000:00:1d.0: [8086:1c26] type 0 class 0x000c03
[    0.463062] pci 0000:00:1d.0: reg 10: [mem 0xfa206000-0xfa2063ff]
[    0.463159] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.463163] pci 0000:00:1d.0: PME# disabled
[    0.463191] pci 0000:00:1f.0: [8086:1c46] type 0 class 0x000601
[    0.463339] pci 0000:00:1f.2: [8086:1c02] type 0 class 0x000106
[    0.463365] pci 0000:00:1f.2: reg 10: [io  0xf070-0xf077]
[    0.463375] pci 0000:00:1f.2: reg 14: [io  0xf060-0xf063]
[    0.463385] pci 0000:00:1f.2: reg 18: [io  0xf050-0xf057]
[    0.463395] pci 0000:00:1f.2: reg 1c: [io  0xf040-0xf043]
[    0.463405] pci 0000:00:1f.2: reg 20: [io  0xf020-0xf03f]
[    0.463415] pci 0000:00:1f.2: reg 24: [mem 0xfa205000-0xfa2057ff]
[    0.463461] pci 0000:00:1f.2: PME# supported from D3hot
[    0.463465] pci 0000:00:1f.2: PME# disabled
[    0.463484] pci 0000:00:1f.3: [8086:1c22] type 0 class 0x000c05
[    0.463504] pci 0000:00:1f.3: reg 10: [mem 0xfa204000-0xfa2040ff 64bit]
[    0.463532] pci 0000:00:1f.3: reg 20: [io  0xf000-0xf01f]
[    0.463584] pci 0000:01:00.0: [10de:06c0] type 0 class 0x000300
[    0.463590] pci 0000:01:00.0: reg 10: [mem 0xf8000000-0xf9ffffff]
[    0.463598] pci 0000:01:00.0: reg 14: [mem 0xd0000000-0xd7ffffff 64bit pref]
[    0.463605] pci 0000:01:00.0: reg 1c: [mem 0xd8000000-0xdbffffff 64bit pref]
[    0.463610] pci 0000:01:00.0: reg 24: [io  0xe000-0xe07f]
[    0.463615] pci 0000:01:00.0: reg 30: [mem 0xfa000000-0xfa07ffff pref]
[    0.463645] pci 0000:01:00.1: [10de:0be5] type 0 class 0x000403
[    0.463652] pci 0000:01:00.1: reg 10: [mem 0xfa080000-0xfa083fff]
[    0.465343] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.465347] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.465351] pci 0000:00:01.0:   bridge window [mem 0xf8000000-0xfa0fffff]
[    0.465357] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdbffffff 64bit pref]
[    0.465436] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.465440] pci 0000:00:1c.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.465444] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.465451] pci 0000:00:1c.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.465535] pci 0000:03:00.0: [10ec:8168] type 0 class 0x000200
[    0.465558] pci 0000:03:00.0: reg 10: [io  0xd000-0xd0ff]
[    0.465599] pci 0000:03:00.0: reg 18: [mem 0xdc204000-0xdc204fff 64bit pref]
[    0.465625] pci 0000:03:00.0: reg 20: [mem 0xdc200000-0xdc203fff 64bit pref]
[    0.465698] pci 0000:03:00.0: supports D1 D2
[    0.465699] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.465704] pci 0000:03:00.0: PME# disabled
[    0.467350] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
[    0.467355] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[    0.467362] pci 0000:00:1c.4:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.467372] pci 0000:00:1c.4:   bridge window [mem 0xdc200000-0xdc2fffff 64bit pref]
[    0.467473] pci 0000:04:00.0: [1b6f:7023] type 0 class 0x000c03
[    0.467503] pci 0000:04:00.0: reg 10: [mem 0xfa100000-0xfa107fff 64bit]
[    0.467625] pci 0000:04:00.0: supports D1 D2
[    0.467626] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.467631] pci 0000:04:00.0: PME# disabled
[    0.469349] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
[    0.469355] pci 0000:00:1c.5:   bridge window [io  0xf000-0x0000] (disabled)
[    0.469361] pci 0000:00:1c.5:   bridge window [mem 0xfa100000-0xfa1fffff]
[    0.469371] pci 0000:00:1c.5:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.469449] pci 0000:00:1c.6: PCI bridge to [bus 05-05]
[    0.469452] pci 0000:00:1c.6:   bridge window [io  0xf000-0x0000] (disabled)
[    0.469456] pci 0000:00:1c.6:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.469463] pci 0000:00:1c.6:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.469538] pci 0000:06:00.0: [1b21:1080] type 1 class 0x000604
[    0.469663] pci 0000:00:1c.7: PCI bridge to [bus 06-07] (subtractive decode)
[    0.469667] pci 0000:00:1c.7:   bridge window [io  0xf000-0x0000] (disabled)
[    0.469671] pci 0000:00:1c.7:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.469677] pci 0000:00:1c.7:   bridge window [mem 0xdc100000-0xdc1fffff 64bit pref]
[    0.469679] pci 0000:00:1c.7:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.469680] pci 0000:00:1c.7:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.469681] pci 0000:00:1c.7:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.469682] pci 0000:00:1c.7:   bridge window [mem 0x000c8000-0x000dffff] (subtractive decode)
[    0.469683] pci 0000:00:1c.7:   bridge window [mem 0xc0000000-0xffffffff] (subtractive decode)
[    0.469754] pci 0000:07:00.0: [109e:036e] type 0 class 0x000400
[    0.469795] pci 0000:07:00.0: reg 10: [mem 0xdc101000-0xdc101fff pref]
[    0.469992] pci 0000:07:00.1: [109e:0878] type 0 class 0x000480
[    0.470032] pci 0000:07:00.1: reg 10: [mem 0xdc100000-0xdc100fff pref]
[    0.470304] pci 0000:06:00.0: PCI bridge to [bus 07-07] (subtractive decode)
[    0.470315] pci 0000:06:00.0:   bridge window [io  0xfff000-0x0000] (disabled)
[    0.470321] pci 0000:06:00.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.470334] pci 0000:06:00.0:   bridge window [mem 0xdc100000-0xdc1fffff 64bit pref]
[    0.470335] pci 0000:06:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    0.470336] pci 0000:06:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    0.470337] pci 0000:06:00.0:   bridge window [mem 0xdc100000-0xdc1fffff 64bit pref] (subtractive decode)
[    0.470338] pci 0000:06:00.0:   bridge window [??? 0x00000000 flags 0x0] (subtractive decode)
[    0.470339] pci 0000:06:00.0:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.470340] pci 0000:06:00.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.470341] pci 0000:06:00.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.470343] pci 0000:06:00.0:   bridge window [mem 0x000c8000-0x000dffff] (subtractive decode)
[    0.470344] pci 0000:06:00.0:   bridge window [mem 0xc0000000-0xffffffff] (subtractive decode)
[    0.470389] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.470431] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.470444] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.470454] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
[    0.470465] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX6._PRT]
[    0.470476] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX7._PRT]
[    0.470487] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX7.PE2P._PRT]
[    0.470507] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.470553]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.470607]  pci0000:00: ACPI _OSC control (0x1d) granted
[    0.472320] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.472347] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.472368] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.472389] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 10 11 12 14 15)
[    0.472410] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
[    0.472431] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
[    0.472452] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.472473] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.472518] SCSI subsystem initialized
[    0.472533] libata version 3.00 loaded.
[    0.472544] usbcore: registered new interface driver usbfs
[    0.472549] usbcore: registered new interface driver hub
[    0.472557] usbcore: registered new device driver usb
[    0.472576] wmi: Mapper loaded
[    0.472577] PCI: Using ACPI for IRQ routing
[    0.482523] PCI: pci_cache_line_size set to 64 bytes
[    0.482600] reserve RAM buffer: 00000000bf35c000 - 00000000bfffffff
[    0.482601] reserve RAM buffer: 00000000bf60d000 - 00000000bfffffff
[    0.482603] reserve RAM buffer: 00000000bf800000 - 00000000bfffffff
[    0.482604] reserve RAM buffer: 000000023f800000 - 000000023fffffff
[    0.482654] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.482658] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.484673] Switching to clocksource hpet
[    0.485328] Switched to NOHz mode on CPU #0
[    0.485379] Switched to NOHz mode on CPU #1
[    0.485387] Switched to NOHz mode on CPU #2
[    0.485456] Switched to NOHz mode on CPU #3
[    0.485795] pnp: PnP ACPI init
[    0.485800] ACPI: bus type pnp registered
[    0.485852] pnp 00:00: [bus 00-ff]
[    0.485854] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.485854] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.485855] pnp 00:00: [io  0x0d00-0xffff window]
[    0.485856] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.485857] pnp 00:00: [mem 0x000c8000-0x000dffff window]
[    0.485858] pnp 00:00: [mem 0xc0000000-0xffffffff window]
[    0.485859] pnp 00:00: [mem 0x00000000 window]
[    0.485879] pnp 00:00: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
[    0.485902] pnp 00:01: [mem 0xfed10000-0xfed19fff]
[    0.485903] pnp 00:01: [mem 0xe0000000-0xefffffff]
[    0.485904] pnp 00:01: [mem 0xfed90000-0xfed93fff]
[    0.485905] pnp 00:01: [mem 0xfed20000-0xfed3ffff]
[    0.485906] pnp 00:01: [mem 0xfee00000-0xfee0ffff]
[    0.485924] system 00:01: [mem 0xfed10000-0xfed19fff] has been reserved
[    0.485925] system 00:01: [mem 0xe0000000-0xefffffff] has been reserved
[    0.485926] system 00:01: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.485927] system 00:01: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.485929] system 00:01: [mem 0xfee00000-0xfee0ffff] has been reserved
[    0.485930] system 00:01: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.485953] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    0.485954] pnp 00:02: [io  0x0290-0x029f]
[    0.485955] pnp 00:02: [io  0x0000-0xffffffffffffffff disabled]
[    0.485970] system 00:02: [io  0x0290-0x029f] has been reserved
[    0.485971] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.486080] pnp 00:03: [dma 4]
[    0.486081] pnp 00:03: [io  0x0000-0x000f]
[    0.486082] pnp 00:03: [io  0x0081-0x0083]
[    0.486083] pnp 00:03: [io  0x0087]
[    0.486084] pnp 00:03: [io  0x0089-0x008b]
[    0.486085] pnp 00:03: [io  0x008f]
[    0.486086] pnp 00:03: [io  0x00c0-0x00df]
[    0.486095] pnp 00:03: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.486099] pnp 00:04: [io  0x0070-0x0071]
[    0.486104] pnp 00:04: [irq 8]
[    0.486113] pnp 00:04: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.486116] pnp 00:05: [io  0x0061]
[    0.486125] pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.486132] pnp 00:06: [io  0x0010-0x001f]
[    0.486133] pnp 00:06: [io  0x0022-0x003f]
[    0.486133] pnp 00:06: [io  0x0044-0x005f]
[    0.486134] pnp 00:06: [io  0x0062-0x0063]
[    0.486135] pnp 00:06: [io  0x0065-0x006f]
[    0.486136] pnp 00:06: [io  0x0072-0x007f]
[    0.486136] pnp 00:06: [io  0x0080]
[    0.486137] pnp 00:06: [io  0x0084-0x0086]
[    0.486138] pnp 00:06: [io  0x0088]
[    0.486139] pnp 00:06: [io  0x008c-0x008e]
[    0.486139] pnp 00:06: [io  0x0090-0x009f]
[    0.486140] pnp 00:06: [io  0x00a2-0x00bf]
[    0.486141] pnp 00:06: [io  0x00e0-0x00ef]
[    0.486142] pnp 00:06: [io  0x04d0-0x04d1]
[    0.486160] system 00:06: [io  0x04d0-0x04d1] has been reserved
[    0.486161] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.486165] pnp 00:07: [io  0x00f0-0x00ff]
[    0.486168] pnp 00:07: [irq 13]
[    0.486177] pnp 00:07: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.486306] pnp 00:08: [io  0x0400-0x0453]
[    0.486306] pnp 00:08: [io  0x0458-0x047f]
[    0.486307] pnp 00:08: [io  0x1180-0x119f]
[    0.486308] pnp 00:08: [io  0x0500-0x057f]
[    0.486309] pnp 00:08: [mem 0xfed1c000-0xfed1ffff]
[    0.486310] pnp 00:08: [mem 0xfec00000-0xfecfffff]
[    0.486311] pnp 00:08: [mem 0xfed08000-0xfed08fff]
[    0.486311] pnp 00:08: [mem 0xff000000-0xffffffff]
[    0.486329] system 00:08: [io  0x0400-0x0453] has been reserved
[    0.486330] system 00:08: [io  0x0458-0x047f] has been reserved
[    0.486331] system 00:08: [io  0x1180-0x119f] has been reserved
[    0.486332] system 00:08: [io  0x0500-0x057f] has been reserved
[    0.486334] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.486335] system 00:08: [mem 0xfec00000-0xfecfffff] could not be reserved
[    0.486336] system 00:08: [mem 0xfed08000-0xfed08fff] has been reserved
[    0.486337] system 00:08: [mem 0xff000000-0xffffffff] has been reserved
[    0.486338] system 00:08: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.486353] pnp 00:09: [io  0x0454-0x0457]
[    0.486369] system 00:09: [io  0x0454-0x0457] has been reserved
[    0.486371] system 00:09: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.486422] pnp 00:0a: [mem 0xfed00000-0xfed003ff]
[    0.486438] pnp 00:0a: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.486508] pnp: PnP ACPI: found 11 devices
[    0.486509] ACPI: ACPI bus type pnp unregistered
[    0.491646] PCI: max bus depth: 2 pci_try_num: 3
[    0.491710] pci 0000:00:01.0: PCI bridge to [bus 01-01]
[    0.491712] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.491713] pci 0000:00:01.0:   bridge window [mem 0xf8000000-0xfa0fffff]
[    0.491715] pci 0000:00:01.0:   bridge window [mem 0xd0000000-0xdbffffff 64bit pref]
[    0.491717] pci 0000:00:1c.0: PCI bridge to [bus 02-02]
[    0.491723] pci 0000:00:1c.0:   bridge window [io  disabled]
[    0.491729] pci 0000:00:1c.0:   bridge window [mem disabled]
[    0.491732] pci 0000:00:1c.0:   bridge window [mem pref disabled]
[    0.491739] pci 0000:00:1c.4: PCI bridge to [bus 03-03]
[    0.491741] pci 0000:00:1c.4:   bridge window [io  0xd000-0xdfff]
[    0.491747] pci 0000:00:1c.4:   bridge window [mem disabled]
[    0.491750] pci 0000:00:1c.4:   bridge window [mem 0xdc200000-0xdc2fffff 64bit pref]
[    0.491757] pci 0000:00:1c.5: PCI bridge to [bus 04-04]
[    0.491758] pci 0000:00:1c.5:   bridge window [io  disabled]
[    0.491763] pci 0000:00:1c.5:   bridge window [mem 0xfa100000-0xfa1fffff]
[    0.491767] pci 0000:00:1c.5:   bridge window [mem pref disabled]
[    0.491773] pci 0000:00:1c.6: PCI bridge to [bus 05-05]
[    0.491774] pci 0000:00:1c.6:   bridge window [io  disabled]
[    0.491779] pci 0000:00:1c.6:   bridge window [mem disabled]
[    0.491783] pci 0000:00:1c.6:   bridge window [mem pref disabled]
[    0.491790] pci 0000:06:00.0: PCI bridge to [bus 07-07]
[    0.491790] pci 0000:06:00.0:   bridge window [io  disabled]
[    0.491798] pci 0000:06:00.0:   bridge window [mem disabled]
[    0.491804] pci 0000:06:00.0:   bridge window [mem 0xdc100000-0xdc1fffff 64bit pref]
[    0.491815] pci 0000:00:1c.7: PCI bridge to [bus 06-07]
[    0.491815] pci 0000:00:1c.7:   bridge window [io  disabled]
[    0.491820] pci 0000:00:1c.7:   bridge window [mem disabled]
[    0.491824] pci 0000:00:1c.7:   bridge window [mem 0xdc100000-0xdc1fffff 64bit pref]
[    0.491835] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.491837] pci 0000:00:01.0: setting latency timer to 64
[    0.491842] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.491846] pci 0000:00:1c.0: setting latency timer to 64
[    0.491851] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.491855] pci 0000:00:1c.4: setting latency timer to 64
[    0.491860] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.491864] pci 0000:00:1c.5: setting latency timer to 64
[    0.491870] pci 0000:00:1c.6: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.491874] pci 0000:00:1c.6: setting latency timer to 64
[    0.491880] pci 0000:00:1c.7: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.491884] pci 0000:00:1c.7: setting latency timer to 64
[    0.491890] pci 0000:06:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.491895] pci 0000:06:00.0: setting latency timer to 64
[    0.491899] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.491900] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.491901] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.491902] pci_bus 0000:00: resource 7 [mem 0x000c8000-0x000dffff]
[    0.491903] pci_bus 0000:00: resource 8 [mem 0xc0000000-0xffffffff]
[    0.491904] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.491905] pci_bus 0000:01: resource 1 [mem 0xf8000000-0xfa0fffff]
[    0.491906] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdbffffff 64bit pref]
[    0.491907] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.491908] pci_bus 0000:03: resource 2 [mem 0xdc200000-0xdc2fffff 64bit pref]
[    0.491909] pci_bus 0000:04: resource 1 [mem 0xfa100000-0xfa1fffff]
[    0.491910] pci_bus 0000:06: resource 2 [mem 0xdc100000-0xdc1fffff 64bit pref]
[    0.491911] pci_bus 0000:06: resource 4 [io  0x0000-0x0cf7]
[    0.491912] pci_bus 0000:06: resource 5 [io  0x0d00-0xffff]
[    0.491913] pci_bus 0000:06: resource 6 [mem 0x000a0000-0x000bffff]
[    0.491914] pci_bus 0000:06: resource 7 [mem 0x000c8000-0x000dffff]
[    0.491915] pci_bus 0000:06: resource 8 [mem 0xc0000000-0xffffffff]
[    0.491916] pci_bus 0000:07: resource 2 [mem 0xdc100000-0xdc1fffff 64bit pref]
[    0.491917] pci_bus 0000:07: resource 6 [mem 0xdc100000-0xdc1fffff 64bit pref]
[    0.491918] pci_bus 0000:07: resource 8 [io  0x0000-0x0cf7]
[    0.491919] pci_bus 0000:07: resource 9 [io  0x0d00-0xffff]
[    0.491920] pci_bus 0000:07: resource 10 [mem 0x000a0000-0x000bffff]
[    0.491921] pci_bus 0000:07: resource 11 [mem 0x000c8000-0x000dffff]
[    0.491922] pci_bus 0000:07: resource 12 [mem 0xc0000000-0xffffffff]
[    0.491938] NET: Registered protocol family 2
[    0.492056] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.492599] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.494682] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.494961] TCP: Hash tables configured (established 524288 bind 65536)
[    0.494962] TCP reno registered
[    0.494970] UDP hash table entries: 4096 (order: 5, 131072 bytes)
[    0.495013] UDP-Lite hash table entries: 4096 (order: 5, 131072 bytes)
[    0.495120] NET: Registered protocol family 1
[    0.740760] pci 0000:01:00.0: Boot video device
[    0.740832] PCI: CLS 64 bytes, default 64
[    0.740866] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.740868] Placing 64MB software IO TLB between ffff8800bb1bf000 - ffff8800bf1bf000
[    0.740869] software IO TLB at phys 0xbb1bf000 - 0xbf1bf000
[    0.741288] audit: initializing netlink socket (disabled)
[    0.741294] type=2000 audit(1307988464.579:1): initialized
[    0.761922] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.791007] VFS: Disk quotas dquot_6.5.2
[    0.791041] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.791320] Btrfs loaded
[    0.791323] msgmni has been set to 15967
[    0.791359] SELinux:  Registering netfilter hooks
[    0.791599] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.791614] io scheduler noop registered
[    0.791631] io scheduler cfq registered (default)
[    0.791686] pcieport 0000:00:01.0: setting latency timer to 64
[    0.791700] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.791752] pcieport 0000:00:1c.0: setting latency timer to 64
[    0.791803] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    0.791877] pcieport 0000:00:1c.4: setting latency timer to 64
[    0.791928] pcieport 0000:00:1c.4: irq 42 for MSI/MSI-X
[    0.792001] pcieport 0000:00:1c.5: setting latency timer to 64
[    0.792052] pcieport 0000:00:1c.5: irq 43 for MSI/MSI-X
[    0.792127] pcieport 0000:00:1c.6: setting latency timer to 64
[    0.792177] pcieport 0000:00:1c.6: irq 44 for MSI/MSI-X
[    0.792252] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    0.792253] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    0.792254] pci 0000:01:00.1: Signaling PME through PCIe PME interrupt
[    0.792255] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    0.792271] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.792275] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    0.792290] pcieport 0000:00:1c.4: Signaling PME through PCIe PME interrupt
[    0.792291] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    0.792295] pcie_pme 0000:00:1c.4:pcie01: service driver pcie_pme loaded
[    0.792311] pcieport 0000:00:1c.5: Signaling PME through PCIe PME interrupt
[    0.792312] pci 0000:04:00.0: Signaling PME through PCIe PME interrupt
[    0.792316] pcie_pme 0000:00:1c.5:pcie01: service driver pcie_pme loaded
[    0.792331] pcieport 0000:00:1c.6: Signaling PME through PCIe PME interrupt
[    0.792335] pcie_pme 0000:00:1c.6:pcie01: service driver pcie_pme loaded
[    0.792342] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.792353] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.792384] efifb: probing for efifb
[    0.792733] efifb: framebuffer at 0xd9000000, mapped to 0xffffc90012880000, using 3072k, total 3072k
[    0.792734] efifb: mode is 1024x768x32, linelength=4096, pages=1
[    0.792735] efifb: scrolling: redraw
[    0.792736] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.804418] Console: switching to colour frame buffer device 128x48
[    0.816079] fb0: EFI VGA frame buffer device
[    0.816082] intel_idle: MWAIT substates: 0x1120
[    0.816083] intel_idle: v0.4 model 0x2A
[    0.816083] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.816131] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
[    0.816133] ACPI: Power Button [PWRB]
[    0.816151] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    0.816152] ACPI: Power Button [PWRF]
[    0.816240] ACPI: acpi_idle yielding to intel_idle
[    0.817100] ERST: Table is not found!
[    0.817132] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.880933] Linux agpgart interface v0.103
[    0.881409] brd: module loaded
[    0.881601] loop: module loaded
[    0.881640] ahci 0000:00:1f.2: version 3.0
[    0.881647] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.881682] ahci 0000:00:1f.2: irq 45 for MSI/MSI-X
[    0.881702] ahci: SSS flag set, parallel bus scan disabled
[    0.892756] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
[    0.892760] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems sxs apst
[    0.892767] ahci 0000:00:1f.2: setting latency timer to 64
[    0.902965] scsi0 : ahci
[    0.903004] scsi1 : ahci
[    0.903031] scsi2 : ahci
[    0.903057] scsi3 : ahci
[    0.903083] scsi4 : ahci
[    0.903108] scsi5 : ahci
[    0.903167] ata1: SATA max UDMA/133 abar m2048@0xfa205000 port 0xfa205100 irq 45
[    0.903169] ata2: SATA max UDMA/133 abar m2048@0xfa205000 port 0xfa205180 irq 45
[    0.903171] ata3: SATA max UDMA/133 abar m2048@0xfa205000 port 0xfa205200 irq 45
[    0.903173] ata4: SATA max UDMA/133 abar m2048@0xfa205000 port 0xfa205280 irq 45
[    0.903176] ata5: SATA max UDMA/133 abar m2048@0xfa205000 port 0xfa205300 irq 45
[    0.903178] ata6: SATA max UDMA/133 abar m2048@0xfa205000 port 0xfa205380 irq 45
[    0.903204] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.903215] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.903225] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.903228] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    0.903232] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.903260] ehci_hcd 0000:00:1a.0: debug port 2
[    0.907148] ehci_hcd 0000:00:1a.0: cache line size of 64 is not supported
[    0.907158] ehci_hcd 0000:00:1a.0: irq 16, io mem 0xfa207000
[    0.916725] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.916836] hub 1-0:1.0: USB hub found
[    0.916839] hub 1-0:1.0: 2 ports detected
[    0.916871] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.916878] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.916880] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    0.916882] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.916902] ehci_hcd 0000:00:1d.0: debug port 2
[    0.920788] ehci_hcd 0000:00:1d.0: cache line size of 64 is not supported
[    0.920797] ehci_hcd 0000:00:1d.0: irq 23, io mem 0xfa206000
[    0.929725] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.929825] hub 2-0:1.0: USB hub found
[    0.929827] hub 2-0:1.0: 2 ports detected
[    0.929854] uhci_hcd: USB Universal Host Controller Interface driver
[    0.929884] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.932701] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.932719] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.932750] mousedev: PS/2 mouse device common for all mice
[    0.932793] rtc_cmos 00:04: RTC can wake from S4
[    0.932864] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    0.932890] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.932930] device-mapper: uevent: version 1.0.3
[    0.932960] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
[    0.933010] cpuidle: using governor ladder
[    0.933073] cpuidle: using governor menu
[    0.933074] EFI Variables Facility v0.08 2004-May-17
[    0.969678] usbcore: registered new interface driver usbhid
[    0.969679] usbhid: USB HID core driver
[    0.969792] TCP cubic registered
[    0.969843] NET: Registered protocol family 10
[    0.970086] Mobile IPv6
[    0.970087] IPv6 over IPv4 tunneling driver
[    0.970267] NET: Registered protocol family 17
[    0.970307] PM: Hibernation image not present or could not be loaded.
[    0.970313] registered taskstats version 1
[    0.985350] rtc_cmos 00:04: setting system clock to 2011-06-13 18:07:45 UTC (1307988465)
[    0.985427] ACPI Warning: For \_PR_.P000._PSS: SubPackage[0,1] - suspicious power dissipation values (20110413/nsrepair2-573)
[    0.985585] ACPI Warning: For \_PR_.P001._PSS: SubPackage[0,1] - suspicious power dissipation values (20110413/nsrepair2-573)
[    0.985658] ACPI Warning: For \_PR_.P002._PSS: SubPackage[0,1] - suspicious power dissipation values (20110413/nsrepair2-573)
[    0.985741] ACPI Warning: For \_PR_.P003._PSS: SubPackage[0,1] - suspicious power dissipation values (20110413/nsrepair2-573)
[    0.985792] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    0.985793] EDD information not available.
[    1.207752] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.218752] usb 1-1: new high speed USB device number 2 using ehci_hcd
[    1.249416] ata1.00: ATA-7: ST3750640AS, 3.AAE, max UDMA/133
[    1.249421] ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.307717] ata1.00: configured for UDMA/133
[    1.307967] scsi 0:0:0:0: Direct-Access     ATA      ST3750640AS      3.AA PQ: 0 ANSI: 5
[    1.308140] sd 0:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
[    1.308340] sd 0:0:0:0: [sda] Write Protect is off
[    1.308345] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.308421] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.333362] hub 1-1:1.0: USB hub found
[    1.333450] hub 1-1:1.0: 6 ports detected
[    1.355718]  sda: sda1
[    1.356105] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.435730] usb 2-1: new high speed USB device number 2 using ehci_hcd
[    1.550375] hub 2-1:1.0: USB hub found
[    1.550445] hub 2-1:1.0: 8 ports detected
[    1.612740] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.613051] ata2.00: ATA-7: INTEL SSDSA2M040G2GC, 2CV102M3, max UDMA/133
[    1.613056] ata2.00: 78165360 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    1.613352] ata2.00: configured for UDMA/133
[    1.613516] scsi 1:0:0:0: Direct-Access     ATA      INTEL SSDSA2M040 2CV1 PQ: 0 ANSI: 5
[    1.613630] sd 1:0:0:0: [sdb] 78165360 512-byte logical blocks: (40.0 GB/37.2 GiB)
[    1.613682] sd 1:0:0:0: [sdb] Write Protect is off
[    1.613684] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.613714] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.616311]  sdb: sdb1 sdb2
[    1.616773] sd 1:0:0:0: [sdb] Attached SCSI disk
[    1.624862] usb 1-1.4: new low speed USB device number 3 using ehci_hcd
[    1.720162] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.0/input/input2
[    1.720234] logitech 0003:046D:C517.0001: input: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:1a.0-1.4/input0
[    1.725356] logitech 0003:046D:C517.0002: fixing up Logitech keyboard report descriptor
[    1.725839] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.4/1-1.4:1.1/input/input3
[    1.725978] logitech 0003:046D:C517.0002: input,hiddev0: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1a.0-1.4/input1
[    1.742723] Refined TSC clocksource calibration: 3292.521 MHz.
[    1.742729] Switching to clocksource tsc
[    1.917723] ata3: SATA link down (SStatus 0 SControl 300)
[    2.222714] ata4: SATA link down (SStatus 0 SControl 300)
[    2.527708] ata5: SATA link down (SStatus 0 SControl 300)
[    2.832699] ata6: SATA link down (SStatus 0 SControl 300)
[    2.856975] device fsid 73d3d24f-521e-4c12-a6b9-45fd63f1c0ba devid 1 transid 43498 /dev/root
[    2.857294] btrfs: use ssd allocation scheme
[    2.886944] VFS: Mounted root (btrfs filesystem) readonly on device 0:14.
[    2.887209] devtmpfs: mounted
[    2.888216] Freeing unused kernel memory: 768k freed
[    2.888264] Write protecting the kernel read-only data: 10240k
[    2.889143] Freeing unused kernel memory: 492k freed
[    2.891647] Freeing unused kernel memory: 1836k freed
[    2.891658] BUG: Bad page state in process swapper  pfn:01850
[    2.891780] page:ffffea0000055180 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.891959] page flags: 0x100000000000000()
[    2.892057] Pid: 1, comm: swapper Not tainted 3.0.0-rc2-patser+ #39
[    2.892058] Call Trace:
[    2.892063]  [<ffffffff810f689b>] ? dump_page+0x9b/0xd0
[    2.892065]  [<ffffffff810f6999>] bad_page+0xc9/0x120
[    2.892066]  [<ffffffff810f6aab>] free_pages_prepare+0xbb/0x130
[    2.892068]  [<ffffffff810f8379>] free_hot_cold_page+0x49/0x440
[    2.892070]  [<ffffffff810f8ddd>] __free_pages+0x2d/0x40
[    2.892072]  [<ffffffff810f8e33>] free_pages+0x43/0x50
[    2.892074]  [<ffffffff810284f2>] free_init_pages+0x132/0x1c0
[    2.892076]  [<ffffffff81028c83>] mark_rodata_ro+0x143/0x150
[    2.892078]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.892080]  [<ffffffff81ab8d2c>] kernel_init+0x158/0x163
[    2.892083]  [<ffffffff8157d6d4>] kernel_thread_helper+0x4/0x10
[    2.892084]  [<ffffffff81ab8bd4>] ? start_kernel+0x3c3/0x3c3
[    2.892086]  [<ffffffff8157d6d0>] ? gs_change+0xb/0xb
[    2.892087] Disabling lock debugging due to kernel taint
[    2.892091] BUG: Bad page state in process swapper  pfn:01860
[    2.892210] page:ffffea0000055500 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.892390] page flags: 0x100000000000000()
[    2.892488] Pid: 1, comm: swapper Tainted: G    B       3.0.0-rc2-patser+ #39
[    2.892489] Call Trace:
[    2.892490]  [<ffffffff810f689b>] ? dump_page+0x9b/0xd0
[    2.892491]  [<ffffffff810f6999>] bad_page+0xc9/0x120
[    2.892493]  [<ffffffff810f6aab>] free_pages_prepare+0xbb/0x130
[    2.892495]  [<ffffffff810f8379>] free_hot_cold_page+0x49/0x440
[    2.892496]  [<ffffffff810f8ddd>] __free_pages+0x2d/0x40
[    2.892498]  [<ffffffff810f8e33>] free_pages+0x43/0x50
[    2.892499]  [<ffffffff810284f2>] free_init_pages+0x132/0x1c0
[    2.892500]  [<ffffffff81028c83>] mark_rodata_ro+0x143/0x150
[    2.892502]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.892503]  [<ffffffff81ab8d2c>] kernel_init+0x158/0x163
[    2.892505]  [<ffffffff8157d6d4>] kernel_thread_helper+0x4/0x10
[    2.892506]  [<ffffffff81ab8bd4>] ? start_kernel+0x3c3/0x3c3
[    2.892508]  [<ffffffff8157d6d0>] ? gs_change+0xb/0xb
[    2.892510] BUG: Bad page state in process swapper  pfn:01868
[    2.892629] page:ffffea00000556c0 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.892811] page flags: 0x100000000000000()
[    2.892906] Pid: 1, comm: swapper Tainted: G    B       3.0.0-rc2-patser+ #39
[    2.892907] Call Trace:
[    2.892909]  [<ffffffff810f689b>] ? dump_page+0x9b/0xd0
[    2.892910]  [<ffffffff810f6999>] bad_page+0xc9/0x120
[    2.892912]  [<ffffffff810f6aab>] free_pages_prepare+0xbb/0x130
[    2.892913]  [<ffffffff810f8379>] free_hot_cold_page+0x49/0x440
[    2.892915]  [<ffffffff810f8ddd>] __free_pages+0x2d/0x40
[    2.892917]  [<ffffffff810f8e33>] free_pages+0x43/0x50
[    2.892918]  [<ffffffff810284f2>] free_init_pages+0x132/0x1c0
[    2.892919]  [<ffffffff81028c83>] mark_rodata_ro+0x143/0x150
[    2.892921]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.892922]  [<ffffffff81ab8d2c>] kernel_init+0x158/0x163
[    2.892923]  [<ffffffff8157d6d4>] kernel_thread_helper+0x4/0x10
[    2.892925]  [<ffffffff81ab8bd4>] ? start_kernel+0x3c3/0x3c3
[    2.892926]  [<ffffffff8157d6d0>] ? gs_change+0xb/0xb
[    2.892934] BUG: Bad page state in process swapper  pfn:0187e
[    2.893052] page:ffffea0000055b90 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.893232] page flags: 0x100000000000000()
[    2.893329] Pid: 1, comm: swapper Tainted: G    B       3.0.0-rc2-patser+ #39
[    2.893330] Call Trace:
[    2.893331]  [<ffffffff810f689b>] ? dump_page+0x9b/0xd0
[    2.893333]  [<ffffffff810f6999>] bad_page+0xc9/0x120
[    2.893334]  [<ffffffff810f6aab>] free_pages_prepare+0xbb/0x130
[    2.893336]  [<ffffffff810f8379>] free_hot_cold_page+0x49/0x440
[    2.893338]  [<ffffffff810f8ddd>] __free_pages+0x2d/0x40
[    2.893339]  [<ffffffff810f8e33>] free_pages+0x43/0x50
[    2.893340]  [<ffffffff810284f2>] free_init_pages+0x132/0x1c0
[    2.893342]  [<ffffffff81028c83>] mark_rodata_ro+0x143/0x150
[    2.893343]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.893345]  [<ffffffff81ab8d2c>] kernel_init+0x158/0x163
[    2.893346]  [<ffffffff8157d6d4>] kernel_thread_helper+0x4/0x10
[    2.893348]  [<ffffffff81ab8bd4>] ? start_kernel+0x3c3/0x3c3
[    2.893349]  [<ffffffff8157d6d0>] ? gs_change+0xb/0xb
[    2.893350] BUG: Bad page state in process swapper  pfn:01880
[    2.893469] page:ffffea0000055c00 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.893649] page flags: 0x100000000000000()
[    2.893747] Pid: 1, comm: swapper Tainted: G    B       3.0.0-rc2-patser+ #39
[    2.893747] Call Trace:
[    2.893749]  [<ffffffff810f689b>] ? dump_page+0x9b/0xd0
[    2.893750]  [<ffffffff810f6999>] bad_page+0xc9/0x120
[    2.893752]  [<ffffffff810f6aab>] free_pages_prepare+0xbb/0x130
[    2.893753]  [<ffffffff810f8379>] free_hot_cold_page+0x49/0x440
[    2.893755]  [<ffffffff810f8ddd>] __free_pages+0x2d/0x40
[    2.893757]  [<ffffffff810f8e33>] free_pages+0x43/0x50
[    2.893758]  [<ffffffff810284f2>] free_init_pages+0x132/0x1c0
[    2.893759]  [<ffffffff81028c83>] mark_rodata_ro+0x143/0x150
[    2.893761]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.893762]  [<ffffffff81ab8d2c>] kernel_init+0x158/0x163
[    2.893763]  [<ffffffff8157d6d4>] kernel_thread_helper+0x4/0x10
[    2.893765]  [<ffffffff81ab8bd4>] ? start_kernel+0x3c3/0x3c3
[    2.893766]  [<ffffffff8157d6d0>] ? gs_change+0xb/0xb
[    2.893769] BUG: Bad page state in process swapper  pfn:01888
[    2.893888] page:ffffea0000055dc0 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.894068] page flags: 0x100000000000000()
[    2.894166] Pid: 1, comm: swapper Tainted: G    B       3.0.0-rc2-patser+ #39
[    2.894166] Call Trace:
[    2.894168]  [<ffffffff810f689b>] ? dump_page+0x9b/0xd0
[    2.894169]  [<ffffffff810f6999>] bad_page+0xc9/0x120
[    2.894171]  [<ffffffff810f6aab>] free_pages_prepare+0xbb/0x130
[    2.894172]  [<ffffffff810f8379>] free_hot_cold_page+0x49/0x440
[    2.894174]  [<ffffffff810f8ddd>] __free_pages+0x2d/0x40
[    2.894175]  [<ffffffff810f8e33>] free_pages+0x43/0x50
[    2.894177]  [<ffffffff810284f2>] free_init_pages+0x132/0x1c0
[    2.894178]  [<ffffffff81028c83>] mark_rodata_ro+0x143/0x150
[    2.894179]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.894181]  [<ffffffff81ab8d2c>] kernel_init+0x158/0x163
[    2.894182]  [<ffffffff8157d6d4>] kernel_thread_helper+0x4/0x10
[    2.894184]  [<ffffffff81ab8bd4>] ? start_kernel+0x3c3/0x3c3
[    2.894185]  [<ffffffff8157d6d0>] ? gs_change+0xb/0xb
[    2.894187] BUG: Bad page state in process swapper  pfn:0188c
[    2.894306] page:ffffea0000055ea0 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.894486] page flags: 0x100000000000000()
[    2.894583] Pid: 1, comm: swapper Tainted: G    B       3.0.0-rc2-patser+ #39
[    2.894584] Call Trace:
[    2.894586]  [<ffffffff810f689b>] ? dump_page+0x9b/0xd0
[    2.894587]  [<ffffffff810f6999>] bad_page+0xc9/0x120
[    2.894588]  [<ffffffff810f6aab>] free_pages_prepare+0xbb/0x130
[    2.894590]  [<ffffffff810f8379>] free_hot_cold_page+0x49/0x440
[    2.894592]  [<ffffffff810f8ddd>] __free_pages+0x2d/0x40
[    2.894593]  [<ffffffff810f8e33>] free_pages+0x43/0x50
[    2.894594]  [<ffffffff810284f2>] free_init_pages+0x132/0x1c0
[    2.894596]  [<ffffffff81028c83>] mark_rodata_ro+0x143/0x150
[    2.894597]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.894599]  [<ffffffff81ab8d2c>] kernel_init+0x158/0x163
[    2.894600]  [<ffffffff8157d6d4>] kernel_thread_helper+0x4/0x10
[    2.894602]  [<ffffffff81ab8bd4>] ? start_kernel+0x3c3/0x3c3
[    2.894603]  [<ffffffff8157d6d0>] ? gs_change+0xb/0xb
[    2.894605] BUG: Bad page state in process swapper  pfn:01890
[    2.894728] page:ffffea0000055f80 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.894903] page flags: 0x100000000000000()
[    2.895001] Pid: 1, comm: swapper Tainted: G    B       3.0.0-rc2-patser+ #39
[    2.895002] Call Trace:
[    2.895003]  [<ffffffff810f689b>] ? dump_page+0x9b/0xd0
[    2.895005]  [<ffffffff810f6999>] bad_page+0xc9/0x120
[    2.895006]  [<ffffffff810f6aab>] free_pages_prepare+0xbb/0x130
[    2.895008]  [<ffffffff810f8379>] free_hot_cold_page+0x49/0x440
[    2.895009]  [<ffffffff810f8ddd>] __free_pages+0x2d/0x40
[    2.895011]  [<ffffffff810f8e33>] free_pages+0x43/0x50
[    2.895012]  [<ffffffff810284f2>] free_init_pages+0x132/0x1c0
[    2.895013]  [<ffffffff81028c83>] mark_rodata_ro+0x143/0x150
[    2.895015]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.895016]  [<ffffffff81ab8d2c>] kernel_init+0x158/0x163
[    2.895018]  [<ffffffff8157d6d4>] kernel_thread_helper+0x4/0x10
[    2.895019]  [<ffffffff81ab8bd4>] ? start_kernel+0x3c3/0x3c3
[    2.895020]  [<ffffffff8157d6d0>] ? gs_change+0xb/0xb
[    2.895022] BUG: Bad page state in process swapper  pfn:01892
[    2.895140] page:ffffea0000055ff0 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.895320] page flags: 0x100000000000000()
[    2.895418] Pid: 1, comm: swapper Tainted: G    B       3.0.0-rc2-patser+ #39
[    2.895419] Call Trace:
[    2.895420]  [<ffffffff810f689b>] ? dump_page+0x9b/0xd0
[    2.895422]  [<ffffffff810f6999>] bad_page+0xc9/0x120
[    2.895423]  [<ffffffff810f6aab>] free_pages_prepare+0xbb/0x130
[    2.895425]  [<ffffffff810f8379>] free_hot_cold_page+0x49/0x440
[    2.895426]  [<ffffffff810f8ddd>] __free_pages+0x2d/0x40
[    2.895428]  [<ffffffff810f8e33>] free_pages+0x43/0x50
[    2.895429]  [<ffffffff810284f2>] free_init_pages+0x132/0x1c0
[    2.895430]  [<ffffffff81028c83>] mark_rodata_ro+0x143/0x150
[    2.895432]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.895433]  [<ffffffff81ab8d2c>] kernel_init+0x158/0x163
[    2.895435]  [<ffffffff8157d6d4>] kernel_thread_helper+0x4/0x10
[    2.895436]  [<ffffffff81ab8bd4>] ? start_kernel+0x3c3/0x3c3
[    2.895437]  [<ffffffff8157d6d0>] ? gs_change+0xb/0xb
[    2.895444] BUG: Bad page state in process swapper  pfn:018a1
[    2.895562] page:ffffea0000056338 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.895745] page flags: 0x100000000000000()
[    2.895840] Pid: 1, comm: swapper Tainted: G    B       3.0.0-rc2-patser+ #39
[    2.895841] Call Trace:
[    2.895842]  [<ffffffff810f689b>] ? dump_page+0x9b/0xd0
[    2.895844]  [<ffffffff810f6999>] bad_page+0xc9/0x120
[    2.895845]  [<ffffffff810f6aab>] free_pages_prepare+0xbb/0x130
[    2.895847]  [<ffffffff810f8379>] free_hot_cold_page+0x49/0x440
[    2.895848]  [<ffffffff810f8ddd>] __free_pages+0x2d/0x40
[    2.895850]  [<ffffffff810f8e33>] free_pages+0x43/0x50
[    2.895851]  [<ffffffff810284f2>] free_init_pages+0x132/0x1c0
[    2.895853]  [<ffffffff81028c83>] mark_rodata_ro+0x143/0x150
[    2.895854]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.895856]  [<ffffffff81ab8d2c>] kernel_init+0x158/0x163
[    2.895857]  [<ffffffff8157d6d4>] kernel_thread_helper+0x4/0x10
[    2.895859]  [<ffffffff81ab8bd4>] ? start_kernel+0x3c3/0x3c3
[    2.895860]  [<ffffffff8157d6d0>] ? gs_change+0xb/0xb
[    2.895861] BUG: Bad page state in process swapper  pfn:018a2
[    2.895979] page:ffffea0000056370 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.896159] page flags: 0x100000000000000()
[    2.896257] Pid: 1, comm: swapper Tainted: G    B       3.0.0-rc2-patser+ #39
[    2.896258] Call Trace:
[    2.896259]  [<ffffffff810f689b>] ? dump_page+0x9b/0xd0
[    2.896261]  [<ffffffff810f6999>] bad_page+0xc9/0x120
[    2.896262]  [<ffffffff810f6aab>] free_pages_prepare+0xbb/0x130
[    2.896264]  [<ffffffff810f8379>] free_hot_cold_page+0x49/0x440
[    2.896265]  [<ffffffff810f8ddd>] __free_pages+0x2d/0x40
[    2.896267]  [<ffffffff810f8e33>] free_pages+0x43/0x50
[    2.896268]  [<ffffffff810284f2>] free_init_pages+0x132/0x1c0
[    2.896270]  [<ffffffff81028c83>] mark_rodata_ro+0x143/0x150
[    2.896271]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.896272]  [<ffffffff81ab8d2c>] kernel_init+0x158/0x163
[    2.896274]  [<ffffffff8157d6d4>] kernel_thread_helper+0x4/0x10
[    2.896275]  [<ffffffff81ab8bd4>] ? start_kernel+0x3c3/0x3c3
[    2.896277]  [<ffffffff8157d6d0>] ? gs_change+0xb/0xb
[    2.896278] BUG: Bad page state in process swapper  pfn:018a4
[    2.896397] page:ffffea00000563e0 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.896577] page flags: 0x100000000000000()
[    2.896675] Pid: 1, comm: swapper Tainted: G    B       3.0.0-rc2-patser+ #39
[    2.896675] Call Trace:
[    2.896677]  [<ffffffff810f689b>] ? dump_page+0x9b/0xd0
[    2.896678]  [<ffffffff810f6999>] bad_page+0xc9/0x120
[    2.896680]  [<ffffffff810f6aab>] free_pages_prepare+0xbb/0x130
[    2.896681]  [<ffffffff810f8379>] free_hot_cold_page+0x49/0x440
[    2.896683]  [<ffffffff810f8ddd>] __free_pages+0x2d/0x40
[    2.896684]  [<ffffffff810f8e33>] free_pages+0x43/0x50
[    2.896686]  [<ffffffff810284f2>] free_init_pages+0x132/0x1c0
[    2.896687]  [<ffffffff81028c83>] mark_rodata_ro+0x143/0x150
[    2.896688]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.896690]  [<ffffffff81ab8d2c>] kernel_init+0x158/0x163
[    2.896691]  [<ffffffff8157d6d4>] kernel_thread_helper+0x4/0x10
[    2.896693]  [<ffffffff81ab8bd4>] ? start_kernel+0x3c3/0x3c3
[    2.896694]  [<ffffffff8157d6d0>] ? gs_change+0xb/0xb
[    2.896698] BUG: Bad page state in process swapper  pfn:018ae
[    2.896817] page:ffffea0000056610 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.896997] page flags: 0x100000000000000()
[    2.897095] Pid: 1, comm: swapper Tainted: G    B       3.0.0-rc2-patser+ #39
[    2.897095] Call Trace:
[    2.897097]  [<ffffffff810f689b>] ? dump_page+0x9b/0xd0
[    2.897098]  [<ffffffff810f6999>] bad_page+0xc9/0x120
[    2.897100]  [<ffffffff810f6aab>] free_pages_prepare+0xbb/0x130
[    2.897101]  [<ffffffff810f8379>] free_hot_cold_page+0x49/0x440
[    2.897103]  [<ffffffff810f8ddd>] __free_pages+0x2d/0x40
[    2.897104]  [<ffffffff810f8e33>] free_pages+0x43/0x50
[    2.897106]  [<ffffffff810284f2>] free_init_pages+0x132/0x1c0
[    2.897107]  [<ffffffff81028c83>] mark_rodata_ro+0x143/0x150
[    2.897109]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.897110]  [<ffffffff81ab8d2c>] kernel_init+0x158/0x163
[    2.897111]  [<ffffffff8157d6d4>] kernel_thread_helper+0x4/0x10
[    2.897113]  [<ffffffff81ab8bd4>] ? start_kernel+0x3c3/0x3c3
[    2.897114]  [<ffffffff8157d6d0>] ? gs_change+0xb/0xb
[    2.897116] BUG: Bad page state in process swapper  pfn:018b0
[    2.897234] page:ffffea0000056680 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.897414] page flags: 0x100000000000000()
[    2.897512] Pid: 1, comm: swapper Tainted: G    B       3.0.0-rc2-patser+ #39
[    2.897513] Call Trace:
[    2.897514]  [<ffffffff810f689b>] ? dump_page+0x9b/0xd0
[    2.897516]  [<ffffffff810f6999>] bad_page+0xc9/0x120
[    2.897517]  [<ffffffff810f6aab>] free_pages_prepare+0xbb/0x130
[    2.897519]  [<ffffffff810f8379>] free_hot_cold_page+0x49/0x440
[    2.897520]  [<ffffffff810f8ddd>] __free_pages+0x2d/0x40
[    2.897522]  [<ffffffff810f8e33>] free_pages+0x43/0x50
[    2.897523]  [<ffffffff810284f2>] free_init_pages+0x132/0x1c0
[    2.897524]  [<ffffffff81028c83>] mark_rodata_ro+0x143/0x150
[    2.897526]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.897527]  [<ffffffff81ab8d2c>] kernel_init+0x158/0x163
[    2.897529]  [<ffffffff8157d6d4>] kernel_thread_helper+0x4/0x10
[    2.897530]  [<ffffffff81ab8bd4>] ? start_kernel+0x3c3/0x3c3
[    2.897531]  [<ffffffff8157d6d0>] ? gs_change+0xb/0xb
[    2.897534] BUG: Bad page state in process swapper  pfn:018b4
[    2.897652] page:ffffea0000056760 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.897835] page flags: 0x100000000000000()
[    2.897930] Pid: 1, comm: swapper Tainted: G    B       3.0.0-rc2-patser+ #39
[    2.897931] Call Trace:
[    2.897932]  [<ffffffff810f689b>] ? dump_page+0x9b/0xd0
[    2.897934]  [<ffffffff810f6999>] bad_page+0xc9/0x120
[    2.897935]  [<ffffffff810f6aab>] free_pages_prepare+0xbb/0x130
[    2.897937]  [<ffffffff810f8379>] free_hot_cold_page+0x49/0x440
[    2.897938]  [<ffffffff810f8ddd>] __free_pages+0x2d/0x40
[    2.897940]  [<ffffffff810f8e33>] free_pages+0x43/0x50
[    2.897941]  [<ffffffff810284f2>] free_init_pages+0x132/0x1c0
[    2.897942]  [<ffffffff81028c83>] mark_rodata_ro+0x143/0x150
[    2.897944]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.897945]  [<ffffffff81ab8d2c>] kernel_init+0x158/0x163
[    2.897947]  [<ffffffff8157d6d4>] kernel_thread_helper+0x4/0x10
[    2.897948]  [<ffffffff81ab8bd4>] ? start_kernel+0x3c3/0x3c3
[    2.897950]  [<ffffffff8157d6d0>] ? gs_change+0xb/0xb
[    2.897951] BUG: Bad page state in process swapper  pfn:018b7
[    2.898070] page:ffffea0000056808 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.898250] page flags: 0x100000000000000()
[    2.903882] Pid: 1, comm: swapper Tainted: G    B       3.0.0-rc2-patser+ #39
[    2.903883] Call Trace:
[    2.903885]  [<ffffffff810f689b>] ? dump_page+0x9b/0xd0
[    2.903886]  [<ffffffff810f6999>] bad_page+0xc9/0x120
[    2.903888]  [<ffffffff810f6aab>] free_pages_prepare+0xbb/0x130
[    2.903889]  [<ffffffff810f8379>] free_hot_cold_page+0x49/0x440
[    2.903891]  [<ffffffff810f8ddd>] __free_pages+0x2d/0x40
[    2.903892]  [<ffffffff810f8e33>] free_pages+0x43/0x50
[    2.903894]  [<ffffffff810284f2>] free_init_pages+0x132/0x1c0
[    2.903895]  [<ffffffff81028c83>] mark_rodata_ro+0x143/0x150
[    2.903896]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.903898]  [<ffffffff81ab8d2c>] kernel_init+0x158/0x163
[    2.903899]  [<ffffffff8157d6d4>] kernel_thread_helper+0x4/0x10
[    2.903901]  [<ffffffff81ab8bd4>] ? start_kernel+0x3c3/0x3c3
[    2.903902]  [<ffffffff8157d6d0>] ? gs_change+0xb/0xb
[    2.903903] BUG: Bad page state in process swapper  pfn:018b8
[    2.909529] page:ffffea0000056840 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.915230] page flags: 0x100000000000000()
[    2.920868] Pid: 1, comm: swapper Tainted: G    B       3.0.0-rc2-patser+ #39
[    2.920869] Call Trace:
[    2.920871]  [<ffffffff810f689b>] ? dump_page+0x9b/0xd0
[    2.920872]  [<ffffffff810f6999>] bad_page+0xc9/0x120
[    2.920874]  [<ffffffff810f6aab>] free_pages_prepare+0xbb/0x130
[    2.920875]  [<ffffffff810f8379>] free_hot_cold_page+0x49/0x440
[    2.920877]  [<ffffffff810f8ddd>] __free_pages+0x2d/0x40
[    2.920878]  [<ffffffff810f8e33>] free_pages+0x43/0x50
[    2.920880]  [<ffffffff810284f2>] free_init_pages+0x132/0x1c0
[    2.920881]  [<ffffffff81028c83>] mark_rodata_ro+0x143/0x150
[    2.920882]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.920884]  [<ffffffff81ab8d2c>] kernel_init+0x158/0x163
[    2.920885]  [<ffffffff8157d6d4>] kernel_thread_helper+0x4/0x10
[    2.920887]  [<ffffffff81ab8bd4>] ? start_kernel+0x3c3/0x3c3
[    2.920888]  [<ffffffff8157d6d0>] ? gs_change+0xb/0xb
[    2.920895] BUG: Bad page state in process swapper  pfn:018cc
[    2.926527] page:ffffea0000056ca0 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.932239] page flags: 0x100000000000000()
[    2.937895] Pid: 1, comm: swapper Tainted: G    B       3.0.0-rc2-patser+ #39
[    2.937896] Call Trace:
[    2.937897]  [<ffffffff810f689b>] ? dump_page+0x9b/0xd0
[    2.937898]  [<ffffffff810f6999>] bad_page+0xc9/0x120
[    2.937900]  [<ffffffff810f6aab>] free_pages_prepare+0xbb/0x130
[    2.937902]  [<ffffffff810f8379>] free_hot_cold_page+0x49/0x440
[    2.937903]  [<ffffffff810f8ddd>] __free_pages+0x2d/0x40
[    2.937905]  [<ffffffff810f8e33>] free_pages+0x43/0x50
[    2.937906]  [<ffffffff810284f2>] free_init_pages+0x132/0x1c0
[    2.937907]  [<ffffffff81028c83>] mark_rodata_ro+0x143/0x150
[    2.937909]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.937910]  [<ffffffff81ab8d2c>] kernel_init+0x158/0x163
[    2.937912]  [<ffffffff8157d6d4>] kernel_thread_helper+0x4/0x10
[    2.937913]  [<ffffffff81ab8bd4>] ? start_kernel+0x3c3/0x3c3
[    2.937914]  [<ffffffff8157d6d0>] ? gs_change+0xb/0xb
[    2.937916] BUG: Bad page state in process swapper  pfn:018d0
[    2.943561] page:ffffea0000056d80 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.949287] page flags: 0x100000000000000()
[    2.954949] Pid: 1, comm: swapper Tainted: G    B       3.0.0-rc2-patser+ #39
[    2.954950] Call Trace:
[    2.954951]  [<ffffffff810f689b>] ? dump_page+0x9b/0xd0
[    2.954953]  [<ffffffff810f6999>] bad_page+0xc9/0x120
[    2.954954]  [<ffffffff810f6aab>] free_pages_prepare+0xbb/0x130
[    2.954956]  [<ffffffff810f8379>] free_hot_cold_page+0x49/0x440
[    2.954958]  [<ffffffff810f8ddd>] __free_pages+0x2d/0x40
[    2.954959]  [<ffffffff810f8e33>] free_pages+0x43/0x50
[    2.954960]  [<ffffffff810284f2>] free_init_pages+0x132/0x1c0
[    2.954962]  [<ffffffff81028c83>] mark_rodata_ro+0x143/0x150
[    2.954963]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.954965]  [<ffffffff81ab8d2c>] kernel_init+0x158/0x163
[    2.954966]  [<ffffffff8157d6d4>] kernel_thread_helper+0x4/0x10
[    2.954968]  [<ffffffff81ab8bd4>] ? start_kernel+0x3c3/0x3c3
[    2.954969]  [<ffffffff8157d6d0>] ? gs_change+0xb/0xb
[    2.954975] BUG: Bad page state in process swapper  pfn:018e0
[    2.960627] page:ffffea0000057100 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.966362] page flags: 0x100000000000000()
[    2.972031] Pid: 1, comm: swapper Tainted: G    B       3.0.0-rc2-patser+ #39
[    2.972032] Call Trace:
[    2.972033]  [<ffffffff810f689b>] ? dump_page+0x9b/0xd0
[    2.972035]  [<ffffffff810f6999>] bad_page+0xc9/0x120
[    2.972036]  [<ffffffff810f6aab>] free_pages_prepare+0xbb/0x130
[    2.972038]  [<ffffffff810f8379>] free_hot_cold_page+0x49/0x440
[    2.972039]  [<ffffffff810f8ddd>] __free_pages+0x2d/0x40
[    2.972041]  [<ffffffff810f8e33>] free_pages+0x43/0x50
[    2.972042]  [<ffffffff810284f2>] free_init_pages+0x132/0x1c0
[    2.972044]  [<ffffffff81028c83>] mark_rodata_ro+0x143/0x150
[    2.972046]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.972047]  [<ffffffff81ab8d2c>] kernel_init+0x158/0x163
[    2.972048]  [<ffffffff8157d6d4>] kernel_thread_helper+0x4/0x10
[    2.972050]  [<ffffffff81ab8bd4>] ? start_kernel+0x3c3/0x3c3
[    2.972051]  [<ffffffff8157d6d0>] ? gs_change+0xb/0xb
[    2.972061] BUG: Bad page state in process swapper  pfn:01900
[    2.977722] page:ffffea0000057800 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.983463] page flags: 0x100000000000000()
[    2.989146] Pid: 1, comm: swapper Tainted: G    B       3.0.0-rc2-patser+ #39
[    2.989146] Call Trace:
[    2.989148]  [<ffffffff810f689b>] ? dump_page+0x9b/0xd0
[    2.989149]  [<ffffffff810f6999>] bad_page+0xc9/0x120
[    2.989151]  [<ffffffff810f6aab>] free_pages_prepare+0xbb/0x130
[    2.989152]  [<ffffffff810f8379>] free_hot_cold_page+0x49/0x440
[    2.989154]  [<ffffffff810f8ddd>] __free_pages+0x2d/0x40
[    2.989155]  [<ffffffff810f8e33>] free_pages+0x43/0x50
[    2.989157]  [<ffffffff810284f2>] free_init_pages+0x132/0x1c0
[    2.989158]  [<ffffffff81028c83>] mark_rodata_ro+0x143/0x150
[    2.989160]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.989161]  [<ffffffff81ab8d2c>] kernel_init+0x158/0x163
[    2.989162]  [<ffffffff8157d6d4>] kernel_thread_helper+0x4/0x10
[    2.989164]  [<ffffffff81ab8bd4>] ? start_kernel+0x3c3/0x3c3
[    2.989165]  [<ffffffff8157d6d0>] ? gs_change+0xb/0xb
[    2.989170] BUG: Bad page state in process swapper  pfn:01910
[    2.994842] page:ffffea0000057b80 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.994843] page flags: 0x100000000000000()
[    2.994844] Pid: 1, comm: swapper Tainted: G    B       3.0.0-rc2-patser+ #39
[    2.994845] Call Trace:
[    2.994846]  [<ffffffff810f689b>] ? dump_page+0x9b/0xd0
[    2.994847]  [<ffffffff810f6999>] bad_page+0xc9/0x120
[    2.994849]  [<ffffffff810f6aab>] free_pages_prepare+0xbb/0x130
[    2.994850]  [<ffffffff810f8379>] free_hot_cold_page+0x49/0x440
[    2.994852]  [<ffffffff810f8ddd>] __free_pages+0x2d/0x40
[    2.994853]  [<ffffffff810f8e33>] free_pages+0x43/0x50
[    2.994854]  [<ffffffff810284f2>] free_init_pages+0x132/0x1c0
[    2.994855]  [<ffffffff81028c83>] mark_rodata_ro+0x143/0x150
[    2.994856]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.994858]  [<ffffffff81ab8d2c>] kernel_init+0x158/0x163
[    2.994859]  [<ffffffff8157d6d4>] kernel_thread_helper+0x4/0x10
[    2.994860]  [<ffffffff81ab8bd4>] ? start_kernel+0x3c3/0x3c3
[    2.994861]  [<ffffffff8157d6d0>] ? gs_change+0xb/0xb

