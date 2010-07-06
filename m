Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab0GFAjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 20:39:46 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:49500 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab0GFAjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 20:39:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=aCu7HBxepQhI2Znp+cAcxVI69LtBzTGtqqAL5krUFSWsxRTYCfsyS8YndLvwzpjuo2
         mVZN0AcR4t7TAFyqq4CLFj6bEXGI9R8nsoRzZfnG0VG0hALDj5QIiP3zE5iqpuGlk9Pf
         TGPuqooCxB5dU/G/6paaMc6rSVQHfV+PyV2gI=
MIME-Version: 1.0
Date: Mon, 5 Jul 2010 18:39:44 -0600
Message-ID: <AANLkTilWE3YdagOtC9ylxte_p8wIgbMXVdp2jrfUIFeK@mail.gmail.com>
Subject: 2.6.34 FSAVE floating point instruction causes BUG! condition memory 
	allocation from coprocessor interrupt context
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function "save_npx" below will trigger the coprocessor exception
interrupt to allocate memory from a bad context and
report a bug.  Shows up under extremely heavy load, but normally does
not happen.  Does not crash the system just
spills out garbage into the dmesg logs.  Definitely a bug in Linux in
how the coprocessor is handled when a floating point
instruction is executed and the chip has not been setup yet.

void save_npx(NUMERIC_FRAME *v)
{
    __asm__ __volatile__("fsave %0":"=m"(*v));
}

void load_npx(NUMERIC_FRAME *v)
{
    __asm__ __volatile__("frstor %0":"=m"(*v));
}

Jul  5 16:45:48 cloudstream kernel: SysRq : MDB
Jul  5 16:45:48 cloudstream kernel: BUG: sleeping function called from
invalid context at mm/slub.c:1705
Jul  5 16:45:48 cloudstream kernel: in_atomic(): 1, irqs_disabled():
0, pid: 5661, name: bash
Jul  5 16:45:48 cloudstream kernel: Pid: 5661, comm: bash Tainted: P
        2.6.34 #1
Jul  5 16:45:48 cloudstream kernel: Call Trace:
Jul  5 16:45:48 cloudstream kernel:  [<804ad54b>] ? kmem_cache_alloc+0x35/0xe1
Jul  5 16:45:48 cloudstream kernel:  [<804082ff>] ? init_fpu+0xcf/0x142
Jul  5 16:45:48 cloudstream kernel:  [<80692f68>] ?
do_device_not_available+0x0/0x40
Jul  5 16:45:48 cloudstream kernel:  [<804082ff>] ? init_fpu+0xcf/0x142
Jul  5 16:45:48 cloudstream kernel:  [<80692f68>] ?
do_device_not_available+0x0/0x40
Jul  5 16:45:48 cloudstream kernel:  [<80402d4f>] ? math_state_restore+0x15/0x2b
Jul  5 16:45:48 cloudstream kernel:  [<80692f9d>] ?
do_device_not_available+0x35/0x40
Jul  5 16:45:48 cloudstream kernel:  [<8069287a>] ? error_code+0x66/0x6c
Jul  5 16:45:48 cloudstream kernel:  [<80692f68>] ?
do_device_not_available+0x0/0x40
Jul  5 16:45:48 cloudstream kernel:  [<9e9a4ffa>] ? save_npx+0x0/0x4 [mdb]
Jul  5 16:45:48 cloudstream kernel:  [<9e9ab75f>] ?
debugger_entry+0x68/0x259 [mdb]
Jul  5 16:45:48 cloudstream kernel:  [<9e9868f3>] ? mdb+0x96/0xc1 [mdb]
Jul  5 16:45:48 cloudstream kernel:  [<9e986a39>] ? mdb_notify+0x11b/0x14e [mdb]
Jul  5 16:45:48 cloudstream kernel:  [<8069495f>] ?
notifier_call_chain+0x2a/0x47
Jul  5 16:45:48 cloudstream kernel:  [<806949a5>] ?
__atomic_notifier_call_chain+0x29/0x4f
Jul  5 16:45:48 cloudstream kernel:  [<806949d4>] ?
atomic_notifier_call_chain+0x9/0xc
Jul  5 16:45:48 cloudstream kernel:  [<80694a07>] ? notify_die+0x30/0x34
Jul  5 16:45:48 cloudstream kernel:  [<80692fc4>] ? do_int3+0x1c/0x68
Jul  5 16:45:48 cloudstream kernel:  [<80692a19>] ? int3+0x29/0x30
Jul  5 16:45:48 cloudstream kernel:  [<9e9b007b>] ?
print_insn+0x1278/0x1423 [mdb]
Jul  5 16:45:48 cloudstream kernel:  [<9e9a5e35>] ? mdb_breakpoint+0x1/0x2 [mdb]
Jul  5 16:45:48 cloudstream kernel:  [<805a09a3>] ? __handle_sysrq+0x83/0xfa
Jul  5 16:45:48 cloudstream kernel:  [<805a0a1a>] ? write_sysrq_trigger+0x0/0x3e
Jul  5 16:45:48 cloudstream kernel:  [<805a0a51>] ?
write_sysrq_trigger+0x37/0x3e
Jul  5 16:45:48 cloudstream kernel:  [<804e6297>] ? proc_reg_write+0x60/0x73
Jul  5 16:45:48 cloudstream kernel:  [<804e6237>] ? proc_reg_write+0x0/0x73
Jul  5 16:45:48 cloudstream kernel:  [<804b12df>] ? vfs_write+0x83/0x12e
Jul  5 16:45:48 cloudstream kernel:  [<804b1896>] ? sys_write+0x3c/0x63
Jul  5 16:45:48 cloudstream kernel:  [<804026cc>] ? sysenter_do_call+0x12/0x22
Jul  5 16:46:02 cloudstream kernel: SysRq : MDB
