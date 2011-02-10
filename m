Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256Ab1BJFsX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 00:48:23 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36049
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751055Ab1BJFsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 00:48:22 -0500
Date: Wed, 09 Feb 2011 21:48:57 -0800 (PST)
Message-Id: <20110209.214857.189691158.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Linux 2.6.38-rc4 (other bugs: x25)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110209205842.c25aa64a.randy.dunlap@oracle.com>
References: <20110209093656.2b23b80b.randy.dunlap@oracle.com>
	<20110209.140115.183045242.davem@davemloft.net>
	<20110209205842.c25aa64a.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Wed, 9 Feb 2011 20:58:42 -0800

> Here's what I captured before the system hung and the beeper stayed
> on constantly.  ;)

:-)

> [  303.931229] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
> [  303.934923] last sysfs file: /sys/devices/pci0000:00/0000:00:1d.1/usb6/6-1/6-1.3/devnum
> [  303.934923] CPU 1 
> [  303.934923] Modules linked in: x25(-) af_packet nfsd lockd nfs_acl auth_rpcgss exportfs sunrpc ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT xt_tcpudp nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables x_tables ipv6 cpufreq_ondemand acpi_cpufreq freq_table mperf binfmt_misc dm_mirror dm_region_hash dm_log dm_multipath scsi_dh dm_mod joydev mousedev evdev mac_hid snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device usbmouse usbkbd usbhid snd_pcm hid snd_timer sr_mod tg3 pcspkr rtc_cmos dcdbas sg snd iTCO_wdt cdrom i2c_i801 rtc_core processor iTCO_vendor_support rtc_lib 8250_pnp soundcore thermal_sys intel_agp button intel_gtt snd_page_alloc hwmon unix ide_pci_generic ide_core ata_generic pata_acpi ata_piix sd_mod crc_t10dif ext3 jbd mbcache uhci_hcd ohci_hcd ssb mmc_core pcmcia pcmcia_core firmware_class ehci_hcd usbcore nls_base [last unloaded: microcode]
> [  303.934923] 
> [  303.934923] Pid: 2573, comm: rmmod Not tainted 2.6.38-rc4 #3 0TY565/OptiPlex 745                 
> [  303.934923] RIP: 0010:[<ffffffffa069c131>]  [<ffffffffa069c131>] x25_link_free+0x41/0x81 [x25]

Ok, a GPF in x25_link_free().

This code simply traverses the x25_neigh_list, unlinking and releasing
each entry it finds.

Every node entry which is added to this list is dynamically allocated
entry.  See x25_link_device_up(), which is the only place where a
list_add() is performed on the x25_neigh_list.

The device should be accessible and the dev_put() should not cause
trouble because we grabbed a reference to this device when
x25_link_device_up() added the new x25_neigh to the list.

I can't see anything here that should barf like this.

I also can't see anything "const" in the x25 protocol code that might
be trampled upon.

I'm assuming in all of this that it's a write to a read-only location
which is causing this GPF, via CONFIG_DEBUG_RODATA.

Playing around with config options and looking at the various x86_64 asm
in these different cases seems to suggest that it's indeed the dev_put()
that is causing the GPF.

Network devices use per-cpu refcounts.

We know that at some point in the past, the ref bump worked, because
we did a dev_hold() when we added the referencing x25_neigh entry to
the list.

For some reason now it fails.

RAX is where the per-cpu base pointer should be, and in your dump
that's:

[  303.934923] RAX: 6b6b6b6b6b6b6b6b RBX: ffffffffa06a03d0 RCX: 0010000000004040

Which is the SLAB free poison value.

So it seems like the network device at nb->dev has been freed for some
reason.

Weird....

Oh, the bug is obvious... 'nb' is freed right before we 'nb->dev', duh.

Please try this fix:

--------------------
x25: Do not reference freed memory.

In x25_link_free(), we destroy 'nb' before dereferencing
'nb->dev'.  Don't do this, because 'nb' might be freed
by then.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/x25/x25_link.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/x25/x25_link.c b/net/x25/x25_link.c
index 4cbc942..2130692 100644
--- a/net/x25/x25_link.c
+++ b/net/x25/x25_link.c
@@ -396,9 +396,12 @@ void __exit x25_link_free(void)
 	write_lock_bh(&x25_neigh_list_lock);
 
 	list_for_each_safe(entry, tmp, &x25_neigh_list) {
+		struct net_device *dev;
+
 		nb = list_entry(entry, struct x25_neigh, node);
+		dev = nb->dev;
 		__x25_remove_neigh(nb);
-		dev_put(nb->dev);
+		dev_put(dev);
 	}
 	write_unlock_bh(&x25_neigh_list_lock);
 }
-- 
1.7.4

