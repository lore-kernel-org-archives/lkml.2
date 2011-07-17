Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab1GQNff (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 09:35:35 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:42563 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753796Ab1GQNfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 09:35:32 -0400
Subject: Re: Imon module Oops and kernel hang
From: Andy Walls <awalls@md.metrocast.net>
To: Chris W <lkml@psychogeeks.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>
Date: Sun, 17 Jul 2011 09:36:05 -0400
In-Reply-To: <4E223D00.1040505@psychogeeks.com>
References: <4E1B978C.2030407@psychogeeks.com>
	 <20110712080309.d538fec9.rdunlap@xenotime.net>
	 <7B814F02-408C-434F-B813-8630B60914DA@wilsonet.com>
	 <4E1CCC26.4060506@psychogeeks.com>
	 <1B380AD0-FE0D-47DF-B2C3-605253C9C783@wilsonet.com>
	 <4E1D3045.7050507@psychogeeks.com>
	 <2E869B1F-D476-4645-BE26-B1DD77DF1735@wilsonet.com>
	 <4E1E574E.9010403@psychogeeks.com>
	 <1310863402.7895.6.camel@palomino.walls.org>
	 <4E223D00.1040505@psychogeeks.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1310909766.2276.10.camel@palomino.walls.org>
Mime-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.4.6813,1.0.211,0.0.0000
 definitions=2011-07-17_05:2011-07-16,2011-07-17,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=2
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1012030000 definitions=main-1107170048
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-17 at 11:38 +1000, Chris W wrote:
> On 17/07/11 10:43, Andy Walls wrote:
> > This is an obviously repeatable NULL pointer dereference in
> > rc_g_keycode_from_table().  The faulting line of code in both cases
> > disasembles to:
> > 
> >   1e:	8b 80 dc 00 00 00    	mov    0xdc(%eax),%eax
> > 
> > %eax obviously holds the value 0 (NULL).  But I'm having a hard time
> > telling to where exactly that line of assembly corresponds in
> > rc_g_keycode_from_table().  And I can't tell from the source which data
> > structure has something at offset 0xdc that gets derefernced early:
> > struct rc_dev or struct rc_map.
> > 
> > Could you provide the output of 
> > 
> > $ locate rc-core.ko
> > $ objdump -d -l /blah/blah/drivers/media/rc/rc-core.ko 
> > 
> > for the rc_g_keycode_from_table() function?
> 
> 
> I have a few copies lying about now.

> This is from my current running kernel
> /lib/modules/2.6.38-gentoo-r6/kernel/drivers/media/rc/rc-core.ko
> 
> and the partial objdump and corresponding oops/crash output:

Thanks.


> 00000450 <rc_g_keycode_from_table>:
> rc_g_keycode_from_table():
>      450:	55                   	push   %ebp
>      451:	89 e5                	mov    %esp,%ebp
>      453:	57                   	push   %edi
>      454:	56                   	push   %esi
>      455:	53                   	push   %ebx
>      456:	83 ec 24             	sub    $0x24,%esp

Store the (struct rc_dev *) "dev" input argument on the stack
>      459:	89 45 e8             	mov    %eax,-0x18(%ebp)

local_irq_save(flags):
>      45c:	9c                   	pushf
>      45d:	8f 45 ec             	popl   -0x14(%ebp)
>      460:	fa                   	cli

preempt_disable():
>      461:	89 e0                	mov    %esp,%eax
>      463:	25 00 e0 ff ff       	and    $0xffffe000,%eax
>      468:	ff 40 14             	incl   0x14(%eax)

Move (struct rc_dev *) dev into %eax
>      46b:	8b 45 e8             	mov    -0x18(%ebp),%eax

&dev->rc_map->lock 
>      46e:	8b 80 d4 00 00 00    	mov    0xd4(%eax),%eax

But that's where the Oops always happens, so the "dev" input argument to
the function is NULL.

Someone familiar with the driver/media/rc/imon.c file needs to figure
out how rc_g_keycode_from_table() can be called with a NULL first
argument: ictx->rdev is NULL when
rc_g_keycode_from_table(ictx->rdev,...) is called.

There might be some race at driver initialization, given that at first
look ictx-rdev being NULL seems impossible.  Your stack backtraces
always indicate some sort of IRQ context, so maybe that matters.

Regards,
Andy

>      474:	89 c3                	mov    %eax,%ebx
>      476:	89 45 f0             	mov    %eax,-0x10(%ebp)
>      479:	4b                   	dec    %ebx
>      47a:	78 38                	js     4b4 <rc_g_keycode_from_table+0x64>
>      47c:	8b 45 e8             	mov    -0x18(%ebp),%eax
>      47f:	31 c9                	xor    %ecx,%ecx
>      481:	8b b0 cc 00 00 00    	mov    0xcc(%eax),%esi
>      487:	eb 0e                	jmp    497 <rc_g_keycode_from_table+0x47>
>      489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
>      490:	8d 48 01             	lea    0x1(%eax),%ecx
>      493:	39 d9                	cmp    %ebx,%ecx
>      495:	7f 1d                	jg     4b4 <rc_g_keycode_from_table+0x64>
>      497:	8d 04 0b             	lea    (%ebx,%ecx,1),%eax
>      49a:	89 c7                	mov    %eax,%edi
>      49c:	c1 ef 1f             	shr    $0x1f,%edi
>      49f:	8d 04 07             	lea    (%edi,%eax,1),%eax
>      4a2:	d1 f8                	sar    %eax
>      4a4:	8d 3c c6             	lea    (%esi,%eax,8),%edi
>      4a7:	3b 17                	cmp    (%edi),%edx
>      4a9:	77 e5                	ja     490 <rc_g_keycode_from_table+0x40>
>      4ab:	73 3b                	jae    4e8 <rc_g_keycode_from_table+0x98>
>      4ad:	8d 58 ff             	lea    -0x1(%eax),%ebx
>      4b0:	39 d9                	cmp    %ebx,%ecx
>      4b2:	7e e3                	jle    497 <rc_g_keycode_from_table+0x47>
>      4b4:	31 db                	xor    %ebx,%ebx
>      4b6:	ff 75 ec             	pushl  -0x14(%ebp)
>      4b9:	9d                   	popf
>      4ba:	89 e0                	mov    %esp,%eax
>      4bc:	25 00 e0 ff ff       	and    $0xffffe000,%eax
>      4c1:	ff 48 14             	decl   0x14(%eax)
>      4c4:	8b 40 08             	mov    0x8(%eax),%eax
>      4c7:	a8 08                	test   $0x8,%al
>      4c9:	75 52                	jne    51d <rc_g_keycode_from_table+0xcd>
>      4cb:	85 db                	test   %ebx,%ebx
>      4cd:	74 0a                	je     4d9 <rc_g_keycode_from_table+0x89>
>      4cf:	8b 3d 00 00 00 00    	mov    0x0,%edi
>      4d5:	85 ff                	test   %edi,%edi
>      4d7:	7f 19                	jg     4f2 <rc_g_keycode_from_table+0xa2>
>      4d9:	83 c4 24             	add    $0x24,%esp
>      4dc:	89 d8                	mov    %ebx,%eax
>      4de:	5b                   	pop    %ebx
>      4df:	5e                   	pop    %esi
>      4e0:	5f                   	pop    %edi
>      4e1:	c9                   	leave
>      4e2:	c3                   	ret
>      4e3:	90                   	nop
>      4e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
>      4e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
>      4eb:	73 c7                	jae    4b4 <rc_g_keycode_from_table+0x64>
>      4ed:	8b 5f 04             	mov    0x4(%edi),%ebx
>      4f0:	eb c4                	jmp    4b6 <rc_g_keycode_from_table+0x66>
>      4f2:	89 54 24 0c          	mov    %edx,0xc(%esp)
>      4f6:	8b 55 e8             	mov    -0x18(%ebp),%edx
>      4f9:	89 5c 24 10          	mov    %ebx,0x10(%esp)
>      4fd:	8b 82 b4 00 00 00    	mov    0xb4(%edx),%eax
>      503:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
>      50a:	00
>      50b:	c7 04 24 bc 00 00 00 	movl   $0xbc,(%esp)
>      512:	89 44 24 08          	mov    %eax,0x8(%esp)
>      516:	e8 fc ff ff ff       	call   517 <rc_g_keycode_from_table+0xc7>
>      51b:	eb bc                	jmp    4d9 <rc_g_keycode_from_table+0x89>
>      51d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
>      520:	e8 fc ff ff ff       	call   521 <rc_g_keycode_from_table+0xd1>
>      525:	8b 55 e4             	mov    -0x1c(%ebp),%edx
>      528:	eb a1                	jmp    4cb <rc_g_keycode_from_table+0x7b>
>      52a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
> chrisw@newton ~ $
> 
> 
> 
> cat /var/log/kepler-netconsole.log
> Jul 17 11:34:56 kepler BUG: unable to handle kernel
> Jul 17 11:34:56 kepler NULL pointer dereference
> Jul 17 11:34:56 kepler at 000000d4
> Jul 17 11:34:56 kepler IP:
> Jul 17 11:34:56 kepler [<f881446e>] rc_g_keycode_from_table+0x1e/0xe0
> [rc_core]
> Jul 17 11:34:56 kepler *pde = 00000000
> Jul 17 11:34:56 kepler
> Jul 17 11:34:56 kepler Oops: 0000 [#1]
> Jul 17 11:34:56 kepler PREEMPT
> Jul 17 11:34:56 kepler
> Jul 17 11:34:56 kepler last sysfs file:
> /sys/devices/pci0000:00/0000:00:10.2/usb4/4-2/4-2:1.0/input/input7/name
> Jul 17 11:34:56 kepler Modules linked in:
> Jul 17 11:34:56 kepler imon(+)
> Jul 17 11:34:56 kepler netconsole
> Jul 17 11:34:56 kepler asb100
> Jul 17 11:34:56 kepler hwmon_vid
> Jul 17 11:34:56 kepler nvidia(P)
> Jul 17 11:34:56 kepler cx22702
> Jul 17 11:34:56 kepler dvb_pll
> Jul 17 11:34:56 kepler mt352
> Jul 17 11:34:56 kepler cx88_dvb
> Jul 17 11:34:56 kepler cx88_vp3054_i2c
> Jul 17 11:34:56 kepler rc_winfast
> Jul 17 11:34:56 kepler videobuf_dvb
> Jul 17 11:34:56 kepler rc_rc6_mce
> Jul 17 11:34:56 kepler cx8800
> Jul 17 11:34:56 kepler cx8802
> Jul 17 11:34:56 kepler snd_via82xx
> Jul 17 11:34:56 kepler cx88xx
> Jul 17 11:34:56 kepler mceusb
> Jul 17 11:34:56 kepler b44
> Jul 17 11:34:56 kepler i2c_algo_bit
> Jul 17 11:34:56 kepler tveeprom
> Jul 17 11:34:56 kepler snd_ac97_codec
> Jul 17 11:34:56 kepler ir_rc6_decoder
> Jul 17 11:34:56 kepler btcx_risc
> Jul 17 11:34:56 kepler ac97_bus
> Jul 17 11:34:56 kepler ssb
> Jul 17 11:34:56 kepler snd_mpu401_uart
> Jul 17 11:34:56 kepler videobuf_dma_sg
> Jul 17 11:34:56 kepler videobuf_core
> Jul 17 11:34:56 kepler rc_core
> Jul 17 11:34:56 kepler snd_rawmidi
> Jul 17 11:34:56 kepler i2c_viapro
> Jul 17 11:34:56 kepler mii
> Jul 17 11:34:56 kepler
> Jul 17 11:34:56 kepler
> Jul 17 11:34:56 kepler Pid: 2841, comm: usb_id Tainted: P
> 2.6.38-gentoo-r6 #11
> Jul 17 11:34:56 kepler
> Jul 17 11:34:56 kepler System Manufacturer System Name
> Jul 17 11:34:56 kepler /
> Jul 17 11:34:56 kepler A7V8X
> Jul 17 11:34:56 kepler
> Jul 17 11:34:56 kepler EIP: 0060:[<f881446e>] EFLAGS: 00010002 CPU: 0
> Jul 17 11:34:56 kepler EIP is at rc_g_keycode_from_table+0x1e/0xe0 [rc_core]
> Jul 17 11:34:56 kepler EAX: 00000000 EBX: f5e0f400 ECX: 00000008 EDX:
> 00000000
> Jul 17 11:34:56 kepler ESI: 00000000 EDI: 00000000 EBP: f7007e60 ESP:
> f7007e30
> Jul 17 11:34:56 kepler DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> Jul 17 11:34:56 kepler Process usb_id (pid: 2841, ti=f7006000
> task=f68bf4a0 task.ti=f7036000)
> Jul 17 11:34:56 kepler Stack:
> Jul 17 11:34:56 kepler 00000001
> Jul 17 11:34:56 kepler f7007e48
> Jul 17 11:34:56 kepler c101e63e
> Jul 17 11:34:56 kepler f71b0a80
> Jul 17 11:34:56 kepler 00000097
> Jul 17 11:34:56 kepler 001b0a80
> Jul 17 11:34:56 kepler 00000000
> Jul 17 11:34:56 kepler 00000086
> Jul 17 11:34:56 kepler
> Jul 17 11:34:56 kepler 00000004
> Jul 17 11:34:56 kepler f5e0f400
> Jul 17 11:34:56 kepler 00000000
> Jul 17 11:34:56 kepler 00000000
> Jul 17 11:34:56 kepler f7007e70
> Jul 17 11:34:56 kepler f87ea59c
> Jul 17 11:34:56 kepler f5e0f400
> Jul 17 11:34:56 kepler f5e0f441
> Jul 17 11:34:56 kepler
> Jul 17 11:34:56 kepler f7007ef4
> Jul 17 11:34:56 kepler f87ea6dc
> Jul 17 11:34:56 kepler c132d67f
> Jul 17 11:34:56 kepler 00000004
> Jul 17 11:34:56 kepler 00000002
> Jul 17 11:34:56 kepler fa6de004
> Jul 17 11:34:56 kepler f6a7e008
> Jul 17 11:34:56 kepler f6a7e000
> Jul 17 11:34:56 kepler
> Jul 17 11:34:56 kepler Call Trace:
> Jul 17 11:34:56 kepler [<c101e63e>] ? T.855+0x2e/0x50
> Jul 17 11:34:56 kepler [<f87ea59c>] imon_remote_key_lookup+0x1c/0x70 [imon]
> Jul 17 11:34:56 kepler [<f87ea6dc>] imon_incoming_packet+0x5c/0xe10 [imon]
> Jul 17 11:34:56 kepler [<c132d67f>] ? pci_read+0x2f/0x40
> Jul 17 11:34:56 kepler [<fa6de004>] ? _nv004358rm+0x24/0x70 [nvidia]
> Jul 17 11:34:56 kepler [<fa6de030>] ? _nv004358rm+0x50/0x70 [nvidia]
> Jul 17 11:34:56 kepler [<fa6de004>] ? _nv004358rm+0x24/0x70 [nvidia]
> Jul 17 11:34:56 kepler [<fa6de030>] ? _nv004358rm+0x50/0x70 [nvidia]
> Jul 17 11:34:56 kepler [<fa6de0b5>] ? _nv004356rm+0x28/0x43 [nvidia]
> Jul 17 11:34:56 kepler [<f87eb563>] usb_rx_callback_intf0+0x63/0x70 [imon]
> Jul 17 11:34:56 kepler [<c12853bc>] ? uhci_free_urb_priv+0x9c/0xb0
> Jul 17 11:34:56 kepler [<c126e1c8>] usb_hcd_giveback_urb+0x48/0xb0
> Jul 17 11:34:56 kepler [<c128545e>] uhci_giveback_urb+0x8e/0x220
> Jul 17 11:34:56 kepler [<fa6de187>] ? _nv004352rm+0x19/0x1d [nvidia]
> Jul 17 11:34:56 kepler [<c1285a86>] uhci_scan_schedule+0x396/0x9a0
> Jul 17 11:34:56 kepler [<c1287e41>] uhci_irq+0x91/0x170
> Jul 17 11:34:56 kepler [<c126d961>] usb_hcd_irq+0x21/0x60
> Jul 17 11:34:56 kepler [<c10501ee>] handle_IRQ_event+0x2e/0xc0
> Jul 17 11:34:56 kepler [<c10166ad>] ? ack_apic_level+0x3d/0x100
> Jul 17 11:34:56 kepler [<c1052180>] ? handle_fasteoi_irq+0x0/0xf0
> Jul 17 11:34:56 kepler [<c10521df>] handle_fasteoi_irq+0x5f/0xf0
> Jul 17 11:34:56 kepler <IRQ>
> Jul 17 11:34:56 kepler
> Jul 17 11:34:56 kepler [<c100430a>] ? do_IRQ+0x3a/0xb0
> Jul 17 11:34:56 kepler [<c1003169>] ? common_interrupt+0x29/0x30
> Jul 17 11:34:56 kepler [<c106fbb0>] ? vma_prio_tree_remove+0x0/0x100
> Jul 17 11:34:56 kepler [<c1078b16>] ? __remove_shared_vm_struct+0x36/0x50
> Jul 17 11:34:56 kepler [<c1078b4e>] ? unlink_file_vma+0x1e/0x40
> Jul 17 11:34:56 kepler [<c1076cc3>] ? free_pgtables+0x43/0x90
> Jul 17 11:34:56 kepler [<c1078840>] ? exit_mmap+0xe0/0x160
> Jul 17 11:34:56 kepler [<c1021366>] ? mmput+0x26/0xb0
> Jul 17 11:34:56 kepler [<c1024ed0>] ? exit_mm+0xe0/0x100
> Jul 17 11:34:56 kepler [<c1026ad5>] ? do_exit+0x5a5/0x680
> Jul 17 11:34:56 kepler [<c1088530>] ? vfs_write+0x100/0x140
> Jul 17 11:34:56 kepler [<c1087a10>] ? do_sync_write+0x0/0xd0
> Jul 17 11:34:56 kepler [<c1026bdc>] ? do_group_exit+0x2c/0x90
> Jul 17 11:34:56 kepler [<c1026c53>] ? sys_exit_group+0x13/0x20
> Jul 17 11:34:56 kepler [<c1002c50>] ? sysenter_do_call+0x12/0x26
> Jul 17 11:34:56 kepler Code:
> Jul 17 11:34:56 kepler ff
> Jul 17 11:34:56 kepler ff
> Jul 17 11:34:56 kepler 8d
> Jul 17 11:34:56 kepler 74
> Jul 17 11:34:56 kepler 26
> Jul 17 11:34:56 kepler 00
> Jul 17 11:34:56 kepler 8d
> Jul 17 11:34:56 kepler bc
> Jul 17 11:34:56 kepler 27
> Jul 17 11:34:56 kepler 00
> Jul 17 11:34:56 kepler 00
> Jul 17 11:34:56 kepler 00
> Jul 17 11:34:56 kepler 00
> Jul 17 11:34:56 kepler 55
> Jul 17 11:34:56 kepler 89
> Jul 17 11:34:56 kepler e5
> Jul 17 11:34:56 kepler 57
> Jul 17 11:34:56 kepler 56
> Jul 17 11:34:56 kepler 53
> Jul 17 11:34:56 kepler 83
> Jul 17 11:34:56 kepler ec
> Jul 17 11:34:56 kepler 24
> Jul 17 11:34:56 kepler 89
> Jul 17 11:34:56 kepler 45
> Jul 17 11:34:56 kepler e8
> Jul 17 11:34:56 kepler 9c
> Jul 17 11:34:56 kepler 8f
> Jul 17 11:34:56 kepler 45
> Jul 17 11:34:56 kepler ec
> Jul 17 11:34:56 kepler fa
> Jul 17 11:34:56 kepler 89
> Jul 17 11:34:56 kepler e0
> Jul 17 11:34:56 kepler 25
> Jul 17 11:34:56 kepler 00
> Jul 17 11:34:56 kepler e0
> Jul 17 11:34:56 kepler ff
> Jul 17 11:34:56 kepler ff
> Jul 17 11:34:56 kepler ff
> Jul 17 11:34:56 kepler 40
> Jul 17 11:34:56 kepler 14
> Jul 17 11:34:56 kepler 8b
> Jul 17 11:34:56 kepler 45
> Jul 17 11:34:56 kepler e8
> Jul 17 11:34:56 kepler syslog-ng[2255]: Error processing log message: <8b>
> Jul 17 11:34:56 kepler 80
> Jul 17 11:34:56 kepler d4
> Jul 17 11:34:56 kepler 00
> Jul 17 11:34:56 kepler 00
> Jul 17 11:34:56 kepler 00
> Jul 17 11:34:56 kepler 89
> Jul 17 11:34:56 kepler c3
> Jul 17 11:34:56 kepler 89
> Jul 17 11:34:56 kepler 45
> Jul 17 11:34:56 kepler f0
> Jul 17 11:34:56 kepler 4b
> Jul 17 11:34:56 kepler 78
> Jul 17 11:34:56 kepler 38
> Jul 17 11:34:56 kepler 8b
> Jul 17 11:34:56 kepler 45
> Jul 17 11:34:56 kepler e8
> Jul 17 11:34:56 kepler 31
> Jul 17 11:34:56 kepler c9
> Jul 17 11:34:56 kepler 8b
> Jul 17 11:34:56 kepler b0
> Jul 17 11:34:56 kepler
> Jul 17 11:34:56 kepler EIP: [<f881446e>]
> Jul 17 11:34:56 kepler rc_g_keycode_from_table+0x1e/0xe0 [rc_core]
> Jul 17 11:34:56 kepler SS:ESP 0068:f7007e30
> Jul 17 11:34:56 kepler CR2: 00000000000000d4
> Jul 17 11:34:56 kepler ---[ end trace ce1de56c8de1850d ]---
> Jul 17 11:34:56 kepler Kernel panic - not syncing: Fatal exception in
> interrupt
> Jul 17 11:34:56 kepler Pid: 2841, comm: usb_id Tainted: P      D
> 2.6.38-gentoo-r6 #11
> Jul 17 11:34:56 kepler Call Trace:
> Jul 17 11:34:56 kepler [<c13c7c78>] ? panic+0x61/0x145
> Jul 17 11:34:56 kepler [<c10057f0>] ? oops_begin+0x0/0x40
> Jul 17 11:34:56 kepler [<c1018dce>] ? no_context+0xbe/0x150
> Jul 17 11:34:56 kepler [<c1018eef>] ? __bad_area_nosemaphore+0x8f/0x130
> Jul 17 11:34:56 kepler [<c1018fa2>] ? bad_area_nosemaphore+0x12/0x20
> Jul 17 11:34:56 kepler [<c101936b>] ? do_page_fault+0x25b/0x420
> Jul 17 11:34:56 kepler [<c1286c66>] ? uhci_alloc_td+0x16/0x40
> Jul 17 11:34:56 kepler [<c1286c66>] ? uhci_alloc_td+0x16/0x40
> Jul 17 11:34:56 kepler [<c1286fef>] ? uhci_submit_common+0x22f/0x340
> Jul 17 11:34:56 kepler [<c1019110>] ? do_page_fault+0x0/0x420
> Jul 17 11:34:56 kepler [<c13ca0b4>] ? error_code+0x58/0x60
> Jul 17 11:34:56 kepler [<c1019110>] ? do_page_fault+0x0/0x420
> Jul 17 11:34:56 kepler [<f881446e>] ? rc_g_keycode_from_table+0x1e/0xe0
> [rc_core]
> Jul 17 11:34:56 kepler [<c101e63e>] ? T.855+0x2e/0x50
> Jul 17 11:34:56 kepler [<f87ea59c>] ? imon_remote_key_lookup+0x1c/0x70
> [imon]
> Jul 17 11:34:56 kepler [<f87ea6dc>] ? imon_incoming_packet+0x5c/0xe10 [imon]
> Jul 17 11:34:56 kepler [<c132d67f>] ? pci_read+0x2f/0x40
> Jul 17 11:34:56 kepler [<fa6de004>] ? _nv004358rm+0x24/0x70 [nvidia]
> Jul 17 11:34:56 kepler [<fa6de030>] ? _nv004358rm+0x50/0x70 [nvidia]
> Jul 17 11:34:56 kepler [<fa6de004>] ? _nv004358rm+0x24/0x70 [nvidia]
> Jul 17 11:34:56 kepler [<fa6de030>] ? _nv004358rm+0x50/0x70 [nvidia]
> Jul 17 11:34:56 kepler [<fa6de0b5>] ? _nv004356rm+0x28/0x43 [nvidia]
> Jul 17 11:34:56 kepler [<f87eb563>] ? usb_rx_callback_intf0+0x63/0x70 [imon]
> Jul 17 11:34:56 kepler [<c12853bc>] ? uhci_free_urb_priv+0x9c/0xb0
> Jul 17 11:34:56 kepler [<c126e1c8>] ? usb_hcd_giveback_urb+0x48/0xb0
> Jul 17 11:34:56 kepler [<c128545e>] ? uhci_giveback_urb+0x8e/0x220
> Jul 17 11:34:56 kepler [<fa6de187>] ? _nv004352rm+0x19/0x1d [nvidia]
> Jul 17 11:34:56 kepler [<c1285a86>] ? uhci_scan_schedule+0x396/0x9a0
> Jul 17 11:34:56 kepler [<c1287e41>] ? uhci_irq+0x91/0x170
> Jul 17 11:34:56 kepler [<c126d961>] ? usb_hcd_irq+0x21/0x60
> Jul 17 11:34:56 kepler [<c10501ee>] ? handle_IRQ_event+0x2e/0xc0
> Jul 17 11:34:56 kepler [<c10166ad>] ? ack_apic_level+0x3d/0x100
> Jul 17 11:34:56 kepler [<c1052180>] ? handle_fasteoi_irq+0x0/0xf0
> Jul 17 11:34:56 kepler [<c10521df>] ? handle_fasteoi_irq+0x5f/0xf0
> Jul 17 11:34:56 kepler <IRQ>
> Jul 17 11:34:56 kepler [<c100430a>] ? do_IRQ+0x3a/0xb0
> Jul 17 11:34:56 kepler [<c1003169>] ? common_interrupt+0x29/0x30
> Jul 17 11:34:56 kepler [<c106fbb0>] ? vma_prio_tree_remove+0x0/0x100
> Jul 17 11:34:56 kepler [<c1078b16>] ? __remove_shared_vm_struct+0x36/0x50
> Jul 17 11:34:56 kepler [<c1078b4e>] ? unlink_file_vma+0x1e/0x40
> Jul 17 11:34:56 kepler [<c1076cc3>] ? free_pgtables+0x43/0x90
> Jul 17 11:34:56 kepler [<c1078840>] ? exit_mmap+0xe0/0x160
> Jul 17 11:34:56 kepler [<c1021366>] ? mmput+0x26/0xb0
> Jul 17 11:34:56 kepler [<c1024ed0>] ? exit_mm+0xe0/0x100
> Jul 17 11:34:56 kepler [<c1026ad5>] ? do_exit+0x5a5/0x680
> Jul 17 11:34:56 kepler [<c1088530>] ? vfs_write+0x100/0x140
> Jul 17 11:34:56 kepler [<c1087a10>] ? do_sync_write+0x0/0xd0
> Jul 17 11:34:56 kepler [<c1026bdc>] ? do_group_exit+0x2c/0x90
> Jul 17 11:34:56 kepler [<c1026c53>] ? sys_exit_group+0x13/0x20
> Jul 17 11:34:56 kepler [<c1002c50>] ? sysenter_do_call+0x12/0x26
> n
> 


