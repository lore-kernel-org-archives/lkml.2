Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab0HEVvt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 17:51:49 -0400
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:41330 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab0HEVvo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 17:51:44 -0400
From: Anjali Kulkarni <anjali@juniper.net>
To: Avi Kivity <avi@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Thu, 5 Aug 2010 14:39:58 -0700
Subject: Re: Freebsd image from Qemu hangs on booting in KVM
Thread-Topic: Freebsd image from Qemu hangs on booting in KVM
Thread-Index: Acs0esE9USofnu+5TxCt4CKr49GvUQAZTtVsAAGw4U0=
Message-ID: <C8807DBE.26044%anjali@juniper.net>
In-Reply-To: <C8807265.2600D%anjali@juniper.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-Entourage/13.3.0.091002
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I could reproduce the problem, and also get the info you asked for:

(qemu) info registers
EAX=00000000 EBX=c27166c0 ECX=00000013 EDX=c0bf85e0
ESI=c057cea0 EDI=00000000 EBP=d35a5ce4 ESP=d35a5ce4
EIP=c09e48ba EFL=00000246 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0028 00000000 ffffffff 00c09300
CS =0020 00000000 ffffffff 00c09b00
SS =0028 00000000 ffffffff 00c09300
DS =0028 00000000 ffffffff 00c09300
FS =0008 c0c6c900 ffffffff 00c09300
GS =003b 00000000 ffffffff 00c0f300
LDT=0050 c0c6c720 00000087 0000e200
TR =0048 c0c6c940 00000067 00008b00
GDT=     c0c6c680 00000097
IDT=     c0c6db40 000007ff
CR0=e005003b CR2=4808e000 CR3=1f54e000 CR4=00000090
DR0=00000000 DR1=00000000 DR2=00000000 DR3=00000000
DR6=ffff0ff0 DR7=00000400
FCW=127f FSW=0000 [ST=0] FTW=00 MXCSR=00000000
FPR0=0000000000000000 0000 FPR1=0000000000000000 0000
FPR2=0000000000000000 0000 FPR3=0000000000000000 0000
FPR4=0000000000000000 0000 FPR5=0000000000000000 0000
FPR6=0000000000000000 0000 FPR7=0000000000000000 0000
XMM00=00000000000000000000000000000000
XMM01=00000000000000000000000000000000
XMM02=00000000000000000000000000000000
XMM03=00000000000000000000000000000000
XMM04=00000000000000000000000000000000
XMM05=00000000000000000000000000000000
XMM06=00000000000000000000000000000000
XMM07=00000000000000000000000000000000
(qemu) x/30i $eip-20
0x00000000c09e48a6:  add    %al,(%eax)
0x00000000c09e48a8:  leave
0x00000000c09e48a9:  ret
0x00000000c09e48aa:  push   %ebp
0x00000000c09e48ab:  mov    %esp,%ebp
0x00000000c09e48ad:  leave
0x00000000c09e48ae:  ret
0x00000000c09e48af:  push   %ebp
0x00000000c09e48b0:  mov    %esp,%ebp
0x00000000c09e48b2:  hlt
0x00000000c09e48b3:  jmp    0xc09e48b2
0x00000000c09e48b5:  push   %ebp
0x00000000c09e48b6:  mov    %esp,%ebp
0x00000000c09e48b8:  sti
0x00000000c09e48b9:  hlt
0x00000000c09e48ba:  leave
0x00000000c09e48bb:  ret
0x00000000c09e48bc:  push   %ebp
0x00000000c09e48bd:  mov    %esp,%ebp
0x00000000c09e48bf:  mov    %cr0,%eax
0x00000000c09e48c2:  or     $0x5002a,%eax
0x00000000c09e48c7:  mov    %eax,%cr0
0x00000000c09e48ca:  movl   0xc0c6c888,%gs
0x00000000c09e48d0:  leave
0x00000000c09e48d1:  ret
0x00000000c09e48d2:  push   %ebp
0x00000000c09e48d3:  mov    %esp,%ebp
0x00000000c09e48d5:  sub    $0x8,%esp
0x00000000c09e48d8:  mov    %ebx,(%esp,1)
0x00000000c09e48db:  mov    %esi,0x4(%esp,1)
(qemu) 



On 8/5/10 1:51 PM, "Anjali Kulkarni" <anjali@juniper.net> wrote:

> Thanks Avi,
> I am trying to reproduce this on another setup, and do not see the issue.
> My understanding is to run KVM + Qemu, I only need to install KVM modules,
> and Qemu does not need to be modified. Is that correct?
> I see 
> 
> [root@ipg-virt01 anjali]# lsmod | grep kvm
> kvm_intel              87016  0
> kvm                   211496  1 kvm_intel
> 
> [root@ipg-virt01 anjali]# modprobe -l 'kvm*'
> /lib/modules/2.6.18-164.el5/kernel/extra/kvm.ko
> /lib/modules/2.6.18-164.el5/kernel/extra/kvm-amd.ko
> /lib/modules/2.6.18-164.el5/kernel/extra/kvm-intel.ko
> 
> And then I run Qemu, as I did, before installing KVM. It should just use
> KVM? Is there any way I can check?
> 
> Btw, when it hangs, I cannot even press any key, so not sure how I can get
> those commands you suggest below..
> 
> Anjali
> 
> On 8/5/10 1:46 AM, "Avi Kivity" <avi@redhat.com> wrote:
> 
>>   On 08/05/2010 05:20 AM, Anjali Kulkarni wrote:
>>> Hi,
>>> 
>>> I have a problem similar to the one seen on this list before - when I boot
>>> my
>>> freebsd based(but modified) image in Qemu with KVM on CentOS, then after
>>> almost booting completely, the image hangs - just before the login prompt is
>>> seen. If I do not have KVM ie plain CenOS with Qemu, then this issue does
>>> not
>>> occur. Has anyone seen this before and any ideas how to debug this?
>> 
>> First step is to issue 'info registers' and 'x/30i $eip-20' from the
>> monitor when it hangs (qemu -monitor stdio makes cut'n'paste easier).
> 

