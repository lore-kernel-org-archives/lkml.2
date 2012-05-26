Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab2EZNfs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:35:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45600 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab2EZNfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:35:47 -0400
Date: Sat, 26 May 2012 06:34:13 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 0/5] Function tracing support for pstore
Message-ID: <20120526133412.GA18001@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

With this support kernel can save functions call chain log into a
persistent ram buffer that can be decoded and dumped after reboot
through pstore filesystem. It can be used to determine what function
was last called before a hang or an unexpected reset (caused by, for
example, a buggy driver that abuses HW).

Here's a "nano howto", to get the idea:

 # mount -t debugfs debugfs /sys/kernel/debug/
 # cd /sys/kernel/debug/tracing
 # echo persistent > current_tracer
 # reboot -f
 [...]
 # mount -t pstore pstore /mnt/
 # tail /mnt/ftrace-ramoops
 0 ffffffff8101ea64  ffffffff8101bcda  native_apic_mem_read <- disconnect_bsp_APIC+0x6a/0xc0
 0 ffffffff8101ea44  ffffffff8101bcf6  native_apic_mem_write <- disconnect_bsp_APIC+0x86/0xc0
 0 ffffffff81020084  ffffffff8101a4b5  hpet_disable <- native_machine_shutdown+0x75/0x90
 0 ffffffff81005f94  ffffffff8101a4bb  iommu_shutdown_noop <- native_machine_shutdown+0x7b/0x90
 0 ffffffff8101a6a1  ffffffff8101a437  native_machine_emergency_restart <- native_machine_restart+0x37/0x40
 0 ffffffff811f9876  ffffffff8101a73a  acpi_reboot <- native_machine_emergency_restart+0xaa/0x1e0
 0 ffffffff8101a514  ffffffff8101a772  mach_reboot_fixups <- native_machine_emergency_restart+0xe2/0x1e0
 0 ffffffff811d9c54  ffffffff8101a7a0  __const_udelay <- native_machine_emergency_restart+0x110/0x1e0
 0 ffffffff811d9c34  ffffffff811d9c80  __delay <- __const_udelay+0x30/0x40
 0 ffffffff811d9d14  ffffffff811d9c3f  delay_tsc <- __delay+0xf/0x20

Mostly the code comes from trace_persistent.c driver found in the
Android git tree, written by Colin Cross <ccross@android.com>
(according to sign-off history). I reworked the driver a little bit,
and ported it to pstore subsystem.

The patches depend on a pile of other pstore-related work, so
if anyone is willing to try the patches, they would rather grab
the whole git tree:
	git://git.infradead.org/users/cbou/linux-pstore.git
or gitweb:
	http://git.infradead.org/users/cbou/linux-pstore.git


Note that so far I've tried to not change the original idea, but if
we consider inclusion, there are some open questions:

1. Should we merge persistent tracer with normal function tracer,
   i.e. add some flag that makes function tracer to duplicate the
   events into pstore (via a callback to pstore)?

2. If we keep the two separate, should the code live in fs/pstore
   or kernel/trace?.. I can see valid points for both approaches.

Thanks,

---
 Documentation/ramoops.txt  |   24 +++++++++
 fs/pstore/Kconfig          |   12 +++++
 fs/pstore/Makefile         |    6 +++
 fs/pstore/ftrace.c         |  122 ++++++++++++++++++++++++++++++++++++++++++++
 fs/pstore/inode.c          |  111 ++++++++++++++++++++++++++++++++++++++--
 fs/pstore/internal.h       |   49 ++++++++++++++++++
 fs/pstore/platform.c       |   13 ++++-
 fs/pstore/ram.c            |   54 +++++++++++++++-----
 include/linux/pstore.h     |    5 ++
 include/linux/pstore_ram.h |    1 +
 kernel/trace/trace.c       |    7 +--
 11 files changed, 384 insertions(+), 20 deletions(-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
