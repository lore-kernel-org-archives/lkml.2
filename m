Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab1JKONS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 10:13:18 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:32845 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750942Ab1JKONR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 10:13:17 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: EFPO4D4VM1mSCLtUdDsHSZzQ9NmyI691vd4yMKSaU1DG3tR
 FlimZfdqv_A_Whc7WHHqXue8VqVzwdYW._8ruXfHTrFZh61G14RJdXD6w.5w
 nQmXyc_nvhD9AROWZAhWZZFnWRMSqHzWZHOd9LpA9uWOPPmCbPEQtgWwlf6N
 qDDga3X4aPhijNW34n4T17Kl9TDVI3NtaD_8RreoRX0y9wGwDLPGa0cUHjJc
 PN4xoBy8ejMbcHrqz8AfWH_hCT6EGROGIRx_sybtXLenk.HVMw2P.crkbjQJ
 OzNjSBoIApJsTNjWSxLPW1f6czbe1VGO6ETDceWeAgMLO_y1ysuQyFgKP.EZ
 iXFvvkxhkgAok7nfm.qOsSNu3O4ENq7jzkpj2H.G6Dl1jy2O0Za_4z07jlU6
 vtHFHzQP0GAIoe044gepCBw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 11 Oct 2011 09:13:14 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
X-X-Sender: cl@router.home
To: "Alex,Shi" <alex.shi@intel.com>
cc: "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH] Code clean up for percpu_xxx() functions
In-Reply-To: <1318324774.27949.693.camel@debian>
Message-ID: <alpine.DEB.2.00.1110110910480.3388@router.home>
References: <1318237851.27949.190.camel@debian>  <alpine.DEB.2.00.1110101026080.16264@router.home> <1318324774.27949.693.camel@debian>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Oct 2011, Alex,Shi wrote:

> percpu_read() used in asm/percpu.h yet. Anyway, I removed definitions
> here and do a work around for the function as following:
>
> @@ -551,7 +544,11 @@ static __always_inline int x86_this_cpu_constant_test_bit(unsigned int nr,
>  {
>         unsigned long __percpu *a = (unsigned long *)addr + nr / BITS_PER_LONG;
>
> -       return ((1UL << (nr % BITS_PER_LONG)) & percpu_read(*a)) != 0;
> +#ifdef CONFIG_X86_64
> +       return ((1UL << (nr % BITS_PER_LONG)) & this_cpu_read_8(*a)) != 0;
> +#else
> +       return ((1UL << (nr % BITS_PER_LONG)) & this_cpu_read_4(*a)) != 0;
> +#endif

OK that looks okay.

> Signed-off-by: Alex Shi <alex.shi@intel.com>

Is this a revised patch? I do not see a use of the __this_cpu_xx ops.

> -#define percpu_write(var, val)		percpu_to_op("mov", var, val)
> -#define percpu_add(var, val)		percpu_add_op(var, val)
> -#define percpu_sub(var, val)		percpu_add_op(var, -(val))
> -#define percpu_and(var, val)		percpu_to_op("and", var, val)
> -#define percpu_or(var, val)		percpu_to_op("or", var, val)
> -#define percpu_xor(var, val)		percpu_to_op("xor", var, val)
> -#define percpu_inc(var)		percpu_unary_op("inc", var)
> +#define this_cpu_read_stable(var)	percpu_from_op("mov", var, "p" (&(var)))
> +#define this_cpu_inc(var)		percpu_unary_op("inc", var)

Why redefine this_cpu_inc? include/linux/percpu.h already defines it.

