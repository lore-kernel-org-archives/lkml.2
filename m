Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab2JRKjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:39:09 -0400
Received: from relay.parallels.com ([195.214.232.42]:43599 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab2JRKjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:39:07 -0400
From: Vladimir Davydov <VDavydov@parallels.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        Paul Turner <pjt@google.com>
CC: Kirill Korotaev <dev@parallels.com>, "devel@openvz.org" <devel@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 18 Oct 2012 14:39:01 +0400
Subject: Re: [Devel] [PATCH RFC] sched: boost throttled entities on wakeups
Thread-Topic: [Devel] [PATCH RFC] sched: boost throttled entities on wakeups
Thread-Index: Ac2tHMnV0WelkvcKQHSNtXAJ9sOgLw==
Message-ID: <4D93624F-5324-422B-B44C-8B65DBAA8106@parallels.com>
References: <206EF0C3-1F5F-4B58-B7DA-E63298939DFD@parallels.com>
In-Reply-To: <206EF0C3-1F5F-4B58-B7DA-E63298939DFD@parallels.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, ru-RU
Content-Type: multipart/mixed;
	boundary="_002_4D93624F5324422BB44C8B65DBAA8106parallelscom_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_4D93624F5324422BB44C8B65DBAA8106parallelscom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

There is an error in the test script: I forgot to initialize cpuset.mems of=
 test cgroups - without it it is impossible to add a task into a cpuset cgr=
oup.

Sorry for that.

Fixed version of the test script is attached.

On Oct 18, 2012, at 11:32 AM, Vladimir Davydov wrote:

> If several tasks in different cpu cgroups are contending for the same res=
ource
> (e.g. a semaphore) and one of those task groups is cpu limited (using cfs
> bandwidth control), the priority inversion problem is likely to arise: if=
 a cpu
> limited task goes to sleep holding the resource (e.g. trying to take anot=
her
> semaphore), it can be throttled (i.e.  removed from the runqueue), which =
will
> result in other, perhaps high-priority, tasks waiting until the low-prior=
ity
> task continues its execution.
>=20
> The patch tries to solve this problem by boosting tasks in throttled grou=
ps on
> wakeups, i.e.  temporarily unthrottling the groups a woken task belongs t=
o in
> order to let the task finish its execution in kernel space.  This obvious=
ly
> should eliminate the priority inversion problem on voluntary preemptable
> kernels.  However, it does not solve the problem for fully preemptable ke=
rnels,
> although I guess the patch can be extended to handle those kernels too (e=
.g. by
> boosting forcibly preempted tasks thus not allowing to throttle).
>=20
> I wrote a simple test that demonstrates the problem (the test is attached=
). It
> creates two cgroups each of which is bound to exactly one cpu using cpuse=
ts,
> sets the limit of the first group to 10% and leaves the second group unli=
mited.
> Then in both groups it starts processes reading the same (big enough) fil=
e
> along with a couple of busyloops in the limited groups, and measures the =
read
> time.
>=20
> I've run the test 10 times for a 1 Gb file on a server with > 10 Gb of RA=
M and
> 4 cores x 2 hyperthreads (the kernel was with CONFIG_PREEMPT_VOLUNTARY=3D=
y). Here
> are the results:
>=20
> without the patch	40.03 +- 7.04 s
> with the patch		 8.42 +- 0.48 s
>=20
> (Since the server's RAM can accommodate the whole file, the read time was=
 the
> same for both groups)
>=20
> I would appreciate if you could answer the following questions regarding =
the
> priority inversion problem and the proposed approach:
>=20
> 1) Do you agree that the problem exists and should be sorted out?
>=20
> 2) If so, does the general approach proposed (unthrottling on wakeups) su=
its
> you? Why or why not?
>=20
> 3) If you think that the approach proposed is sane, what you dislike abou=
t the
> patch?
>=20
> Thank you!
>=20
> ---
> include/linux/sched.h   |    8 ++
> kernel/sched/core.c     |    8 ++
> kernel/sched/fair.c     |  182 ++++++++++++++++++++++++++++++++++++++++++=
++++-
> kernel/sched/features.h |    2 +
> kernel/sched/sched.h    |    6 ++
> 5 files changed, 204 insertions(+), 2 deletions(-)
>=20
> <sched-boost-throttled-entities-on-wakeups.patch><ioprio_inv_test.sh><ATT=
00001.c>


--_002_4D93624F5324422BB44C8B65DBAA8106parallelscom_
Content-Type: application/octet-stream; name="ioprio_inv_test.sh"
Content-Description: ioprio_inv_test.sh
Content-Disposition: attachment; filename="ioprio_inv_test.sh"; size=1886;
	creation-date="Thu, 18 Oct 2012 10:39:02 GMT";
	modification-date="Thu, 18 Oct 2012 10:39:02 GMT"
Content-Transfer-Encoding: base64

IyEgL2Jpbi9iYXNoDQojDQoNClBBR0VfU0laRT00MDk2DQoNClJFU1VMVFNfRElSPWlvcHJpb19p
bnZfdGVzdF9yZXN1bHRzDQoNClRFU1RfRklMRT0vcm9vdC9kdW1teQ0KVEVTVF9GSUxFX1NJWkU9
JFsyNTYqMTAyNF0gIyBpbiBwYWdlcw0KDQpEUk9QX0NBQ0hFUz0xDQpQUkVQX1RFU1RfRklMRT0x
DQoNCkNHUk9VUF9NTlQ9L21udC9jZ3JvdXANCk5SX0NHUk9VUFM9Mg0KDQpDR1JPVVBbMF09dGVz
dDENCkNHUk9VUF9OUl9CVVNZTE9PUFNbMF09Mg0KQ0dST1VQX0NGU19QRVJJT0RbMF09MTAwMDAw
DQpDR1JPVVBfQ0ZTX1FVT1RBWzBdPTEwMDAwDQpDR1JPVVBfQ1BVTUFTS1swXT0xDQpDR1JPVVBf
TUVNTUFTS1swXT0wDQoNCkNHUk9VUFsxXT10ZXN0Mg0KQ0dST1VQX05SX0JVU1lMT09QU1sxXT0w
DQpDR1JPVVBfQ0ZTX1BFUklPRFsxXT0xMDAwMDANCkNHUk9VUF9DRlNfUVVPVEFbMV09LTENCkNH
Uk9VUF9DUFVNQVNLWzFdPTINCkNHUk9VUF9NRU1NQVNLWzFdPTANCg0KZnVuY3Rpb24gZG9fdGVz
dCgpDQp7DQoJbG9jYWwgY2dycD0kMQ0KCXNsZWVwIDMNCglsb2NhbCBwaWRsaXN0PQ0KCWxvY2Fs
IGk9DQoJZm9yIGkgaW4gYHNlcSAxICR7Q0dST1VQX05SX0JVU1lMT09QU1skY2dycF19YDsgZG8N
CgkJd2hpbGUgOjsgZG8gOjsgZG9uZSAmDQoJCXBpZGxpc3Q9IiRwaWRsaXN0ICQhIg0KCWRvbmUN
CglkZCBpZj0kVEVTVF9GSUxFIG9mPS9kZXYvbnVsbCBicz0kUEFHRV9TSVpFIGNvdW50PSRURVNU
X0ZJTEVfU0laRSAmPiAkUkVTVUxUU19ESVIvJGNncnAubG9nDQoJbG9jYWwgcGlkDQoJZm9yIHBp
ZCBpbiAkcGlkbGlzdDsgZG8NCgkJa2lsbCAkcGlkDQoJZG9uZQ0KfQ0KDQpybSAtcmYgJFJFU1VM
VFNfRElSDQpta2RpciAtcCAkUkVTVUxUU19ESVINCg0KaWYgWyAkUFJFUF9URVNUX0ZJTEUgLW5l
IDAgXTsgdGhlbg0KCWVjaG8gIkNyZWF0aW5nIHRlc3QgZmlsZSAoJFRFU1RfRklMRV9TSVpFIHBh
Z2VzKS4uLiINCglybSAtZiAkVEVTVF9GSUxFX1NJWkUNCglkZCBpZj0vZGV2L3plcm8gb2Y9JFRF
U1RfRklMRSBicz0kUEFHRV9TSVpFIGNvdW50PSRURVNUX0ZJTEVfU0laRSAmPi9kZXYvbnVsbA0K
CWVjaG8gIlN5bmNpbmcuLi4iDQoJc3luYzsgc3luYw0KZmkNCg0KaWYgWyAkRFJPUF9DQUNIRVMg
LW5lIDAgXTsgdGhlbg0KCWVjaG8gIkRyb3BwaW5nIGNhY2hlcy4uLiINCgllY2hvIDMgPiAvcHJv
Yy9zeXMvdm0vZHJvcF9jYWNoZXMNCmZpDQoNCmVjaG8gIk1vdW50aW5nIGNncm91cC4uLiINCm1r
ZGlyIC1wICRDR1JPVVBfTU5UDQptb3VudCAtdCBjZ3JvdXAgLW8gY3B1LGNwdXNldCBub25lICRD
R1JPVVBfTU5UDQoNCnBpZGxpc3Q9DQplY2hvICJQcmVwYXJpbmcgdGVzdC4uLiINCmZvciBpIGlu
IGBzZXEgMCAkW05SX0NHUk9VUFMtMV1gOyBkbw0KCWNncnA9JENHUk9VUF9NTlQvJHtDR1JPVVBb
JGldfQ0KCW1rZGlyIC1wICRjZ3JwDQoJZWNobyAke0NHUk9VUF9DRlNfUEVSSU9EWyRpXX0gPiAk
Y2dycC9jcHUuY2ZzX3BlcmlvZF91cw0KCWVjaG8gJHtDR1JPVVBfQ0ZTX1FVT1RBWyRpXX0gPiAk
Y2dycC9jcHUuY2ZzX3F1b3RhX3VzDQoJZWNobyAke0NHUk9VUF9DUFVNQVNLWyRpXX0gPiAkY2dy
cC9jcHVzZXQuY3B1cw0KCWVjaG8gJHtDR1JPVVBfTUVNTUFTS1skaV19ID4gJGNncnAvY3B1c2V0
Lm1lbXMNCgllY2hvICQkID4gJGNncnAvdGFza3MNCglkb190ZXN0ICRpICYNCglwaWRsaXN0PSIk
cGlkbGlzdCAkISINCmRvbmUNCg0KZWNobyAkJCA+ICRDR1JPVVBfTU5UL3Rhc2tzDQoNCmVjaG8g
IlRlc3RpbmcuLi4iDQpmb3IgcGlkIGluICRwaWRsaXN0OyBkbw0KCXdhaXQgJHBpZA0KZG9uZQ0K
DQplY2hvDQplY2hvICJSZXN1bHRzOiINCmVjaG8NCnRhaWwgLW4xICRSRVNVTFRTX0RJUi8qDQpl
Y2hvDQo=

--_002_4D93624F5324422BB44C8B65DBAA8106parallelscom_--
