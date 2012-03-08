Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429Ab2CHMSg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 07:18:36 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:52649
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757194Ab2CHMSc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 07:18:32 -0500
X-SpamScore: -4
X-BigFish: VPS-4(zz9371I98dKzz1202hzz8275bh8275dhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M0KFIQ-02-D53-02
X-M-MSG: 
From: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
To: Rusty Russell <rusty@ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
Subject: RE: [PATCH 1/2] Refine mutex and rcu method in module.c,
 kernel<3.2.9>
Thread-Topic: [PATCH 1/2] Refine mutex and rcu method in module.c,
 kernel<3.2.9>
Thread-Index: Acz8cbLg6k3HMRVqQxaI2PGzwf9WcQAV53YAABY7RRA=
Date: Thu, 8 Mar 2012 12:18:19 +0000
Message-ID: <491D6B4EAD0A714894D8AD22F4BDE043032A1A@SCYBEXDAG04.amd.com>
References: <491D6B4EAD0A714894D8AD22F4BDE04303289D@SCYBEXDAG04.amd.com>
 <87ipifwiwh.fsf@rustcorp.com.au>
In-Reply-To: <87ipifwiwh.fsf@rustcorp.com.au>
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

