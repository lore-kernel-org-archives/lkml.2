Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab1LMTgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 14:36:43 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39648 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab1LMTgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 14:36:39 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6559"; a="146339422"
Message-ID: <4EE7A946.9010909@codeaurora.org>
Date: Tue, 13 Dec 2011 11:36:38 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: john.stultz@linaro.org, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, cschan@codeaurora.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [tip:core/debugobjects] debugobjects: Be smarter about static
 objects
References: <1320724108-20788-2-git-send-email-sboyd@codeaurora.org> <tip-feac18dda25134005909e7770c77464e65608bd8@git.kernel.org> <alpine.LFD.2.02.1112131137130.3020@ionos>
In-Reply-To: <alpine.LFD.2.02.1112131137130.3020@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/11 02:38, Thomas Gleixner wrote:
> Stephen,
>
> On Mon, 28 Nov 2011, tip-bot for Stephen Boyd wrote:
>
>> Commit-ID:  feac18dda25134005909e7770c77464e65608bd8
>> Gitweb:     http://git.kernel.org/tip/feac18dda25134005909e7770c77464e65608bd8
>> Author:     Stephen Boyd <sboyd@codeaurora.org>
>> AuthorDate: Mon, 7 Nov 2011 19:48:26 -0800
>> Committer:  Thomas Gleixner <tglx@linutronix.de>
>> CommitDate: Wed, 23 Nov 2011 18:49:22 +0100
>>
>> debugobjects: Be smarter about static objects
>>
>> Make debugobjects use the return code from the fixup function. That
>> allows us better diagnostics in the activate check than relying on a
>> WARN_ON() in the object specific code.
> that series wreckaged the debugobjects selftest. Can you please have a
> look?
>
> [    0.000000] ODEBUG: selftest warnings failed 4 != 5
>
>

Thanks, I should have run the selftest :-(

This code is only slightly confusing

static int __init fixup_activate(void *addr, enum debug_obj_state state)
{
        struct self_test *obj = addr;

        switch (state) {
        case ODEBUG_STATE_NOTAVAILABLE:
                if (obj->static_init == 1) {
                        debug_object_init(obj, &descr_type_test);
                        debug_object_activate(obj, &descr_type_test);
                        /*
                         * Real code should return 0 here ! This is
                         * not a fixup of some bad behaviour. We
                         * merily call the debug_init function to keep
                         * track of the object.
                         */
                        return 1;
                } else {
                        /* Real code needs to emit a warning here */
                }
                return 0;


It seems that it does the complete opposite of what it should do, i.e.
return 1 when the fixup is static and not actually a problem and return
0 otherwise. Because of this return 1, debug_object_activate() thinks
there was a problem in the fixup and then it ups the warning count
because this patch added a warning print for static objects.

I see two solutions:

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 77cb245..a79083e 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -967,7 +967,7 @@ static void __init debug_objects_selftest(void)

        obj.static_init = 1;
        debug_object_activate(&obj, &descr_type_test);
-       if (check_results(&obj, ODEBUG_STATE_ACTIVE, ++fixups, warnings))
+       if (check_results(&obj, ODEBUG_STATE_ACTIVE, ++fixups, ++warnings))
                goto out;
        debug_object_init(&obj, &descr_type_test);
        if (check_results(&obj, ODEBUG_STATE_INIT, ++fixups, ++warnings))


This would just up the warning count to take into account that a warning
is now printed when the state is NOTAVAILABLE and the fixup returns 1.

Or

diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index 77cb245..0ab9ae8 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -818,17 +818,9 @@ static int __init fixup_activate(void *addr, enum debug_obj_state state)   
                if (obj->static_init == 1) {
                        debug_object_init(obj, &descr_type_test);
                        debug_object_activate(obj, &descr_type_test);
-                       /*
-                        * Real code should return 0 here ! This is
-                        * not a fixup of some bad behaviour. We
-                        * merily call the debug_init function to keep
-                        * track of the object.
-                        */
-                       return 1;
-               } else {
-                       /* Real code needs to emit a warning here */
+                       return 0;
                }
-               return 0;
+               return 1;

        case ODEBUG_STATE_ACTIVE:
                debug_object_deactivate(obj, &descr_type_test);
@@ -967,7 +959,7 @@ static void __init debug_objects_selftest(void)

        obj.static_init = 1;
        debug_object_activate(&obj, &descr_type_test);
-       if (check_results(&obj, ODEBUG_STATE_ACTIVE, ++fixups, warnings))
+       if (check_results(&obj, ODEBUG_STATE_ACTIVE, fixups, warnings))
                goto out;
        debug_object_init(&obj, &descr_type_test);
        if (check_results(&obj, ODEBUG_STATE_INIT, ++fixups, ++warnings))



This would make the fixup function for a static NOTAVAILABLE object
return 0 and 1 appropriately and corrects the fixup and warning checking
to reflect that nothing was in need of fixing.

Why was the fixup for selftest inverted?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

