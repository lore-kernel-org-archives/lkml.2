Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab1LGNUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 08:20:47 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:57803 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755452Ab1LGNUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 08:20:46 -0500
X-Nat-Received: from [202.181.97.72]:63879 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1323264044.16173
To: linux-kernel@vger.kernel.org
Subject: [3.2-rc4 x86] (Compiler bug?) Uninitialized variable in ioapic_read_entry()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201112072220.HDB13093.HSFFLVOMtQJOFO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 7 Dec 2011 22:20:43 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 07122011 #5946426, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Regarding commit e57253a8 "x86, ioapic: Restore the mask bit correctly in
eoi_ioapic_irq()", I got below warning:

  arch/x86/kernel/apic/io_apic.c: In function 'ioapic_read_entry':
  arch/x86/kernel/apic/io_apic.c:385: warning: 'eu' is used uninitialized in this function

 369: union entry_union {
 370:   struct { u32 w1, w2; };
 371:   struct IO_APIC_route_entry entry;
 372: };
 373:
 374: static struct IO_APIC_route_entry __ioapic_read_entry(int apic, int pin)
 375: {
 376:   union entry_union eu;
 377:
 378:   eu.w1 = io_apic_read(apic, 0x10 + 2 * pin);
 379:   eu.w2 = io_apic_read(apic, 0x11 + 2 * pin);
 380:   return eu.entry;
 381: }
 382:
 383: static struct IO_APIC_route_entry ioapic_read_entry(int apic, int pin)
 384: {
 385:   union entry_union eu;
 386:   unsigned long flags;
 387:   raw_spin_lock_irqsave(&ioapic_lock, flags);
 388:   eu.entry = __ioapic_read_entry(apic, pin);
 389:   raw_spin_unlock_irqrestore(&ioapic_lock, flags);
 390:   return eu.entry;
 391: }

I compared using several gcc versions.
It turned out that only gcc 4.4 shows this warning.

--- gcc (SUSE Linux) 4.6.2 in OpenSUSE 12.1 ---
  CC      arch/x86/kernel/apic/io_apic.o
--- gcc (GCC) 4.5.1 20100924 (Red Hat 4.5.1-4) on Fedora 14 ---
  CC      arch/x86/kernel/apic/io_apic.o
--- gcc (Debian 4.4.5-8) 4.4.5 on Debian Squeeze ---
  CC      arch/x86/kernel/apic/io_apic.o
arch/x86/kernel/apic/io_apic.c: In function ‘ioapic_read_entry’:
arch/x86/kernel/apic/io_apic.c:385: warning: ‘eu’ is used uninitialized in this function
--- gcc (Ubuntu 4.4.3-4ubuntu5) 4.4.3 on Ubuntu 10.04 ---
  CC      arch/x86/kernel/apic/io_apic.o
arch/x86/kernel/apic/io_apic.c: In function ‘ioapic_read_entry’:
arch/x86/kernel/apic/io_apic.c:385: warning: ‘eu’ is used uninitialized in this function
--- gcc (Debian 4.3.2-1.1) 4.3.2 on Debian Lenny ---
  CC      arch/x86/kernel/apic/io_apic.o
--- gcc (GCC) 4.2.4 (Ubuntu 4.2.4-1ubuntu4) on Ubuntu 8.04 ---
  CC      arch/x86/kernel/apic/io_apic.o
--- gcc (GCC) 4.1.2 20080704 (Red Hat 4.1.2-51) on CentOS 5 ---
  CC      arch/x86/kernel/apic/io_apic.o
--- gcc (GCC) 3.3.5 (Debian 1:3.3.5-13) on Debian Sarge ---
  CC      arch/x86/kernel/apic/io_apic.o
arch/x86/kernel/apic/io_apic.c: In function `setup_ir_ioapic_entry':
arch/x86/kernel/apic/io_apic.c:1354: warning: unsigned int format, different type arg (arg 11)

It turned out that gcc 4.3 and 4.5 do not inline __ioapic_read_entry() whereas
gcc 4.4 inlines __ioapic_read_entry().

--- gcc (Debian 4.3.2-1.1) 4.3.2 on Debian Lenny ---

00000040 <__ioapic_read_entry>:
      40:       56                      push   %esi
      41:       53                      push   %ebx
      42:       8d 58 05                lea    0x5(%eax),%ebx
      45:       8d 04 80                lea    (%eax,%eax,4),%eax
      48:       8b 0c c5 ac 08 00 00    mov    0x8ac(,%eax,8),%ecx
      4f:       c1 e3 0c                shl    $0xc,%ebx
      52:       8d 74 12 10             lea    0x10(%edx,%edx,1),%esi
      56:       81 e1 ff 0f 00 00       and    $0xfff,%ecx
      5c:       03 0d 00 00 00 00       add    0x0,%ecx
      62:       29 d9                   sub    %ebx,%ecx
      64:       89 31                   mov    %esi,(%ecx)
      66:       83 c1 10                add    $0x10,%ecx
      69:       8b 09                   mov    (%ecx),%ecx
      6b:       8b 04 c5 ac 08 00 00    mov    0x8ac(,%eax,8),%eax
      72:       8d 54 12 11             lea    0x11(%edx,%edx,1),%edx
      76:       25 ff 0f 00 00          and    $0xfff,%eax
      7b:       03 05 00 00 00 00       add    0x0,%eax
      81:       29 d8                   sub    %ebx,%eax
      83:       89 10                   mov    %edx,(%eax)
      85:       83 c0 10                add    $0x10,%eax
      88:       8b 10                   mov    (%eax),%edx
      8a:       89 c8                   mov    %ecx,%eax
      8c:       5b                      pop    %ebx
      8d:       5e                      pop    %esi
      8e:       c3                      ret
      8f:       90                      nop

000004e0 <ioapic_read_entry>:
     4e0:       83 ec 0c                sub    $0xc,%esp
     4e3:       89 74 24 04             mov    %esi,0x4(%esp)
     4e7:       89 c6                   mov    %eax,%esi
     4e9:       b8 4e 08 00 00          mov    $0x84e,%eax
     4ee:       89 1c 24                mov    %ebx,(%esp)
     4f1:       89 d3                   mov    %edx,%ebx
     4f3:       89 7c 24 08             mov    %edi,0x8(%esp)
     4f7:       e8 fc ff ff ff          call   4f8 <ioapic_read_entry+0x18>
     4fc:       89 da                   mov    %ebx,%edx
     4fe:       89 c7                   mov    %eax,%edi
     500:       89 f0                   mov    %esi,%eax
     502:       e8 39 fb ff ff          call   40 <__ioapic_read_entry>
     507:       89 c6                   mov    %eax,%esi
     509:       89 d3                   mov    %edx,%ebx
     50b:       b8 4e 08 00 00          mov    $0x84e,%eax
     510:       89 fa                   mov    %edi,%edx
     512:       e8 fc ff ff ff          call   513 <ioapic_read_entry+0x33>
     517:       89 f0                   mov    %esi,%eax
     519:       89 da                   mov    %ebx,%edx
     51b:       8b 1c 24                mov    (%esp),%ebx
     51e:       8b 74 24 04             mov    0x4(%esp),%esi
     522:       8b 7c 24 08             mov    0x8(%esp),%edi
     526:       83 c4 0c                add    $0xc,%esp
     529:       c3                      ret
     52a:       8d b6 00 00 00 00       lea    0x0(%esi),%esi

--- gcc (Ubuntu 4.4.3-4ubuntu5) 4.4.3 on Ubuntu 10.04 ---

00001d60 <ioapic_read_entry>:
    1d60:       83 ec 0c                sub    $0xc,%esp
    1d63:       89 1c 24                mov    %ebx,(%esp)
    1d66:       89 c3                   mov    %eax,%ebx
    1d68:       b8 4e 08 00 00          mov    $0x84e,%eax
    1d6d:       89 74 24 04             mov    %esi,0x4(%esp)
    1d71:       89 7c 24 08             mov    %edi,0x8(%esp)
    1d75:       89 d7                   mov    %edx,%edi
    1d77:       e8 fc ff ff ff          call   1d78 <ioapic_read_entry+0x18>
    1d7c:       8d 53 05                lea    0x5(%ebx),%edx
    1d7f:       8d 1c 9b                lea    (%ebx,%ebx,4),%ebx
    1d82:       8b 0c dd ac 08 00 00    mov    0x8ac(,%ebx,8),%ecx
    1d89:       c1 e2 0c                shl    $0xc,%edx
    1d8c:       8d 74 3f 10             lea    0x10(%edi,%edi,1),%esi
    1d90:       81 e1 ff 0f 00 00       and    $0xfff,%ecx
    1d96:       03 0d 00 00 00 00       add    0x0,%ecx
    1d9c:       29 d1                   sub    %edx,%ecx
    1d9e:       89 31                   mov    %esi,(%ecx)
    1da0:       8b 71 10                mov    0x10(%ecx),%esi
    1da3:       8b 0c dd ac 08 00 00    mov    0x8ac(,%ebx,8),%ecx
    1daa:       8d 7c 3f 11             lea    0x11(%edi,%edi,1),%edi
    1dae:       81 e1 ff 0f 00 00       and    $0xfff,%ecx
    1db4:       03 0d 00 00 00 00       add    0x0,%ecx
    1dba:       29 d1                   sub    %edx,%ecx
    1dbc:       89 39                   mov    %edi,(%ecx)
    1dbe:       8b 59 10                mov    0x10(%ecx),%ebx
    1dc1:       89 c2                   mov    %eax,%edx
    1dc3:       b8 4e 08 00 00          mov    $0x84e,%eax
    1dc8:       e8 fc ff ff ff          call   1dc9 <ioapic_read_entry+0x69>
    1dcd:       89 f0                   mov    %esi,%eax
    1dcf:       89 da                   mov    %ebx,%edx
    1dd1:       8b 1c 24                mov    (%esp),%ebx
    1dd4:       8b 74 24 04             mov    0x4(%esp),%esi
    1dd8:       8b 7c 24 08             mov    0x8(%esp),%edi
    1ddc:       83 c4 0c                add    $0xc,%esp
    1ddf:       c3                      ret

--- gcc (GCC) 4.5.1 20100924 (Red Hat 4.5.1-4) on Fedora 14 ---

00000020 <__ioapic_read_entry>:
      20:       56                      push   %esi
      21:       8d 48 05                lea    0x5(%eax),%ecx
      24:       8d 04 80                lea    (%eax,%eax,4),%eax
      27:       53                      push   %ebx
      28:       8d 1c c5 60 08 00 00    lea    0x860(,%eax,8),%ebx
      2f:       8b 43 0c                mov    0xc(%ebx),%eax
      32:       c1 e1 0c                shl    $0xc,%ecx
      35:       8d 74 12 10             lea    0x10(%edx,%edx,1),%esi
      39:       25 ff 0f 00 00          and    $0xfff,%eax
      3e:       03 05 00 00 00 00       add    0x0,%eax
      44:       29 c8                   sub    %ecx,%eax
      46:       89 30                   mov    %esi,(%eax)
      48:       8b 40 10                mov    0x10(%eax),%eax
      4b:       8d 74 12 11             lea    0x11(%edx,%edx,1),%esi
      4f:       8b 53 0c                mov    0xc(%ebx),%edx
      52:       81 e2 ff 0f 00 00       and    $0xfff,%edx
      58:       03 15 00 00 00 00       add    0x0,%edx
      5e:       29 ca                   sub    %ecx,%edx
      60:       89 32                   mov    %esi,(%edx)
      62:       8b 52 10                mov    0x10(%edx),%edx
      65:       5b                      pop    %ebx
      66:       5e                      pop    %esi
      67:       c3                      ret
      68:       90                      nop
      69:       8d b4 26 00 00 00 00    lea    0x0(%esi,%eiz,1),%esi

00000200 <ioapic_read_entry>:
     200:       83 ec 0c                sub    $0xc,%esp
     203:       89 1c 24                mov    %ebx,(%esp)
     206:       89 c3                   mov    %eax,%ebx
     208:       b8 62 12 00 00          mov    $0x1262,%eax
     20d:       89 74 24 04             mov    %esi,0x4(%esp)
     211:       89 d6                   mov    %edx,%esi
     213:       89 7c 24 08             mov    %edi,0x8(%esp)
     217:       e8 fc ff ff ff          call   218 <ioapic_read_entry+0x18>
     21c:       89 f2                   mov    %esi,%edx
     21e:       89 c7                   mov    %eax,%edi
     220:       89 d8                   mov    %ebx,%eax
     222:       e8 f9 fd ff ff          call   20 <__ioapic_read_entry>
     227:       89 c3                   mov    %eax,%ebx
     229:       89 d6                   mov    %edx,%esi
     22b:       b8 62 12 00 00          mov    $0x1262,%eax
     230:       89 fa                   mov    %edi,%edx
     232:       e8 fc ff ff ff          call   233 <ioapic_read_entry+0x33>
     237:       89 d8                   mov    %ebx,%eax
     239:       89 f2                   mov    %esi,%edx
     23b:       8b 1c 24                mov    (%esp),%ebx
     23e:       8b 74 24 04             mov    0x4(%esp),%esi
     242:       8b 7c 24 08             mov    0x8(%esp),%edi
     246:       83 c4 0c                add    $0xc,%esp
     249:       c3                      ret
     24a:       8d b6 00 00 00 00       lea    0x0(%esi),%esi

Also, it turned out that this warning does not apprar when compiled with
CONFIG_M586MMX and earlier. This warning appears when compiled with CONFIG_M686
and later.

I don't know whether this warning is a false positive or not.
Can somebody who understand assembly code check this?

Regards.
