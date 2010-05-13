Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849Ab0EMMJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 08:09:40 -0400
Received: from ozlabs.org ([203.10.76.45]:45771 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755942Ab0EMMJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 08:09:38 -0400
Subject: Re: [PATCH 4/4] trace, powerpc: Implement raw syscall tracepoints
 on PowerPC
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Ian Munsie <imunsie@au1.ibm.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
       linuxppc-dev@lists.ozlabs.org
In-Reply-To: <1273736594-19320-5-git-send-email-imunsie@au1.ibm.com>
References: <1273736594-19320-1-git-send-email-imunsie@au1.ibm.com>
	 <1273736594-19320-5-git-send-email-imunsie@au1.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HpTfXCVmlRcZ5i46g9PE"
Date: Thu, 13 May 2010 22:09:31 +1000
Message-ID: <1273752571.8067.12.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HpTfXCVmlRcZ5i46g9PE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-05-13 at 17:43 +1000, Ian Munsie wrote:
> From: Ian Munsie <imunsie@au.ibm.com>

Hi Ian,

Just a few comments ..

> This patch implements the raw syscall tracepoints on PowerPC required
> for ftrace syscalls.

OK. It also adds a bunch of code under CONFIG_FTRACE_*, so does it
implement raw syscall tracepoints _and_ hook them up to ftrace?

> To minimise reworking existing code, I slightly re-ordered the thread
> info flags such that the new TIF_SYSCALL_TRACEPOINT bit would still fit
> within the 16 bits of the andi instruction's UI field.

Which andi instruction? That could use a bit more explaining.

> In the case of 64bit PowerPC, arch_syscall_addr and
> arch_syscall_match_sym_name are overridden to allow ftrace syscalls to
> work given the unusual system call table structure and symbol names that
> start with a period.

Not unusual, just different (ie. better) than x86 ;)

> diff --git a/arch/powerpc/include/asm/syscall.h b/arch/powerpc/include/as=
m/syscall.h
> index 23913e9..4098105 100644
> --- a/arch/powerpc/include/asm/syscall.h
> +++ b/arch/powerpc/include/asm/syscall.h
> @@ -15,6 +15,15 @@
> =20
>  #include <linux/sched.h>
> =20
> +/* ftrace syscalls requires exporting the sys_call_table */
> +#ifdef CONFIG_FTRACE_SYSCALLS
> +#ifdef CONFIG_PPC64
> +extern const unsigned long long *sys_call_table;

I'm not sure why this is ULL ? UL and ULL are both 64 bits (on 64bit),
and it would save you this ifdef block and a cast in
arch_syscall_addr().

> +#else /* !CONFIG_PPC64 */
> +extern const unsigned long *sys_call_table;
> +#endif /* CONFIG_PPC64 */
> +#endif /* CONFIG_FTRACE_SYSCALLS */
> +
>  static inline long syscall_get_nr(struct task_struct *task,
>  				  struct pt_regs *regs)
>  {
> diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/includ=
e/asm/thread_info.h
> index aa9d383..e7a8af2 100644
> --- a/arch/powerpc/include/asm/thread_info.h
> +++ b/arch/powerpc/include/asm/thread_info.h
> @@ -110,7 +110,8 @@ static inline struct thread_info *current_thread_info=
(void)
>  #define TIF_NOERROR		12	/* Force successful syscall return */
>  #define TIF_NOTIFY_RESUME	13	/* callback before returning to user */
>  #define TIF_FREEZE		14	/* Freezing for suspend */
> -#define TIF_RUNLATCH		15	/* Is the runlatch enabled? */
> +#define TIF_SYSCALL_TRACEPOINT	15	/* syscall tracepoint instrumentation =
*/
> +#define TIF_RUNLATCH		16	/* Is the runlatch enabled? */

I don't grok why this is good or safe, not that it isn't but please tell
me why it is :)

> diff --git a/arch/powerpc/kernel/Makefile b/arch/powerpc/kernel/Makefile
> index 8773263..9c404bb 100644
> --- a/arch/powerpc/kernel/Makefile
> +++ b/arch/powerpc/kernel/Makefile
> @@ -98,6 +98,7 @@ obj64-$(CONFIG_AUDIT)		+=3D compat_audit.o
> =20
>  obj-$(CONFIG_DYNAMIC_FTRACE)	+=3D ftrace.o
>  obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+=3D ftrace.o
> +obj-$(CONFIG_FTRACE_SYSCALLS)	+=3D ftrace.o

You're following the existing pattern there, but it's a little odd.
Seems like those three config options should really all depend on
something common and that should trigger the build of ftrace.c

> diff --git a/arch/powerpc/kernel/ftrace.c b/arch/powerpc/kernel/ftrace.c
> index ce1f3e4..b34171e 100644
> --- a/arch/powerpc/kernel/ftrace.c
> +++ b/arch/powerpc/kernel/ftrace.c
> @@ -22,6 +22,7 @@
>  #include <asm/cacheflush.h>
>  #include <asm/code-patching.h>
>  #include <asm/ftrace.h>
> +#include <asm/syscall.h>
> =20
>=20
>  #ifdef CONFIG_DYNAMIC_FTRACE
> @@ -600,3 +601,15 @@ void prepare_ftrace_return(unsigned long *parent, un=
signed long self_addr)
>  	}
>  }
>  #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
> +
> +#if defined(CONFIG_FTRACE_SYSCALLS) && defined(CONFIG_PPC64)

Does 32-bit just work using the existing routines? Or do we not support
it on 32-bit (though that's not what your Kconfig change said).

> +unsigned long __init arch_syscall_addr(int nr)
> +{
> +	return (unsigned long)sys_call_table[nr*2];

That's the cast I was referring to.

> +}
> +
> +inline bool arch_syscall_match_sym_name(const char *sym, const char *nam=
e)
> +{
> +	return (!strcmp(sym + 4, name + 3));

So the +4 is to skip ".sys" and the +3 is to skip "sys" ? That could use
a comment IMHO :)


cheers



--=-HpTfXCVmlRcZ5i46g9PE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkvr6/sACgkQdSjSd0sB4dI+HwCgwKGOD6K19HGvhpV5cnyWDwtU
UPUAoIpXr+Wjp9g18DHSMtPkoYTAfwpg
=OxIB
-----END PGP SIGNATURE-----

--=-HpTfXCVmlRcZ5i46g9PE--

