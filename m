Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab1BIV5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 16:57:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53250
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753971Ab1BIV5Q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 16:57:16 -0500
Date: Wed, 09 Feb 2011 13:57:51 -0800 (PST)
Message-Id: <20110209.135751.112605587.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: torvalds@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, isdn@linux-pingi.de
Subject: Re: Linux 2.6.38-rc4 (hysdn: BUG)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110209132529.76927f5f.randy.dunlap@oracle.com>
References: <20110209092419.2b335697.randy.dunlap@oracle.com>
	<AANLkTimUg8Dm9mZotubcgPHz8_at=_hnbeWUo-LfSALp@mail.gmail.com>
	<20110209132529.76927f5f.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Wed, 9 Feb 2011 13:25:29 -0800

> On Wed, 9 Feb 2011 11:44:00 -0800 Linus Torvalds wrote:
> 
>> On Wed, Feb 9, 2011 at 9:24 AM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> >
>> > on x86_64.  no HYSDN hardware found (correct).
>> > Nearly allmodconfig.
>> >
>> >
>> > [   65.397577] HYSDN: module Rev: 1.6.6.6 loaded
>> > [   65.397584] HYSDN: network interface Rev: 1.8.6.4
>> > [   65.398057] HYSDN: 0 card(s) found.
>> > [   65.398121] BUG: unable to handle kernel paging request at ffffffffa06c99f0
>> > [   65.398269] IP: [<ffffffffa06c68ba>] hysdn_getrev+0x2e/0x50 [hysdn]
>> > [   65.398379] PGD 1a14067 PUD 1a18063 PMD 6f6c1067 PTE 800000006ce8c161
>> > [   65.398613] Oops: 0003 [#1] SMP DEBUG_PAGEALLOC
>> > [   65.400030]
>> > [   65.400030] Pid: 2497, comm: modprobe Not tainted 2.6.38-rc4 #1 0TY565/OptiPlex 745
>> > [   65.400030] RIP: 0010:[<ffffffffa06c68ba>]  [<ffffffffa06c68ba>] hysdn_getrev+0x2e/0x50 [hysdn]
>> > [   65.400030] RSP: 0018:ffff88006eec1e68  EFLAGS: 00010206
>> > [   65.400030] RAX: ffffffffa06c99f1 RBX: ffffffffa06c99e9 RCX: ffff88007c4159a0
>> 
>> The instruction sequence decodes to
>> 
>>   1e:	be 24 00 00 00       	mov    $0x24,%esi
>>   23:	48 89 df             	mov    %rbx,%rdi
>>   26:	e8 5b 39 c0 e0       	callq  0xffffffffe0c03986
>>   2b:*	c6 40 ff 00          	movb   $0x0,-0x1(%rax)     <-- trapping instruction
>> 
>> which seems to be this
>> 
>>                 p = strchr(rev, '$');
>>                 *--p = 0;
>> 
>> code. And yes, it's total crap, because while "p" and "rev" are "char
>> *", the string that is passed in is actually of type "const char *",
>> so that function is seriously broken. It's also seriously broken to
>> not test that "p" is non-NULL - the function would just break if there
>> is a colon in the string but not a '$'.
>> 
>> And hysdn_procconf_init() passes in a constant string to the thing:
>> 
>>     static char *hysdn_procconf_revision = "$Revision: 1.8.6.4 $";
>> 
>> What happens is that it breaks when we mark the constant section as
>> read-only, because you have CONFIG_DEBUG_RODATA enabled.
>> 
>> So the fix seems to be to
>>  - fix the prototype for hysdn_getrev() to not have "const".
>>  - fix hysdn_procconf_init() to not pass in a constant string to it
>> 
>> The minimal patch would appear to be something like the appended. UNTESTED!
> 
> for your patch:
> 
> Tested-and-acked-by: Randy Dunlap <randy.dunlap@oracle.com>

This stuff just prints out a CVS revision string that hasn't changed
in 10 years into the kernel log.

I propose we just kill this stuff off completely.

I note that there is code in other places of this driver that copy
the read-only revision string into a local string buffer then pass
it into the hysdn_getrev() function, it just doesn't happen in this
one spot.

Anyways, I think I'll fix this like so:

--------------------
isdn: hysdn: Kill (partially buggy) CVS regision log reporting.

Some cases try to modify const strings, and in any event the
CVS revision strings have not changed in over ten years making
these printouts completely worthless.

Just kill all of this stuff off.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/isdn/hysdn/hysdn_defs.h     |    2 --
 drivers/isdn/hysdn/hysdn_init.c     |   26 +-------------------------
 drivers/isdn/hysdn/hysdn_net.c      |    3 ---
 drivers/isdn/hysdn/hysdn_procconf.c |    3 +--
 4 files changed, 2 insertions(+), 32 deletions(-)

diff --git a/drivers/isdn/hysdn/hysdn_defs.h b/drivers/isdn/hysdn/hysdn_defs.h
index 729df40..18b801a 100644
--- a/drivers/isdn/hysdn/hysdn_defs.h
+++ b/drivers/isdn/hysdn/hysdn_defs.h
@@ -227,7 +227,6 @@ extern hysdn_card *card_root;	/* pointer to first card */
 /*************************/
 /* im/exported functions */
 /*************************/
-extern char *hysdn_getrev(const char *);
 
 /* hysdn_procconf.c */
 extern int hysdn_procconf_init(void);	/* init proc config filesys */
@@ -259,7 +258,6 @@ extern int hysdn_tx_cfgline(hysdn_card *, unsigned char *,
 
 /* hysdn_net.c */
 extern unsigned int hynet_enable; 
-extern char *hysdn_net_revision;
 extern int hysdn_net_create(hysdn_card *);	/* create a new net device */
 extern int hysdn_net_release(hysdn_card *);	/* delete the device */
 extern char *hysdn_net_getname(hysdn_card *);	/* get name of net interface */
diff --git a/drivers/isdn/hysdn/hysdn_init.c b/drivers/isdn/hysdn/hysdn_init.c
index b7cc5c2..0ab42ac 100644
--- a/drivers/isdn/hysdn/hysdn_init.c
+++ b/drivers/isdn/hysdn/hysdn_init.c
@@ -36,7 +36,6 @@ MODULE_DESCRIPTION("ISDN4Linux: Driver for HYSDN cards");
 MODULE_AUTHOR("Werner Cornelius");
 MODULE_LICENSE("GPL");
 
-static char *hysdn_init_revision = "$Revision: 1.6.6.6 $";
 static int cardmax;		/* number of found cards */
 hysdn_card *card_root = NULL;	/* pointer to first card */
 static hysdn_card *card_last = NULL;	/* pointer to first card */
@@ -49,25 +48,6 @@ static hysdn_card *card_last = NULL;	/* pointer to first card */
 /* Additionally newer versions may be activated without rebooting.          */
 /****************************************************************************/
 
-/******************************************************/
-/* extract revision number from string for log output */
-/******************************************************/
-char *
-hysdn_getrev(const char *revision)
-{
-	char *rev;
-	char *p;
-
-	if ((p = strchr(revision, ':'))) {
-		rev = p + 2;
-		p = strchr(rev, '$');
-		*--p = 0;
-	} else
-		rev = "???";
-	return rev;
-}
-
-
 /****************************************************************************/
 /* init_module is called once when the module is loaded to do all necessary */
 /* things like autodetect...                                                */
@@ -175,13 +155,9 @@ static int hysdn_have_procfs;
 static int __init
 hysdn_init(void)
 {
-	char tmp[50];
 	int rc;
 
-	strcpy(tmp, hysdn_init_revision);
-	printk(KERN_NOTICE "HYSDN: module Rev: %s loaded\n", hysdn_getrev(tmp));
-	strcpy(tmp, hysdn_net_revision);
-	printk(KERN_NOTICE "HYSDN: network interface Rev: %s \n", hysdn_getrev(tmp));
+	printk(KERN_NOTICE "HYSDN: module loaded\n");
 
 	rc = pci_register_driver(&hysdn_pci_driver);
 	if (rc)
diff --git a/drivers/isdn/hysdn/hysdn_net.c b/drivers/isdn/hysdn/hysdn_net.c
index feec8d8..11f2cce 100644
--- a/drivers/isdn/hysdn/hysdn_net.c
+++ b/drivers/isdn/hysdn/hysdn_net.c
@@ -26,9 +26,6 @@
 unsigned int hynet_enable = 0xffffffff; 
 module_param(hynet_enable, uint, 0);
 
-/* store the actual version for log reporting */
-char *hysdn_net_revision = "$Revision: 1.8.6.4 $";
-
 #define MAX_SKB_BUFFERS 20	/* number of buffers for keeping TX-data */
 
 /****************************************************************************/
diff --git a/drivers/isdn/hysdn/hysdn_procconf.c b/drivers/isdn/hysdn/hysdn_procconf.c
index 96b3e39..5fe83bd 100644
--- a/drivers/isdn/hysdn/hysdn_procconf.c
+++ b/drivers/isdn/hysdn/hysdn_procconf.c
@@ -23,7 +23,6 @@
 #include "hysdn_defs.h"
 
 static DEFINE_MUTEX(hysdn_conf_mutex);
-static char *hysdn_procconf_revision = "$Revision: 1.8.6.4 $";
 
 #define INFO_OUT_LEN 80		/* length of info line including lf */
 
@@ -404,7 +403,7 @@ hysdn_procconf_init(void)
 		card = card->next;	/* next entry */
 	}
 
-	printk(KERN_NOTICE "HYSDN: procfs Rev. %s initialised\n", hysdn_getrev(hysdn_procconf_revision));
+	printk(KERN_NOTICE "HYSDN: procfs initialised\n");
 	return (0);
 }				/* hysdn_procconf_init */
 
-- 
1.7.4

