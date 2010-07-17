Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0GQHlL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 03:41:11 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:55984 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316Ab0GQHlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 03:41:08 -0400
To: john.johansen@canonical.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [AppArmor #5 0/13] AppArmor security module
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>
	<E1OZO8Z-0004a5-6S@pomaz-ex.szeredi.hu>
	<201007160521.o6G5Li2j093689@www262.sakura.ne.jp>
	<4C408AB5.6070908@canonical.com>
In-Reply-To: <4C408AB5.6070908@canonical.com>
Message-Id: <201007171641.IFB26502.JOOOSQMLFVFHFt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 17 Jul 2010 16:41:01 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Johansen wrote:
> >  75 void aa_info_message(const char *str)
> >  76 {
> >  77         struct common_audit_data sa;
> >  78         COMMON_AUDIT_DATA_INIT_NONE(&sa);
> >  79         sa.aad.info = str,
> >  80         printk(KERN_INFO "AppArmor: %s\n", str);
> >  81         if (audit_enabled)
> >  82                 aa_audit(AUDIT_APPARMOR_STATUS, NULL, GFP_KERNEL, &sa, NULL);
> >  83 }
> > 
It will work but you meant "sa.aad.info = str;" rather than "sa.aad.info = str,".

> > void aa_info_message(const char *str)
> > {
> > 	printk(KERN_INFO "AppArmor: %s\n", str);
> > 	if (audit_enabled) {
> > 		struct common_audit_data sa;
> > 		COMMON_AUDIT_DATA_INIT_NONE(&sa);
> > 		sa.aad.info = str;
> > 		aa_audit(AUDIT_APPARMOR_STATUS, NULL, GFP_KERNEL, &sa, NULL);
> > 	}
> > }
> > 
> > ?
> > 
> Anything more specific? :)
> 
I thought you don't need to call COMMON_AUDIT_DATA_INIT_NONE() if !audit_enabled.
Maybe compiler optimizes it implicitly...

> > 134 static int apparmor_capable(struct task_struct *task, const struct cred *cred,
> > 135                             int cap, int audit)
> > 136 {
> > 137         struct aa_profile *profile;
> > 138         /* cap_capable returns 0 on success, else -EPERM */
> > 139         int error = cap_capable(task, cred, cap, audit);
> > 140 
> > 141         profile = aa_cred_profile(cred);
> > 142         if (!error  && !unconfined(profile))
> > 143                 error = aa_capable(task, profile, cap, audit);
> > 144 
> > 145         return error;
> > 146 }
> > 
> > static int apparmor_capable(struct task_struct *task, const struct cred *cred,
> > 			    int cap, int audit)
> > {
> > 	/* cap_capable returns 0 on success, else -EPERM */
> > 	int error = cap_capable(task, cred, cap, audit);
> > 
> > 	if (!error) {
> > 		struct aa_profile *profile;
> > 		profile = aa_cred_profile(cred);
> > 	  	if (!unconfined(profile))
> > 			error = aa_capable(task, profile, cap, audit);
> > 	}
> > 	return error;
> > }
> > 
> > ?
> > 
> ? 
> 
I thought you don't need to call aa_cred_profile() if cap_capable() returned an error.
If you meant to update profile even if cap_capable() returned an error, please add a comment.
