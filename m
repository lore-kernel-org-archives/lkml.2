Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab1FNVRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 17:17:18 -0400
Received: from hawking.das.ufsc.br ([150.162.12.21]:45727 "EHLO
	hawking.das.ufsc.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab1FNVRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 17:17:16 -0400
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jun 2011 17:17:14 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 14 Jun 2011 18:11:32 -0300
From: xtarke <xtarke@das.ufsc.br>
To: <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?Q?stop=5Fmachine=20question?=
Message-ID: <88c177c8eb360c9d54583b5af504613a@das.ufsc.br>
User-Agent: Roundcube Webmail/0.5.1
X-das-MailScanner-ID: AF05D5FA32.5DCC7
X-das-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-das-MailScanner-SpamCheck: not spam (whitelisted),
	SpamAssassin (not cached, score=-2.9, required 7, autolearn=not spam,
	ALL_TRUSTED -1.00, BAYES_00 -1.90)
X-das-MailScanner-From: xtarke@das.ufsc.br
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Hi guys,

 I've been made some study in System Management Interrupts (SMI) using 
 Linux.  Looking into lwn.net, I found a module called "Hardware Latency 
 Detector (formerly SMI detector)"  written by Jon Masters a few years 
 ago, as Jon says (http://lwn.net/Articles/337018/):

 "This is a loadable module that grabs the CPU for
 configurable periods of time (all under stop_machine()) and samples the 
 TSC
 looking for discontinuity. If observed latencies exceed a threshold 
 (for
 example caused by an System Management Interrupt or similar) then the
 event is recorded in a global ring_buffer, readable via debugfs."

 I modified the module to grab the TSC directly as you can see in the 
 "get_sample" code below:

 static int get_sample(void *unused)
 {

 (...)

   do {
         t2 = ktime_get();

         rdtscll(tsc[1]);
 
         total = ktime_to_us(ktime_sub(t2, start)); /* sample width */
         //diff = ktime_to_us(ktime_sub(t2, t1));     /* current diff */

         diff = (s64)(tsc[1] - tsc[0]); /* tsc diff*/

         /* This shouldn't happen */
         if (diff < 0) {
             printk(KERN_ERR BANNER "time running backwards\n");
             goto out;
         }
 
 
         if (diff > data.threshold){
             overthrc++;
             sample = diff;    /* only want highest value */
             s.timestamp = tsc[1];
         }

         tsc[0] = tsc[1];

         count++;
 
    } while (total <= data.sample_width);

    (...)
 }

 The function get_sample is invoked by a kernel thread coded below:

 static int kthread_fn(void *unused)
 {
     (...)

 while (!kthread_should_stop()) {

         mutex_lock(&data.lock);

         err = stop_machine(get_sample, unused, &cpus);
         if (err) {
             /* Houston, we have a problem */
             mutex_unlock(&data.lock);
             goto err_out;
         }

         interval = data.sample_window - data.sample_width;
         do_div(interval, USEC_PER_MSEC); /* modifies interval value */

         mutex_unlock(&data.lock);

         if (data.count > data.max_count){
                     enabled = 0;
                     stop_kthread();
                     wake_up(&data.wq);
                     data.count = 0;
                 }

         if (msleep_interruptible(interval))
             goto out;
 (...)

 }

 Running this code in kernel 2.6.37.6 (Slackware 13.37) there is a huge 
 discontinuity,  (diff = (s64)(tsc[1] - tsc[0])), about 25000 cycles, 
 just when I run this code with a msleep_interruptible() in the kernel 
 thread. When I remove it, the problem disappears. Moreover, the 
 discontinuity appears always in the same time in the get_sample's while 
 and never in the first execution of the kthread_fn's while. The kernel 
 trace doesn't shows get_sample to be interrupted.

 My question, is possible to some kernel code run inside stop_machine? 
 In other words, why get_sample seems to be interrupted when I use a 
 sleep?

 Any help will be apreeciated.

 Thanks a lot,

 Renan Augusto Starke

 processor       : 0
 vendor_id       : GenuineIntel
 cpu family      : 6
 model           : 15
 model name      : Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz
 stepping        : 2
 cpu MHz         : 2133.336
 cache size      : 2048 KB

 The system is a Dell Optiplex 745.

 Xtarke under Slackware 13.1
 Linux user ID #354257
