Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab0EJMql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 08:46:41 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:41570 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab0EJMqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 08:46:39 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Huaxu Wan <huaxu.wan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       huaxu.wan@intel.com, Carsten Emde <Carsten.Emde@osadl.org>
Subject: Re: [PATCH 1/2 V2] hwmon: (coretemp) Detect the thermal sensors by CPUID
In-Reply-To: Your message of "Mon, 10 May 2010 11:35:25 +0800."
             <20100510033525.GC9181@owl>
From: Valdis.Kletnieks@vt.edu
References: <20100507095459.GA12190@owl>
            <20100510033525.GC9181@owl>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1273495551_8340P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 10 May 2010 08:45:51 -0400
Message-ID: <148928.1273495551@localhost>
X-Mirapoint-Received-SPF: 128.173.34.98 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020202.4BE80000.00C8,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1273495551_8340P
Content-Type: text/plain; charset=us-ascii

On Mon, 10 May 2010 11:35:25 +0800, Huaxu Wan said:
> 
> The thermal sensors of Intel(R) CPUs can be detected by CPUID instruction,
> indicated by CPUID.06H.EAX[0].
> 
> Signed-off-by: Huaxu Wan <huaxu.wan@linux.intel.com>
> Signed-off-by: Carsten Emde <C.Emde@osadl.org>
> ---
>  drivers/hwmon/coretemp.c |   24 +++++++-----------------
>  1 files changed, 7 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
> index e9b7fbc..d194207 100644
> --- a/drivers/hwmon/coretemp.c
> +++ b/drivers/hwmon/coretemp.c
> @@ -440,6 +440,7 @@ static int __init coretemp_init(void)
>  {
>  	int i, err = -ENODEV;
>  	struct pdev_entry *p, *n;
> +	u32 eax;
>  
>  	/* quick check if we run Intel */
>  	if (cpu_data(0).x86_vendor != X86_VENDOR_INTEL)
> @@ -450,23 +451,12 @@ static int __init coretemp_init(void)
>  		goto exit;
>  
>  	for_each_online_cpu(i) {
> -		struct cpuinfo_x86 *c = &cpu_data(i);
> -
> -		/* check if family 6, models 0xe (Pentium M DC),
> -		  0xf (Core 2 DC 65nm), 0x16 (Core 2 SC 65nm),
> -		  0x17 (Penryn 45nm), 0x1a (Nehalem), 0x1c (Atom),
> -		  0x1e (Lynnfield) */
> -		if ((c->cpuid_level < 0) || (c->x86 != 0x6) ||
> -		    !((c->x86_model == 0xe) || (c->x86_model == 0xf) ||
> -			(c->x86_model == 0x16) || (c->x86_model == 0x17) ||
> -			(c->x86_model == 0x1a) || (c->x86_model == 0x1c) ||
> -			(c->x86_model == 0x1e))) {

So we remove something that checks the CPU level for a model we *expect*
to find a thermal sensor, and only throws a KERN_WARNING if we're on a
model we don't know about...

> + 		/* check if the CPU has thermal sensor */
> + 		eax = cpuid_eax(0x06);
> + 		if (!(eax & 0x01)) {
> + 			struct cpuinfo_x86 *c = &cpu_data(i);
> + 			printk(KERN_WARNING DRVNAME ": CPU (model=0x%x)"
> + 				" has no thermal sensor!\n", c->x86_model);

And replace it with a totally unprotected check that's going to fire off
a KERN_WARNING on every single CPU that Intel ever made that doesn't
include a hardware thermal sensor - including all the family 0-5,
and model < 0x0e hardware.

KERN_WARNING is for "We expected to find the hardware but it's gone off
for a walk on us".  If you wanted to say "Hmm.. this CPU doesn't have one"
you probably wanted KERN_DEBUG or *maybe* KERN_INFO.

--==_Exmh_1273495551_8340P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFL5///cC3lWbTT17ARAsebAJ45wCEIcBkej9RyvSuThIT3aTwhUwCgtH4r
gocOJqnVegIe/kxcRFcgi7s=
=s9OR
-----END PGP SIGNATURE-----

--==_Exmh_1273495551_8340P--

