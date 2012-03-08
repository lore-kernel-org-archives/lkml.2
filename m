Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab2CHQOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 11:14:12 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:36762
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751476Ab2CHQOH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 11:14:07 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz9371I98dKzz1202hzz8275bh8275dhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0KQFA-01-BK9-02
X-M-MSG: 
From: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
To: Rusty Russell <rusty@ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
Subject: RE: [PATCH 1/2] Refine mutex and rcu method in module.c,
 kernel<3.2.9>
Thread-Topic: [PATCH 1/2] Refine mutex and rcu method in module.c,
 kernel<3.2.9>
Thread-Index: Acz8cbLg6k3HMRVqQxaI2PGzwf9WcQAV53YAABY7RRAACIe/QA==
Date: Thu, 8 Mar 2012 16:13:53 +0000
Message-ID: <491D6B4EAD0A714894D8AD22F4BDE043032A5E@SCYBEXDAG04.amd.com>
References: <491D6B4EAD0A714894D8AD22F4BDE04303289D@SCYBEXDAG04.amd.com>
 <87ipifwiwh.fsf@rustcorp.com.au>
 <491D6B4EAD0A714894D8AD22F4BDE043032A1A@SCYBEXDAG04.amd.com>
In-Reply-To: <491D6B4EAD0A714894D8AD22F4BDE043032A1A@SCYBEXDAG04.amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.74.102]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen, Dennis (SRDC SW) 
Sent: Thursday, March 08, 2012 8:18 PM
To: Rusty Russell; linux-kernel@vger.kernel.org
Cc: Chen, Dennis (SRDC SW)
Subject: RE: [PATCH 1/2] Refine mutex and rcu method in module.c, kernel<3.2.9>

From: Rusty Russell [mailto:rusty@ozlabs.org] 
Sent: Thursday, March 08, 2012 5:18 PM
To: Chen, Dennis (SRDC SW); linux-kernel@vger.kernel.org
Cc: Chen, Dennis (SRDC SW)
Subject: Re: [PATCH 1/2] Refine mutex and rcu method in module.c, kernel<3.2.9>

On Wed, 7 Mar 2012 14:51:06 +0000, "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com> wrote:
> 1. Narrow down the granularity of mutex_lock/ mutex_unlock
> 2. Replace some unnecessary mutex_lock/mutex_unlock pairs with RCU
> 3. Refine the consistent calling style of RCU functioan 

Hi Dennis,

        This follows a logical evolution, where we wean off the mutex,
but AFAICT this is lost in the noise.  Taking the mutex might be naive,
but adding or removing a module is the slow path.  Or am I missing
something?

> -
> -       /* Now sew it into the lists so we can get lockdep and oops
> -        * info during argument parsing.  No one should access us, since
> -        * strong_try_module_get() will fail.
> -        * lockdep/oops can run asynchronous, so use the RCU list insertion
> -        * function to insert in a way safe to concurrent readers.
> -        * The mutex protects against concurrent writers.
> -        */
> -       mutex_lock(&module_mutex);
> +        
> +        /* Concurrent writers for the global modules list are protected by RCU*/
>         if (find_module(mod->name)) {
>                 err = -EEXIST;
>                 goto unlock;
>         }

RCU does not protect concurrent writers:

> -
> +        
>         /* This has to be done once we're sure module name is unique. */
>         dynamic_debug_setup(info.debug, info.num_debug);

Now this is racy...

======================================================================================

Hi Rusty,

I known RCU doesn't protect concurrent writers, so all the writers for the global modules list has been 
protected by the original module_mutex in the 2-patch, I just make the scope of module_mutex become smaller 
as it can, for example, dynamic_debug_setup doesn't touch modules, so it should not be in the protection of
module_mutex.

I am a person like to see a perfect world, especially in the kernel space:) Maybe I can write a test case
to trigger something you don't expect to see while the original codes will...let's think about it

BRs,
Dennis 

+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Hi Rusty,

Pls notice the following change in the patch (in set_all_modules_text_ro function):

/* Iterate through all modules and set each module's text as RO */
@@ -1693,7 +1699,7 @@
 {
        struct module *mod;
 
-       mutex_lock(&module_mutex);
+       rcu_read_lock();
        list_for_each_entry_rcu(mod, &modules, list) {
                if ((mod->module_core) && (mod->core_text_size)) {
                        set_page_attributes(mod->module_core,
@@ -1706,7 +1712,7 @@
                                                set_memory_ro);
                }
        }
-       mutex_unlock(&module_mutex);
+       rcu_read_unlock();
 }

This function just needs to iterate the modules list, but now it holds a unnecessary lock when it does that, 
The other module can't be inserted during this operation, also can you make sure the set_page_attributes will
run smoothly all the time, if not it's a risk action to hold a lock.
So summary--
I think the idea for kernel module protection is simple:
Writers to modules, use mutex_lock
Readers, use rcu. __ALL__ codes here should be with a unified style! This will make our kernel gracefully.

PS: my comments in the patch " /* Concurrent writers for the global modules list are protected by RCU*/" is not right, RCU
Should be mutex lock.

BRs,
Dennis 

