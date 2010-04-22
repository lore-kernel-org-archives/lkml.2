Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117Ab0DVUDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:03:42 -0400
Received: from kroah.org ([198.145.64.141]:60091 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758158Ab0DVUB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:01:59 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:18 2010
Message-Id: <20100422195417.995921837@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:55:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Adam Lackorzynski <adam@os.inf.tu-dresden.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [126/139] powerpc: Fix SMP build with disabled CPU hotplugging.
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Adam Lackorzynski <adam@os.inf.tu-dresden.de>

commit 5b72d74ce2fccca2a301de60f31b16ddf5c93984 upstream.

Compiling 2.6.33 with SMP enabled and HOTPLUG_CPU disabled gives me the
following link errors:

  LD      init/built-in.o
  LD      .tmp_vmlinux1
arch/powerpc/platforms/built-in.o: In function `.smp_xics_setup_cpu':
smp.c:(.devinit.text+0x88): undefined reference to `.set_cpu_current_state'
smp.c:(.devinit.text+0x94): undefined reference to `.set_default_offline_state'
arch/powerpc/platforms/built-in.o: In function `.smp_pSeries_kick_cpu':
smp.c:(.devinit.text+0x13c): undefined reference to `.set_preferred_offline_state'
smp.c:(.devinit.text+0x148): undefined reference to `.get_cpu_current_state'
smp.c:(.devinit.text+0x1a8): undefined reference to `.get_cpu_current_state'
make: *** [.tmp_vmlinux1] Error 1

The following change fixes that for me and seems to work as expected.

Signed-off-by: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/platforms/pseries/offline_states.h |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/arch/powerpc/platforms/pseries/offline_states.h
+++ b/arch/powerpc/platforms/pseries/offline_states.h
@@ -9,10 +9,30 @@ enum cpu_state_vals {
 	CPU_MAX_OFFLINE_STATES
 };
 
+#ifdef CONFIG_HOTPLUG_CPU
 extern enum cpu_state_vals get_cpu_current_state(int cpu);
 extern void set_cpu_current_state(int cpu, enum cpu_state_vals state);
-extern enum cpu_state_vals get_preferred_offline_state(int cpu);
 extern void set_preferred_offline_state(int cpu, enum cpu_state_vals state);
 extern void set_default_offline_state(int cpu);
+#else
+static inline enum cpu_state_vals get_cpu_current_state(int cpu)
+{
+	return CPU_STATE_ONLINE;
+}
+
+static inline void set_cpu_current_state(int cpu, enum cpu_state_vals state)
+{
+}
+
+static inline void set_preferred_offline_state(int cpu, enum cpu_state_vals state)
+{
+}
+
+static inline void set_default_offline_state(int cpu)
+{
+}
+#endif
+
+extern enum cpu_state_vals get_preferred_offline_state(int cpu);
 extern int start_secondary(void);
 #endif


