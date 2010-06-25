Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab0FYQVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 12:21:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51585 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab0FYQV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 12:21:29 -0400
Message-ID: <4C24D779.6020209@oracle.com>
Date: Fri, 25 Jun 2010 09:21:13 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Corey Minyard <minyard@acm.org>
Subject: Re: [PATCH -next] ipmi: fix module param sparse warnings
References: <20100624152122.bfc0472a.randy.dunlap@oracle.com> <201006252220.17228.rusty@rustcorp.com.au>
In-Reply-To: <201006252220.17228.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4C24D780.0087:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/10 05:50, Rusty Russell wrote:
> On Fri, 25 Jun 2010 07:51:22 am Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> The <arg> parameter in module_param_cb() should be a pointer,
> 
> Well, I don't think there's anything wrong with it being a function.

Ah, yes, I see.  That makes it a sparse error, right?

> The actual problem is that it tries to figure out if the arg is a bool
> or an int: if someone wants to work through the 700-odd cases of 
> module_param*bool and convert those vars to actual bools, that'd allow
> us to get rid of that logic.
> 
> Meanwhile, we can do this instead.  Does it solve it as well?

Yes, that also fixes it.
Thanks.

> Subject: ipmi: fix module param sparse warnings
> Date: Thu, 24 Jun 2010 15:21:22 -0700
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> The <arg> parameter in module_param_cb() should be a pointer,
> i.e., like one of these:
> 	union {
> 		void *arg;
> 		const struct kparam_string *str;
> 		const struct kparam_array *arr;
> 	};
> 
> sparse complains:
> drivers/char/ipmi/ipmi_watchdog.c:303:1: error: cannot dereference this type
> drivers/char/ipmi/ipmi_watchdog.c:307:1: error: cannot dereference this type
> drivers/char/ipmi/ipmi_watchdog.c:311:1: error: cannot dereference this type
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Corey Minyard <minyard@acm.org>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  drivers/char/ipmi/ipmi_watchdog.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> --- linux-next-20100528.orig/drivers/char/ipmi/ipmi_watchdog.c
> +++ linux-next-20100528/drivers/char/ipmi/ipmi_watchdog.c
> @@ -300,15 +300,15 @@ MODULE_PARM_DESC(timeout, "Timeout value
>  module_param(pretimeout, timeout, 0644);
>  MODULE_PARM_DESC(pretimeout, "Pretimeout value in seconds.");
>  
> -module_param_cb(action, &param_ops_str, action_op, 0644);
> +module_param_cb(action, &param_ops_str, &action_op, 0644);
>  MODULE_PARM_DESC(action, "Timeout action. One of: "
>  		 "reset, none, power_cycle, power_off.");
>  
> -module_param_cb(preaction, &param_ops_str, preaction_op, 0644);
> +module_param_cb(preaction, &param_ops_str, &preaction_op, 0644);
>  MODULE_PARM_DESC(preaction, "Pretimeout action.  One of: "
>  		 "pre_none, pre_smi, pre_nmi, pre_int.");
>  
> -module_param_cb(preop, &param_ops_str, preop_op, 0644);
> +module_param_cb(preop, &param_ops_str, &preop_op, 0644);
>  MODULE_PARM_DESC(preop, "Pretimeout driver operation.  One of: "
>  		 "preop_none, preop_panic, preop_give_data.");
>  
> 
> 


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
