Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab2JSHlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 03:41:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59661 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2JSHlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 03:41:07 -0400
Message-ID: <50810409.9000209@canonical.com>
Date: Fri, 19 Oct 2012 09:40:57 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Luis Henriques <luis.henriques@canonical.com>
CC: cwillu <cwillu@cwillu.com>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        peterz@infradead.org, tglx@linutronix.de, yong.zhang0@gmail.com
Subject: Re: [tip:sched/core] sched: Fix race in task_group()
References: <1340364965.18025.71.camel@twins> <tip-8323f26ce3425460769605a6aece7a174edaa7d1@git.kernel.org> <CAE5mzvjPXAZdOi1p8AB47zOQzgAErBU66gAS8spnpOs+=-+azA@mail.gmail.com> <507FD8AA.50500@canonical.com> <20121018133353.GA25885@hercules>
In-Reply-To: <20121018133353.GA25885@hercules>
X-Enigmail-Version: 1.4.5
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigC473E055DF1A0D16ECD79A90"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC473E055DF1A0D16ECD79A90
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 18.10.2012 15:33, Luis Henriques wrote:
> On Thu, Oct 18, 2012 at 12:23:38PM +0200, Stefan Bader wrote:
>> On 18.10.2012 10:27, cwillu wrote:
>>> On Tue, Jul 24, 2012 at 8:21 AM, tip-bot for Peter Zijlstra
>>> <peterz@infradead.org> wrote:
>>>> Commit-ID:  8323f26ce3425460769605a6aece7a174edaa7d1
>>>> Gitweb:     http://git.kernel.org/tip/8323f26ce3425460769605a6aece7a=
174edaa7d1
>>>> Author:     Peter Zijlstra <peterz@infradead.org>
>>>> AuthorDate: Fri, 22 Jun 2012 13:36:05 +0200
>>>> Committer:  Ingo Molnar <mingo@kernel.org>
>>>> CommitDate: Tue, 24 Jul 2012 13:58:20 +0200
>>>>
>>>> sched: Fix race in task_group()
>>>>
>>>> Stefan reported a crash on a kernel before a3e5d1091c1 ("sched:
>>>> Don't call task_group() too many times in set_task_rq()"), he
>>>> found the reason to be that the multiple task_group()
>>>> invocations in set_task_rq() returned different values.
>>>>
>>>> Looking at all that I found a lack of serialization and plain
>>>> wrong comments.
>>>>
>>>> The below tries to fix it using an extra pointer which is
>>>> updated under the appropriate scheduler locks. Its not pretty,
>>>> but I can't really see another way given how all the cgroup
>>>> stuff works.
>>>>
>>>> Reported-and-tested-by: Stefan Bader <stefan.bader@canonical.com>
>>>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>>> Link: http://lkml.kernel.org/r/1340364965.18025.71.camel@twins
>>>> Signed-off-by: Ingo Molnar <mingo@kernel.org>
>>>
>>> I just finished bisecting a crash on boot to this commit; booting wit=
h
>>> "noautogroup" brings it back.
>>>
>>> 3.5.4 is the latest -stable that still boots, and none of the 3.6 rc'=
s
>>> boot at all.
>>>
>>> Photo of the bug (3.6.0next is 3.6 + btrfs's for-linus):
>>> https://lh5.googleusercontent.com/-0DY-YYhgvzs/UHdB-BQdzMI/AAAAAAAAAE=
g/QhY9rgxnv98/s811/2012-10-11
>>>
>>
>> On a very quick glance I wonder whether there might be a case where sc=
hed_fork
>> goes into set_task_cpu with a different cpu than the current but has n=
ot yet
>> task_group.sched_task_group set to something valid...
>>
>>
>=20
> I was looking at another bug report [1] which may be related with this
> issue.  Basically, it looks like there is a race window where
> resetting sched_autogroup_enabled will cause a crash on
> shutdown/reboot.  In the bug report, the user has added:
>=20
> echo 0 > /proc/sys/kernel/sched_autogroup_enabled
>=20
> to /etc/rc.local.  This will cause a NULL pointer dereference during
> shutdown (and it is reproducible with mainline kernel 3.7.0-rc1).
>=20
> By using the kernel parameter noautogroup I *wasn't* able to reproduce
> this issue.
>=20
> After a little bit of digging, commit
> 800d4d30c8f20bd728e5741a3b77c4859a613f7c ("sched, autogroup: Stop
> going ahead if autogroup is disabled") caught my attention as it
> changes the following code path when sched_autogroup_enabled is
> disabled:
>=20
>     sched_autogroup_create_attach()
>       autogroup_move_group()
>         sched_move_task()          <<-- conditionally invoked
>           task_move_group_fair()
>             set_task_rq()
>               task_group()
>                 autogroup_task_group()
>=20
> And commit 8323f26ce3425460769605a6aece7a174edaa7d1 ("sched: Fix
> race in task_group()") actually adds code to this conditional path (in
> sched_move_task()).
>=20
> A quick test shows that reverting
> 800d4d30c8f20bd728e5741a3b77c4859a613f7c (i.e., always going through
> the whole call tree) seems to fix it or, at least, doesn't trigger the
> NULL pointer.  But again, I may just be doing something foolish,
> hiding something else.  It is also possible that this is a completely
> different issue.

I think you are right Luis. Looking at it with a bit more time it looks t=
hat,
while the patch you mention optimizes for the case where sched_autogroup =
was
disabled from the beginning (noautogroup), it is rather bad for the case =
where
it gets disabled after booting with it since by then some tasks likely ha=
ve gone
into some task groups and when the sched_move_task is skipped, then the p=
ointer
to the old autogroup (which I suspect of beeing freed) still remains set.=
 This
all was unlikely a problem when the autogroup was looked up from the othe=
r
place. But then that would race while setting it.

kernel/sched/sched_auto_group.c
        if (!ACCESS_ONCE(sysctl_sched_autogroup_enabled))
+		if (p->sched_task_group =3D=3D &root_task_group)
+	                goto out;
-                goto out;

I wonder whether this would be an acceptable (and working since I actuall=
y have
not tried to compile it) way out of it...

-Stefan
>=20
> [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1055222
>=20
> Cheers,
> --
> Luis
>=20



--------------enigC473E055DF1A0D16ECD79A90
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQIcBAEBCgAGBQJQgQQJAAoJEOhnXe7L7s6jeesP/A6F4ha3r1waFHay4a7fstTj
Wc/wLNLTa7Trf94/dTC1CRC1U3iYpuREFDybKiSaUyJPSUbYU/nVbpVHEadrB7na
ltP5ErhHztdIf4Evmn1HBleipquwVu1pH+Wb66luTVY0iS3EpRKAbLjvgf5QdLHF
+u0ELYuzk5t8yg85AFiO4weD6q9mSFtCXK5vGcnnOjbqkxqGcBeOT+5K/8zokZBa
v91gH0crkhDijDmDp/Z2vu6eS3aDNtEe3F34xQssTU7O70HT5LOmcYozIW/Xt3j1
Jh7udhGvO0X4Jgj/Bu8DNOwLRHci6lsfH8FDcER8F8rOJ0w+KcQ0XcYWomggl1xJ
HuJwd+BBMR4pQN6YxUuwnmh5PU0QxrvaokRyxM/fTMFEekMRcVIlwLSfjpuFb3IZ
1jMv1zCzQrbgdjobCdZJ99bl8fP6FsbwYWb7jyZOaoz0ZWGWecG9cCfKIntxrNJv
Wkz19pcdlpfFnMp9JMsOuVjhPpzdUntasoOLgPTxIF3MoVj16ZB6+Oa5H/IViTc9
OBwmBORjwIjCWY2NAugfdiN0X62IqUVnRVkAamlVPkNYN03VyXdDdx3aV79dglCh
srxi02HeCyBydEHFqdpQu1Rh2Fk5zGP6b/pJ/pLp3UEZTeMzFnYUKPs5GEPEcgh5
5kYjzNja33qG22xlt86c
=0Nus
-----END PGP SIGNATURE-----

--------------enigC473E055DF1A0D16ECD79A90--
