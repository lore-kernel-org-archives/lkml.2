Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911Ab1DMVDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 17:03:08 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:36341 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab1DMVDG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 17:03:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=ollgjwi5LcX1KW3LUkGtKyv1QMQpAlyynyi2e2hkdFL3z1cs9bALaAwr+7FvZ46wqx
         4xLX+zz/ATUTGQWldyVDtf6+qyiqgXNancmwFEFMxc1Otflb3JeU+AAYrXP3vJL4ljnu
         Ua/7sD1X+8HweI4yEwOXZTS1+yNXIdyt5jn/g=
MIME-Version: 1.0
In-Reply-To: <201104132258.17705.rjw@sisk.pl>
References: <BANLkTi=F-C-vwX4PGGfbkdTBw3OWL-twfg@mail.gmail.com> <201104132258.17705.rjw@sisk.pl>
From: Mike Frysinger <vapier@gentoo.org>
Date: Wed, 13 Apr 2011 17:02:45 -0400
X-Google-Sender-Auth: zoyjVkLRJXQ5lNvzdSONr7cvG0E
Message-ID: <BANLkTiknfeTj6GD0t-ekMoaS1QYQBVyBjQ@mail.gmail.com>
Subject: Re: freezer: should barriers be smp ?
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        linux-pm@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 16:58, Rafael J. Wysocki wrote:
> On Wednesday, April 13, 2011, Mike Frysinger wrote:
>> when we suspend/resume Blackfin SMP systems, we notice that the
>> freezer code runs on multiple cores.  this is of course what you want
>> -- freeze processes in parallel.  however, the code only uses non-smp
>> based barriers which causes us problems ... our cores need software
>> support to keep caches in sync, so our smp barriers do just that.  but
>> the non-smp barriers do not, and so the frozen/thawed processes
>> randomly get stuck in the wrong task state.
>>
>> thinking about it, shouldnt the freezer code be using smp barriers ?
>
> Yes, it should, but rmb() and wmb() are supposed to be SMP barriers.
>
> Or do you mean something different?

then what's the diff between smp_rmb() and rmb() ?

this is what i'm proposing:
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -17,7 +17,7 @@ static inline void frozen_process(void)
 {
    if (!unlikely(current->flags & PF_NOFREEZE)) {
        current->flags |= PF_FROZEN;
-       wmb();
+       smp_wmb();
    }
    clear_freeze_flag(current);
 }
@@ -93,7 +93,7 @@ bool freeze_task(struct task_struct *p, bool sig_only)
     * the task as frozen and next clears its TIF_FREEZE.
     */
    if (!freezing(p)) {
-       rmb();
+       smp_rmb();
        if (frozen(p))
            return false;

-mike
