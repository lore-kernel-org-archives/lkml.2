Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab0JHG0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 02:26:36 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:58423 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083Ab0JHG0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 02:26:34 -0400
X-Nat-Received: from [202.181.97.72]:57634 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1286519179.9940
Message-Id: <201010080626.o986QJX4002281@www262.sakura.ne.jp>
Subject: Re: 2.6.36-rc7: kernel panic with SECURITY_TOMOYO=y
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To: kosaki.motohiro@jp.fujitsu.com
Cc: linux-kernel@vger.kernel.org, takedakn@nttdata.co.jp,
        lists@nerdbynature.de, kawime@gmx.de, jkosina@suse.cz,
        linux-security-module@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Fri, 08 Oct 2010 15:26:19 +0900
References: <alpine.DEB.2.01.1010071534370.21082@trent.utfs.org> <alpine.DEB.2.01.1010071637090.21082@trent.utfs.org> <20101008134644.8049.A69D9226@jp.fujitsu.com>
In-Reply-To: <20101008134644.8049.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 08102010 #4288303, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote: ( http://lkml.org/lkml/2010/8/11/80 )
> > The panic message was:
> > >  Profile %u (used by '%s') not defined.
> >
> > Profile 0 (used by '0') not defined.
> 
> Looking at the code ...
> 
>      void tomoyo_check_profile(void)
>      {
>              struct tomoyo_domain_info *domain;
>              const int idx = tomoyo_read_lock();
>              tomoyo_policy_loaded = true;
>              /* Check all profiles currently assigned to domains are defined. */
>              list_for_each_entry_rcu(domain, &tomoyo_domain_list, list) {
>                      const u8 profile = domain->profile;
>                      if (tomoyo_profile_ptr[profile])
>                              continue;
>                      panic("Profile %u (used by '%s') not defined.\n",
>                            profile, domain->domainname->name);
>              }
>              tomoyo_read_unlock(idx);
>              if (tomoyo_profile_version != 20090903)
>                      panic("Profile version %u is not supported.\n",
>                            tomoyo_profile_version);
>              printk(KERN_INFO "TOMOYO: 2.3.0\n");
>              printk(KERN_INFO "Mandatory Access Control activated.\n");
>      }
> 
> makes one wonder whether not having up-to-date userspace really does
> qualify for unconditional kernel panic.

KOSAKI Motohiro wrote:
> Handa-san, please see this panic message again.
> 
> > Kernel panic - not syncing: Profile uersion 0 is not supported
> 
> Profile?
> This message doesn't have any information which should we look!
> And, 'profile' is wrong word. TOMOYO have to recommend to upgrade
> userland tools here at minimum.

I see. What about this?

>From cc7601c18982909987bbb48971acb86a69a3317a Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Fri, 8 Oct 2010 14:43:22 +0900
Subject: [PATCH] TOMOYO: Print URL information before panic().

Configuration files for TOMOYO 2.3 are not compatible with TOMOYO 2.2.
But current panic() message is too unfriendly and is confusing users.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 security/tomoyo/common.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index c668b44..1f0d45a 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -2051,13 +2051,22 @@ void tomoyo_check_profile(void)
 		const u8 profile = domain->profile;
 		if (tomoyo_profile_ptr[profile])
 			continue;
+		printk(KERN_ERR "You need to define profile %u before using it.\n",
+		       profile);
+		printk(KERN_ERR "Please see http://tomoyo.sourceforge.jp/2.3/ "
+		       "for more information.\n");
 		panic("Profile %u (used by '%s') not defined.\n",
 		      profile, domain->domainname->name);
 	}
 	tomoyo_read_unlock(idx);
-	if (tomoyo_profile_version != 20090903)
+	if (tomoyo_profile_version != 20090903) {
+		printk(KERN_ERR "You need to install userland programs for "
+		       "TOMOYO 2.3 and initialize policy configuration.\n");
+		printk(KERN_ERR "Please see http://tomoyo.sourceforge.jp/2.3/ "
+		       "for more information.\n");
 		panic("Profile version %u is not supported.\n",
 		      tomoyo_profile_version);
+	}
 	printk(KERN_INFO "TOMOYO: 2.3.0\n");
 	printk(KERN_INFO "Mandatory Access Control activated.\n");
 }
-- 
1.7.1
