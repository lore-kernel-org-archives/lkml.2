Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220Ab0LNMww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 07:52:52 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33008 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912Ab0LNMwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 07:52:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=Thy1MidO8emLK2tsyMmYDFeBg797JK/Epqby7OMhwCbU38wjDmIvd1QvGPvyd3jo6z
         yc+fSIF9c6wcTo+pI40MlV3kIpHUPTbgJMFvkTymMVd8jwc5fTFB3exMYWMS2NBwH3LU
         ZAO0dy2AizJbbTfTZSnSrLxAmKh3R3FGilrV4=
Date: Tue, 14 Dec 2010 10:52:45 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <daahern@cisco.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] perf tools: Add symfs option for off-box analysis
 using specified tree
Message-ID: <20101214125245.GB13425@ghostprotocols.net>
References: <1291926427-28846-1-git-send-email-daahern@cisco.com>
 <20101214122428.GA13425@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101214122428.GA13425@ghostprotocols.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 14, 2010 at 10:24:28AM -0200, Arnaldo Carvalho de Melo escreveu:
> Em Thu, Dec 09, 2010 at 01:27:07PM -0700, David Ahern escreveu:
> > The symfs argument allows analysis of perf.data file using a locally
> > accessible filesystem tree with debug symbols - e.g., tree created
> > during image builds, sshfs mount, loop mounted KVM disk images,
> > USB keys, initrds, etc. Anything with an OS tree can be analyzed from
> > anywhere without the need to populate a local data store with
> > build-ids.
> > 
> > Signed-off-by: David Ahern <daahern@cisco.com>
> > 
> > v2 --> v3: handle symfs="/"
> 
> [acme@felicio ~]$ ./realpath /..//.
> /
> [acme@felicio ~]$
> 
> I'll fix this up and merge, thanks!

Ok, there are still some problems:

It is escaping the symfs jail for /home/acme/bin/perf, /lib64/libpthread-2.5.so
and kernel modules, investigating...

- Arnaldo

[acme@mica linux]$ find /tmp/bla
/tmp/bla
/tmp/bla/lib64
/tmp/bla/lib64/libc-2.5.so
[acme@mica linux]$ perf report -v -g none --stdio --symfs /tmp/bla > /tmp/out
Looking at the vmlinux_path (3 entries long)
Failed to open [kernel.kallsyms], continuing without symbols
dso__synthesize_plt_symbols: problems reading /home/acme/bin/perf PLT info.
dso__synthesize_plt_symbols: problems reading /lib64/libpthread-2.5.so PLT info.
dso__synthesize_plt_symbols: problems reading /lib/modules/2.6.37-rc3-00084-gd937616/kernel/drivers/net/ixgbe/ixgbe.ko PLT info.
[acme@mica linux]$ cat /tmp/out
# Events: 503  cycles
#
# Overhead      Command                                                             Shared Object                         Symbol
# ........  ...........  ........................................................................  .............................
#
    86.67%         perf  [kernel.kallsyms]                                                         0xffffffff8106f697 ! [k] 0xffffffff8106f697
     2.56%      swapper  [kernel.kallsyms]                                                         0xffffffff81089f50 ! [k] 0xffffffff81089f50
     0.84%         perf  /lib64/libc-2.5.so                                                        0x798ed          d [.] __memchr
     0.84%         perf  /home/acme/bin/perf                                                       0x26bf1          G [.] die_builtin
     0.82%         perf  /lib64/libc-2.5.so                                                        0x728ea          d [.] _int_malloc
     0.63%         perf  /lib64/libc-2.5.so                                                        0xe6077          d [.] ___snprintf_chk
     0.63%         perf  /lib64/libc-2.5.so                                                        0x7b528          d [.] __GI_memcpy
     0.63%         perf  /lib64/libc-2.5.so                                                        0x786c0          d [.] index
     0.51%         perf  /lib64/libc-2.5.so                                                        0x625b0          d [.] _IO_getline_internal
     0.42%         perf  /lib64/libc-2.5.so                                                        0x6265a          d [.] _IO_getline_info
     0.42%         perf  /lib64/libc-2.5.so                                                        0x6cbc4          d [.] _IO_new_file_underflow
     0.42%         perf  /lib64/libc-2.5.so                                                        0x6d148          d [.] _IO_un_link_internal
     0.34%         perf  /lib64/libc-2.5.so                                                        0x60c49          d [.] _IO_new_fclose
     0.21%         perf  /lib64/libc-2.5.so                                                        0x5ff40          d [.] __find_specmb
     0.21%         perf  /lib64/libc-2.5.so                                                        0x6c35b          d [.] _IO_new_file_fopen
     0.21%         perf  /home/acme/bin/perf                                                       0x1db4b          G [.] event__synthesize_kernel_mmap
     0.21%         perf  /lib64/libc-2.5.so                                                        0x6d3c5          d [.] _IO_link_in_internal
     0.21%         perf  /lib64/libc-2.5.so                                                        0x34524          d [.] __GI_____strtoll_l_internal
     0.21%         perf  /home/acme/bin/perf                                                       0x4700           G [.] _init
     0.21%         perf  /lib64/libc-2.5.so                                                        0x41907          d [.] _itoa_word
     0.21%         perf  /lib64/libc-2.5.so                                                        0x6148f          d [.] fgets
     0.21%         perf  /home/acme/bin/perf                                                       0x1deca          G [.] event__synthesize_comm
     0.21%         perf  /lib64/libc-2.5.so                                                        0xcfe7d          d [.] __munmap
     0.21%         perf  /lib64/libc-2.5.so                                                        0x79513          d [.] __GI_strstr
     0.21%         perf  /lib64/libc-2.5.so                                                        0x6e060          d [.] _IO_setb_internal
     0.21%         perf  /lib64/libc-2.5.so                                                        0x6bac3          d [.] _IO_file_close_internal
     0.21%         perf  /lib64/libc-2.5.so                                                        0x95dc3          d [.] __getdents64
     0.21%         perf  /lib64/libc-2.5.so                                                        0x6f1b2          d [.] _IO_str_init_static_internal
     0.21%         perf  /lib64/libpthread-2.5.so                                                  0xd210           G [.] __write_nocancel
     0.21%         perf  /lib64/libc-2.5.so                                                        0x9595a          d [.] __readdir_r
     0.21%         perf  /home/acme/bin/perf                                                       0xddbd           G [.] atexit_header
     0.21%         perf  /lib64/libc-2.5.so                                                        0xc4de7          d [.] __GI___open
     0.12%        pcscd  [unknown]                                                                 0x3f44a79110     ! [.] 0x3f44a79110    
     0.09%        pcscd  [kernel.kallsyms]                                                         0xffffffff810e59ac ! [k] 0xffffffff810e59ac
     0.03%         sshd  [kernel.kallsyms]                                                         0xffffffff810f45f9 ! [k] 0xffffffff810f45f9
     0.03%  kworker/0:1  /lib/modules/2.6.37-rc3-00084-gd937616/kernel/drivers/net/ixgbe/ixgbe.ko  0x605            G [k] ixgbe_update_stats
     0.02%         sshd  [unknown]                                                                 0x7f78ed5f8ccb   ! [.] 0x7f78ed5f8ccb  


#
# (For a higher level overview, try: perf report --sort comm,dso)
#
[acme@mica linux]$ 

