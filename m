Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab0JVCTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 22:19:45 -0400
Received: from mail.perches.com ([173.55.12.10]:3445 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab0JVCTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 22:19:44 -0400
Subject: [RFC PATCH] include/linux/kernel.h: Add config option for
 pr_fmt(fmt)
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 21 Oct 2010 19:19:42 -0700
Message-ID: <1287713982.16920.39.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the default #define pr_fmt(fmt) from:
	- #define pr_fmt(fmt) fmt
to:
	- #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

This will standard use of prefixes and prevent the
addition of new #defines when using pr_<level>.

Adds a config option to use the old style if desired.

This adds prefixes to 326 strings in an x86 defconfig.
Broken out by subsystem/module, the prefixes are:

     10 acpi                
      2 act_api             
      2 af_inet             
      6 af_packet           
     22 apic                
      1 apic_noop           
      2 blktrace            
      1 boot                
      4 calibrate           
      1 centaur             
      2 cleanup             
      1 common              
      2 dev                 
      1 devinet             
     17 edac_mce_amd        
      1 ehci_hcd            
      1 fb                  
     13 generic             
      9 hibernate           
      2 i2c_algo_bit        
      1 io_delay            
      1 ip6table_filter     
      1 iptable_filter      
      2 iptable_nat         
      3 ipv6                
      2 irq                 
      8 kexec               
      5 libphy              
     19 main                
      2 manage              
     11 mce                 
      2 mount               
      1 msr                 
      5 nf_conntrack_ipv4   
      7 nf_conntrack_ipv6   
      4 nf_conntrack_netlink
      2 nfnetlink           
      2 nfnetlink_log       
      1 ohci_hcd            
      5 oom_kill            
      1 pcieportdrv         
      9 percpu              
     21 perf_event          
      1 pid                 
      2 platform            
      2 probe_32            
      1 rtc_cmos            
      2 setup               
      1 setup_bus           
      1 skbuff              
      1 sleep               
      8 smpboot             
      4 snapshot            
      3 suspend             
      6 swap                
      1 tcp_ipv4            
      8 trace               
     14 trace_events        
     26 trace_kprobe        
      3 trace_sched_switch  
      1 trace_stat          
      3 tsc_sync            
     10 usbcore             
      2 usb_storage         
     10 vgaarb              
      1 xt_state 

Some of these add useful info, others are redundant
and can and will be trivially fixed by adding either
a new line to #define pr_fmt(fmt) fmt to the sources
or by removing the internal prefix strings in the
existing pr_<level> calls.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/kernel.h |    4 ++++
 init/Kconfig           |   10 ++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 1759ba5..9cb2e8f 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -409,8 +409,12 @@ static inline char *pack_hex_byte(char *buf, u8
byte)
 extern int hex_to_bin(char ch);
 
 #ifndef pr_fmt
+#ifdef CONFIG_PR_FMT_IS_KBUILD_MODNAME
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+#else
 #define pr_fmt(fmt) fmt
 #endif
+#endif
 
 #define pr_emerg(fmt, ...) \
         printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
diff --git a/init/Kconfig b/init/Kconfig
index 7b920aa..a406d1c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -897,6 +897,16 @@ config PRINTK
 	  very difficult to diagnose system problems, saying N here is
 	  strongly discouraged.
 
+config PR_FMT_IS_KBUILD_MODNAME
+	default y
+	depends on PRINTK
+	bool "Use KBUILD_MODNAME as prefix for pr_<level>"
+	help
+	  This option sets the default pr_fmt to KBUILD_MODNAME.
+	  This will prefix all pr_<level> logging message calls with the
+	  build system defined value unless there is an existing define
+	  of pr_fmt in the source code.
+
 config BUG
 	bool "BUG() support" if EMBEDDED
 	default y


