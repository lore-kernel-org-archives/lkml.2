Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab1HAOER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 10:04:17 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:34268 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab1HAOEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 10:04:08 -0400
From: Richard Weinberger <richard@nod.at>
To: Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: shm updates broke UML
Date: Mon, 1 Aug 2011 16:04:05 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.5; x86_64; ; )
Cc: serge.hallyn@canonical.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, toralf.foerster@gmx.de
References: <201108011541.59640.richard@nod.at> <20110801134911.GA11705@albatros>
In-Reply-To: <20110801134911.GA11705@albatros>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108011604.05382.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vasiliy,

On Montag 01 August 2011 15:49:11 Vasiliy Kulikov wrote:
> Hi Richard,
> 
> On Mon, Aug 01, 2011 at 15:41 +0200, Richard Weinberger wrote:
> > 5774ed01 (shm: handle separate PID namespaces case)
> > b34a6b1d (ipc: introduce shm_rmid_forced sysctl)
> > 4c677e2e (shm: optimize locking and ipc_namespace getting)
> > 
> > broke UML on i386.
> > It crashes while starting up by SIGSEGV.
> > exit_shm() seems to be the evil doer.
> 
> I was reported 20 mins ago that it's reproducable on MIPS too.
> 
> > Reverting all three patches make UML work again.
> 
> Can you confirm that 5774ed01 breaks the boot? (it is for MIPS)

Yes. But I also had to revert 4c677e2e because 5774ed01 depends on it...

> Can you post the whole oops message?  I'd want to see what pointer is
> NULL.

UML is not that friendly in reporting NULL pointers :)
EAX and ECX are NULL.

---cut---

$ ./linux earlyprintk
Locating the bottom of the address space ... 0x10000
Locating the top of the address space ... 0xffffd000
Core dump limits :
        soft - 0
        hard - NONE
Checking that ptrace can change system call numbers...OK
Checking syscall emulation patch for ptrace...OK
Checking advanced syscall emulation patch for ptrace...OK
Checking for tmpfs mount on /dev/shm...OK
Checking PROT_EXEC mmap in /tmp/...OK
Checking for the skas3 patch in the host:
  - /proc/mm...not found: No such file or directory
  - PTRACE_FAULTINFO...not found
  - PTRACE_LDT...not found
UML running in SKAS0 mode
bootconsole [earlycon0] enabled
PID hash table entries: 128 (order: -3, 512 bytes)
Dentry cache hash table entries: 4096 (order: 2, 16384 bytes)
Inode-cache hash table entries: 2048 (order: 1, 8192 bytes)
Memory: 29896k available
NR_IRQS:15
Calibrating delay loop... 3173.58 BogoMIPS (lpj=15867904)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
Checking for host processor cmov support...Yes
Checking that host ptys support output SIGIO...Yes
Checking that host ptys support SIGIO on close...No, enabling workaround

EIP: 0023:[<081c7b8a>] CPU: 0 Not tainted ESP: 002b:09c74f00 EFLAGS: 00010206
    Not tainted
EAX: 00000000 EBX: 0824cc9c ECX: 00000000 EDX: 09c74f00
ESI: 09c73b60 EDI: 00000001 EBP: 09c74f20 DS: 002b ES: 002b
0823fb70:  [<0806b6e8>] show_regs+0xc5/0xcd
0823fb9c:  [<0805a52a>] segv+0x5b/0x234
0823fc40:  [<0805a74c>] segv_handler+0x49/0x53
0823fc68:  [<08066776>] sig_handler_common+0x61/0x70
0823fce0:  [<08066851>] sig_handler+0x31/0x40
0823fcec:  [<0806653e>] handle_signal+0x50/0x7d
0823fd0c:  [<08067efb>] hard_handler+0xf/0x14
0823fd1c:  [<ffffe400>] 0xffffe400

Kernel panic - not syncing: Segfault with no mm
0823fb4c:  [<081c63da>] dump_stack+0x1c/0x20
0823fb64:  [<081c642b>] panic+0x4d/0x13e
0823fb98:  [<0805a5d9>] segv+0x10a/0x234
0823fc40:  [<0805a74c>] segv_handler+0x49/0x53
0823fc68:  [<08066776>] sig_handler_common+0x61/0x70
0823fce0:  [<08066851>] sig_handler+0x31/0x40
0823fcec:  [<0806653e>] handle_signal+0x50/0x7d
0823fd0c:  [<08067efb>] hard_handler+0xf/0x14
0823fd1c:  [<ffffe400>] 0xffffe400


EIP: 0023:[<ffffe430>] CPU: 0 Not tainted ESP: 002b:ffaae1c8 EFLAGS: 00000296
    Not tainted
EAX: 00000000 EBX: 000017b4 ECX: 00000013 EDX: 000017b4
ESI: 000017a6 EDI: 0000003d EBP: ffaae1f4 DS: 002b ES: 002b
0823fafc:  [<0806b6e8>] show_regs+0xc5/0xcd
0823fb28:  [<0805a97b>] panic_exit+0x25/0x3b
0823fb3c:  [<0808a9c4>] notifier_call_chain+0x25/0x4a
0823fb64:  [<0808aa17>] atomic_notifier_call_chain+0x15/0x17
0823fb74:  [<081c6446>] panic+0x68/0x13e
0823fb98:  [<0805a5d9>] segv+0x10a/0x234
0823fc40:  [<0805a74c>] segv_handler+0x49/0x53
0823fc68:  [<08066776>] sig_handler_common+0x61/0x70
0823fce0:  [<08066851>] sig_handler+0x31/0x40
0823fcec:  [<0806653e>] handle_signal+0x50/0x7d
0823fd0c:  [<08067efb>] hard_handler+0xf/0x14
0823fd1c:  [<ffffe400>] 0xffffe400

---cut---

Thanks,
//richard
