Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab1DABeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 21:34:05 -0400
Received: from 216-146-103-100.dsl.nemontel.net ([216.146.103.100]:37452 "EHLO
	silka.with-linux.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab1DABeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 21:34:04 -0400
Message-ID: <4D952B76.7000201@silka.with-linux.com>
Date: Thu, 31 Mar 2011 19:33:42 -0600
From: Kelly Anderson <kelly@silka.with-linux.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110309 Thunderbird/3.1.9
MIME-Version: 1.0
To: "Christopher K." <c.krooss@googlemail.com>
CC: Clemens Ladisch <clemens@ladisch.de>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: Linux 2.6.38 freeze because of sound/core/pcm_lib.c commit 59ff878ffb26bc0be812ca8295799164f413ae88
References: <AANLkTin17=rCU4eDGYtnVFZ1ffbUn+var4Q_AQUuGKaw@mail.gmail.com>	<4D946C73.4090402@ladisch.de> <AANLkTinyRqEa_ML47DOqAJU8aLDEA12geiUUrPGjXHrN@mail.gmail.com> <4D94F728.60609@silka.with-linux.com>
In-Reply-To: <4D94F728.60609@silka.with-linux.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/11 15:50, Kelly Anderson wrote:
>
> Just to let you know.  I'm using a gtx460 also.  I haven't had a 
> chance to reboot into the newly patched kernel yet.  It is interesting 
> that we both have gtx460's.  I have a machine with a gtx430 that 
> doesn't seem to exhibit the problem.
>
> cat /etc/modprobe.d/snd_hda_intel.conf
>
> options snd-hda-intel probe_mask=-1,0xa
>
OK, I debugged the problem and came up with a solution.  The bottom line 
is that it's a problem with a signed to unsigned compare.  First the fix:

--- ./sound/core/pcm_lib.c.orig    2011-03-27 12:37:20.000000000 -0600
+++ ./sound/core/pcm_lib.c    2011-03-31 19:01:35.392739127 -0600
@@ -379,17 +379,17 @@ static int snd_pcm_update_hw_ptr0(struct
           * Without regular period interrupts, we have to check
           * the elapsed time to detect xruns.
           */
-        jdelta = jiffies - runtime->hw_ptr_jiffies;
-        if (jdelta < runtime->hw_ptr_buffer_jiffies / 2)
+        jdelta = (snd_pcm_sframes_t)(jiffies - runtime->hw_ptr_jiffies);
+        if (jdelta < (snd_pcm_sframes_t)runtime->hw_ptr_buffer_jiffies / 2)
              goto no_delta_check;
          hdelta = jdelta - delta * HZ / runtime->rate;
-        while (hdelta > runtime->hw_ptr_buffer_jiffies / 2 + 1) {
+        while (hdelta > 
(snd_pcm_sframes_t)runtime->hw_ptr_buffer_jiffies / 2 + 1) {
              delta += runtime->buffer_size;
              hw_base += runtime->buffer_size;
              if (hw_base >= runtime->boundary)
                  hw_base = 0;
              new_hw_ptr = hw_base + pos;
-            hdelta -= runtime->hw_ptr_buffer_jiffies;
+            hdelta -= (snd_pcm_sframes_t)runtime->hw_ptr_buffer_jiffies;
          }
          goto no_delta_check;
      }

And here's the patch I used to debug the problem:

--- ./sound/core/pcm_lib.c.orig    2011-03-27 12:37:20.000000000 -0600
+++ ./sound/core/pcm_lib.c    2011-03-31 18:44:23.701411841 -0600
@@ -379,18 +379,31 @@ static int snd_pcm_update_hw_ptr0(struct
           * Without regular period interrupts, we have to check
           * the elapsed time to detect xruns.
           */
+        int loopCount = 0;
+        BUG_ON(runtime->hw_ptr_jiffies < 0);
+        BUG_ON(runtime->hw_ptr_jiffies == 0);
+        BUG_ON(runtime->hw_ptr_jiffies > jiffies);
          jdelta = jiffies - runtime->hw_ptr_jiffies;
          if (jdelta < runtime->hw_ptr_buffer_jiffies / 2)
              goto no_delta_check;
          hdelta = jdelta - delta * HZ / runtime->rate;
-        while (hdelta > runtime->hw_ptr_buffer_jiffies / 2 + 1) {
+        printk(KERN_INFO "Before loop: jdelta=%ld, hdelta=%ld 
runtime->hw_ptr_buffer_jiffies=%lu\n"
+                        , jdelta , hdelta , 
runtime->hw_ptr_buffer_jiffies);
+        while (hdelta > runtime->hw_ptr_buffer_jiffies / 2 + 1) {
              delta += runtime->buffer_size;
              hw_base += runtime->buffer_size;
              if (hw_base >= runtime->boundary)
                  hw_base = 0;
              new_hw_ptr = hw_base + pos;
-            hdelta -= runtime->hw_ptr_buffer_jiffies;
+            hdelta -= runtime->hw_ptr_buffer_jiffies;
+            if (++loopCount >= 1024*1024*4)
+            {
+                printk(KERN_INFO "stopped the madness at 4 thousand\n");
+                break;
+            }
          }
+        printk(KERN_INFO "After loop: jdelta=%ld, hdelta=%ld 
runtime->hw_ptr_buffer_jiffies=%lu\n"
+                        , jdelta , hdelta , 
runtime->hw_ptr_buffer_jiffies);
          goto no_delta_check;
      }


The kernel output with the testing patch applied:

Mar 31 18:37:02 speedy kernel: Before loop: jdelta=352, hdelta=352 
runtime->hw_ptr_buffer_jiffies=371
Mar 31 18:37:02 speedy kernel: stopped the madness at 4 million
Mar 31 18:37:02 speedy kernel: After loop: jdelta=352, 
hdelta=-1556086432 runtime->hw_ptr_buffer_jiffies=371


