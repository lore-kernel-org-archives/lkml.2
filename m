Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757676Ab2CJE0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 23:26:39 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60652 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab2CJE0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 23:26:38 -0500
Message-ID: <4F5AD7F6.2000509@gmail.com>
Date: Sat, 10 Mar 2012 12:26:30 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
CC: Rusty Russell <rusty@ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] Refine mutex and rcu method in module.c, kernel<3.2.9>
References: <491D6B4EAD0A714894D8AD22F4BDE04303289D@SCYBEXDAG04.amd.com> <87ipifwiwh.fsf@rustcorp.com.au> <491D6B4EAD0A714894D8AD22F4BDE043032A1A@SCYBEXDAG04.amd.com> <491D6B4EAD0A714894D8AD22F4BDE043032A5E@SCYBEXDAG04.amd.com>
In-Reply-To: <491D6B4EAD0A714894D8AD22F4BDE043032A5E@SCYBEXDAG04.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/2012 12:13 AM, Chen, Dennis (SRDC SW) wrote:
> Hi Rusty,
>
> Pls notice the following change in the patch (in set_all_modules_text_ro function):
>
> /* Iterate through all modules and set each module's text as RO */
> @@ -1693,7 +1699,7 @@
>   {
>          struct module *mod;
>
> -       mutex_lock(&module_mutex);
> +       rcu_read_lock();
>          list_for_each_entry_rcu(mod,&modules, list) {
>                  if ((mod->module_core)&&  (mod->core_text_size)) {
>                          set_page_attributes(mod->module_core,
> @@ -1706,7 +1712,7 @@
>                                                  set_memory_ro);
>                  }
>          }
> -       mutex_unlock(&module_mutex);
> +       rcu_read_unlock();
>   }
>
> This function just needs to iterate the modules list, but now it holds a unnecessary lock when it does that,
> The other module can't be inserted during this operation, also can you make sure the set_page_attributes will
> run smoothly all the time, if not it's a risk action to hold a lock.
> So summary--
> I think the idea for kernel module protection is simple:
> Writers to modules, use mutex_lock
> Readers, use rcu. __ALL__ codes here should be with a unified style! This will make our kernel gracefully.
>
> PS: my comments in the patch " /* Concurrent writers for the global modules list are protected by RCU*/" is not right, RCU
> Should be mutex lock.

I think your change makes sense, I don't know why preempt_disable() was 
used, git blame told me the related two commits are 4 years-old...

cb2a5205 2008-01-14 00:55:03 -0800 3180
d72b3751 2008-08-30 10:09:00 +0200 3181

maybe at that time rcu was not what it is today... Cc'ing Paul.
