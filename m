Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751838Ab2LUCCt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 21:02:49 -0500
Received: from mail.windriver.com ([147.11.1.11]:47909 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab2LUCCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 21:02:44 -0500
Message-ID: <50D3C339.5000201@windriver.com>
Date: Fri, 21 Dec 2012 10:02:33 +0800
From: "tiejun.chen" <tiejun.chen@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <jason.wessel@windriver.com>
Subject: Re: [v1][PATCH 3/6] book3e/kgdb: update thread's dbcr0
References: <1355994510-11934-1-git-send-email-tiejun.chen@windriver.com> <1355994510-11934-4-git-send-email-tiejun.chen@windriver.com> <A47C9236-0744-45BC-B25A-3DDEB05CD8A1@kernel.crashing.org>
In-Reply-To: <A47C9236-0744-45BC-B25A-3DDEB05CD8A1@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [147.11.178.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2012 02:41 AM, Kumar Gala wrote:
>
> On Dec 20, 2012, at 3:08 AM, Tiejun Chen wrote:
>
>> gdb always need to generate a single step properly to invoke
>> a kgdb state. But with lazy interrupt, book3e can't always
>> trigger a debug exception with a single step since the current
>> is blocked for handling those pending exception, then we miss
>> that expected dbcr configuration at last to generate a debug
>> exception.
>>
>> So here we also update thread's dbcr0 to make sure the current
>> can go back with that missed dbcr0 configuration.
>>
>> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
>> ---
>> arch/powerpc/kernel/kgdb.c |   10 ++++++++++
>> 1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
>> index c470a40..516b44b 100644
>> --- a/arch/powerpc/kernel/kgdb.c
>> +++ b/arch/powerpc/kernel/kgdb.c
>> @@ -426,8 +426,18 @@ int kgdb_arch_handle_exception(int vector, int signo, int err_code,
>> 		/* set the trace bit if we're stepping */
>> 		if (remcom_in_buffer[0] == 's') {
>> #ifdef CONFIG_PPC_ADV_DEBUG_REGS
>> +#ifdef CONFIG_PPC_BOOK3E
>
> Should this really be CONFIG_PPC64 or CONFIG_PPC_BOOK3E_64?

Yes, I think CONFIG_PPC_BOOK3E_64 is better currently. Because I didn't validate 
this on power arch since I have no a real machine :)

>
>> +			/* With lazy interrut we have to update thread dbcr0 here
>> +			 * to make sure we can set debug properly at last to invoke
>> +			 * kgdb again to work well.
>> +			 */
>> +			current->thread.dbcr0 =
>> +				mfspr(SPRN_DBCR0) | DBCR0_IC | DBCR0_IDM;
>> +			mtspr(SPRN_DBCR0, current->thread.dbcr0);
>> +#else
>> 			mtspr(SPRN_DBCR0,
>> 			      mfspr(SPRN_DBCR0) | DBCR0_IC | DBCR0_IDM);
>> +#endif
>
> Can we code this so we don't need the #else?

I guess you're saying something like this:

---
diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index c470a40..b2df42a 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -409,7 +409,7 @@ int kgdb_arch_handle_exception(int vector, int signo, int 
err_code,
  			       struct pt_regs *linux_regs)
  {
  	char *ptr = &remcom_in_buffer[1];
-	unsigned long addr;
+	unsigned long addr, dbcr0;

  	switch (remcom_in_buffer[0]) {
  		/*
@@ -426,8 +426,15 @@ int kgdb_arch_handle_exception(int vector, int signo, int 
err_code,
  		/* set the trace bit if we're stepping */
  		if (remcom_in_buffer[0] == 's') {
  #ifdef CONFIG_PPC_ADV_DEBUG_REGS
-			mtspr(SPRN_DBCR0,
-			      mfspr(SPRN_DBCR0) | DBCR0_IC | DBCR0_IDM);
+			dbcr0 = mfspr(SPRN_DBCR0) | DBCR0_IC | DBCR0_IDM;
+			mtspr(SPRN_DBCR0, dbcr0);
+#ifdef CONFIG_PPC_BOOK3E_64
+			/* With lazy interrut we have to update thread dbcr0 here
+			 * to make sure we can set debug properly at last to invoke
+			 * kgdb again to work well.
+			 */
+			current->thread.dbcr0 = dbcr0;
+#endif
  			linux_regs->msr |= MSR_DE;
  #else
  			linux_regs->msr |= MSR_SE;
-- 
1.7.9.5

Tiejun
