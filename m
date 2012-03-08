Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024Ab2CHJTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 04:19:15 -0500
Received: from ozlabs.org ([203.10.76.45]:56035 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274Ab2CHJTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 04:19:11 -0500
From: Rusty Russell <rusty@ozlabs.org>
To: "Chen\, Dennis \(SRDC SW\)" <Dennis1.Chen@amd.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "Chen\, Dennis \(SRDC SW\)" <Dennis1.Chen@amd.com>
Subject: Re: [PATCH 1/2] Refine mutex and rcu method in module.c, kernel<3.2.9>
In-Reply-To: <491D6B4EAD0A714894D8AD22F4BDE04303289D@SCYBEXDAG04.amd.com>
References: <491D6B4EAD0A714894D8AD22F4BDE04303289D@SCYBEXDAG04.amd.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 08 Mar 2012 19:48:06 +1030
Message-ID: <87ipifwiwh.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Cheers,
Rusty.
-- 
  How could I marry someone with more hair than me?  http://baldalex.org
