Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326Ab1DORB0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 13:01:26 -0400
Received: from sentry-three.sandia.gov ([132.175.109.17]:56417 "EHLO
	sentry-three.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922Ab1DORBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 13:01:25 -0400
X-WSS-ID: 0LJPDY9-0C-9HR-02
X-M-MSG: 
X-Server-Uuid: AF72F651-81B1-4134-BA8C-A8E1A4E620FF
Message-ID: <4DA879CA.8060305@sandia.gov>
Date: Fri, 15 Apr 2011 11:00:58 -0600
From: "Jim Schutt" <jaschut@sandia.gov>
User-Agent: Thunderbird 2.0.0.24 (X11/20110128)
MIME-Version: 1.0
To: dchinner@redhat.com, viro@zeniv.linux.org.uk
cc: linux-kernel@vger.kernel.org,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: [Regression,bisected] 2.6.39-rc3 ceph client write hangs
X-Originating-IP: [134.253.95.179]
X-PMX-Version: 5.6.0.2009776, Antispam-Engine: 2.7.2.376379,
 Antispam-Data: 2011.4.15.165115
X-PMX-Spam: Gauge=IIIIIIII, Probability=8%, Report='
 BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS
 0, BODY_SIZE_7000_LESS 0, DATE_TZ_NA 0, WEBMAIL_SOURCE 0, WEBMAIL_XOIP
 0, WEBMAIL_X_IP_HDR 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID
 0, __HAS_XOIP 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __MOZILLA_MSGID
 0, __RATWARE_X_MAILER_CS_B 0, __SANE_MSGID 0, __TO_MALFORMED_2 0,
 __TO_NO_NAME 0, __URI_NO_PATH 0, __URI_NO_WWW 0, __URI_NS ,
 __USER_AGENT 0'
X-TMWD-Spam-Summary: TS=20110415170106; ID=1; SEV=2.3.1;
 DFV=B2011041518; IFV=NA; AIF=B2011041518; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230342E34444138373944322E303041343A534346535441543838363133332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAAAAAAAAAAAAAAAAAAAAAAAfQ==
X-MMS-Spam-Filter-ID: B2011041518_5.03.0010
X-WSS-ID: 61B6A65A2TS1373759-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
X-RSA-Inspected: yes
X-RSA-Classifications: public
X-RSA-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

This command is hanging on 2.6.39-rc3, where /mnt/ceph is
a ceph file system:
   dd conv=fdatasync if=/dev/zero of=/mnt/ceph/zero.`hostname -s` bs=4k count=4k

It works on 2.6.38.  As of commit e38f5b745075 in Linus'
tree it still doesn't work.

I bisected this to:

250df6ed274d767da844a5d9f05720b804240197 is the first bad commit
commit 250df6ed274d767da844a5d9f05720b804240197
Author: Dave Chinner <dchinner@redhat.com>
Date:   Tue Mar 22 22:23:36 2011 +1100

     fs: protect inode->i_state with inode->i_lock

In the early stages of the bisection, bad commits would show this
in dmesg:

[  137.004963] libceph: loaded (mon/osd proto 15/24, osdmap 5/6 5/6)
[  137.056431] ceph: loaded (mds proto 32)
[  137.063213] libceph: client4283 fsid 950217ad-499e-eab1-03f7-f6d245f42751
[  137.063826] libceph: mon0 172.17.40.34:6789 session established
[  219.658002] INFO: rcu_sched_state detected stall on CPU 0 (t=60000 jiffies)

For the last couple of bad commits during the bisection, the
client box would just hang and I'd have to power-cycle it.

When I reboot/remount after a hang, the file I was trying
to write is there, with size and date both zero:

# ls -l --time-style=+%s /mnt/ceph/zero.an1024
-rw-r--r-- 1 jaschut jaschut 0 0 /mnt/ceph/zero.an1024

strace suggests it's the write that hangs:

close(3)                                = 0
close(0)                                = 0
open("/dev/zero", O_RDONLY)             = 0
lseek(0, 0, SEEK_CUR)                   = 0
close(1)                                = 0
open("/mnt/ceph/zero.an1024", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 1
rt_sigaction(SIGUSR1, NULL, {SIG_DFL, [], 0}, 8) = 0
rt_sigaction(SIGINT, NULL, {SIG_DFL, [], 0}, 8) = 0
rt_sigaction(SIGUSR1, {0x401a20, [INT USR1], SA_RESTORER, 0x7f3a97f292d0}, NULL, 8) = 0
rt_sigaction(SIGINT, {0x401a10, [INT USR1], SA_RESTORER|SA_NODEFER|SA_RESETHAND, 0x7f3a97f292d0}, NULL, 8) = 0
clock_gettime(CLOCK_MONOTONIC, {216, 671807533}) = 0
read(0, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096) = 4096
write(1, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096

Let me know if I can do anything else to help sort this out.

-- Jim

(Please Cc: me as I am not subscribed to lkml.)

