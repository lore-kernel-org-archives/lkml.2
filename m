Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab1AMF7O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 00:59:14 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62713 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912Ab1AMF7L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 00:59:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SSUZHFTaOmyagq9b7vgtY2z0ptgXxx5xDOgGm6cb+u9ScF1ULwjzrk2A4T6c/WEBmJ
         BLFjYeQOTv5JKVG6h6RPjkcbYfSp7OcuZBk/Dft88L/VFS9zf3TAWpvDTmxF/568Y6Y/
         pBQLe5rADCDLVM0yYrEY+DaLS6ygI9PwrsnQQ=
MIME-Version: 1.0
In-Reply-To: <1294890890.8089.39.camel@marge.simson.net>
References: <20110110091622.GF2772@in.ibm.com>
	<1294655388.8197.22.camel@marge.simson.net>
	<1294657154.2016.459.camel@laptop>
	<1294677746.8345.4.camel@marge.simson.net>
	<20110111171046.GL4772@in.ibm.com>
	<1294771686.8006.15.camel@marge.simson.net>
	<1294810842.8370.7.camel@marge.simson.net>
	<AANLkTimtwt+OGohMxGRC7L4Dm-h4wvCWYi-=13efqFtr@mail.gmail.com>
	<1294890890.8089.39.camel@marge.simson.net>
Date: Thu, 13 Jan 2011 13:59:10 +0800
Message-ID: <AANLkTi=x-nO-Z7hG9b5t2FvuznHXaTSLPdS05wkXYMKA@mail.gmail.com>
Subject: Re: [patch] Re: autogroup: sched_setscheduler() fails
From: Yong Zhang <yong.zhang0@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: bharata@linux.vnet.ibm.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 11:54 AM, Mike Galbraith <efault@gmx.de> wrote:
> sched, autogroup: fix CONFIG_RT_GROUP_SCHED sched_setscheduler() failure.
>
> If CONFIG_RT_GROUP_SCHED is set, __sched_setscheduler() fails due to autogroup
> not allocating rt_runtime.  Free unused/unusable rt_se and rt_rq, redirect RT
> tasks to the root task group, and tell __sched_setscheduler() that it's ok.
>
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Reported-by: Bharata B Rao <bharata@linux.vnet.ibm.com>

This looks more clear ;)

And a little comment below

>
> ---
>  kernel/sched.c           |    3 ++-
>  kernel/sched_autogroup.c |   27 +++++++++++++++++++++++++++
>  kernel/sched_autogroup.h |    4 ++++
>  3 files changed, 33 insertions(+), 1 deletion(-)
> @@ -106,6 +128,11 @@ task_wants_autogroup(struct task_struct
>        return true;
>  }
>
> +static inline bool task_group_is_autogroup(struct task_group *tg)
> +{
> +       return tg != &root_task_group && tg->autogroup;

Isn't just checking tg->autogroup sufficient?

if tg == &root_task_group

> --- linux-2.6.orig/kernel/sched.c
> +++ linux-2.6/kernel/sched.c
> @@ -4874,7 +4874,8 @@ recheck:
>                 * assigned.
>                 */
>                if (rt_bandwidth_enabled() && rt_policy(policy) &&
> -                               task_group(p)->rt_bandwidth.rt_runtime == 0) {
> +                               task_group(p)->rt_bandwidth.rt_runtime == 0 &&

this check will fail.

Thanks,
Yong

-- 
Only stand for myself
