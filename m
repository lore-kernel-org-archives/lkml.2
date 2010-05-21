Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab0EUB3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 21:29:06 -0400
Received: from mail.windriver.com ([147.11.1.11]:38655 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab0EUB3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 21:29:02 -0400
Message-ID: <4BF5E1D6.1090607@windriver.com>
Date: Thu, 20 May 2010 20:28:54 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the kgdb tree
References: <20100323150443.608ad7f0.sfr@canb.auug.org.au> <20100325154307.9cdeae10.sfr@canb.auug.org.au> <201003242159.25770.dmitry.torokhov@gmail.com> <20100521102158.bf6df441.sfr@canb.auug.org.au> <4BF5D8AF.6010408@windriver.com> <20100521110938.7bbbbf59.sfr@canb.auug.org.au> <20100521012340.GA12372@core.coreip.homeip.net>
In-Reply-To: <20100521012340.GA12372@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2010 01:28:56.0378 (UTC) FILETIME=[FAFDA9A0:01CAF884]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2010 08:23 PM, Dmitry Torokhov wrote:
> On Fri, May 21, 2010 at 11:09:38AM +1000, Stephen Rothwell wrote:
>> Hi Jason,
>>
>> On Thu, 20 May 2010 19:49:51 -0500 Jason Wessel <jason.wessel@windriver.com> wrote:
>>> Before brute force toggling it, it seems we should check the value and
>>> restore it after the execution of handle_sysrq().
>> Indeed, at the time I couldn't find an easy way to do that.
>>
>>> I'll have to look and see if there is an access function for this.
>> Great, thanks.
> 
> I would not mind re-exporting sysrq_on() again.
> 

We could but I don't know that you need to.

Would you be willing to sign off on a change like the one below
Dmitry?  If so then I'll push it into kgdb-next.

It is as simple as making the return from sysrq_toggle_support a bit
more meaningful.

Thanks,
Jason.


--- a/drivers/char/sysrq.c
+++ b/drivers/char/sysrq.c
@@ -717,7 +717,7 @@ int sysrq_toggle_support(int enable_mask
 			sysrq_unregister_handler();
 	}
 
-	return 0;
+	return was_enabled;
 }
 
 static int __sysrq_swap_key_ops(int key, struct sysrq_key_op *insert_op_p,
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -1926,17 +1926,19 @@ static int kdb_rm(int argc, const char *
  */
 static int kdb_sr(int argc, const char **argv)
 {
+	int toggle_save;
+
 	if (argc != 1)
 		return KDB_ARGCOUNT;
-	if (!__sysrq_enabled) {
-		kdb_printf("Auto activating sysrq\n");
-		__sysrq_enabled = 1;
-	}
+
+	toggle_save = sysrq_toggle_support(1);
 
 	kdb_trap_printk++;
 	handle_sysrq(*argv[1], NULL);
 	kdb_trap_printk--;
 
+	sysrq_toggle_support(toggle_save);
+
 	return 0;
 }
 #endif	/* CONFIG_MAGIC_SYSRQ */
