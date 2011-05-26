Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932835Ab1EZQXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:23:53 -0400
Received: from smp.if.uj.edu.pl ([149.156.82.206]:52036 "EHLO smp.if.uj.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932480Ab1EZQXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:23:52 -0400
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 May 2011 12:23:52 EDT
From: "Witold Baryluk" <baryluk@smp.if.uj.edu.pl>
Date: Thu, 26 May 2011 18:18:35 +0200
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 12/12] ftrace: Add internal recursive checks
Message-ID: <20110526161835.GL25813@smp.if.uj.edu.pl>
References: <20110526152541.995963172@goodmis.org>
 <20110526152958.961788971@goodmis.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_smp.if.uj.edu.pl-10520-1306426716-0001-2"
Content-Disposition: inline
In-Reply-To: <20110526152958.961788971@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_smp.if.uj.edu.pl-10520-1306426716-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05-26 11:25, Steven Rostedt wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
>=20
> Witold reported a reboot caused by the selftests of the dynamic function
> tracer. He sent me a config and I used ktest to do a config_bisect on it
> (as my config did not cause the crash). It pointed out that the problem
> config was CONFIG_PROVE_RCU.

Just disabling PROVE_RCU in my config
make crash disapear, so it is good diagnosis. Good work.

>=20
> What happened was that if multiple callbacks are attached to the
> function tracer, we iterate a list of callbacks. Because the list is
> managed by synchronize_sched() and preempt_disable, the access to the
> pointers uses rcu_dereference_raw().
>=20
> When PROVE_RCU is enabled, the rcu_dereference_raw() calls some
> debugging functions, which happen to be traced. The tracing of the debug
> function would then call rcu_dereference_raw() which would then call the
> debug function and then... well you get the idea.
>=20
> I first wrote two different patches to solve this bug.
>=20
> 1) add a __rcu_dereference_raw() that would not do any checks.
> 2) add notrace to the offending debug functions.
>=20
> Both of these patches worked.
>=20
> Talking with Paul McKenney on IRC, he suggested to add recursion
> detection instead. This seemed to be a better solution, so I decided to
> implement it. As the task_struct already has a trace_recursion to detect
> recursion in the ring buffer, and that has a very small number it
> allows, I decided to use that same variable to add flags that can detect
> the recursion inside the infrastructure of the function tracer.
>=20
> I plan to change it so that the task struct bit can be checked in
> mcount, but as that requires changes to all archs, I will hold that off
> to the next merge window.

I'm testing this patch now, and do not see any problem right now.

Regards,
Witek

--=20
Witold Baryluk

--=_smp.if.uj.edu.pl-10520-1306426716-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk3efVoACgkQ7ZLFFOttZ4IekQCeJWjzNmy44I3o78j8mso5iVOW
4YoAoL3HfpyhMiUuZCIsaLdq+jVL8j8s
=w56x
-----END PGP SIGNATURE-----

--=_smp.if.uj.edu.pl-10520-1306426716-0001-2--
