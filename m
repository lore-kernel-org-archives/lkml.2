Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934183Ab0GOVh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 17:37:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54171 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933759Ab0GOVh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 17:37:27 -0400
Date: Thu, 15 Jul 2010 14:35:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, x86@kernel.org
Subject: Re: Make CONFIG_DEBUG_RODATA boot-time configurable
Message-Id: <20100715143525.987dc8f4.randy.dunlap@oracle.com>
In-Reply-To: <20100715210944.GA24961@redhat.com>
References: <20100715210944.GA24961@redhat.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C3F7F5D.0090:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jul 2010 17:09:44 -0400 Dave Jones wrote:

> We had a request to disable DEBUG_RODATA in our kernel for debugging purposes.  
> Turning it off completely seems a bit unfortunate for the minority case
> of people wanting to do debugging, so I came up with this patch to make
> it a boot-time 'disable_rodata' argument.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> 
> diff --git a/init/main.c b/init/main.c
> index a42fdf4..eb60fae 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -820,6 +820,15 @@ static void run_init_process(char *init_filename)
>  	kernel_execve(init_filename, argv_init, envp_init);
>  }
>  
> +static unsigned int disable_rodata;
> +static int __init set_disable_rodata(char *str)
> +{
> +	disable_rodata = 1;
> +	return 1;
> +}
> +__setup("disable_rodata", set_disable_rodata);
> +
> +
>  /* This is a non __init function. Force it to be noinline otherwise gcc
>   * makes it inline to init() and it becomes part of init.text section
>   */
> @@ -830,7 +839,8 @@ static noinline int init_post(void)
>  	async_synchronize_full();
>  	free_initmem();
>  	unlock_kernel();
> -	mark_rodata_ro();
> +	if (disable_rodata == 0)
> +		mark_rodata_ro();
>  	system_state = SYSTEM_RUNNING;
>  	numa_default_policy();
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 4ddb58d..1320d80 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -651,6 +651,10 @@ and is between 256 and 4096 characters. It is defined in the file
>  			MTRR settings.  This parameter disables that behavior,
>  			possibly causing your machine to run very slowly.
>  
> +	disable_rodata [X86]

What is X86-specific about this boot option?

> +			Don't mark .rodata section as read-only.
> +			May be useful for debugging.
> +
>  	disable_timer_pin_1 [X86]
>  			Disable PIN 1 of APIC timer
>  			Can be useful to work around chipset bugs.
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
