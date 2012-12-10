Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278Ab2LJW7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 17:59:44 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:35126 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751006Ab2LJW7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 17:59:43 -0500
Date: Mon, 10 Dec 2012 16:59:28 -0600
From: Clark Williams <clark.williams@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC][PATCH RT 0/4] sched/rt: Lower rq lock contention
 latencies on many CPU boxes
Message-ID: <20121210165928.7ffd9a21@gmail.com>
In-Reply-To: <20121207235615.206108556@goodmis.org>
References: <20121207235615.206108556@goodmis.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YKRM+6.+zIgUYSZJAOMZUKf"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/YKRM+6.+zIgUYSZJAOMZUKf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 07 Dec 2012 18:56:15 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

> I've been debugging large latencies on a 40 core box and found a major
> cause due to the thundering herd like grab of the rq lock due to the
> pull_rt_task() logic.
>=20
> Basically, if a large number of CPUs were to lower its priority roughly
> the same time, they would all trigger a pull. If there happens to be
> only one CPU available to get a task, all CPUs doing the pull will try
> to grab it. In doing so, they will all contend on the rq lock of
> the overloaded CPU. Only one CPU will succeed in pulling the task
> and unfortunately, there's no quick way to know which, as it's dependent
> on the affinitiy of the task that needs to be pulled, and to look at that,
> we need to grab its rq lock!
>=20
> Instead of having the pull logic grab the rq locks and do the work to
> switch the task over to the pulling CPU, this patch series (well patch
> #3) has the pulling CPU send an IPI to the overloaded CPU and that
> CPU will do the push instead. The push logic uses the cpupri.c code
> to quickly find the best CPU to offload the overloaded RT task to, so
> it makes it quite efficient to do this.
>=20
> Retrieving multiple IPIs has a much lower overhead than all the CPUs
> grabbing the rq lock.
>=20
> The other three patches are fixes/enhancements to the push/pull code
> that I found while doing the debugging of the latencies.
>=20
> Note, although this patch series is made for the -rt patch, the issues
> apply to mainline as well. But because -rt has the migrate_disable() code,
> this patch series is tailored to that. But if we can vet this out in
> -rt, all this code should make its way quickly to mainline.
>=20
> I tested this code out, but it probably needs some clean up and definitely
> more comments. I'm only posting this as an RFC for now to get feedback
> on the idea.
>=20
> Thanks!
>=20

Steve,

I've been running this set of patches on my laptop+RT kernel since
Friday with no ill-effects. I just applied it to v3.6.10+rt21 and it
seems to be fine.

I've got rteval runs going on a 40-core and a 24-core box which will be
done early Tuesday morning so I'll let you know results then.=20

Clark

--Sig_/YKRM+6.+zIgUYSZJAOMZUKf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJQxmlUAAoJEOIu7msziWiGGdYH/0CPHr5GeaFpSzpHvRwOntiE
5l2/QwC0j5xgYUJGdVWwxVSKhYYIkEog9F0nq+8wE63gu0fLBux/G3DDf+Nj/LX9
MTXppMwy2aMRVqLwiMqIOd24IWPZgZtUT31W1KpcxMLyryDySlPaViAs7Iz1EgnD
K5O3bFzdorFfLybMrQ+CFR4oh2hG6tz7Ua05oYWhPXNkvgyD60JDMmVqmWQ3ksYk
7TfIL5oWXVgaUY8zhQ9mnWkHElIcV0ee/QZpXlaCAHnJ61XdOyG7YL8jq9quusJs
0gNI6AkFWHepkUIt0t9lzRjlYTBozDcjqnuay9nVVY2H9aOThW2NMeogd/DUz7Q=
=gw7a
-----END PGP SIGNATURE-----

--Sig_/YKRM+6.+zIgUYSZJAOMZUKf--
