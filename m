Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab1HXPoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 11:44:17 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:39994 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172Ab1HXPoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 11:44:13 -0400
Date: Wed, 24 Aug 2011 17:44:08 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Borislav Petkov <bp@amd64.org>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        kernel-janitors@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/x86/kernel/microcode_core.c: add missing
 platform_device_unregister
In-Reply-To: <20110824153611.GB21066@gere.osrc.amd.com>
Message-ID: <Pine.LNX.4.64.1108241742480.25172@ask.diku.dk>
References: <1314198652-10333-1-git-send-email-julia@diku.dk>
 <20110824153611.GB21066@gere.osrc.amd.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011, Borislav Petkov wrote:

> On Wed, Aug 24, 2011 at 05:10:52PM +0200, Julia Lawall wrote:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > Call platform_device_unregister as in the previous error-handling code.
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> > 
> > ---
> > This is not tested, but I couldn't see how else platform_device_unregister
> > could be called.
> > 
> >  arch/x86/kernel/microcode_core.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/microcode_core.c b/arch/x86/kernel/microcode_core.c
> > index f924280..1872a3a 100644
> > --- a/arch/x86/kernel/microcode_core.c
> > +++ b/arch/x86/kernel/microcode_core.c
> > @@ -532,8 +532,10 @@ static int __init microcode_init(void)
> >  	}
> >  
> >  	error = microcode_dev_init();
> > -	if (error)
> > +	if (error) {
> > +		platform_device_unregister(microcode_pdev);
> >  		return error;
> > +	}
> >  
> >  	register_syscore_ops(&mc_syscore_ops);
> >  	register_hotcpu_notifier(&mc_cpu_notifier);
> 
> I guess the most sensible thing to do here is to convert this to the
> classic goto with labels kernel style:
> 
> 	...
> 	error = sysdev_driver_register(..);
> 	mutex_unlock(&microcode_mutex);
> 	put_online_cpus();
> 	if (error)
> 		goto err_sysdev;
> 
> 	error = microcode_dev_init();
> 	if (error)
> 		goto err_dev;
> 
> 	...
> 
> err_dev:
>         get_online_cpus();
>         mutex_lock(&microcode_mutex);
> 
>         sysdev_driver_unregister(&cpu_sysdev_class, &mc_sysdev_driver);
> 
>         mutex_unlock(&microcode_mutex);
>         put_online_cpus();
> 
> 
> err_sysdev:
> 	platform_device_unregister(microcode_pdev);
> 
> out:
> 	return err;
> 
> or something to that effect.

That seems like a fairly big change.  Is it desirable to move the calls to 
sysdev_driver_register and microcode_dev_init up over the get_online_cpus 
... put_online_cpus sequence?

julia
