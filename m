Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab0LAOhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 09:37:08 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40125 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab0LAOhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 09:37:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=XJ33LuLoplRwg5/41feTbJMi0bxY1oJpSN9lawc4l/LS3mYQQzIIlkn4MFas2tLLp1
         m5yLux5l/qkWolZ4jkqEiXt7varlKMqK8+1wJL5vsIiIqT5+5GPGj5X8WLyp3BbH6XpT
         e3y/tOwk1ToulfPpxnh94Ufldr8Npm2xLP+BI=
MIME-Version: 1.0
Date: Wed, 1 Dec 2010 15:37:04 +0100
Message-ID: <AANLkTimDVNfTavhLD9=yD=EYWASoRZQy9FCHkiLNgYFJ@mail.gmail.com>
Subject: timer.c - high load avarage with idle cpu
From: Harry Nak <harrynak@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am developing an application on a at91rm9200 platform. Recently I
found out that the load average on this system is very high while the
cpu remains almost idle.
My application uses a lot of timers but the expiration of such a timer
causes almost no processing to be performed.

I think I found the reason for this load average/cpu usage
inconsistency and I (think I ) found a solution:

update_process_times() in timer.c first calls the function
run_local_timers() before calling scheduler_tick().

run_local_timers() raises TIMER_SOFTIRQ, which causes threads
associated with any expired timers to be marked RUNNABLE.
scheduler_tick() -> update_cpu_load() -> calc_load_account_active() ->
calc_load_fold_active() adds such a thread to the number of active
threads, thus causing the load average to increase. However this
particular thread never had to wait to become running and it will not
consume much cpu time.

My solution is to postpone the call to run_local_timers() until
scheduler_tick() has been called.

Could anybody confirm my theory and is it possible that my solution
breaks anything?

- Harry
