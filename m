Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab1LMUhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 15:37:40 -0500
Received: from www.linutronix.de ([62.245.132.108]:58606 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab1LMUhg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:37:36 -0500
Date: Tue, 13 Dec 2011 21:37:27 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: john.stultz@linaro.org, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, cschan@codeaurora.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [tip:core/debugobjects] debugobjects: Be smarter about static
 objects
In-Reply-To: <4EE7A946.9010909@codeaurora.org>
Message-ID: <alpine.LFD.2.02.1112132127180.3020@ionos>
References: <1320724108-20788-2-git-send-email-sboyd@codeaurora.org> <tip-feac18dda25134005909e7770c77464e65608bd8@git.kernel.org> <alpine.LFD.2.02.1112131137130.3020@ionos> <4EE7A946.9010909@codeaurora.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Dec 2011, Stephen Boyd wrote:
> 
> This code is only slightly confusing

Maybe we should tell that the guy who wrote it :)
 
> static int __init fixup_activate(void *addr, enum debug_obj_state state)
> {
>         struct self_test *obj = addr;
> 
>         switch (state) {
>         case ODEBUG_STATE_NOTAVAILABLE:
>                 if (obj->static_init == 1) {
>                         debug_object_init(obj, &descr_type_test);
>                         debug_object_activate(obj, &descr_type_test);
>                         /*
>                          * Real code should return 0 here ! This is
>                          * not a fixup of some bad behaviour. We
>                          * merily call the debug_init function to keep
>                          * track of the object.
>                          */
>                         return 1;
>                 } else {
>                         /* Real code needs to emit a warning here */
>                 }
>                 return 0;
> 
> 
> It seems that it does the complete opposite of what it should do, i.e.
> return 1 when the fixup is static and not actually a problem and return
> 0 otherwise. Because of this return 1, debug_object_activate() thinks
> there was a problem in the fixup and then it ups the warning count
> because this patch added a warning print for static objects.

Hmm, I think that was because I had not implemented that static
warning thing back then. So yes, it's backwards and should be fixed
proper:

> diff --git a/lib/debugobjects.c b/lib/debugobjects.c
> index 77cb245..0ab9ae8 100644
> --- a/lib/debugobjects.c
> +++ b/lib/debugobjects.c
> @@ -818,17 +818,9 @@ static int __init fixup_activate(void *addr, enum debug_obj_state state)   
>                 if (obj->static_init == 1) {
>                         debug_object_init(obj, &descr_type_test);
>                         debug_object_activate(obj, &descr_type_test);
> -                       /*
> -                        * Real code should return 0 here ! This is
> -                        * not a fixup of some bad behaviour. We
> -                        * merily call the debug_init function to keep
> -                        * track of the object.
> -                        */
> -                       return 1;
> -               } else {
> -                       /* Real code needs to emit a warning here */
> +                       return 0;
>                 }
> -               return 0;
> +               return 1;
> 
>         case ODEBUG_STATE_ACTIVE:
>                 debug_object_deactivate(obj, &descr_type_test);
> @@ -967,7 +959,7 @@ static void __init debug_objects_selftest(void)
> 
>         obj.static_init = 1;
>         debug_object_activate(&obj, &descr_type_test);
> -       if (check_results(&obj, ODEBUG_STATE_ACTIVE, ++fixups, warnings))
> +       if (check_results(&obj, ODEBUG_STATE_ACTIVE, fixups, warnings))
>                 goto out;
>         debug_object_init(&obj, &descr_type_test);
>         if (check_results(&obj, ODEBUG_STATE_INIT, ++fixups, ++warnings))
> 
> 
> 
> This would make the fixup function for a static NOTAVAILABLE object
> return 0 and 1 appropriately and corrects the fixup and warning checking
> to reflect that nothing was in need of fixing.

Yes, the other thing works, but is butt ugly.
 
> Why was the fixup for selftest inverted?

See above plus laziness I assume :)

Can you please resend with a changelong ?

Thanks,

	tglx
