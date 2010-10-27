Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab0J0K72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:59:28 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37457 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab0J0K70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:59:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WAP7FE2dHsgRlOqUSNBSQZl/gkCyL8SqNf2IUmhwE6tESkPebWyqppF/gvP9n56Z0x
         AepC3IN88hvSPEXg+yYLPAVREB/OSCRm3gtKSaSY77Ze4d9CMVL6tT9lCRS98aSRWON8
         dDQgQYHdb6g6RdioAOvfLn2pn/vBeTc5/ca3g=
From: Wu Zhangjin <wuzhangjin@gmail.com>
To: rostedt@goodmis.org, Ralf Baechle <ralf@linux-mips.org>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Cc: John Reiser <jreiser@bitwagon.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        David Daney <ddaney@caviumnetworks.com>,
        Wu Zhangjin <wuzhangjin@gmail.com>
Subject: [PATCH 0/3] Add C version of recordmcount for MIPS
Date: Wed, 27 Oct 2010 18:59:06 +0800
Message-Id: <cover.1288176026.git.wuzhangjin@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wu Zhangjin <wuzhangjin@gmail.com>

This patchset adds the C Version of recordmcount for MIPS, it includes the
necessary fixups for the MIPS64 support and module support of the old
recordmcount.c.

To add MIPS64 support, John has introduced function pointers which can be
overriden by specific e_machine(.e.g. EM_MIPS, EM_xx) in do_file() of
scripts/recordmcount.c. this method helps a lot, when migrating from the old
Perl recordmcount, the left Archs may possibly apply this method to add their
specific support. Maciej has simplified the MIPS specific ELF64_Rel.r_info and
the related functions.

The module support for MIPS is such a good application of John's method, it
adds MIPS_is_fake_mcount() to filter one of the two _mcount symbol of the long
mcount call, a function pointer: is_fake_mcount() points to the default 'empty'
fn_is_fake_mcount(), we overrides it by MIPS_is_fake_mcount() for EM_MIPS in
do_file().

At last, HAVE_C_RECORDMCOUNT is selected for MIPS to enable the C version of
recordmcount.

The whole support has been tested on my YeeLoong laptop(MIPS, Litten Endian),
including: 32bit kernel and moduels, 64bit kernel and modules.

Here is part of the testing log:

-------

root@yeeloong:~# lsmod
Module                  Size  Used by
yeeloong_laptop        16142  0 
sparse_keymap           3803  1 yeeloong_laptop
hwmon                   1841  1 yeeloong_laptop
backlight               5627  1 yeeloong_laptop
power_supply            9512  1 yeeloong_laptop
output                  2524  1 yeeloong_laptop

1. 32bit kernel and module

root@yeeloong:~# uname -a
Linux yeeloong 2.6.36-ftrace+ #71 PREEMPT Wed Oct 27 15:03:02 CST 2010 mips GNU/Linux
root@yeeloong:~# mount -t debugfs nodev /debug
root@yeeloong:~# echo function > /debug/tracing/current_tracer
root@yeeloong:~# echo 1 > /debug/tracing/tracing_enabled
root@yeeloong:~# sleep 1
root@yeeloong:~# echo 0 > /debug/tracing/tracing_enabled
root@yeeloong:~# head -20 /debug/tracing/trace
# tracer: function
#
#	    TASK-PID	CPU#	TIMESTAMP  FUNCTION
#	       | |	 |	    |	      |
	    Xorg-1443  [000]   132.196336: remove_wait_queue <-poll_freewait
	    Xorg-1443  [000]   132.196337: fput <-poll_freewait
	    Xorg-1443  [000]   132.196338: remove_wait_queue <-poll_freewait
	    Xorg-1443  [000]   132.196339: fput <-poll_freewait
	    Xorg-1443  [000]   132.196340: remove_wait_queue <-poll_freewait
	    Xorg-1443  [000]   132.196341: fput <-poll_freewait
	    Xorg-1443  [000]   132.196342: remove_wait_queue <-poll_freewait
	    Xorg-1443  [000]   132.196343: fput <-poll_freewait
	    Xorg-1443  [000]   132.196344: remove_wait_queue <-poll_freewait
	    Xorg-1443  [000]   132.196345: fput <-poll_freewait
	    Xorg-1443  [000]   132.196346: remove_wait_queue <-poll_freewait
	    Xorg-1443  [000]   132.196347: fput <-poll_freewait
	    Xorg-1443  [000]   132.196348: remove_wait_queue <-poll_freewait
	    Xorg-1443  [000]   132.196349: fput <-poll_freewait
	    Xorg-1443  [000]   132.196351: poll_select_copy_remaining <-sys_select
	    Xorg-1443  [000]   132.196352: ktime_get_ts <-poll_select_copy_remaining
root@yeeloong:~# echo *yeeloong* > /debug/tracing/setKset_ftrace_filter
root@yeeloong:~# echo 1 > /debug/tracing/tracing_enabled
root@yeeloong:~# (Press Fn + Up/Down to trigger the functions in yeeloong_laptop module) 
root@yeeloong:~# echo 0 > /tracing/tracing_enabled
root@yeeloong:~# head -20 /debug/tracing/trace
# tracer: function
#
#	    TASK-PID	CPU#	TIMESTAMP  FUNCTION
#	       | |	 |	    |	      |
 hald-addon-gene-1397  [000]   168.904096: yeeloong_get_brightness <-backlight_show_actual_brightness
 hald-addon-gene-1397  [000]   170.414572: yeeloong_get_brightness <-backlight_show_actual_brightness
 hald-addon-gene-1397  [000]   170.625428: yeeloong_get_brightness <-backlight_show_actual_brightness
 hald-addon-gene-1397  [000]   170.806029: yeeloong_get_brightness <-backlight_show_actual_brightness
 hald-addon-gene-1397  [000]   170.977210: yeeloong_get_brightness <-backlight_show_actual_brightness
 hald-addon-gene-1397  [000]   171.262519: yeeloong_get_brightness <-backlight_show_actual_brightness
 hald-addon-gene-1397  [000]   171.271132: yeeloong_set_brightness <-backlight_store_brightness
 hald-addon-gene-1397  [000]   171.545363: yeeloong_get_brightness <-backlight_show_actual_brightness
 hald-addon-gene-1397  [000]   171.679358: yeeloong_get_brightness <-backlight_show_actual_brightness
 hald-addon-gene-1397  [000]   171.825652: yeeloong_get_brightness <-backlight_show_actual_brightness
 hald-addon-gene-1397  [000]   171.996121: yeeloong_get_brightness <-backlight_show_actual_brightness
 hald-addon-gene-1397  [000]   172.246240: yeeloong_get_brightness <-backlight_show_actual_brightness
 hald-addon-gene-1397  [000]   172.383859: yeeloong_get_brightness <-backlight_show_actual_brightness
 hald-addon-gene-1397  [000]   172.532963: yeeloong_get_brightness <-backlight_show_actual_brightness
 hald-addon-gene-1397  [000]   172.844048: yeeloong_get_brightness <-backlight_show_actual_brightness
 hald-addon-gene-1397  [000]   172.851410: yeeloong_set_brightness <-backlight_store_brightness
root@yeeloong:~# exit

2. 64bit kernel and module

root@yeeloong:~# uname -a
Linux yeeloong 2.6.36-ftrace+ #75 PREEMPT Wed Oct 27 16:12:20 CST 2010 mips64 GNU/Linux
root@yeeloong:~# mount -t debugfs nodev /debug
root@yeeloong:~# echo function > /debug/tracing/current_tracer 
root@yeeloong:~# echo 1 > /debug/tracing/tracing_enabled 
root@yeeloong:~# ls
[snip]
root@yeeloong:~# echo 0 > /debug/tracing/tracing_enabled 
root@yeeloong:~# cat /debug/tracing/trace | head -20
# tracer: function
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
          <idle>-0     [000]   389.507465: complete <-usb_stor_blocking_completion
          <idle>-0     [000]   389.507466: default_wake_function <-complete
          <idle>-0     [000]   389.507467: try_to_wake_up <-default_wake_function
          <idle>-0     [000]   389.507468: enqueue_task_fair <-try_to_wake_up
          <idle>-0     [000]   389.507469: T.1160 <-enqueue_task_fair
          <idle>-0     [000]   389.507470: check_preempt_curr_idle <-try_to_wake_up
          <idle>-0     [000]   389.507472: usb_free_urb <-usb_hcd_giveback_urb
          <idle>-0     [000]   389.507473: dma_pool_free <-qh_completions
          <idle>-0     [000]   389.507475: mod_timer <-scan_async
          <idle>-0     [000]   389.507476: usb_hcd_irq <-handle_IRQ_event
          <idle>-0     [000]   389.507477: ohci_irq <-usb_hcd_irq
          <idle>-0     [000]   389.507481: note_interrupt <-handle_level_irq
          <idle>-0     [000]   389.507482: compat_irq_unmask <-handle_level_irq
          <idle>-0     [000]   389.507483: enable_8259A_irq <-compat_irq_unmask
          <idle>-0     [000]   389.507484: irq_exit <-do_IRQ
          <idle>-0     [000]   389.507485: rcu_irq_exit <-irq_exit
root@yeeloong:~# echo *yeeloong* > /debug/tracing/set_ftrace_filter 
root@yeeloong:~# echo 1 > /debug/tracing/tracing_enabled 
root@yeeloong:~# (Press Fn + Up/Down here to trigger the kernel functions called in yeeloong_laptop module) 
root@yeeloong:~# echo 0 > /debug/tracing/tracing_enabled 
root@yeeloong:~# cat /debug/tracing/trace | head -20
# tracer: function
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
            hald-1378  [000]   414.479887: yeeloong_get_bat_props <-power_supply_show_property
            hald-1378  [000]   414.480143: yeeloong_get_bat_props <-power_supply_show_property
            hald-1378  [000]   414.480327: yeeloong_get_bat_props <-power_supply_show_property
            hald-1378  [000]   414.480486: yeeloong_get_bat_props <-power_supply_show_property
            hald-1378  [000]   414.480602: yeeloong_get_bat_props <-power_supply_show_property
            hald-1378  [000]   414.480741: yeeloong_get_bat_props <-power_supply_show_property
            hald-1378  [000]   414.480860: yeeloong_get_bat_props <-power_supply_show_property
         upowerd-1656  [000]   414.481609: yeeloong_get_bat_props <-power_supply_show_property
         upowerd-1656  [000]   414.482058: yeeloong_get_bat_props <-power_supply_show_property
         upowerd-1656  [000]   414.482185: yeeloong_get_bat_props <-power_supply_show_property
         upowerd-1656  [000]   414.482257: yeeloong_get_bat_props <-power_supply_show_property
         upowerd-1656  [000]   414.482333: yeeloong_get_bat_props <-power_supply_show_property
         upowerd-1656  [000]   414.482414: yeeloong_get_bat_props <-power_supply_show_property
 hald-addon-gene-1409  [000]   415.412442: yeeloong_get_brightness <-backlight_show_actual_brightness
 hald-addon-gene-1409  [000]   416.135571: yeeloong_get_brightness <-backlight_show_actual_brightness
 hald-addon-gene-1409  [000]   416.381292: yeeloong_get_brightness <-backlight_show_actual_brightness

--------

Thanks all.

Best Regards,
	Wu Zhangjin

Wu Zhangjin (3):
  ftrace/MIPS: Add MIPS64 support for C version of recordmcount
  ftrace/MIPS: Add module support for C version of recordmcount
  ftrace/MIPS: Enable C Version of recordmcount

 arch/mips/Kconfig      |    1 +
 scripts/recordmcount.c |   44 ++++++++++++++++++++++++
 scripts/recordmcount.h |   86 +++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 126 insertions(+), 5 deletions(-)

