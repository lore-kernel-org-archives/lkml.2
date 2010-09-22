Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab0IVSX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 14:23:59 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:41181 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187Ab0IVSX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 14:23:58 -0400
Date: Wed, 22 Sep 2010 11:43:04 -0700
From: Andres Salomon <dilinger@queued.net>
To: Daniel Drake <dsd@laptop.org>
Cc: tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] OLPC: Extend BIOS signature check
Message-ID: <20100922114304.4afb936d@debxo>
In-Reply-To: <20100922164437.5712F9D401B@zog.reactivated.net>
References: <20100922164437.5712F9D401B@zog.reactivated.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Sep 2010 17:44:37 +0100 (BST)
Daniel Drake <dsd@laptop.org> wrote:

> The XO-1.5 laptop is not currently detected as an OLPC machine because
> it fails this XO-1-centric check.
> 
> Now that we have OLPC OFW support in the kernel, a more sensible
> check is to see if we found OFW during boot. This also eliminates the
> need to check the BIOS signature, since we trust the detection code
> in olpc_ofw.c
> 
> Also remove a now-meaningless codepath, as we're always going to have
> OFW support with OLPC.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
[...]
> diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
> index 10b4dce..52ecc3f 100644
> --- a/arch/x86/kernel/olpc.c
> +++ b/arch/x86/kernel/olpc.c
> @@ -183,7 +183,6 @@ err:
>  }
>  EXPORT_SYMBOL_GPL(olpc_ec_cmd);
>  
> -#ifdef CONFIG_OLPC_OPENFIRMWARE
>  static void __init platform_detect(void)
>  {
>  	size_t propsize;
> @@ -197,37 +196,14 @@ static void __init platform_detect(void)
>  	}
>  	olpc_platform_info.boardrev = be32_to_cpu(rev);
>  }
> -#else
> -static void __init platform_detect(void)
> -{
> -	/* stopgap until OFW support is added to the kernel */
> -	olpc_platform_info.boardrev = olpc_board(0xc2);
> -}
> -#endif
>  
>  static int __init olpc_init(void)
>  {
> -	unsigned char *romsig;
> -
> -	/* The ioremap check is dangerous; limit what we run it on */
> -	if (!is_geode() || cs5535_has_vsa2())
> +	if (!olpc_ofw_present())
>  		return 0;
>  
>  	spin_lock_init(&ec_lock);
>  
> -	romsig = ioremap(0xffffffc0, 16);
> -	if (!romsig)
> -		return 0;
> -
> -	if (strncmp(romsig, "CL1   Q", 7))
> -		goto unmap;
> -	if (strncmp(romsig+6, romsig+13, 3)) {
> -		printk(KERN_INFO "OLPC BIOS signature looks
> invalid.  "
> -				"Assuming not OLPC\n");
> -		goto unmap;
> -	}
> -
> -	printk(KERN_INFO "OLPC board with OpenFirmware %.16s\n",
> romsig); 
>  
>  	/* get the platform revision */
> @@ -250,8 +226,6 @@ static int __init olpc_init(void)
>  			olpc_platform_info.boardrev >> 4,
>  			olpc_platform_info.ecver);
>  
> -unmap:
> -	iounmap(romsig);
>  	return 0;
>  }
>  

I'm ecstatic to see this stuff go away.  However, Mitch has pointed out
that there are embedded x86 machines running OFW, so just checking for
the existence of OFW is not enough.

My suggestion would be to change to code to something like:


spin_lock_init(&ec_lock);
if (!olpc_ofw_present() && !olpc_platform_detect())
	return 0;  
olpc_platform_info.flags |= OLPC_F_PRESENT;


static int __init olpc_platform_detect(void)
{
	const char *olpc_arch = NULL;
	void *res[] = { &olpc_arch };

	/* fetch "architecture" property from / of devtree here */
 
	if (!olpc_arch || strncmp(olpc_arch, "olpc"))
		return -ENODEV;

	return platform_detect();
}

And actually, once the device-tree stuff is upstream (still pending
reviews), you can probably fetch the architecture from that rather than
calling into OFW.

> diff --git a/arch/x86/kernel/olpc_ofw.c b/arch/x86/kernel/olpc_ofw.c
> index 3218aa7..e7bfcc4 100644
> --- a/arch/x86/kernel/olpc_ofw.c
> +++ b/arch/x86/kernel/olpc_ofw.c
> @@ -74,6 +74,12 @@ int __olpc_ofw(const char *name, int nr_args,
> const void **args, int nr_res, }
>  EXPORT_SYMBOL_GPL(__olpc_ofw);
>  
> +int olpc_ofw_present(void)
> +{
> +	return olpc_ofw_cif != NULL;
> +}
> +EXPORT_SYMBOL_GPL(olpc_ofw_present);

Definitely should return a bool.

> +
>  /* OFW cif _should_ be above this address */
>  #define OFW_MIN 0xff000000
>  

