Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031565Ab2CPGtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 02:49:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51094 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030370Ab2CPGtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 02:49:51 -0400
Date: Fri, 16 Mar 2012 17:49:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20120316174941.40421ba160741a0f6aab6611@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Mar_2012_17_49_41_+1100_54VYpWMxodL+OC9x"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Mar_2012_17_49_41_+1100_54VYpWMxodL+OC9x
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-msm/timer.c between commit f8e56c42e4e3 ("msm: timer:
Support sched_clock()") from the arm tree and commit 5ca709c16d0f ("ARM:
local timers: convert MSM to runtime registration interface") from the
arm-soc tree.

I fixed it up (see below) and can carry the fax as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-msm/timer.c
index 61983da,75f4be4..0000000
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@@ -128,11 -127,45 +128,50 @@@ static struct clocksource msm_clocksour
  	.flags	=3D CLOCK_SOURCE_IS_CONTINUOUS,
  };
 =20
 +static notrace u32 msm_sched_clock_read(void)
 +{
 +	return msm_clocksource.read(&msm_clocksource);
 +}
 +
+ #ifdef CONFIG_LOCAL_TIMERS
+ static int __cpuinit msm_local_timer_setup(struct clock_event_device *evt)
+ {
+ 	/* Use existing clock_event for cpu 0 */
+ 	if (!smp_processor_id())
+ 		return 0;
+=20
+ 	writel_relaxed(0, event_base + TIMER_ENABLE);
+ 	writel_relaxed(0, event_base + TIMER_CLEAR);
+ 	writel_relaxed(~0, event_base + TIMER_MATCH_VAL);
+ 	evt->irq =3D msm_clockevent.irq;
+ 	evt->name =3D "local_timer";
+ 	evt->features =3D msm_clockevent.features;
+ 	evt->rating =3D msm_clockevent.rating;
+ 	evt->set_mode =3D msm_timer_set_mode;
+ 	evt->set_next_event =3D msm_timer_set_next_event;
+ 	evt->shift =3D msm_clockevent.shift;
+ 	evt->mult =3D div_sc(GPT_HZ, NSEC_PER_SEC, evt->shift);
+ 	evt->max_delta_ns =3D clockevent_delta2ns(0xf0000000, evt);
+ 	evt->min_delta_ns =3D clockevent_delta2ns(4, evt);
+=20
+ 	*__this_cpu_ptr(msm_evt.percpu_evt) =3D evt;
+ 	clockevents_register_device(evt);
+ 	enable_percpu_irq(evt->irq, 0);
+ 	return 0;
+ }
+=20
+ static void msm_local_timer_stop(struct clock_event_device *evt)
+ {
+ 	evt->set_mode(CLOCK_EVT_MODE_UNUSED, evt);
+ 	disable_percpu_irq(evt->irq);
+ }
+=20
+ static struct local_timer_ops msm_local_timer_ops __cpuinitdata =3D {
+ 	.setup	=3D msm_local_timer_setup,
+ 	.stop	=3D msm_local_timer_stop,
+ };
+ #endif /* CONFIG_LOCAL_TIMERS */
+=20
  static void __init msm_timer_init(void)
  {
  	struct clock_event_device *ce =3D &msm_clockevent;
@@@ -195,44 -232,8 +238,10 @@@ err
  	res =3D clocksource_register_hz(cs, dgt_hz);
  	if (res)
  		pr_err("clocksource_register failed\n");
 +	setup_sched_clock(msm_sched_clock_read,
 +			cpu_is_msm7x01() ? 32 - MSM_DGT_SHIFT : 32, dgt_hz);
  }
 =20
- #ifdef CONFIG_LOCAL_TIMERS
- int __cpuinit local_timer_setup(struct clock_event_device *evt)
- {
- 	/* Use existing clock_event for cpu 0 */
- 	if (!smp_processor_id())
- 		return 0;
-=20
- 	writel_relaxed(0, event_base + TIMER_ENABLE);
- 	writel_relaxed(0, event_base + TIMER_CLEAR);
- 	writel_relaxed(~0, event_base + TIMER_MATCH_VAL);
- 	evt->irq =3D msm_clockevent.irq;
- 	evt->name =3D "local_timer";
- 	evt->features =3D msm_clockevent.features;
- 	evt->rating =3D msm_clockevent.rating;
- 	evt->set_mode =3D msm_timer_set_mode;
- 	evt->set_next_event =3D msm_timer_set_next_event;
- 	evt->shift =3D msm_clockevent.shift;
- 	evt->mult =3D div_sc(GPT_HZ, NSEC_PER_SEC, evt->shift);
- 	evt->max_delta_ns =3D clockevent_delta2ns(0xf0000000, evt);
- 	evt->min_delta_ns =3D clockevent_delta2ns(4, evt);
-=20
- 	*__this_cpu_ptr(msm_evt.percpu_evt) =3D evt;
- 	clockevents_register_device(evt);
- 	enable_percpu_irq(evt->irq, 0);
- 	return 0;
- }
-=20
- void local_timer_stop(struct clock_event_device *evt)
- {
- 	evt->set_mode(CLOCK_EVT_MODE_UNUSED, evt);
- 	disable_percpu_irq(evt->irq);
- }
- #endif /* CONFIG_LOCAL_TIMERS */
-=20
  struct sys_timer msm_timer =3D {
  	.init =3D msm_timer_init
  };

--Signature=_Fri__16_Mar_2012_17_49_41_+1100_54VYpWMxodL+OC9x
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYuKFAAoJEECxmPOUX5FE4v0QAKdmD5VCcRamgtKKM8Z1Vzsb
+6lOMLo+N9mAto6MB6RFWwALHwq1iMytVcZ+Hk71dwy6jRdJYZOlDUI6WqvZ1uOE
V4j1FtOqfBwONkZipCwkCr3ipVcUD7ZLHTrpy8keKTsmGfFISe6X28XYIJ8ETfvW
2Lje3Ohgp84tw/Muopx4IH9tdixbfG2qOuL0akLfxGbltfzOqVl3Z7yx02USKlc6
078ve80FoPgN1KCXWVg0DHzXJ03XVwAh3fJzsPndFhhD+Ovhj9f6hDWd89nsYMy3
jq52dbmbRxQ0KNtSBBOTHTCobpKwlrNh/msnAqG/BEVLhly7GiYcGOeYbW+k0rhv
9qc3wZ5DlRKGhujlgI2bMQQ7VIhTIfACv9X0WCDvirYr0OLzwFNUmtRTp7z5scG0
70SbPEG+gcR76mt27tErgnsuIwwzWQzomN/Bz7zsmaLASiIM9o3/pd8xWNRPLCjm
LjR5D4kxsS0HBocOzZpPXydC5+hFK9slskZAObIsOU8zCp3uobpLdqflqDheUIM8
Gifns9QhfKtvaClpCTKIDk/1ykJwnqxvKOR52GGmWbVzhNdSAjtXJiaOsdXgKzOi
Nf3jsEoqjD1xV/77wKNJaNji7GagtfyGAX/xyV4t2g1M65jDf7hg3kppyqnUbYne
cuqbPopcc8ie2o8DEaUb
=Imfj
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Mar_2012_17_49_41_+1100_54VYpWMxodL+OC9x--
