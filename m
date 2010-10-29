Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab0J2Gpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 02:45:50 -0400
Received: from rt-pi1-ru-sssup.pi1.garr.net ([193.206.136.46]:26584 "EHLO
	sssup.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754323Ab0J2Gpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 02:45:45 -0400
Subject: [RFC][PATCH 22/22] sched: add sched_dl documentation
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1288333128.8661.137.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BsKmMhJledqtAduNlEgG"
Date: Fri, 29 Oct 2010 08:45:34 +0200
Message-ID: <1288334734.8661.164.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BsKmMhJledqtAduNlEgG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable


Add in Documentation/scheduler/ some hints about the design
choices, the usage and the future possible developments of the
sched_dl scheduling class and of the SCHED_DEADLINE policy.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 Documentation/scheduler/sched-deadline.txt |  147 ++++++++++++++++++++++++=
++++
 1 files changed, 147 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/scheduler/sched-deadline.txt

diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/sch=
eduler/sched-deadline.txt
new file mode 100644
index 0000000..e795968
--- /dev/null
+++ b/Documentation/scheduler/sched-deadline.txt
@@ -0,0 +1,147 @@
+			Deadline Task and Group Scheduling
+			----------------------------------
+
+CONTENTS
+=3D=3D=3D=3D=3D=3D=3D=3D
+
+0. WARNING
+1. Overview
+2. Task scheduling
+2. The interface
+3. Bandwidth management
+  3.1 System wide settings
+  2.2 Task interface
+  2.4 Default behavior
+3. Future plans
+
+
+0. WARNING
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+ Fiddling with these settings can result in an unpredictable or even unsta=
ble
+ system behavior. As for -rt (group) scheduling, it is assumed that root
+ knows what he is doing.
+
+
+1. Overview
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+ The SCHED_DEADLINE policy contained inside the sched_dl scheduling class =
is
+ basically an implementation of the Earliest Deadline First (EDF) scheduli=
ng
+ algorithm, augmented with a mechanism (called Constant Bandwidth Server, =
CBS)
+ that make it possible to isolate the behaviour of tasks between each othe=
r.
+
+
+2. Task scheduling
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+ The typical -deadline task will be made up of a computation phase (instan=
ce)
+ which is activated on a periodic or sporadic fashion. The expected (maxim=
um)
+ duration of such computation is called the task's runtime; the time inter=
val
+ by which each instance need to be completed is called the task's relative
+ deadline. The task's absolute deadline is dynamically calculated as the
+ time instant a task (better, an instance) activates plus the relative
+ deadline.
+
+ The EDF algorithms selects the task with the smallest absolute deadline a=
s
+ the one to be executed first, while the CBS ensures each task to run for
+ at most the its runtime every (relative) deadline length time interval,
+ avoiding any interference between different tasks (bandwidth isolation).
+ Thanks to this feature, also tasks that do not strictly comply with the
+ computational model sketched above can effectively use the new policy.
+ IOW, there are no limitations on what kind of task can exploit this new
+ scheduling discipline, even if it must be said that it is particularly
+ suited for periodic or sporadic tasks that need guarantees on their
+ timing behaviour, e.g., multimedia, streaming, control applications, etc.
+
+
+3. Bandwidth management
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+ In order of -deaadline scheduling to be effective and useful, it is impor=
tant
+ that some method of having the allocation of the available CPU bandwidth =
to
+ the tasks under control.
+ This is usually called "admission control" and if it is not performed at =
all,
+ no guarantee can be given on the actual scheduling of the -deadline tasks=
.
+
+ Since when RT-throttling has been introduced each task group have a bandw=
idth
+ associated to itself, calculated as a certain amount of runtime over a pe=
riod.
+ Moreover, to make it possible to manipulate such bandwidth, readable/writ=
able
+ controls have been added to both procfs (for system wide settings) and cg=
roupfs
+ (for per-group settings).
+ Therefore, the same interface is being used for controlling the bandwidth
+ distrubution to -deadline tasks and task groups, i.e., new controls but w=
ith
+ similar names, equivalent meaning and with the same usage paradigm are ad=
ded.
+
+ However, more discussion is needed in order to figure out how we want to =
manage
+ SCHED_DEADLINE bandwidth at the task group level. Therefore, SCHED_DEADLI=
NE uses
+ (for now) a less sophisticated, but actually very sensible, machanism to =
ensure
+ that a certain utilization cap is not overcome per each root_domain.
+
+ Another main difference between deadline bandwidth management and RT-thro=
ttling
+ is that -deadline tasks have bandwidth on their own (while -rt ones doesn=
't!),
+ and thus we don't need an higher level throttling mechanism to enforce th=
e
+ desired bandwidth.
+
+3.1 System wide settings
+------------------------
+
+The system wide settings are configured under the /proc virtual file syste=
m:
+
+ The per-group controls that are added to the cgroupfs virtual file system=
 are:
+  * /proc/sys/kernel/sched_dl_runtime_us,
+  * /proc/sys/kernel/sched_dl_period_us,
+
+ They accepts (if written) and provides (if read) the new runtime and peri=
od,
+ respectively, for each CPU in each root_domain.
+
+ This means that, for a root_domain comprising M CPUs, -deadline tasks
+ can be created until the sum of their bandwidths stay below:
+
+   M * (sched_dl_runtime_us / sched_dl_period_us)
+
+ It is also possible to disable this bandwidth management logic, and
+ be thus free of oversubscribing the system up to any arbitrary level.
+ This is done by writing -1 in /proc/sys/kernel/sched_dl_runtime_us.
+
+
+2.2 Task interface
+------------------
+
+ Specifying a periodic/sporadic task that executes for a given amount of
+ runtime at each instance, and that is scheduled according to the usrgency=
 of
+ their own timing constraints needs, in general, a way of declaring:
+  - a (maximum/typical) instance execution time,
+  - a minimum interval between consecutive instances,
+  - a time constraint by which each instance must be completed.
+
+ Therefore:
+  * a new struct sched_param_ex, containing all the necessary fields is
+    provided;
+  * the new scheduling related syscalls that manipulate it, i.e.,
+    sched_setscheduler_ex(), sched_setparam_ex() and sched_getparam_ex()
+    are implemented.
+
+
+2.4 Default behavior
+---------------------
+
+The default values for SCHED_DEADLINE bandwidth is to have dl_runtime and
+dl_period equal to 500000 and 1000000, respectively. This means -deadline
+tasks can use at most 5%, multiplied by the number of CPUs that compose th=
e
+root_domain, for each root_domain.
+
+When a -deadline task fork a child, its dl_runtime is set to 0, which mean=
s
+someone must call sched_setscheduler_ex() on it, or it won't even start.
+
+
+3. Future plans
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Still Missing parts:
+
+ - refinements in deadline inheritance, especially regarding the possibili=
ty
+   of retaining bandwidth isolation among non-interacting tasks. This is
+   being studied from both theoretical and practical point of views, and
+   hopefully we can have some demonstrative code soon.
+
--=20
1.7.2.3


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-BsKmMhJledqtAduNlEgG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkzKbY4ACgkQk4XaBE3IOsSqkwCggxJcVWHMntHwNTwN56qaxdmY
DtMAoIDH+VCgeQdI0HhMXFexTz66VIOz
=nFKm
-----END PGP SIGNATURE-----

--=-BsKmMhJledqtAduNlEgG--

