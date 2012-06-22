Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762893Ab2FVXlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 19:41:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51948 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463Ab2FVXlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 19:41:44 -0400
Date: Fri, 22 Jun 2012 16:41:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: shuox.liu@intel.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>, andi@firstfloor.org,
        Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v4 2/2] x86 mce: use new printk recursion disabling
 interface
Message-Id: <20120622164143.bb7dc290.akpm@linux-foundation.org>
In-Reply-To: <4FCC265F.5@intel.com>
References: <4FBC444A.6060500@intel.com>
	<20120523100138.GA13506@x1.osrc.amd.com>
	<4FBDCE4A.7050900@intel.com>
	<20120524061145.GA18284@liondog.tnic>
	<20120524155611.b7aeff4d.akpm@linux-foundation.org>
	<1337905811.14538.206.camel@ymzhang.sh.intel.com>
	<4FBF3295.7090608@intel.com>
	<4FBF32E8.90101@intel.com>
	<20120525074114.GA5417@liondog.tnic>
	<4FC2DDFF.3020600@intel.com>
	<20120530090844.GA23663@liondog.tnic>
	<4FCC25D3.7070308@intel.com>
	<4FCC265F.5@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Jun 2012 11:07:11 +0800
ShuoX Liu <shuox.liu@intel.com> wrote:

> From: ShuoX Liu <shuox.liu@intel.com>
> 
> Disable printk recursion to make sure MCE logs printed out.
> 
> Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
> Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
> ---
> We hit it when running a MTBF testing on a Android atom mobile.
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index 2afcbd2..906e838 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -306,6 +306,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
>  {
>  	int i, apei_err = 0;
>  
> +	printk_recursion_check_disable();
>  	if (!fake_panic) {
>  		/*
>  		 * Make sure only one CPU runs in machine check panic
> @@ -360,6 +361,7 @@ static void mce_panic(char *msg, struct mce *final, char *exp)
>  		panic(msg);
>  	} else
>  		pr_emerg(HW_ERR "Fake kernel panic: %s\n", msg);
> +	printk_recursion_check_enable();
>  }
>  
>  /* Support code for software error injection */

A couple of things here.

a) mce_panic() has a "return" statement deep inside.  So we return
   from mce_panic() with the recursion check disabled.  whoops.

b) adding a nice comment is nice.

--- a/arch/x86/kernel/cpu/mcheck/mce.c~x86-mce-use-new-printk-recursion-disabling-interface-fix
+++ a/arch/x86/kernel/cpu/mcheck/mce.c
@@ -303,11 +303,10 @@ static void wait_for_panic(void)
 	panic("Panicing machine check CPU died");
 }
 
-static void mce_panic(char *msg, struct mce *final, char *exp)
+static void __mce_panic(char *msg, struct mce *final, char *exp)
 {
 	int i, apei_err = 0;
 
-	printk_recursion_check_disable();
 	if (!fake_panic) {
 		/*
 		 * Make sure only one CPU runs in machine check panic
@@ -362,6 +361,17 @@ static void mce_panic(char *msg, struct 
 		panic(msg);
 	} else
 		pr_emerg(HW_ERR "Fake kernel panic: %s\n", msg);
+}
+
+/*
+ * If an MCE happens to occur during the execution of a printk(), we want the
+ * MCE information to be displayed.  But printk()'s recursion checking prevents
+ * that.  So temporarily disable it.
+ */
+static void mce_panic(char *msg, struct mce *final, char *exp)
+{
+	printk_recursion_check_disable();
+	__mce_panic(msg, final, exp);
 	printk_recursion_check_enable();
 }
 
_

