Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760523Ab2EDWtR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:49:17 -0400
Received: from defout.telus.net ([204.209.205.32]:62545 "EHLO defout.telus.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757285Ab2EDWtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:49:16 -0400
X-Greylist: delayed 1293 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 May 2012 18:49:15 EDT
X-Authority-Analysis: v=1.1 cv=CahIzEM66sRduNWDROnMkgwu8o1gouh8ANYbdw+6K0U=
 c=1 sm=2 a=OwUyLCURGuUA:10 a=LGgl8L9ij00A:10 a=danhDmx_AAAA:8
 a=ag1SF4gXAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=z1H5ADGQAAAA:8
 a=JfrnYn6hAAAA:8 a=aatUQebYAAAA:8 a=HTcZWkJnAAAA:8 a=pGLkceISAAAA:8
 a=z5wP7CvIfAqVn-Z0yi8A:9 a=UhGd5CkwNN6GWlwmD48A:7 a=QEXdDO2ut3YA:10
 a=1TSTQ8KKaH4A:10 a=jbrJJM5MRmoA:10 a=3Rfx1nUSh_UA:10 a=rBKJJ2Jc0C4A:10
 a=mYwiVMoDH04A:10 a=MSl-tDqOz04A:10 a=d_ZXZpSNwmoHNu36Wf8A:9
X-Telus-Outbound-IP: 209.121.28.192
From: "Doug Smythies" <dsmythies@telus.net>
To: "'Greg KH'" <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>,
        =?utf-8?B?J0xlc8OF77+9YXcgS29wZcSHJw==?= 
	<leslaw.kopec@nasza-klasa.pl>,
        "'Aman Gupta'" <aman@tmm1.net>,
        "'Peter Zijlstra'" <a.p.zijlstra@chello.nl>,
        "'Ingo Molnar'" <mingo@elte.hu>,
        "'Kerin Millar'" <kerframil@gmail.com>,
        "Doug Smythies" <dsmythies@telus.net>
References: <20120504204258.GA12552@kroah.com> <20120504204229.151017761@linuxfoundation.org>
In-Reply-To: <20120504204229.151017761@linuxfoundation.org>
Subject: RE: [ 56/75] sched: Fix nohz load accounting -- again!
Date: Fri, 4 May 2012 15:03:00 -0700
Message-ID: <001601cd2a41$c83798a0$58a6c9e0$@net>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0017_01CD2A07.1BD8C0A0"
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac0qNwdwpLFeRbiZQOSGItIltjnT7AABRfiQ
Content-Language: en-ca
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0017_01CD2A07.1BD8C0A0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Just earlier this morning, an issue was raised against this patch on the =
related thread on Ubuntu launchpad.
The complaint is that reported load averages are now to high under =
conditions of "high" frequency enter into / exit from cpu idle =
conditions where the cpu is very lightly loaded.
Most of the testing I did was with medium to heavy load on the cpu and =
relatively short idle periods. This is the opposite.
For a quick test, I hacked up my test program, and was able to reproduce =
the issue.
I am still attempting to understand better and also determine the lower =
bound to "high" frequency (I think it is 25 Hertz, and scales from there =
down, but no proof yet). I'll also go backwards and test this scenario =
without the patch. I'll let this list know the results, but it might be =
a few days.
My quick test results are attached.

Doug Smythies

References (even though I have been told not to include links in e-mails =
to this list):

https://bugs.launchpad.net/ubuntu/+source/linux/+bug/838811 <<< starting =
from post #52

version:
doug@s15:~/c$ uname -a
Linux s15 3.2.0-24-generic #37-Ubuntu SMP Wed Apr 25 08:43:22 UTC 2012 =
x86_64 x86_64 x86_64 GNU/Linux
doug@s15:~/c$ cat /proc/version
Linux version 3.2.0-24-generic (buildd@yellow) (gcc version 4.6.3 =
(Ubuntu/Linaro 4.6.3-1ubuntu5) ) #37-Ubuntu SMP Wed Apr 25 08:43:22 UTC =
2012

-----Original Message-----
From: Greg KH [mailto:gregkh@linuxfoundation.org]=20
Sent: May-04-2012 13:43
To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
Cc: torvalds@linux-foundation.org; akpm@linux-foundation.org; =
alan@lxorguk.ukuu.org.uk; Doug Smythies; Les=C3=85=EF=BF=BDaw =
Kope=C4=87; Aman Gupta; Peter Zijlstra; Ingo Molnar; Kerin Millar
Subject: [ 56/75] sched: Fix nohz load accounting -- again!

3.3-stable review patch.  If anyone has any objections, please let me =
know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit c308b56b5398779cd3da0f62ab26b0453494c3d4 upstream.

Various people reported nohz load tracking still being wrecked, but Doug =
spotted the actual problem. We fold the nohz remainder in too soon, =
causing us to loose samples and under-account.

So instead of playing catch-up up-front, always do a single load-fold =
with whatever state we encounter and only then fold the nohz remainder =
and play catch-up.

Reported-by: Doug Smythies <dsmythies@telus.net>
Reported-by: Les=C3=85=3D82aw Kope=3DC4=3D87 =
<leslaw.kopec@nasza-klasa.pl>
Reported-by: Aman Gupta <aman@tmm1.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: =
http://lkml.kernel.org/n/tip-4v31etnhgg9kwd6ocgx3rxl8@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Kerin Millar <kerframil@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/core.c |   53 =
+++++++++++++++++++++++++---------------------------
 1 file changed, 26 insertions(+), 27 deletions(-)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2266,13 +2266,10 @@ calc_load_n(unsigned long load, unsigned
  * Once we've updated the global active value, we need to apply the =
exponential
  * weights adjusted to the number of cycles missed.
  */
-static void calc_global_nohz(unsigned long ticks)
+static void calc_global_nohz(void)
 {
 	long delta, active, n;
=20
-	if (time_before(jiffies, calc_load_update))
-		return;
-
 	/*
 	 * If we crossed a calc_load_update boundary, make sure to fold
 	 * any pending idle changes, the respective CPUs might have @@ =
-2284,31 +2281,25 @@ static void calc_global_nohz(unsigned lo
 		atomic_long_add(delta, &calc_load_tasks);
=20
 	/*
-	 * If we were idle for multiple load cycles, apply them.
+	 * It could be the one fold was all it took, we done!
 	 */
-	if (ticks >=3D LOAD_FREQ) {
-		n =3D ticks / LOAD_FREQ;
+	if (time_before(jiffies, calc_load_update + 10))
+		return;
=20
-		active =3D atomic_long_read(&calc_load_tasks);
-		active =3D active > 0 ? active * FIXED_1 : 0;
+	/*
+	 * Catch-up, fold however many we are behind still
+	 */
+	delta =3D jiffies - calc_load_update - 10;
+	n =3D 1 + (delta / LOAD_FREQ);
=20
-		avenrun[0] =3D calc_load_n(avenrun[0], EXP_1, active, n);
-		avenrun[1] =3D calc_load_n(avenrun[1], EXP_5, active, n);
-		avenrun[2] =3D calc_load_n(avenrun[2], EXP_15, active, n);
+	active =3D atomic_long_read(&calc_load_tasks);
+	active =3D active > 0 ? active * FIXED_1 : 0;
=20
-		calc_load_update +=3D n * LOAD_FREQ;
-	}
+	avenrun[0] =3D calc_load_n(avenrun[0], EXP_1, active, n);
+	avenrun[1] =3D calc_load_n(avenrun[1], EXP_5, active, n);
+	avenrun[2] =3D calc_load_n(avenrun[2], EXP_15, active, n);
=20
-	/*
-	 * Its possible the remainder of the above division also crosses
-	 * a LOAD_FREQ period, the regular check in calc_global_load()
-	 * which comes after this will take care of that.
-	 *
-	 * Consider us being 11 ticks before a cycle completion, and us
-	 * sleeping for 4*LOAD_FREQ + 22 ticks, then the above code will
-	 * age us 4 cycles, and the test in calc_global_load() will
-	 * pick up the final one.
-	 */
+	calc_load_update +=3D n * LOAD_FREQ;
 }
 #else
 void calc_load_account_idle(struct rq *this_rq) @@ -2320,7 +2311,7 @@ =
static inline long calc_load_fold_idle(v
 	return 0;
 }
=20
-static void calc_global_nohz(unsigned long ticks)
+static void calc_global_nohz(void)
 {
 }
 #endif
@@ -2348,8 +2339,6 @@ void calc_global_load(unsigned long tick  {
 	long active;
=20
-	calc_global_nohz(ticks);
-
 	if (time_before(jiffies, calc_load_update + 10))
 		return;
=20
@@ -2361,6 +2350,16 @@ void calc_global_load(unsigned long tick
 	avenrun[2] =3D calc_load(avenrun[2], EXP_15, active);
=20
 	calc_load_update +=3D LOAD_FREQ;
+
+	/*
+	 * Account one period with whatever state we found before
+	 * folding in the nohz state and ageing the entire idle period.
+	 *
+	 * This avoids loosing a sample when we go idle between
+	 * calc_load_account_active() (10 ticks ago) and now and thus
+	 * under-accounting.
+	 */
+	calc_global_nohz();
 }
=20
 /*



------=_NextPart_000_0017_01CD2A07.1BD8C0A0
Content-Type: text/plain;
	name="high01.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="high01.txt"

Doug Smythies 2012.05.04 CPU's enter and exit idle at high frequencies. =
but with very very low actual utilization.
The majority of previous testing was very high utilization.

Excerpt from "Top"

top - 11:57:04 up 1 day, 15:28,  3 users,  load average: 0.91, 0.87, =
0.76
Tasks: 144 total,   2 running, 142 sleeping,   0 stopped,   0 zombie
Cpu0  :  0.9%us,  8.8%sy,  0.0%ni, 90.2%id,  0.0%wa,  0.0%hi,  0.0%si,  =
0.0%st
Cpu1  :  1.0%us,  4.8%sy,  0.0%ni, 94.3%id,  0.0%wa,  0.0%hi,  0.0%si,  =
0.0%st
Cpu2  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  =
0.0%st
Cpu3  :  0.3%us,  0.3%sy,  0.0%ni, 99.3%id,  0.0%wa,  0.0%hi,  0.0%si,  =
0.0%st
Cpu4  :  0.7%us,  0.0%sy,  0.0%ni, 99.3%id,  0.0%wa,  0.0%hi,  0.0%si,  =
0.0%st
Cpu5  :  0.0%us,  0.0%sy,  0.0%ni,100.0%id,  0.0%wa,  0.0%hi,  0.0%si,  =
0.0%st
Cpu6  :  0.3%us,  2.6%sy,  0.0%ni, 97.0%id,  0.0%wa,  0.0%hi,  0.0%si,  =
0.0%st
Cpu7  :  0.3%us,  0.3%sy,  0.0%ni, 99.3%id,  0.0%wa,  0.0%hi,  0.0%si,  =
0.0%st
Mem:   7956400k total,  1591044k used,  6365356k free,   292288k buffers
Swap:  8294396k total,        0k used,  8294396k free,   882488k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
15970 doug      20   0  4156   88    0 S    2  0.0   0:23.23 waiter
15972 doug      20   0  4156   88    0 S    2  0.0   0:23.24 waiter
15968 doug      20   0  4156   88    0 S    2  0.0   0:23.30 waiter
15971 doug      20   0  4156   88    0 S    2  0.0   0:23.36 waiter
15969 doug      20   0  4156   88    0 S    1  0.0   0:23.51 waiter
15986 doug      20   0 17332 1332  960 R    1  0.0   0:01.24 top
    1 root      20   0 24724 2616 1344 S    0  0.0   0:01.42 init

Similar excerpt from test program output. Note: TOP resource time =3D =
user cpu + sys cpu times.

Child  0 lp  706 of 9999: Elapsed:1411.97 s. Delta:   2.00 s. user cpu:  =
 5.03 s. sys cpu:  18.46 s. last sleep freq.: 250.000 Hz. average sleep =
freq.: 250.005 Hz.
Child  1 lp  706 of 9999: Elapsed:1411.98 s. Delta:   2.00 s. user cpu:  =
 5.38 s. sys cpu:  18.31 s. last sleep freq.: 250.000 Hz. average sleep =
freq.: 250.004 Hz.
Child  2 lp  706 of 9999: Elapsed:1411.97 s. Delta:   2.00 s. user cpu:  =
 5.02 s. sys cpu:  18.39 s. last sleep freq.: 250.000 Hz. average sleep =
freq.: 250.005 Hz.
Child  3 lp  706 of 9999: Elapsed:1411.97 s. Delta:   2.00 s. user cpu:  =
 5.23 s. sys cpu:  18.35 s. last sleep freq.: 250.000 Hz. average sleep =
freq.: 250.005 Hz.
Child  4 lp  706 of 9999: Elapsed:1411.97 s. Delta:   2.00 s. user cpu:  =
 5.25 s. sys cpu:  18.22 s. last sleep freq.: 250.000 Hz. average sleep =
freq.: 250.005 Hz.
Child  0 lp  707 of 9999: Elapsed:1413.97 s. Delta:   2.00 s. user cpu:  =
 5.04 s. sys cpu:  18.47 s. last sleep freq.: 250.000 Hz. average sleep =
freq.: 250.005 Hz.
Child  1 lp  707 of 9999: Elapsed:1413.98 s. Delta:   2.00 s. user cpu:  =
 5.39 s. sys cpu:  18.34 s. last sleep freq.: 250.000 Hz. average sleep =
freq.: 250.004 Hz.
Child  2 lp  707 of 9999: Elapsed:1413.97 s. Delta:   2.00 s. user cpu:  =
 5.02 s. sys cpu:  18.41 s. last sleep freq.: 250.000 Hz. average sleep =
freq.: 250.005 Hz.
Child  3 lp  707 of 9999: Elapsed:1413.97 s. Delta:   2.00 s. user cpu:  =
 5.24 s. sys cpu:  18.38 s. last sleep freq.: 250.000 Hz. average sleep =
freq.: 250.005 Hz.
Child  4 lp  707 of 9999: Elapsed:1413.97 s. Delta:   2.00 s. user cpu:  =
 5.26 s. sys cpu:  18.24 s. last sleep freq.: 250.000 Hz. average sleep =
freq.: 250.005 Hz.

Resource math: ~23.5 seconds / 1414 seconds * 5 occurances ~~=3D 0.08 =
real load average.=20

Similar output from vmstat (but it was running at a different time than =
above):
(While I have a relatively high context switch rate and interrupt rate =
in this example, the issue exists over a wide range)

doug@s15:~/c$ vmstat -n 10 10
procs -----------memory---------- ---swap-- -----io---- -system-- =
----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy =
id wa
 1  0      0 6366016 292320 882488    0    0     1     1    7   12  0  0 =
100  0
 0  0      0 6366008 292320 882488    0    0     0     0 1319 2693  1  2 =
98  0
 0  0      0 6366008 292320 882488    0    0     0     0 1270 2541  0  0 =
100  0
 0  0      0 6366008 292324 882488    0    0     0     1 1268 2542  0  0 =
100  0
 0  0      0 6366008 292324 882488    0    0     0     0 1313 2678  1  1 =
98  0
 0  0      0 6366008 292324 882488    0    0     0     0 1306 2677  0  1 =
98  0
 0  0      0 6366008 292324 882488    0    0     0     0 1339 2773  0  3 =
97  0
 0  0      0 6366008 292324 882488    0    0     0     0 1347 2828  0  3 =
96  0
 0  0      0 6366008 292324 882488    0    0     0     0 1324 2721  0  2 =
98  0
 0  0      0 6366008 292328 882488    0    0     0     1 1341 2811  0  3 =
97  0

------=_NextPart_000_0017_01CD2A07.1BD8C0A0--


