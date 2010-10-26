Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603Ab0JZJDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 05:03:44 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:25307 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab0JZJDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 05:03:43 -0400
Date: Tue, 26 Oct 2010 11:03:35 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [RFC PATCH] include/linux/kernel.h: Add config option for 
 pr_fmt(fmt)
Message-ID: <20101026110335.3a4c7679@endymion.delvare>
In-Reply-To: <1287713982.16920.39.camel@Joe-Laptop>
References: <1287713982.16920.39.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Thu, 21 Oct 2010 19:19:42 -0700, Joe Perches wrote:
> Change the default #define pr_fmt(fmt) from:
> 	- #define pr_fmt(fmt) fmt
> to:
> 	- #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> This will standard use of prefixes and prevent the
> addition of new #defines when using pr_<level>.

I'm all for it!

> Adds a config option to use the old style if desired.

Not sure what the idea is. Once  pr_fmt() includes the module name, we
will drop hard-coded prefixes in all log messages throughout the kernel
tree. Once this is done, a kernel built with PR_FMT_IS_KBUILD_MODNAME=n
would become horribly confusing.

So I wouldn't add any configuration option. Doing so is likely to add
to confusion more than help.

> This adds prefixes to 326 strings in an x86 defconfig.

How relevant is the x86 defconfig? It doesn't include any
hardware-specific driver, does it? This is where I would expect the
greater count of pr_*() calls. For example, I have 15 hits in
drivers/hwmon, and 8 in drivers/i2c.

I've used the following grep to find them: grep -I 'pr_[a-z]*([^"]'

Let me know if you have anything better.

> Broken out by subsystem/module, the prefixes are:
> 
>      10 acpi                
>       2 act_api             
>       2 af_inet             
>       6 af_packet           
>      22 apic                
>       1 apic_noop           
>       2 blktrace            
>       1 boot                
>       4 calibrate           
>       1 centaur             
>       2 cleanup             
>       1 common              
>       2 dev                 
>       1 devinet             
>      17 edac_mce_amd        
>       1 ehci_hcd            
>       1 fb                  
>      13 generic             
>       9 hibernate           
>       2 i2c_algo_bit        
>       1 io_delay            
>       1 ip6table_filter     
>       1 iptable_filter      
>       2 iptable_nat         
>       3 ipv6                
>       2 irq                 
>       8 kexec               
>       5 libphy              
>      19 main                
>       2 manage              
>      11 mce                 
>       2 mount               
>       1 msr                 
>       5 nf_conntrack_ipv4   
>       7 nf_conntrack_ipv6   
>       4 nf_conntrack_netlink
>       2 nfnetlink           
>       2 nfnetlink_log       
>       1 ohci_hcd            
>       5 oom_kill            
>       1 pcieportdrv         
>       9 percpu              
>      21 perf_event          
>       1 pid                 
>       2 platform            
>       2 probe_32            
>       1 rtc_cmos            
>       2 setup               
>       1 setup_bus           
>       1 skbuff              
>       1 sleep               
>       8 smpboot             
>       4 snapshot            
>       3 suspend             
>       6 swap                
>       1 tcp_ipv4            
>       8 trace               
>      14 trace_events        
>      26 trace_kprobe        
>       3 trace_sched_switch  
>       1 trace_stat          
>       3 tsc_sync            
>      10 usbcore             
>       2 usb_storage         
>      10 vgaarb              
>       1 xt_state 
> 
> Some of these add useful info, others are redundant
> and can and will be trivially fixed by adding either
> a new line to #define pr_fmt(fmt) fmt to the sources
> or by removing the internal prefix strings in the
> existing pr_<level> calls.

Hopefully the latter, otherwise the effort to standardize the log
messages will fail.

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  include/linux/kernel.h |    4 ++++
>  init/Kconfig           |   10 ++++++++++
>  2 files changed, 14 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index 1759ba5..9cb2e8f 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -409,8 +409,12 @@ static inline char *pack_hex_byte(char *buf, u8
> byte)
>  extern int hex_to_bin(char ch);
>  
>  #ifndef pr_fmt
> +#ifdef CONFIG_PR_FMT_IS_KBUILD_MODNAME
> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> +#else
>  #define pr_fmt(fmt) fmt
>  #endif
> +#endif
>  
>  #define pr_emerg(fmt, ...) \
>          printk(KERN_EMERG pr_fmt(fmt), ##__VA_ARGS__)
> diff --git a/init/Kconfig b/init/Kconfig
> index 7b920aa..a406d1c 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -897,6 +897,16 @@ config PRINTK
>  	  very difficult to diagnose system problems, saying N here is
>  	  strongly discouraged.
>  
> +config PR_FMT_IS_KBUILD_MODNAME
> +	default y
> +	depends on PRINTK
> +	bool "Use KBUILD_MODNAME as prefix for pr_<level>"
> +	help
> +	  This option sets the default pr_fmt to KBUILD_MODNAME.
> +	  This will prefix all pr_<level> logging message calls with the
> +	  build system defined value unless there is an existing define
> +	  of pr_fmt in the source code.
> +
>  config BUG
>  	bool "BUG() support" if EMBEDDED
>  	default y
> 

-- 
Jean Delvare
