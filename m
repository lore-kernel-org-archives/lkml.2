Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab0JKG05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 02:26:57 -0400
Received: from ns0.wincor-nixdorf.com ([80.154.98.130]:50854 "EHLO
	mxpdbe2.wincor-nixdorf.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362Ab0JKG05 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 02:26:57 -0400
Message-ID: <4CB2ADB1.6070401@wincor-nixdorf.com>
Date: Mon, 11 Oct 2010 08:24:49 +0200
From: Frank Salomon <frank.salomon@wincor-nixdorf.com>
Reply-To: frank.salomon@wincor-nixdorf.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.4) Gecko/20030624 
    Netscape/7.1
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: driver or calculation of load average wrong ?
Content-Type: text/plain; charset="ISO-8859-1"; format="flowed"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

I have the following configuration:
- CentOS 5
- kernel 2.6.20.1
- My own driver in a kernel_thread:
		while ( 1 ){
			printk ( KERN_INFO "go sleep, %lu\n", jiffies );
			current -> state = TASK_UNINTERRUPTIBLE;
			schedule_timeout ( msecs_to_jiffies(4000) );
			printk ( KERN_INFO "wakeup, %lu\n", jiffies );
		}

Each time I load the driver, the load average in /proc/loadavg reached:
	$ cat /proc/loadavg
	0.99 0.62 0.26 1/47 2868
Without my driver:
	$ cat /proc/loadavg
	0.03 0.03 0.00 1/47 2867

I changed nr_active(void) in kernel/sched.c:
unsigned long nr_active(void)
{
          unsigned long i, running = 0, uninterruptible = 0;

          for_each_online_cpu(i) {
                  running += cpu_rq(i)->nr_running;
                  uninterruptible += cpu_rq(i)->nr_uninterruptible;
          }

          if (unlikely((long)uninterruptible < 0))
                  uninterruptible = 0;

// original:     return running + uninterruptible;
          return running;
}

Driver loaded or not:
	$ cat /proc/loadavg
	0.03 0.03 0.00 1/47 2867

Any help or comments would be really great?

Best regards, thanks, Frank
-- 
WINCOR NIXDORF International GmbH
Retail Store Solutions
Heinz-Nixdorf-Ring 1
33106 Paderborn
Tel. +49 (0) 30 5017 1335
Fax +49 (0) 30 5017 1305
mail frank.salomon@wincor-nixdorf.com


WINCOR NIXDORF International GmbH
Sitz der Gesellschaft: Paderborn
Registergericht Paderborn HRB 3507
Geschäftsführer: Eckard Heidloff (Vorsitzender), Stefan Auerbach, Dr. Jürgen Wunram
Vorsitzender des Aufsichtsrats: Karl-Heinz Stiller
Steuernummer: 339/5884/0020 - Ust-ID Nr.: DE812927716 - WEEE-Reg.-Nr. DE44477193

Diese E-Mail enthält vertrauliche Informationen.
Wenn Sie nicht der richtige Adressat sind oder diese E-Mail irrtümlich erhalten haben,
informieren Sie bitte sofort den Absender und vernichten Sie diese E-Mail.
Das unerlaubte Kopieren sowie die unbefugte Weitergabe dieser E-Mail ist nicht gestattet.

This e-mail may contain confidential information.
If you are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail.
Any unauthorised copying, disclosure or distribution of the material in this e-mail is strictly forbidden.
