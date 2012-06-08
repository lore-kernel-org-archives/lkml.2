Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964856Ab2FHVDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 17:03:33 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40141 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934509Ab2FHVDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 17:03:23 -0400
MIME-Version: 1.0
Date: Fri, 8 Jun 2012 14:03:22 -0700
Message-ID: <CAH5vBdJ3ZHkK5qoW9Wj+jp=rgZ2Hio4fCdJMLR2cTuMAi6eVCA@mail.gmail.com>
Subject: [migration/0] used 90% of CPU ?
From: cheng renquan <crquan@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with v3.4.0; happening after resume, but not immediately, maybe 10
minutes after resume,
I'm not sure if it's related after resuming;

$ ps fu -e |awk 'NR <=2 || /[m]igration/'
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         2  0.0  0.0      0     0 ?        S    Jun07   0:00 [kthreadd]
root         6 90.7  0.0      0     0 ?        S    Jun07 1133:40  \_
[migration/0]
root     18299  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[migration/1]
root     18302  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[migration/2]
root     18305  0.0  0.0      0     0 ?        S    13:05   0:00  \_
[migration/3]

$ ps f -o uid,pid,%cpu,rss,stat,bsdstart,bsdtime,wchan:18,cmd -p
1,2,6,18299,18302,18305,$$
  UID   PID %CPU   RSS STAT  START   TIME WCHAN              CMD
 1000 24855  0.0  2508 Ss    13:52   0:00 wait               -bash
    0     2  0.0     0 S     17:04   0:00 kthreadd           [kthreadd]
    0     6 90.7     0 S     17:04 1133:40 cpu_stopper_thread  \_ [migration/0]
    0 18299  0.0     0 S     13:05   0:00 cpu_stopper_thread  \_ [migration/1]
    0 18302  0.0     0 S     13:05   0:00 cpu_stopper_thread  \_ [migration/2]
    0 18305  0.0     0 S     13:05   0:00 cpu_stopper_thread  \_ [migration/3]
    0     1  0.0   720 Ss    17:04   0:01 poll_schedule_time init [5]


I think the reason here is why pid:6 [migration/0]'s stime becomes 6802075 ?

some seconds ago, it was still a few hundreds, like suddenly increased
to 6802075,
equals 1133 minutes, 90% of the system uptime;

              stime %lu   Amount of time that this process has been  scheduled
                          in  kernel  mode, measured in clock ticks (divide by
                          sysconf(_SC_CLK_TCK).


$ cat /proc/{1,2,6,18299,18302,18305,$$}/stat |cut -d ' ' -f-17
1 (init) S 0 1 1 0 -1 4202752 258 1364571 14 769 18 82 76381 27261
2 (kthreadd) S 0 0 0 0 -1 2129984 0 0 0 0 0 2 0 0
6 (migration/0) S 2 0 0 0 -1 69238848 0 0 0 0 0 6802075 0 0
18299 (migration/1) S 2 0 0 0 -1 69238848 0 0 0 0 0 0 0 0
18302 (migration/2) S 2 0 0 0 -1 69238848 0 0 0 0 0 0 0 0
18305 (migration/3) S 2 0 0 0 -1 69238848 0 0 0 0 0 0 0 0
24855 (bash) S 2574 24855 24855 34820 25116 4202496 1435 5803 0 1 8 0 7 8
