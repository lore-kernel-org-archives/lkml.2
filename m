Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab2IOCzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 22:55:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40179 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455Ab2IOCzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 22:55:09 -0400
Date: Sat, 15 Sep 2012 08:25:02 +0530
From: Raghavendra D Prabhu <raghu.prabhu13@gmail.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: jeremy@goop.org, mingo@redhat.com, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        liu chuansheng <chuansheng.liu@intel.com>,
        Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re:  Re: [PATCH] IRQ: Add a check for uninitialized irqs.
Message-ID: <20120915025502.GB58426@Archie.local>
References: <9250ef1afde6ddd2bab613bd847ad54adc014bac.1347218449.git.rprabhu@wnohang.net>
 <504DEE1D.3040704@windriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
In-Reply-To: <504DEE1D.3040704@windriver.com>
X-Operating-System: Arch linux x86_64 3.5.3-1-ARCH
X-Editor: VIM - Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,


* On Mon, Sep 10, 2012 at 09:41:49AM -0400, Paul Gortmaker <paul.gortmaker@=
windriver.com> wrote:
>On 12-09-09 03:25 PM, raghu.prabhu13@gmail.com wrote:
>> From: Raghavendra D Prabhu <rprabhu@wnohang.net>
>>
>> Errors like "do_IRQ: 0.84 No Irq handler for vector (irq -1)" have been =
reported
>> earlier filling up the console/logs. So this adds a condition to check f=
or
>
>Reported by who, and where, and on what hardware, and under what
>circumstances?

I have seen it reported in many places like=20
https://bugzilla.redhat.com/show_bug.cgi?id=3D225399 and=20
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/480997

>
>You are adding another if statement to the hot path of do_IRQ just
>to mask some random unknown symptom. instead of trying to understand
>(and then solve) what the real breakage is.  Which is not the right
>approach.

I just realized that handler_irq checks for < NR_IRQS where the=20
underflow will fail and will return. So this patch is not required.

However,  I think we need to fix the unsigned / int mixup by=20
assigning vector_irq[..] to NR_IRQS+1  as guard value and=20
changing unsigned to signed as in patch.
>
>Paul.
>--
>
>> uninitialized irqs so that it exits early and doesn't proceed further. A=
lso, irq
>> is made a signed integer, since if it is not mapped to a vector, it will=
 be
>> assigned -1 which will be UINT_MAX otherwise.
>>
>> Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
>> ---
>>  arch/x86/kernel/irq.c | 13 ++++++++-----
>>  1 file changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
>> index d44f782..ddba63a 100644
>> --- a/arch/x86/kernel/irq.c
>> +++ b/arch/x86/kernel/irq.c
>> @@ -184,21 +184,24 @@ unsigned int __irq_entry do_IRQ(struct pt_regs *re=
gs)
>>
>>  	/* high bit used in ret_from_ code  */
>>  	unsigned vector =3D ~regs->orig_ax;
>> -	unsigned irq;
>> +	int irq;
>>
>>  	irq_enter();
>>  	exit_idle();
>>
>> -	irq =3D __this_cpu_read(vector_irq[vector]);
>> +	if (unlikely((irq =3D __this_cpu_read(vector_irq[vector])) =3D=3D -1))=
 {
>> +		pr_emerg_ratelimited("IRQ handler not setup for vector %u", vector);
>> +		goto err_exit;
>> +	}
>>
>>  	if (!handle_irq(irq, regs)) {
>>  		ack_APIC_irq();
>>
>> -		if (printk_ratelimit())
>> -			pr_emerg("%s: %d.%d No irq handler for vector (irq %d)\n",
>> -				__func__, smp_processor_id(), vector, irq);
>> +		pr_emerg_ratelimited("%s: %d.%d No irq handler for vector (irq %u)\n",
>> +			__func__, smp_processor_id(), vector, irq);
>>  	}
>>
>> +err_exit:
>>  	irq_exit();
>>
>>  	set_irq_regs(old_regs);
>>
>




Regards,
--=20
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJQU+4GAAoJEKYW3KHXK+l3GjMH/13tFhVkqOXX3/uj5ifwgPKG
2f6wHfMOWv579Nn9OCcrE33i3yuf+QD7pyan1c0PXfPQ2xJ7nIDS/q/puIweGLYI
LYQy1GllqJd/klPROnOpMjyqOdc+YC+6lZgSbZCrvHHON2uRvgiisU7UFrhFhGrF
DQ+UIGiBJbNlCKscVkAGFwbIPnJ7OgzAXfDbs//vw7bnV5bVLbHjUQ0hRMg4GWv8
lmKzpbhcd4kHpKqjBAsU5+yVQvD2xzOHzYxY5LQwhnkzgkqGoqpiKI7N0bKA5Bs9
x1QcUAfXrHH40zatLiGbWEqHX1xZmqAZxnn13GQWX6vHwHYbWkCS5mFoYk0QFbA=
=a8sv
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
