Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab2GJAMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 20:12:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57007 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab2GJAMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 20:12:03 -0400
Date: Mon, 9 Jul 2012 17:10:04 -0700
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
Subject: [PATCH v4 0/8] Function tracing support for pstore
Message-ID: <20120710001004.GA22744@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

In v4:
- A few cosmetic changes in func_set_flag(), as suggested by Steven
  Rostedt. Firstly, in the patch that adds pstore option, I use
  'else if' for the new bit (it keeps changes minimal), but then there
  is a new separate patch (the last in the series) that converts the
  whole thing into a switch construction.

In v3:
- Make traces versioned, as suggested by Steven, Tony and Colin. (The
  version tag is stored in the PRZ signature, see the last patch for
  the implementation details).
- Add Steven's Ack on the first patch.

In v2:
- Do not introduce a separate 'persistent' tracer, but introduce an
  option to the existing 'function' tracer.

Rationale for this patch set:

With this support kernel can save functions call chain log into a
persistent ram buffer that can be decoded and dumped after reboot
through pstore filesystem. It can be used to determine what function
was last called before a hang or an unexpected reset (caused by, for
example, a buggy driver that abuses HW).

Here's a "nano howto", to get the idea:

 # mount -t debugfs debugfs /sys/kernel/debug/
 # cd /sys/kernel/debug/tracing
 # echo function > current_tracer
 # echo 1 > options/func_pstore
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

---
 Documentation/ramoops.txt      |   25 +++++++++
 fs/pstore/Kconfig              |   13 +++++
 fs/pstore/Makefile             |    1 +
 fs/pstore/ftrace.c             |   35 +++++++++++++
 fs/pstore/inode.c              |  111 ++++++++++++++++++++++++++++++++++++++--
 fs/pstore/internal.h           |   43 ++++++++++++++++
 fs/pstore/platform.c           |   12 ++++-
 fs/pstore/ram.c                |   65 +++++++++++++++++------
 fs/pstore/ram_core.c           |   12 +++--
 include/linux/pstore.h         |   13 +++++
 include/linux/pstore_ram.h     |    3 +-
 kernel/trace/trace.c           |    7 +--
 kernel/trace/trace_functions.c |   36 +++++++++----
 13 files changed, 337 insertions(+), 39 deletions(-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
