Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab2EXDvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 23:51:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21398 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2EXDvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 23:51:06 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=KyWxpwrltrkA:10 a=5SG0PmZfjMsA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8 a=eyxFRtE9eyDmbLhVd08A:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=UTB_XpHje0EA:10 a=jeBq3FmKZ4MA:10 a=awMDHk0ZrKvBXxw_:21 a=wnYPXBWZwpPE0ki3:21 a=gbZTrWTAdGJ2Ra4yuiUA:9 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337831458.13348.173.camel@gandalf.stny.rr.com>
Subject: [PATCH][GIT PULL][v3.5] ring-buffer: Check for valid buffer before
 changing size
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Wed, 23 May 2012 23:50:58 -0400
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Ad26MPKpymmRds17Hrbs"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ad26MPKpymmRds17Hrbs
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable


Ingo,

Testing one of my boxes I stumbled over this bug. It was added with the
ring buffer size changes that was pushed in this merge window. To
trigger it, you need to run one of the latency tracers (wakeup, irqsoff,
etc) on a box that reports more CPUs than it physically has. This is why
it passed my initial tests, because I did not run them on this
particular box.

-- Steve


Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: 6a31e1f135d1abfb5137697f889c8cd5d72eb522


Steven Rostedt (1):
      ring-buffer: Check for valid buffer before changing size

----
 kernel/trace/ring_buffer.c |    5 +++++
 1 file changed, 5 insertions(+)
---------------------------
commit 6a31e1f135d1abfb5137697f889c8cd5d72eb522
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed May 23 15:35:17 2012 -0400

    ring-buffer: Check for valid buffer before changing size
   =20
    On some machines the number of possible CPUS is not the same as the
    number of CPUs that is on the machine. Ftrace uses possible_cpus to
    update the tracing structures but the ring buffer only allocates
    per cpu buffers for online CPUs when they come up.
   =20
    When the wakeup tracer was enabled in such a case, the ftrace code
    enabled all possible cpu buffers, but the code in ring_buffer_resize()
    did not check to see if the buffer in question was allocated. Since
    boot up CPUs did not match possible CPUs it caused the following
    crash:
   =20
    BUG: unable to handle kernel NULL pointer dereference at 00000020
    IP: [<c1097851>] ring_buffer_resize+0x16a/0x28d
    *pde =3D 00000000
    Oops: 0000 [#1] PREEMPT SMP
    Dumping ftrace buffer:
       (ftrace buffer empty)
    Modules linked in: [last unloaded: scsi_wait_scan]
   =20
    Pid: 1387, comm: bash Not tainted 3.4.0-test+ #13                  /DG9=
65MQ
    EIP: 0060:[<c1097851>] EFLAGS: 00010217 CPU: 0
    EIP is at ring_buffer_resize+0x16a/0x28d
    EAX: f5a14340 EBX: f6026b80 ECX: 00000ff4 EDX: 00000ff3
    ESI: 00000000 EDI: 00000002 EBP: f4275ecc ESP: f4275eb0
     DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
    CR0: 80050033 CR2: 00000020 CR3: 34396000 CR4: 000007d0
    DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
    DR6: ffff0ff0 DR7: 00000400
    Process bash (pid: 1387, ti=3Df4274000 task=3Df4380cb0 task.ti=3Df42740=
00)
    Stack:
     c109cf9a f6026b98 00000162 00160f68 00000006 00160f68 00000002 f4275ef=
0
     c109d013 f4275ee8 c123b72a c1c0bf00 c1cc81dc 00000005 f4275f98 0000000=
7
     f4275f70 c109d0c7 7700000e 75656b61 00000070 f5e90900 f5c4e198 0000030=
1
    Call Trace:
     [<c109cf9a>] ? tracing_set_tracer+0x115/0x1e9
     [<c109d013>] tracing_set_tracer+0x18e/0x1e9
     [<c123b72a>] ? _copy_from_user+0x30/0x46
     [<c109d0c7>] tracing_set_trace_write+0x59/0x7f
     [<c10ec01e>] ? fput+0x18/0x1c6
     [<c11f8732>] ? security_file_permission+0x27/0x2b
     [<c10eaacd>] ? rw_verify_area+0xcf/0xf2
     [<c10ec01e>] ? fput+0x18/0x1c6
     [<c109d06e>] ? tracing_set_tracer+0x1e9/0x1e9
     [<c10ead77>] vfs_write+0x8b/0xe3
     [<c10ebead>] ? fget_light+0x30/0x81
     [<c10eaf54>] sys_write+0x42/0x63
     [<c1834fbf>] sysenter_do_call+0x12/0x28
   =20
    This happens with the latency tracer as the ftrace code updates the
    saved max buffer via its cpumask and not with a global setting.
   =20
    Adding a check in ring_buffer_resize() to make sure the buffer being re=
sized
    exists, fixes the problem.
   =20
    Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 6420cda..1d0f6a8 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1486,6 +1486,11 @@ int ring_buffer_resize(struct ring_buffer *buffer, u=
nsigned long size,
 	if (!buffer)
 		return size;
=20
+	/* Make sure the requested buffer exists */
+	if (cpu_id !=3D RING_BUFFER_ALL_CPUS &&
+	    !cpumask_test_cpu(cpu_id, buffer->cpumask))
+		return size;
+
 	size =3D DIV_ROUND_UP(size, BUF_PAGE_SIZE);
 	size *=3D BUF_PAGE_SIZE;
=20


--=-Ad26MPKpymmRds17Hrbs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPvbAjAAoJEIy3vGnGbaoAb4MP+wV3J/6OyO9Qys50pfjJBTFw
WPElWdoDWV5R1kICsYQwhmTpNIjE+j9LhJZsyscfVj68ONq0fkY53gXUdAFcw4LE
xgnXPL66BEGES6r4ReqzDWNTCKK1Kr26VxDrX5oLg150b9HXT9PhIFqkh4qXFZo2
ndvLUP2WJo7m14l5UIevM1g/UfeMjX9cwBNrvggJq3s3eFq3sFyXLkiKy4JfhZYW
EdcNKZL3cXGDmz4FaqQpF4qu7Iu2fGelHoys5QETWpLm69UuZfG1P5xWqAkEPxZF
j15n5mLBwbuN6z1cih4E2V79xSdO/HW00A3a5CAPME1JL+zF/UsB+E6m5WBdYZIh
ma4d8aPXH8B1h4pJlVtEkv0nt6D3i8dDsgt29LWqfktm8+0+huHTy6XiAc3Brv7g
yl58670+ZXU+0/PJ91U5HKqknKOAOjibeHiITjbdap1YXC8AHy74wpOFF0aVJZ54
1hXZpCKG0JJR6WC6p0bpsSXguZ2MjgTzhpbXKgK4u89Pk8Brcp5i2zBuxQYab36W
e2R4K2Zzp0K5kizoHibotba6GdIUKvOfaNnxoQZOc2hF9qQQeCPg6ezDPUjNd5WJ
7vDolZHS557WVtYLGI9wWD0GAGU3JZStTXQYST3bMwihmp/ws6ZhXNWUTiQARkGB
6zbYvz4NnN9X6VGaWXkG
=L/Ni
-----END PGP SIGNATURE-----

--=-Ad26MPKpymmRds17Hrbs--

