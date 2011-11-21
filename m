Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab1KUQWh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 11:22:37 -0500
Received: from oz.csail.mit.edu ([128.30.30.239]:37376 "EHLO mail.mgebm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293Ab1KUQWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 11:22:35 -0500
Date: Mon, 21 Nov 2011 11:22:27 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, William Cohen <wcohen@redhat.com>,
        linux-kernel@vger.kernel.org, Michael Cree <mcree@orcon.net.nz>,
        Will Deacon <will.deacon@arm.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Anton Blanchard <anton@samba.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Kuo <rkuo@codeaurora.org>,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        Vince Weaver <vince@deater.net>
Subject: Re: [RFC][PATCH 2/6] perf, arch: Rework perf_event_index()
Message-ID: <20111121162227.GC7722@mgebm.net>
References: <20111121145114.049265181@chello.nl>
 <20111121145337.533322271@chello.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0vzXIDBeUiKkjNJl"
Content-Disposition: inline
In-Reply-To: <20111121145337.533322271@chello.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0vzXIDBeUiKkjNJl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Nov 2011, Peter Zijlstra wrote:

> Put the logic to compute the event index into a per pmu method. This
> is required because the x86 rules are weird and wonderful and don't
> match the capabilities of the current scheme.
>=20
> AFAIK only powerpc actually has a usable userspace read of the PMCs
> but I'm not at all sure anybody actually used that.
>=20
> ARM looks like it cared, but I really wouldn't know, Will?
>=20
> For the rest we preserve the status quo with a default function.
>=20
> We probably want to provide an explicit method for sw counters and the
> like so they don't try and dereference event->hw.index which is a
> random field in the middle of their hrtimer structure.
>=20
> Cc: Michael Cree <mcree@orcon.net.nz>
> Cc: Will Deacon <will.deacon@arm.com>
> Cc: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
> Cc: Anton Blanchard <anton@samba.org>
> Cc: Eric B Munson <emunson@mgebm.net>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Richard Kuo <rkuo@codeaurora.org>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Arun Sharma <asharma@fb.com>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Eric B Munson <emunson@mgebm.net>

> ---
>  arch/arm/include/asm/perf_event.h            |    4 ----
>  arch/arm/kernel/perf_event.c                 |   10 ++++++++++
>  arch/frv/include/asm/perf_event.h            |    2 --
>  arch/hexagon/include/asm/perf_event.h        |    2 --
>  arch/powerpc/include/asm/perf_event_server.h |    2 --
>  arch/powerpc/kernel/perf_event.c             |    6 ++++++
>  arch/s390/include/asm/perf_event.h           |    1 -
>  arch/x86/include/asm/perf_event.h            |    2 --
>  include/linux/perf_event.h                   |    6 ++++++
>  kernel/events/core.c                         |   14 +++++++++-----
>  10 files changed, 31 insertions(+), 18 deletions(-)
> Index: linux-2.6/include/linux/perf_event.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/include/linux/perf_event.h
> +++ linux-2.6/include/linux/perf_event.h
> @@ -679,6 +679,12 @@ struct pmu {
>  	 * for each successful ->add() during the transaction.
>  	 */
>  	void (*cancel_txn)		(struct pmu *pmu); /* optional */
> +
> +	/*
> +	 * Will return the value for perf_event_mmap_page::index for this event,
> +	 * if no implementation is provided it will default to: event->hw.idx +=
 1.
> +	 */
> +	int (*event_idx)		(struct perf_event *event); /*optional */
>  };
> =20
>  /**
> Index: linux-2.6/kernel/events/core.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/kernel/events/core.c
> +++ linux-2.6/kernel/events/core.c
> @@ -3191,10 +3191,6 @@ int perf_event_task_disable(void)
>  	return 0;
>  }
> =20
> -#ifndef PERF_EVENT_INDEX_OFFSET
> -# define PERF_EVENT_INDEX_OFFSET 0
> -#endif
> -
>  static int perf_event_index(struct perf_event *event)
>  {
>  	if (event->hw.state & PERF_HES_STOPPED)
> @@ -3203,7 +3199,7 @@ static int perf_event_index(struct perf_
>  	if (event->state !=3D PERF_EVENT_STATE_ACTIVE)
>  		return 0;
> =20
> -	return event->hw.idx + 1 - PERF_EVENT_INDEX_OFFSET;
> +	return event->pmu->event_idx(event);
>  }
> =20
>  static void calc_timer_values(struct perf_event *event,
> @@ -5334,6 +5330,11 @@ static void perf_pmu_cancel_txn(struct p
>  	perf_pmu_enable(pmu);
>  }
> =20
> +static int perf_event_idx_default(struct perf_event *event)
> +{
> +	return event->hw.idx + 1;
> +}
> +
>  /*
>   * Ensures all contexts with the same task_ctx_nr have the same
>   * pmu_cpu_context too.
> @@ -5523,6 +5524,9 @@ int perf_pmu_register(struct pmu *pmu, c
>  		pmu->pmu_disable =3D perf_pmu_nop_void;
>  	}
> =20
> +	if (!pmu->event_idx)
> +		pmu->event_idx =3D perf_event_idx_default;
> +
>  	list_add_rcu(&pmu->entry, &pmus);
>  	ret =3D 0;
>  unlock:
> Index: linux-2.6/arch/arm/include/asm/perf_event.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/arch/arm/include/asm/perf_event.h
> +++ linux-2.6/arch/arm/include/asm/perf_event.h
> @@ -12,10 +12,6 @@
>  #ifndef __ARM_PERF_EVENT_H__
>  #define __ARM_PERF_EVENT_H__
> =20
> -/* ARM performance counters start from 1 (in the cp15 accesses) so use t=
he
> - * same indexes here for consistency. */
> -#define PERF_EVENT_INDEX_OFFSET 1
> -
>  /* ARM perf PMU IDs for use by internal perf clients. */
>  enum arm_perf_pmu_ids {
>  	ARM_PERF_PMU_ID_XSCALE1	=3D 0,
> Index: linux-2.6/arch/arm/kernel/perf_event.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/arch/arm/kernel/perf_event.c
> +++ linux-2.6/arch/arm/kernel/perf_event.c
> @@ -572,6 +572,15 @@ static void armpmu_disable(struct pmu *p
>  	armpmu->stop();
>  }
> =20
> +/*
> + * ARM performance counters start from 1 (in the cp15 accesses) so use t=
he
> + * same indexes here for consistency.
> + */
> +static int armpmu_event_idx(struct perf_event *event)
> +{
> +	return event->hw.idx;
> +}
> +
>  static void __init armpmu_init(struct arm_pmu *armpmu)
>  {
>  	atomic_set(&armpmu->active_events, 0);
> @@ -586,6 +595,7 @@ static void __init armpmu_init(struct ar
>  		.start		=3D armpmu_start,
>  		.stop		=3D armpmu_stop,
>  		.read		=3D armpmu_read,
> +		.event_idx	=3D armpmu_event_idx,
>  	};
>  }
> =20
> Index: linux-2.6/arch/frv/include/asm/perf_event.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/arch/frv/include/asm/perf_event.h
> +++ linux-2.6/arch/frv/include/asm/perf_event.h
> @@ -12,6 +12,4 @@
>  #ifndef _ASM_PERF_EVENT_H
>  #define _ASM_PERF_EVENT_H
> =20
> -#define PERF_EVENT_INDEX_OFFSET	0
> -
>  #endif /* _ASM_PERF_EVENT_H */
> Index: linux-2.6/arch/hexagon/include/asm/perf_event.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/arch/hexagon/include/asm/perf_event.h
> +++ linux-2.6/arch/hexagon/include/asm/perf_event.h
> @@ -19,6 +19,4 @@
>  #ifndef _ASM_PERF_EVENT_H
>  #define _ASM_PERF_EVENT_H
> =20
> -#define PERF_EVENT_INDEX_OFFSET	0
> -
>  #endif /* _ASM_PERF_EVENT_H */
> Index: linux-2.6/arch/powerpc/include/asm/perf_event_server.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/arch/powerpc/include/asm/perf_event_server.h
> +++ linux-2.6/arch/powerpc/include/asm/perf_event_server.h
> @@ -61,8 +61,6 @@ struct pt_regs;
>  extern unsigned long perf_misc_flags(struct pt_regs *regs);
>  extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
> =20
> -#define PERF_EVENT_INDEX_OFFSET	1
> -
>  /*
>   * Only override the default definitions in include/linux/perf_event.h
>   * if we have hardware PMU support.
> Index: linux-2.6/arch/powerpc/kernel/perf_event.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/arch/powerpc/kernel/perf_event.c
> +++ linux-2.6/arch/powerpc/kernel/perf_event.c
> @@ -1187,6 +1187,11 @@ static int power_pmu_event_init(struct p
>  	return err;
>  }
> =20
> +static int power_pmu_event_idx(struct perf_event *event)
> +{
> +	return event->hw.idx;
> +}
> +
>  struct pmu power_pmu =3D {
>  	.pmu_enable	=3D power_pmu_enable,
>  	.pmu_disable	=3D power_pmu_disable,
> @@ -1199,6 +1204,7 @@ struct pmu power_pmu =3D {
>  	.start_txn	=3D power_pmu_start_txn,
>  	.cancel_txn	=3D power_pmu_cancel_txn,
>  	.commit_txn	=3D power_pmu_commit_txn,
> +	.event_idx	=3D power_pmu_event_idx,
>  };
> =20
>  /*
> Index: linux-2.6/arch/s390/include/asm/perf_event.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/arch/s390/include/asm/perf_event.h
> +++ linux-2.6/arch/s390/include/asm/perf_event.h
> @@ -6,4 +6,3 @@
> =20
>  /* Empty, just to avoid compiling error */
> =20
> -#define PERF_EVENT_INDEX_OFFSET 0
> Index: linux-2.6/arch/x86/include/asm/perf_event.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/arch/x86/include/asm/perf_event.h
> +++ linux-2.6/arch/x86/include/asm/perf_event.h
> @@ -187,8 +187,6 @@ extern u32 get_ibs_caps(void);
>  #ifdef CONFIG_PERF_EVENTS
>  extern void perf_events_lapic_init(void);
> =20
> -#define PERF_EVENT_INDEX_OFFSET			0
> -
>  /*
>   * Abuse bit 3 of the cpu eflags register to indicate proper PEBS IP fix=
ups.
>   * This flag is otherwise unused and ABI specified to be 0, so nobody sh=
ould
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20

--0vzXIDBeUiKkjNJl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOynrDAAoJEKhG9nGc1bpJD0sP/jy45EJWhIGK7RHSqaRr/YbR
oVKj2uUnHPhFNPxSL2KK603JTlT29un+IjHHSdb7c6UmRv+H1hlB+0lZSAJeodWx
0AptQ3opY5Fpd9b9QzClg/QwwouGW9SFJOd9K4aFl5vt9Sj/eyvoBjsp/Jz0iMMG
+u1FfUHC9gzdTSHQL2D1Rciz1/wdWqx+4xBasQtTC1rFGbXUoOc2WrYy8j+c8AS5
ObmZWxw4A6T9ZKDH0q3lvGL6ynHtu+5S7R0rqBiaVctyqv2Tld7L7H/85isAWGd5
0oTB+juFaDgHakZ7qEnoFxgAKcBs12MRcuz2DzyzKNF2xxe+IGXwOrM0iqAqTuDm
j3DsU8fzKmDwRoGYBMMRyp40AH4CbOMDM0Zr8yCB4dMoUEqhdfZWqIKuDav6ezem
wUCcP3NWJPF8TYTM6w4i17rm8ujjoFlzFHVLOAc9dLXeLeRe95dw7RsWLCRV57SX
lJsdvkWK+0K4de1AEaTdyK3xBvKf8Y93FetVw8CANKX9rxx4z0oBpOYbVFtTQlB2
K5BB7mk4qhswHE4Ti0dCCmxWafaOvUvp0K+MQE39bj13CsONMSMNsHOAuofKoZKP
Ugc+1hrPLYGUnE7sWb+DwQD+vtS6rmEp1JPW6CMcPmDBPY9IhBMImTojc1EXDGnL
In+NMF5tWXLr2kuvhHSB
=23X6
-----END PGP SIGNATURE-----

--0vzXIDBeUiKkjNJl--
