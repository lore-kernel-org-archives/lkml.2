Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab2C0IBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 04:01:50 -0400
Received: from shelob.oktetlabs.ru ([195.131.132.186]:33764 "EHLO
	shelob.oktetlabs.ru" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753772Ab2C0IBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 04:01:48 -0400
X-Greylist: delayed 619 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Mar 2012 04:01:48 EDT
X-DKIM: Sendmail DKIM Filter v2.8.2 shelob.oktetlabs.ru 3A6837F411
Message-ID: <4F717174.9090008@oktetlabs.ru>
Date: Tue, 27 Mar 2012 11:51:16 +0400
From: "Yurij M. Plotnikov" <Yurij.Plotnikov@oktetlabs.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120317 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, jbaron@redhat.com,
        "Alexandra N. Kossovsky" <Alexandra.Kossovsky@oktetlabs.ru>
Subject: Dead circle in epoll file descriptor causes soft lockup on kernel
 3.2.12
Content-Type: multipart/mixed;
 boundary="------------040506080302050901020009"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040506080302050901020009
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Adding epoll file descriptors in each other in circle causes soft lockup 
on kernel 3.2.12 (I'm using Debian kernel 3.2.0-0.bpo.1-amd64). The 
following steps describe the problem:

1. epoll_create(1) -> 3
2. epoll_create(1) -> 4
3. socket(SOCK_STREAM) -> 5
4. bind(5, 0.0.0.0:0) -> 0
5. listen(5, 1) -> 0
6. epoll_ctl(3, ADD, 5, events = 0) -> 0
7. epoll_ctl(3, ADD, 4, events = EPOLLIN) -> 0
8. epoll_ctl(4, ADD, 3, events = EPOLLIN) -> -1(ELOOP)
9. close(3) -> 0
10. close(4) -> 0
11. close(5) -> 0

After repetaing this sequence 2-3 times soft lockup appers. In 
attachment c program to reproduce this problem.

Error logs from the host:

[  144.021060] BUG: soft lockup - CPU#3 stuck for 23s! [epoll_dead:1848]
[  144.027853] Modules linked in: autofs4 des_generic cbc 
rpcsec_gss_krb5 nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc 8021q 
garp stp w83627ehf hwmon_vid coretemp loop snd_hda_intel snd_hda_codec 
snd_hwdep i915 drm_kms_helper drm snd_pcm iTCO_wdt processor snd_timer 
snd video mtdchar iTCO_vendor_support thermal_sys i2c_i801 soundcore 
snd_page_alloc evdev pcspkr button ext3 jbd mbcache dm_mod sd_mod 
crc_t10dif ata_generic ehci_hcd ata_piix sfc mtd i2c_algo_bit i2c_core 
mdio libata usbcore usb_common e1000e scsi_mod [last unloaded: 
scsi_wait_scan]
[  144.080190] CPU 3
[  144.082148] Modules linked in: autofs4 des_generic cbc 
rpcsec_gss_krb5 nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc 8021q 
garp stp w83627ehf hwmon_vid coretemp loop snd_hda_intel snd_hda_codec 
snd_hwdep i915 drm_kms_helper drm snd_pcm iTCO_wdt processor snd_timer 
snd video mtdchar iTCO_vendor_support thermal_sys i2c_i801 soundcore 
snd_page_alloc evdev pcspkr button ext3 jbd mbcache dm_mod sd_mod 
crc_t10dif ata_generic ehci_hcd ata_piix sfc mtd i2c_algo_bit i2c_core 
mdio libata usbcore usb_common e1000e scsi_mod [last unloaded: 
scsi_wait_scan]
[  144.134763]
[  144.136335] Pid: 1848, comm: epoll_dead Not tainted 3.2.0-2-amd64 
#1                  /DH55HC
[  144.145441] RIP: 0010:[<ffffffff8104b253>]  [<ffffffff8104b253>] 
arch_local_irq_enable+0x4/0x8
[  144.154602] RSP: 0018:ffff880077263ef8  EFLAGS: 00000206
[  144.160208] RAX: 0000000000000003 RBX: ffffffff810248c2 RCX: 
0000000000000020
[  144.167698] RDX: 000000218711a000 RSI: 0000000000000096 RDI: 
0000000000000100
[  144.175232] RBP: ffff880036963fd8 R08: 0000000000000200 R09: 
0000000000000200
[  144.182871] R10: 0000000000000800 R11: ffff88007726e780 R12: 
ffff880077263e68
[  144.190430] R13: ffffffff8134eade R14: ffff880036963fd8 R15: 
ffffffff81604080
[  144.198023] FS:  00007f2c885fd700(0000) GS:ffff880077260000(0000) 
knlGS:0000000000000000
[  144.206607] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  144.212704] CR2: 00007f2c880e4b50 CR3: 0000000037286000 CR4: 
00000000000006e0
[  144.220259] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  144.227803] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[  144.235312] Process epoll_dead (pid: 1848, threadinfo 
ffff880036962000, task ffff8800371ef810)
[  144.244481] Stack:
[  144.246608]  ffffffff8104be38 000000219a61790e 000000030000000a 
0000000000000003
[  144.254549]  0000000000000046 ffff880077263f58 ffff880036c4d380 
ffff880036c4d380
[  144.262386]  ffffffff817e6b30 0000000000000000 ffffffff8135026c 
ffff880077263f58
[  144.270288] Call Trace:
[  144.272900] <IRQ>
[  144.275145]  [<ffffffff8104be38>] ? __do_softirq+0x59/0x177
[  144.280933]  [<ffffffff8135026c>] ? call_softirq+0x1c/0x30
[  144.286676]  [<ffffffff8100f8e5>] ? do_softirq+0x3c/0x7b
[  144.292325]  [<ffffffff8104c100>] ? irq_exit+0x3c/0x9a
[  144.297680]  [<ffffffff81023fd8>] ? smp_apic_timer_interrupt+0x74/0x82
[  144.304470]  [<ffffffff811284f4>] ? ep_call_nested.constprop.8+0xec/0xec
[  144.311577]  [<ffffffff8134eade>] ? apic_timer_interrupt+0x6e/0x80
[  144.318124] <EOI>
[  144.320389]  [<ffffffff811284f4>] ? ep_call_nested.constprop.8+0xec/0xec
[  144.327493]  [<ffffffff8107072e>] ? arch_local_irq_restore+0x2/0x8
[  144.333977]  [<ffffffff8112848f>] ? ep_call_nested.constprop.8+0x87/0xec
[  144.341030]  [<ffffffff81129003>] ? sys_epoll_ctl+0x43a/0x696
[  144.348417]  [<ffffffff811282a0>] ? ep_set_mstimeout+0x4a/0x4a
[  144.355994]  [<ffffffff8134e012>] ? system_call_fastpath+0x16/0x1b
[  144.363876] Code: 83 c4 58 5b 5d c3 90 90 f0 0f ab 3e 19 c0 c3 9c 58 
66 66 90 66 90 c3 57 9d 66 66 90 66 90 c3 fa 66 66 90 66 66 90 c3 fb 66 
66 90 <66> 66 90 c3 f0 80 67 08 fd c3 48 c7 07 00 00 00 00 48 c7 47 08
[  144.387832] Call Trace:
[  144.391831] <IRQ>  [<ffffffff8104be38>] ? __do_softirq+0x59/0x177
[  144.399741]  [<ffffffff8135026c>] ? call_softirq+0x1c/0x30
[  144.406861]  [<ffffffff8100f8e5>] ? do_softirq+0x3c/0x7b
[  144.413802]  [<ffffffff8104c100>] ? irq_exit+0x3c/0x9a
[  144.420594]  [<ffffffff81023fd8>] ? smp_apic_timer_interrupt+0x74/0x82
[  144.428789]  [<ffffffff811284f4>] ? ep_call_nested.constprop.8+0xec/0xec
[  144.437099]  [<ffffffff8134eade>] ? apic_timer_interrupt+0x6e/0x80
[  144.444923] <EOI>  [<ffffffff811284f4>] ? 
ep_call_nested.constprop.8+0xec/0xec
[  144.453927]  [<ffffffff8107072e>] ? arch_local_irq_restore+0x2/0x8
[  144.461647]  [<ffffffff8112848f>] ? ep_call_nested.constprop.8+0x87/0xec
[  144.469962]  [<ffffffff81129003>] ? sys_epoll_ctl+0x43a/0x696
[  144.477263]  [<ffffffff811282a0>] ? ep_set_mstimeout+0x4a/0x4a
[  144.484576]  [<ffffffff8134e012>] ? system_call_fastpath+0x16/0x1b

--------------040506080302050901020009
Content-Type: text/x-csrc;
 name="epoll_dead.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="epoll_dead.c"

#include <stdio.h>
#include <netinet/in.h>
#include <sys/epoll.h>
#include <errno.h>

int
main ()
{
    struct sockaddr_in addr;
    struct epoll_event event;
    int epfd1, epfd2, sock;
    int rc;
    int i = 0;

    while (1)
    {
        printf("ITERATION %d\n", ++i);
        epfd1 = epoll_create(1);
        printf("epoll_create() -> %d(%d)\n", epfd1, errno);

        epfd2 = epoll_create(1);
        printf("epoll_create() -> %d(%d)\n", epfd2, errno);

        sock = socket(PF_INET, SOCK_STREAM, 0);
        printf("socket() -> %d(%d)\n", sock, errno);

        addr.sin_family = AF_INET;
        addr.sin_port = 0;
        addr.sin_addr.s_addr = 0;
        rc = bind(sock, (struct sockaddr*)&addr, sizeof(addr));
        printf("bind() -> %d(%d)\n", rc, errno);

        rc = listen(sock, 1);
        printf("listen() -> %d(%d)\n", rc, errno);

        event.data.fd = sock;
        event.events = 0;
        rc = epoll_ctl(epfd1, EPOLL_CTL_ADD, sock, &event);
        printf("epoll_ctl() -> %d(%d)\n", rc, errno);

        event.data.fd = epfd2;
        event.events = EPOLLIN;
        rc = epoll_ctl(epfd1, EPOLL_CTL_ADD, epfd2, &event);
        printf("epoll_ctl() -> %d(%d)\n", rc, errno);

        event.data.fd = epfd1;
        event.events = EPOLLIN;
        rc = epoll_ctl(epfd2, EPOLL_CTL_ADD, epfd1, &event);
        printf("epoll_ctl() -> %d(%d)\n", rc, errno);

        rc = close(epfd1);
        printf("close(epfd1) -> %d(%d)\n", rc, errno);

        rc = close(epfd2);
        printf("close(epfd2) -> %d(%d)\n", rc, errno);

        rc = close(sock);
        printf("close(sock) -> %d(%d)\n", rc, errno);

        sleep(1);
        printf("\n\n");
    }

    return 0;
}

--------------040506080302050901020009--
