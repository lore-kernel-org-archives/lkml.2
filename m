Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab1C3Lm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 07:42:59 -0400
Received: from 216-146-103-100.dsl.nemontel.net ([216.146.103.100]:49545 "EHLO
	silka.with-linux.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab1C3Lm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 07:42:58 -0400
X-Greylist: delayed 666 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Mar 2011 07:42:57 EDT
Message-ID: <4D9314A1.7030106@silka.with-linux.com>
Date: Wed, 30 Mar 2011 05:31:45 -0600
From: Kelly Anderson <kelly@silka.with-linux.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110309 Thunderbird/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-sound@vger.kernel.org
Subject: 2.6.38+ hard lockup in pcm_lib.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had a consistent hard-lockup on one of my machines, an Amd X6, just 
after Kdm loaded the desktop (most certainly when it decides to start 
talking to the sound card).  Everything was dead, even ssh access to the 
computer.  I git bisected it until I found the commit that was causing 
it.  After reverting the patch everything is fine.  This is the only one 
of four computers that had the problem.  Here's the revert patch (so I 
can get some expert eyeballs looking at what may be the problem).

--- ./sound/core/pcm_lib.c.orig    2011-03-27 12:37:20.000000000 -0600
+++ ./sound/core/pcm_lib.c    2011-03-30 03:34:50.222400089 -0600
@@ -375,22 +375,6 @@ static int snd_pcm_update_hw_ptr0(struct
      }

      if (runtime->no_period_wakeup) {
-        /*
-         * Without regular period interrupts, we have to check
-         * the elapsed time to detect xruns.
-         */
-        jdelta = jiffies - runtime->hw_ptr_jiffies;
-        if (jdelta < runtime->hw_ptr_buffer_jiffies / 2)
-            goto no_delta_check;
-        hdelta = jdelta - delta * HZ / runtime->rate;
-        while (hdelta > runtime->hw_ptr_buffer_jiffies / 2 + 1) {
-            delta += runtime->buffer_size;
-            hw_base += runtime->buffer_size;
-            if (hw_base >= runtime->boundary)
-                hw_base = 0;
-            new_hw_ptr = hw_base + pos;
-            hdelta -= runtime->hw_ptr_buffer_jiffies;
-        }
          goto no_delta_check;
      }



59ff878ffb26bc0be812ca8295799164f413ae88 is the first bad commit
commit 59ff878ffb26bc0be812ca8295799164f413ae88
Author: Clemens Ladisch
Date:   Thu Nov 18 09:43:52 2010 +0100

     ALSA: pcm: detect xruns in no-period-wakeup mode

     When period wakeups are disabled, successive calls to the pointer 
update
     function do not have a maximum allowed distance, so xruns cannot be
     detected with the pointer value only.

     To detect xruns, compare the actually elapsed time with the time that
     should have theoretically elapsed since the last update.  When the
     hardware pointer has wrapped around due to an xrun, the actually 
elapsed
     time will be too big by about hw_ptr_buffer_jiffies.

     Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
     Signed-off-by: Takashi Iwai <tiwai@suse.de>

:040000 040000 5daac6baa3aaecbe4a030955a1cfe9714178019a 
94f07701413dff5712c8fa5e60d93ef909864cc0 M    sound

