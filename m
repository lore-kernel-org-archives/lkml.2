Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965166Ab0COPev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 11:34:51 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:51368 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208Ab0COPer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 11:34:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=GdY7S5epcJRzzmfSAcgcEAzL5/DCAIlbTAgQAFMnk3vz2IXEGKKQbGwredj0hvviFn
         goIJ9Ai/qKW3pahiiIJOxZ3IpEZDe0IaKHG2PFmSejUyev8GGO1vmbIDO0vD5b1oWm5i
         jzFnSeSxynKHJlgs9USqP8C8Mop2wbXuHViP0=
From: =?UTF-8?q?T=C3=B6r=C3=B6k=20Edwin?= <edwintorok@gmail.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: fix callgraphs of 32-bit processes on 64-bit kernels.
Date: Mon, 15 Mar 2010 17:34:19 +0200
Message-Id: <1268667260-5505-1-git-send-email-edwintorok@gmail.com>
X-Mailer: git-send-email 1.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Callgraph profiling 32-bit apps on a 64-bit kernel doesn't work.
The reason is that perf_callchain_user tries to read a stackframe with 64-bit
pointers, which is wrong for a 32-bit process.

This patch fixes that, and I am almost able to get nice callgraph profiles
from 32-bit apps now! (except for some problems with perf itself when tracing
kernel modules, see [1])

Page-faults can be traced nicely (sid-ia32 is a 32-bit chroot):

$ sudo perf record -e page-faults -f -g /home/edwin/sid-ia32/usr/bin/glxgears
$ sudo perf report
...
    45.33%  libc-2.10.2.so                   [.] __GI_memcpy
            |
            --- __GI_memcpy
                _mesa_BufferDataARB
                _mesa_meta_Clear
                radeonUserClear
                r700Clear
                _mesa_Clear
                0x8049367
                0x804a6ba
                __libc_start_main
                0x8049111

    16.96%  libc-2.10.2.so                   [.] __GI_memset
            |
            --- __GI_memset
                _tnl_init_vertices
                _swsetup_CreateContext
                r600CreateContext
                driCreateNewContext
                dri2CreateNewContext
                0xf77ab7dd
                0xf7783c67
                0xf778514c
                0x804974f
                0x804a33d
                __libc_start_main
                0x8049111

And CPU cycles can be traced too in userspace:
$ sudo perf record -f -g /home/edwin/sid-ia32/usr/bin/glxgears
$ sudo perf report --sort comm,dso
    [...]
    44.97%  glxgears  r600_dri.so
            |
            |--5.85%-- r700SendSPIState
            |          radeonEmitState
            |          r700DrawPrims
            |          |
            |          |--95.45%-- vbo_save_playback_vertex_list
            |          |          execute_list
            |          |          _mesa_CallList
            |          |          neutral_CallList
            |          |          |
            |          |          |--38.10%-- 0x80494a8
            |          |          |          0x804a6ba
            |          |          |          __libc_start_main
            |          |          |          0x8049111
    [....]
    40.00%  glxgears  [kernel]
            |
            |--3.14%-- copy_user_generic_string
            |          |
            |          |--71.70%-- 0xffffffffa01b4493
            |          |          0xffffffffa01b7c0b
            |          |          0xffffffffa018b45b
            |          |          0xffffffffa00ca927
            |          |          0xffffffffa01c524e
            |          |          compat_sys_ioctl
            |          |          sysenter_dispatch
            |          |          0xf77ca430
            |          |          drmCommandWriteRead
            |          |          0xf74d7ab5
            |          |          0xf74d89a4
            |          |          rcommonFlushCmdBufLocked
            |          |          rcommonFlushCmdBuf
            |          |          radeonFlush
            |          |          _mesa_flush
            |          |          _mesa_Flush
            |          |          0xf775f270
            |          |          0x804a6d5
            |          |          __libc_start_main
            |          |          0x8049111
            |          |
            |          |--15.09%-- 0xffffffffa01c524e
            |          |          compat_sys_ioctl
            |          |          sysenter_dispatch
            |          |          0xf77ca430
            |          |          drmCommandWriteRead

[1] But there is a problem with the perf tool: it can't trace addresses in
kernel modules. This is a problem regardless if the traced app is 32-bit or
64-bit; and regardless if I do callgraph profiling or not.
See the above trace, where the kernel addresses have all ffffffffa0* without a
symbol name.

If I look at /proc/kallsyms I can guess the symbols, for example
0xffffffffa01b4493 is probably this one:
  ffffffffa01b4411 t r600_cs_packet_parse	[radeon]

If I record/report without callgraph its the same problem:
[...]
    24.01%  glxgears  [kernel]                           [k] 0xffffffffa01b4ee9
     3.96%  glxgears  libdrm_radeon.so.1.0.0             [.] cs_gem_write_reloc
     3.53%  glxgears  r600_dri.so                        [.] r700SendSPIState
     2.77%  glxgears  r600_dri.so                        [.] r700DrawPrims
     1.99%  glxgears  r600_dri.so                        [.] r700SendVSConsts

Kernel symbol for 0xffffffffa01b4ee9 is not shown, I can guess it is this one
(hey it was an exact match!):
  ffffffffa01b4ee9 t r600_packet3_check	[radeon]

It would be good if perf knew how to lookup symbols in kernel modules!

Best regards,
--Edwin
