Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab0KHW2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:28:24 -0500
Received: from smtp-out.google.com ([74.125.121.35]:16692 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab0KHW2W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:28:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=jxKEEEPPs44z7wGfpKYgx/jbm5NI+eUm8UMgloN/oQ5CR0JKpT7o0s73IOESop+3A8
         OPLCPc18qo7LTPjjhI8g==
MIME-Version: 1.0
In-Reply-To: <20101108130939.13436673.randy.dunlap@oracle.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
 <20101108203322.22479.47929.stgit@crlf.mtv.corp.google.com> <20101108130939.13436673.randy.dunlap@oracle.com>
From: Mike Waychison <mikew@google.com>
Date: Mon, 8 Nov 2010 14:27:59 -0800
Message-ID: <AANLkTikBvbp44ttPG95Pf4aymjJk_Ke7H=sg_ZLcpfge@mail.gmail.com>
Subject: Re: [PATCH v2 18/23] sys-rq: Add option to soft dump
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: simon.kagstrom@netinsight.net, davem@davemloft.net, nhorman@tuxdriver.com,
        Matt Mackall <mpm@selenic.com>, adurbin@google.com,
        linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 8, 2010 at 1:09 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Mon, 08 Nov 2010 12:33:23 -0800 Mike Waychison wrote:
>
>> It is very useful to provide some means to force the kernel logs to make it out
>> via the kmsg_oops implementations on the console.  Add a new option 'Y' to
>> sysrq to allow dumping of logs to kmsg_dumper drivers.
>>
>> Signed-off-by: Mike Waychison <mikew@google.com>
>
> Hi,
>
> Please add 'y' to Documentation/sysrq.txt .

Ok.

Looking at the docs though, sparc64 has 'y' mapped to "Show global CPU
Registers".  The only slot available is 'a' if the list is up to date.

An alternative may be to overload 'v' "Forcefully restores framebuffer
console" and "Causes ETM buffer dump [ARM-specific]" as these actions
seem to be about making crash data visible.

>
>> ---
>>  drivers/char/sysrq.c |   14 +++++++++++++-
>>  1 files changed, 13 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/char/sysrq.c b/drivers/char/sysrq.c
>> index eaa5d3e..058d3c8 100644
>> --- a/drivers/char/sysrq.c
>> +++ b/drivers/char/sysrq.c
>> @@ -41,6 +41,7 @@
>>  #include <linux/oom.h>
>>  #include <linux/slab.h>
>>  #include <linux/input.h>
>> +#include <linux/kmsg_dump.h>
>>
>>  #include <asm/ptrace.h>
>>  #include <asm/irq_regs.h>
>> @@ -395,6 +396,17 @@ static struct sysrq_key_op sysrq_unrt_op = {
>>       .enable_mask    = SYSRQ_ENABLE_RTNICE,
>>  };
>>
>> +static void sysrq_handle_softdump(int key)
>> +{
>> +     kmsg_dump(KMSG_DUMP_SOFT, NULL);
>> +}
>> +static struct sysrq_key_op sysrq_softdump_op = {
>> +     .handler        = sysrq_handle_softdump,
>> +     .help_msg       = "soft-dump(Y)",
>> +     .action_msg     = "Trigger a soft dump",
>> +     .enable_mask    = SYSRQ_ENABLE_DUMP,
>> +};
>> +
>>  /* Key Operations table and lock */
>>  static DEFINE_SPINLOCK(sysrq_key_table_lock);
>>
>> @@ -451,7 +463,7 @@ static struct sysrq_key_op *sysrq_key_table[36] = {
>>       /* x: May be registered on ppc/powerpc for xmon */
>>       NULL,                           /* x */
>>       /* y: May be registered on sparc64 for global register dump */
>> -     NULL,                           /* y */
>> +     &sysrq_softdump_op,             /* y */
>>       &sysrq_ftrace_dump_op,          /* z */
>>  };
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
