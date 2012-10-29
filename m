Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab2J2A4n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 20:56:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59708 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab2J2A4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 20:56:42 -0400
Message-ID: <508DD443.9050505@gmail.com>
Date: Mon, 29 Oct 2012 11:56:35 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Corey Minyard <cminyard@mvista.com>, minyard@acm.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: Re: [PATCH v2] Remove uninitialized_var()
References: <1350420820-7156-1-git-send-email-minyard@acm.org> <1350420820-7156-5-git-send-email-minyard@acm.org> <20121022164902.9b204646.akpm@linux-foundation.org> <508AE611.3020504@mvista.com> <CA+55aFw+Vbj0i=1TGqCR5vQkCzWJ0QxK6CernOU6eedsudAixw@mail.gmail.com> <20121027131203.GA27313@gmail.com> <20121027114836.e9a6a922.akpm@linux-foundation.org> <20121028102007.GA7547@gmail.com>
In-Reply-To: <20121028102007.GA7547@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/10/12 21:20, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> On Sat, 27 Oct 2012 15:12:03 +0200 Ingo Molnar <mingo@kernel.org> wrote:
>>
>>> There's 3 types of conversions done:
>>>
>>>    uninitialized_var(x)        =>  x = 0       /* for scalar types */
>>>    uninitialized_var(x)        =>  x = NULL    /* for pointers */
>>>    uninitialized_var(x)        =>  x = { }     /* for structures, unions */
>>
>> It's regrettable that we lose information.  
>> uninitialized_var() says "this isn't needed - it's just there 
>> for gcc".  The reader can of course work out the reason with 
>> careful code inspection, but that's a lot more time consuming.
>>
>> We could go add "/* keep gcc quiet */" to every site, or add 
>> self-documenting macros for the above.
> 
> Ok, agreed - I've added /* GCC */ to every site to make people 
> think about it.
> 
> I left it a bit mystic because in some cases this macro was 
> mis-used not to suppress GCC being wrong, but to hide GCC being 
> *right*: for example unused variable warnings in cases like:
> 
>    int uninitialized_var(var);
> 
>    #ifdef XYZ
>    var = ...;
>    ...
>    #endif
> 
> which (ab-)use was no doubt actively dangerous beyond being 
> ugly. One such example is in arch/x86/mm/numa.c. (These cases 
> now turn into clear (and always harmless) compiler warnings, as 
> they should.)

Shouldn't those cases be using:

	int var __maybe_unused;

To clarify that the variable is not used in some configurations. Or
moving the variable declaration inside the #ifdef block if possible. The
alternative:

	#ifdef XYZ
	int var;
	#endif
	
	...

	#ifdef XYZ
	var = ...;
	#endif

Does get pretty clunky.

> 
> This further strengthens the argument that we should remove this 
> whole thing.
> 
> Thanks,
> 
> 	Ingo
> 
> ---
> Signed-off-by: Ingo Molnar <mingo@kernel.org>

<snip>

>  185 files changed, 281 insertions(+), 291 deletions(-)

It might be interesting to know how many instances of uninitialized_var
are no longer required because of code change around them. Possibly
redefining uninitialized_var as an empty macro and then checking how
many don't cause errors would identify if any can just be removed
outright rather than converting them to an assignment.

> diff --git a/arch/arm/mach-sa1100/assabet.c b/arch/arm/mach-sa1100/assabet.c
> index 6a7ad3c..5ec34d6 100644
> --- a/arch/arm/mach-sa1100/assabet.c
> +++ b/arch/arm/mach-sa1100/assabet.c
> @@ -388,7 +388,7 @@ static void __init map_sa1100_gpio_regs( void )
>   */
>  static void __init get_assabet_scr(void)
>  {
> -	unsigned long uninitialized_var(scr), i;
> +	unsigned long scr = 0 /* GCC */, i;
>  
>  	GPDR |= 0x3fc;			/* Configure GPIO 9:2 as outputs */
>  	GPSR = 0x3fc;			/* Write 0xFF to GPIO 9:2 */
> diff --git a/arch/ia64/kernel/process.c b/arch/ia64/kernel/process.c
> index 35e106f..2c2da64 100644
> --- a/arch/ia64/kernel/process.c
> +++ b/arch/ia64/kernel/process.c
> @@ -493,7 +493,7 @@ static void
>  do_copy_task_regs (struct task_struct *task, struct unw_frame_info *info, void *arg)
>  {
>  	unsigned long mask, sp, nat_bits = 0, ar_rnat, urbs_end, cfm;
> -	unsigned long uninitialized_var(ip);	/* GCC be quiet */
> +	unsigned long ip = 0 /* GCC */;	/* GCC be quiet */

Doubled up comment. Same in a few other places.

>  	elf_greg_t *dst = arg;
>  	struct pt_regs *pt;
>  	char nat;
> diff --git a/arch/ia64/mm/discontig.c b/arch/ia64/mm/discontig.c
> index c641333..75cc8da 100644
> --- a/arch/ia64/mm/discontig.c
> +++ b/arch/ia64/mm/discontig.c
> @@ -185,7 +185,7 @@ static void *per_cpu_node_setup(void *cpu_data, int node)
>  void __init setup_per_cpu_areas(void)
>  {
>  	struct pcpu_alloc_info *ai;
> -	struct pcpu_group_info *uninitialized_var(gi);
> +	struct pcpu_group_info *gi = NULL /* GCC */;

The placement of the comment here is a bit ugly, can you change it so it
appears after the semicolon when it is the last initialiser?

~Ryan

