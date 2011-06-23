Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab1FWHmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 03:42:54 -0400
Received: from webbox687.server-home.net ([195.149.74.151]:53856 "EHLO
	webbox687.server-home.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab1FWHmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 03:42:52 -0400
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: Re: [PATCH] pch_dma: Fix channel locking
Date: Thu, 23 Jun 2011 09:42:23 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r6; KDE/4.6.3; x86_64; ; )
Cc: "Wang, Yong Y" <yong.y.wang@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        "Wang, Qi" <qi.wang@intel.com>,
        "toshiharu-linux@dsn.okisemi.com" <toshiharu-linux@dsn.okisemi.com>
References: <1308755133-8605-1-git-send-email-alexander.stein@systec-electronic.com> <4E0284C7.30909@dsn.okisemi.com>
In-Reply-To: <4E0284C7.30909@dsn.okisemi.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Message-Id: <201106230942.24105.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 23 June 2011 02:11:51 Tomoya MORINAGA wrote:
> (2011/06/23 0:05), Alexander Stein wrote:
> > Fix for the following INFO message
> > 
> > =================================
> > [ INFO: inconsistent lock state ]
> > 2.6.39+ #89
> > ---------------------------------
> > inconsistent {HARDIRQ-ON-W} ->  {IN-HARDIRQ-W} usage.
> > 
> > rs232/822 [HC1[1]:SC0[0]:HE0:SE1] takes:
> >   (&(&pd_chan->lock)->rlock){?.....}, at: [<c123b9a1>]
> >   pdc_desc_get+0x16/0xab
> > 
> > {HARDIRQ-ON-W} state was registered at:
> >    [<c104fe28>] mark_irqflags+0xbd/0x11a
> >    [<c1050386>] __lock_acquire+0x501/0x6bb
> >    [<c1050945>] lock_acquire+0x63/0x7b
> >    [<c131c51d>] _raw_spin_lock_bh+0x43/0x51
> >    [<c123bee4>] pd_alloc_chan_resources+0x92/0x11e
> >    [<c123ad62>] dma_chan_get+0x9b/0x107
> >    [<c123b2d1>] __dma_request_channel+0x61/0xdc
> >    [<c11ba24b>] pch_request_dma+0x61/0x19e
> >    [<c11bb3b8>] pch_uart_startup+0x16a/0x1a2
> >    [<c11b8446>] uart_startup+0x87/0x147
> >    [<c11b9183>] uart_open+0x117/0x13e
> >    [<c11a5c7d>] tty_open+0x23c/0x34c
> >    [<c1097705>] chrdev_open+0x140/0x15f
> >    [<c10930a6>] __dentry_open.clone.14+0x14a/0x22b
> >    [<c1093dfb>] nameidata_to_filp+0x36/0x40
> >    [<c109f28b>] do_last+0x513/0x635
> >    [<c109f4af>] path_openat+0x9c/0x2aa
> >    [<c109f6e4>] do_filp_open+0x27/0x69
> >    [<c1093f02>] do_sys_open+0xfd/0x184
> >    [<c1093fad>] sys_open+0x24/0x2a
> >    [<c131d58c>] sysenter_do_call+0x12/0x32
> > 
> > irq event stamp: 2522
> > hardirqs last  enabled at (2521): [<c131ca3b>]
> > _raw_spin_unlock_irqrestore+0x36/0x52 hardirqs last disabled at (2522):
> > [<c131db27>] common_interrupt+0x27/0x34 softirqs last  enabled at
> > (2354): [<c102fa11>] __do_softirq+0x10a/0x11a softirqs last disabled at
> > (2299): [<c10041a4>] do_softirq+0x57/0xa4
> > 
> > other info that might help us debug this:
> > 
> > 2 locks held by rs232/822:
> >   #0:  (&tty->atomic_write_lock){+.+.+.}, at: [<c11a4b7a>]
> >   tty_write_lock+0x14/0x3c #1:  (&port_lock_key){-.....}, at:
> >   [<c11bad72>] pch_uart_interrupt+0x17/0x1e9
> > 
> > stack backtrace:
> > Pid: 822, comm: rs232 Not tainted 2.6.39+ #89
> > 
> > Call Trace:
> >   [<c1319f90>] ? printk+0x19/0x1b
> >   [<c104f893>] print_usage_bug+0x184/0x18f
> >   [<c104e5b1>] ? print_irq_inversion_bug+0x10e/0x10e
> >   [<c104f943>] mark_lock_irq+0xa5/0x1f6
> >   [<c104fc9c>] mark_lock+0x208/0x2d7
> >   [<c104fdc0>] mark_irqflags+0x55/0x11a
> >   [<c1050386>] __lock_acquire+0x501/0x6bb
> >   [<c10042ee>] ? dump_trace+0x92/0xb6
> >   [<c1050945>] lock_acquire+0x63/0x7b
> >   [<c123b9a1>] ? pdc_desc_get+0x16/0xab
> >   [<c131c2d0>] _raw_spin_lock+0x3e/0x4c
> >   [<c123b9a1>] ? pdc_desc_get+0x16/0xab
> >   [<c123b9a1>] pdc_desc_get+0x16/0xab
> >   [<c10504d8>] ? __lock_acquire+0x653/0x6bb
> >   [<c123bb2c>] pd_prep_slave_sg+0x7c/0x1cb
> >   [<c1006c3f>] ? nommu_map_sg+0x6e/0x81
> >   [<c11bace6>] dma_handle_tx+0x2cf/0x344
> >   [<c11bad72>] ? pch_uart_interrupt+0x17/0x1e9
> >   [<c11baebb>] pch_uart_interrupt+0x160/0x1e9
> >   [<c10642fb>] handle_irq_event_percpu+0x25/0x127
> >   [<c1064429>] handle_irq_event+0x2c/0x43
> >   [<c1065e0d>] ? handle_fasteoi_irq+0x84/0x84
> >   [<c1065eb9>] handle_edge_irq+0xac/0xce
> >   <IRQ>   [<c1003ecb>] ? do_IRQ+0x38/0x9d
> >   [<c131db2e>] ? common_interrupt+0x2e/0x34
> >   [<c105007b>] ? __lock_acquire+0x1f6/0x6bb
> >   [<c131ca3d>] ? _raw_spin_unlock_irqrestore+0x38/0x52
> >   [<c11b798b>] ? uart_start+0x2d/0x32
> >   [<c11b7998>] ? uart_flush_chars+0x8/0xa
> >   [<c11a7962>] ? n_tty_write+0x12c/0x1c6
> >   [<c1027a73>] ? try_to_wake_up+0x251/0x251
> >   [<c11a4d0b>] ? tty_write+0x169/0x1dc
> >   [<c11a7836>] ? n_tty_ioctl+0xb7/0xb7
> >   [<c1094841>] ? vfs_write+0x91/0x10d
> >   [<c11a4ba2>] ? tty_write_lock+0x3c/0x3c
> >   [<c1094a69>] ? sys_write+0x3e/0x63
> >   [<c131d58c>] ? sysenter_do_call+0x12/0x32

> To: Alexander
> Thank you for your report.
> How can I see the above kernel error log ?
> Let me know your test condition.

Enable DMA on ttyPCH0 (we use ttyPCH1 for serial login)
and write to the UART.
DMA is _not_ enabled by default, so I had to track back the code to find the 
trigger for DMA enable.
After that, I wrote more than FIFO size, which is 256 for UART0), actually 270 
chars on ttyPCH0.
See this minimalistic snippet:

#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <linux/serial.h>
int main(int argc, char *argv[])
{
int fd;
char buf[270];
struct serial_struct serial;

	fd = open ("/dev/ttyPCH0", O_RDWR);

	/* Read current settings */
	ioctl(fd, TIOCGSERIAL, &serial);
	/* Write themagain to trigger DMA mode enable */
	ioctl(fd, TIOCSSERIAL, &serial);

	close(fd);
	fd = open ("/dev/ttyPCH0", O_RDWR);
	write (fd, buf, 270);

	close (fd);
	return 0;
}

The close and open is actually needed (I had a separate application for that 
yesterday).

If all is done without closing again, I get the following bug:

BUG: unable to handle kernel NULL pointer dereference at   (null)
dma_handle_tx+0x2bb/0x344
*pde = 00000000 
PREEMPT SMP 
last sysfs file: /sys/devices/pci0000:00/0000:00:18.0/0000:03:00.0/class
Modules linked in:

Pid: 825, comm: raise_dma_fault Not tainted 2.6.39+ #93  
EFLAGS: 00010046 CPU: 0
EIP is at dma_handle_tx+0x2bb/0x344
EAX: 00000000 EBX: f6b53e00 ECX: 00000001 EDX: f7350180
ESI: f7014800 EDI: f7350194 EBP: f700df6c ESP: f700df2c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process raise_dma_fault (pid: 825, ti=f700c000 task=f6145780 task.ti=f60a4000)
Stack:
 00000001 00000000 c11bad79 00000000 f7350180 00000001 00000001 00000000
 000000b2 000000b2 00000100 00000001 00000000 f6b53e00 00000000 00000000
 f700dfa0 c11baec2 00000000 00000001 00000018 f6145b0c 00000002 00000046
Call Trace:
? pch_uart_interrupt+0x17/0x1e9
pch_uart_interrupt+0x160/0x1e9
handle_irq_event_percpu+0x25/0x127
handle_irq_event+0x2c/0x43
? handle_fasteoi_irq+0x84/0x84
handle_edge_irq+0xac/0xce
 <IRQ> 
? do_IRQ+0x38/0x9d
? common_interrupt+0x2e/0x34
? lock_acquire+0x72/0x7b
? process_output+0x19/0x41
? mutex_lock_nested+0x45/0x291
? process_output+0x19/0x41
? trace_hardirqs_on+0xb/0xd
? process_output+0x19/0x41
? n_tty_write+0x10c/0x1c6
? try_to_wake_up+0x251/0x251
? tty_write+0x169/0x1dc
? n_tty_ioctl+0xb7/0xb7
? vfs_write+0x91/0x10d
? tty_write_lock+0x3c/0x3c
? sys_write+0x3e/0x63
? sysenter_do_call+0x12/0x32
Code: 89 57 0c 3b 45 dc 8b 55 e4 0f 45 55 e0 89 57 10 40 83 c7 14 03 4d e8 3b 
45 ec 7c c3 8b 83 3c 01 00 00 8b 93 44 01 00 00 8b 4d ec <8b> 30 c7 44 24 04 
03 00 00 00 c7 04 24 01 00 00 00 ff 56 54 85 
dma_handle_tx+0x2bb/0x344 SS:ESP 0068:f700df2c
CR2: 0000000000000000
---[ end trace 0aeb50fd75b47c6f ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 825, comm: raise_dma_fault Tainted: G      D     2.6.39+ #93
Call Trace:
? printk+0x19/0x1b
panic+0x62/0x151
oops_end+0x76/0x82
no_context+0x11c/0x125
__bad_area_nosemaphore+0x114/0x11d
? dump_trace+0x92/0xb6
? vmalloc_sync_all+0xeb/0xeb
bad_area_nosemaphore+0x13/0x15
do_page_fault+0x151/0x337
? __lock_acquire+0x653/0x6bb
? vmalloc_sync_all+0xeb/0xeb
error_code+0x5f/0x64
? vmalloc_sync_all+0xeb/0xeb
? dma_handle_tx+0x2bb/0x344
? pch_uart_interrupt+0x17/0x1e9
pch_uart_interrupt+0x160/0x1e9
handle_irq_event_percpu+0x25/0x127
handle_irq_event+0x2c/0x43
? handle_fasteoi_irq+0x84/0x84
handle_edge_irq+0xac/0xce
? do_IRQ+0x38/0x9d
? common_interrupt+0x2e/0x34
? lock_acquire+0x72/0x7b
? process_output+0x19/0x41
? mutex_lock_nested+0x45/0x291
? process_output+0x19/0x41
? trace_hardirqs_on+0xb/0xd
? process_output+0x19/0x41
? n_tty_write+0x10c/0x1c6
? try_to_wake_up+0x251/0x251
? tty_write+0x169/0x1dc
? n_tty_ioctl+0xb7/0xb7
? vfs_write+0x91/0x10d
? tty_write_lock+0x3c/0x3c
? sys_write+0x3e/0x63
? sysenter_do_call+0x12/0x32

Regards,
Alexander
