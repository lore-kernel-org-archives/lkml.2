Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab2HVInO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:43:14 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:40241 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2HVInH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:43:07 -0400
X-AuditID: b753bd60-8ecbeba0000047ca-1c-50349b973943
X-AuditID: b753bd60-8ecbeba0000047ca-1c-50349b973943
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [PATCH 0/5] trace-cmd: Add a recorder readable feature for
 virtio-trace
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Amit Shah <amit.shah@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@amd64.org>,
        "Franch Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        yrl.pp-manager.tt@hitachi.com
Date: Wed, 22 Aug 2012 17:42:51 +0900
Message-ID: <20120822084251.17293.69086.stgit@ltc189.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

The following patch set provides a feature which can read trace data of a guest
using virtio-trace (https://lkml.org/lkml/2012/8/9/210) for a recorder
function of trace-cmd. This patch set depends on the trace-agent running on a
guest in the virtio-trace system.

To translate raw data of a guest to text data on a host, information of debugfs
in the guest is also needed on the host. In other words, the guest's debugfs
must be exposed (mounted) on the host via other serial line (we don't like to
depend on network connection). For this purpose, we'll use DIOD 9pfs server
(http://code.google.com/p/diod/) as below.

***HOW TO USE***
We explain about how to translate raw data to text data on a host using
trace-cmd applied this patch set and virtio-trace.

- Preparation
1. Make FIFO in a host
 virtio-trace uses virtio-serial pipe as trace data paths as to the number
of CPUs and a control path, so FIFO (named pipe) should be created as follows:
        # mkdir /tmp/virtio-trace/
        # mkfifo /tmp/virtio-trace/trace-path-cpu{0,1,2,...,X}.{in,out}
        # mkfifo /tmp/virtio-trace/agent-ctl-path.{in,out}

Here, if we assign 1VCPU for a guest, then we set as follows:
        trace-path-cpu0.{in.out}
and
        agent-ctl-path.{in,out}.

2. Set up of virtio-serial pipe and unix in a host
 Add qemu option to use virtio-serial pipe for tracing and unix for debugfs.

 ##virtio-serial device##
     -device virtio-serial-pci,id=virtio-serial0\
 ##control path##
     -chardev pipe,id=charchannel0,path=/tmp/virtio-trace/agent-ctl-path\
     -device virtserialport,bus=virtio-serial0.0,nr=1,chardev=charchannel0,\
      id=channel0,name=agent-ctl-path\
 ##data path##
     -chardev pipe,id=charchannel1,path=/tmp/virtio-trace/trace-path-cpu0\
     -device virtserialport,bus=virtio-serial0.0,nr=2,chardev=charchannel1,\
      id=channel1,name=trace-path-cpu0\
 ##9pfs path##
     -device virtio-serial \
     -chardev socket,path=/tmp/virtio-trace/trace-9pfs,server,nowait, \
      id=trace-9pfs \
     -device virtserialport,chardev=trace-9pfs,name=virtioserial

If you manage guests with libvirt, add the following tags to domain XML files.
Then, libvirt passes the same command option to qemu.

        <channel type='pipe'>
           <source path='/tmp/virtio-trace/agent-ctl-path'/>
           <target type='virtio' name='agent-ctl-path'/>
           <address type='virtio-serial' controller='0' bus='0' port='0'/>
        </channel>
        <channel type='pipe'>
           <source path='/tmp/virtio-trace/trace-path-cpu0'/>
           <target type='virtio' name='trace-path-cpu0'/>
           <address type='virtio-serial' controller='0' bus='0' port='1'/>
        </channel>
	<channel type='unix'>
           <source mode='bind' path='/tmp/virtio-trace/trace-9pfs'/>
           <target type='virtio' name='trace-9pfs'/>
           <address type='virtio-serial' controller='0' bus='0' port='2'/>
        </channel>
Here, chardev names are restricted to trace-path-cpu0 and agent-ctl-path. UNIX
domain socket is automatically created on a host.

3. Boot the guest
 You can find some chardev in /dev/virtio-ports/ in the guest.

4. Create symbolic link for trace-cmd on the host
	# ln -s /tmp/virtio-trace/trace-path-cpu0.out \
	  /tmp/virtio-tracing/tracing/per_cpu/cpu0/trace_pipe_raw

5. Wait for 9pfs server on the host
	# mount -t 9p -o trans=unix,access=any,uname=root, \
	  aname=/sys/kernel/debug,version=9p2000.L \
	  /tmp/virtio-trace/trace-9pfs /tmp/virtio-trace/debugfs

6. Run DIOD on the guest
	# diod -E -Nn -u 0

7. Connect DIOD to virtio-console on the guest
	# socat TCP4:127.0.0.1:564 /dev/virtio-ports/trace-9pfs

- Execution
1. Run trace-agent on the guest
	# ./trace-agent

2. Execute trace-cmd on the host
	# AGENT_READ_DIR=/tmp/virtio-trace/tracing \
	  AGENT_CTL=/tmp/virtio-trace/agent-ctl-path.in \
	  TRACE_DIR=/tmp/virtio-trace/debugfs/tracing \
	  ./trace-cmd record -e "sched:*

3. Translate raw data to text data on the host
	# ./trace-cmd report trace.dat

***Just enhancement ideas***
 - Support for trace-cmd => done
 - Support for 9pfs protocol
 - Support for non-blocking mode in QEMU

Thank you,

---

Masami Hiramatsu (2):
      trace-cmd: Use tracing directory to count CPUs
      trace-cmd: Use TRACE_DIR envrionment variable if defined

Yoshihiro YUNOMAE (3):
      trace-cmd: Use polling function
      trace-cmd: Add non-blocking option for open() and splice_read()
      trace-cmd: Support trace-agent of virtio-trace


 trace-cmd.h      |    1 
 trace-record.c   |   41 ++++++++++++++++++++
 trace-recorder.c |  112 ++++++++++++++++++++++++++++++++++++++++++++++++------
 trace-util.c     |   27 +++++++++++++
 4 files changed, 169 insertions(+), 12 deletions(-)

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com

