Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab2F0MwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 08:52:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56406 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2F0MwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 08:52:17 -0400
Message-ID: <4FEB01ED.7020804@canonical.com>
Date: Wed, 27 Jun 2012 14:51:57 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Hillf Danton <dhillf@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Andrew Vagin <avagin@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH] sched: Fix race in task_group()
References: <1340364965.18025.71.camel@twins> <4FE48A09.7050305@canonical.com> <1340718515.21991.83.camel@twins> <4FE9F63B.1000908@canonical.com> <CAJd=RBBWGVkTeZEz9K70AP2-DDTm0p5VEwHgM1tvcnwU3Y=brQ@mail.gmail.com>
In-Reply-To: <CAJd=RBBWGVkTeZEz9K70AP2-DDTm0p5VEwHgM1tvcnwU3Y=brQ@mail.gmail.com>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig2958250A1FC9015E5B8B379F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2958250A1FC9015E5B8B379F
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 27.06.2012 14:40, Hillf Danton wrote:
> The patch went three versions, the first,
>=20
> On Fri, Jun 22, 2012 at 7:36 PM, Peter Zijlstra <peterz@infradead.org> =
wrote:
>> Reported-by: Stefan Bader <stefan.bader@canonical.com>
>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> ---
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index 32157b9..77437d4 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1246,6 +1246,9 @@ struct task_struct {
>> 	const struct sched_class *sched_class;
>> 	struct sched_entity se;
>> 	struct sched_rt_entity rt;
>> +#ifdef CONFIG_CGROUP_SCHED
>> +	struct task_struct *sched_task_group;
>> +#endif
>>
>=20
> The second,
>=20
>>> On 26.06.2012 15:48, Peter Zijlstra wrote:
>>> Here's one that's actually compile tested (with the right CONFIG_foo
>>> enabled) and I fixed the autogroup lockdep splat.
>>>
>>> ---
>>> Subject: sched: Fix race in task_group()
>>> From: Peter Zijlstra <peterz@infradead.org>
>>> Date: Fri, 22 Jun 2012 13:36:05 +0200
>>>
>>> Reported-by: Stefan Bader <stefan.bader@canonical.com>
>>> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>>> ---
>>> --- a/include/linux/sched.h
>>> +++ b/include/linux/sched.h
>>> @@ -1246,6 +1246,9 @@ struct task_struct {
>>>       const struct sched_class *sched_class;
>>>       struct sched_entity se;
>>>       struct sched_rt_entity rt;
>>> +#ifdef CONFIG_CGROUP_SCHED
>>> +     struct task_group *sched_task_group;
>>> +#endif
>>>
>=20
> And the third,  https://lkml.org/lkml/2012/6/26/331
>=20
> From d751ab1f1e532f32412d99b71a1bfea3e5282d07 Mon Sep 17 00:00:00 2001
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Fri, 22 Jun 2012 13:36:00 +0200
> Subject: [PATCH] sched: Fix race in task_group()
>=20
> Stefan reported a crash on a kernel before a3e5d1091c1 ("sched: Don't
> call task_group() too many times in set_task_rq()"), he found the reaso=
n
> to be that the multiple task_group() invocations in set_task_rq()
> returned different values.
>=20
> Looking at all that I found a lack of serialization and plain wrong
> comments.
>=20
> The below tries to fix it using an extra pointer which is updated under=

> the appropriate scheduler locks. Its not pretty, but I can't really see=

> another way given how all the cgroup stuff works.
>=20
> Reported-and-tested-by: Stefan Bader <stefan.bader@canonical.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> [backported to apply to 3.0 and 3.2]
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
> ---
>  include/linux/init_task.h |   12 +++++++++++-
>  include/linux/sched.h     |    5 ++++-
>  kernel/sched.c            |   32 ++++++++++++++++++--------------
>  3 files changed, 33 insertions(+), 16 deletions(-)
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 56de5c1..1fd9884 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1242,6 +1242,9 @@ struct task_struct {
>  	const struct sched_class *sched_class;
>  	struct sched_entity se;
>  	struct sched_rt_entity rt;
> +#ifdef CONFIG_CGROUP_SCHED
> +	struct task_struct *sched_task_group;
> +#endif
>=20
> where sched_task_group was defined to be task_struct twice(in the first=

> and the third versions) and to be task_group once.
>=20
> Before backport, feel free to respin with the final define determined.
>=20
The second version is correct. I just messed up updating my backport, fai=
ling to
notice that change (and trying to be clever and not going trhough re-appl=
ying
and failure again).

-Stefan



--------------enig2958250A1FC9015E5B8B379F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCgAGBQJP6wH3AAoJEOhnXe7L7s6jP9EP+wXcCJTcIrXcQAxJ2ijueXuh
R0yZrTOaPhNQ3cKxEk7y8dCgpoyLb55mZWYvVEuKApcEP9Zzkx4kjnQzbdkT57sN
cruH1N9WPRl3Lh7hj/Uq96N6kNHOhgvQ3psKFusu+BG5lv+qAL8MW4yRSVbqMYDE
1dNjranLqAU9lq6GcTS7U3oVZ/jFlRGcIrajSFxltXXBw1YE1f5NtoHqmSsGrlD9
MS37X6nSd+IU3XSERS3Y8kH3P3pqw9yXStLcLi/mWO0pRnxi6CQF+Krw39/N9COQ
QdrWb5idFYmEdA7WBa1k92b89VghKbLyUvj4+1oTCnU5/DCGZRsBzS4DO1vcEMS3
RyM5d1kL9sgA37xN2XSgItjqcmYCLob2auhiA0kEBtKy1JHi5wxLR2T1QzjCLC5R
Oe2WC6lAOUDYGcnIQ8ejrGL70aFtz+iGmbRR3tscrDovJsBZt+/qjfSsoLJu5uU7
EwH5qMOPu0bsWYRFEt2NJy/kryT4JC5mLlg/aNYc4BSHe8xiyXnCbaD0tUjD3wyV
DtpZ7SzeLLzVLYz3TgOvchwmzyGSTKRGQCM1NTZgQ40rxON9Pk8hg5M7/UTOmLis
VMPqmxLCMvYanUBcH+xM1Z9L8m1nRY9Ch4GBs4p0Fp5mDZMsh+JQofRfivXxU/8H
+WrtleWbRywqy0h1IwhK
=+6Vu
-----END PGP SIGNATURE-----

--------------enig2958250A1FC9015E5B8B379F--
