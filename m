Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab1EQC2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 22:28:38 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:61324 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1EQC2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 22:28:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dcm2490amevZ+w0xbcZ2czjGhBi2URFJjbncDwCM4enskJzkzR23/8BOGLQQeUxikx
         ++eU4/PMrzoXicKVzic6GWzfgOrjsqU7FOH3MiMu2Jw7KT/vhB9Xp/9iDP+SV/hxMdq+
         tWAs2z4BoiRFGv6vDbpAiPnXbz8ppMAnVRQoA=
MIME-Version: 1.0
In-Reply-To: <BANLkTikqKnQgyLr0OmL86iEHE95xB4Z50Q@mail.gmail.com>
References: <BANLkTikqKnQgyLr0OmL86iEHE95xB4Z50Q@mail.gmail.com>
Date: Tue, 17 May 2011 10:28:35 +0800
Message-ID: <BANLkTim=di8pbt1CzHjHYSC0SbtgJzbmkw@mail.gmail.com>
Subject: Re: [PATCH] sched: fix priority leakage in pick_next_highest_task_rt()
From: Yong Zhang <yong.zhang0@gmail.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4H2SiIx027749

On Mon, May 16, 2011 at 8:55 PM, Hillf Danton <dhillf@gmail.com> wrote:
> When picking the second highest RT task for a given runqueue, if no
> task found after scanning the queue of priority == idx, the next idx
> should also be checked even in case that next is already existing, or
> the window of priority leakage could be opened.

I don't see what kind of problem you patch will fix.
And mind explaining how priority leakage could happen?

Thanks,
Yong

>
> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
>
> --- a/kernel/sched_rt.c 2011-04-27 11:48:50.000000000 +0800
> +++ b/kernel/sched_rt.c 2011-05-16 19:58:42.000000000 +0800
> @@ -1166,6 +1166,8 @@ static struct task_struct *pick_next_hig
>        int idx;
>
>        for_each_leaf_rt_rq(rt_rq, rq) {
> +               struct task_struct *this;
> +
>                array = &rt_rq->active;
>                idx = sched_find_first_bit(array->bitmap);
>  next_idx:
> @@ -1173,6 +1175,7 @@ next_idx:
>                        continue;
>                if (next && next->prio < idx)
>                        continue;
> +               this = NULL;
>                list_for_each_entry(rt_se, array->queue + idx, run_list) {
>                        struct task_struct *p;
>
> @@ -1181,11 +1184,15 @@ next_idx:
>
>                        p = rt_task_of(rt_se);
>                        if (pick_rt_task(rq, p, cpu)) {
> -                               next = p;
> +                               this = p;
>                                break;
>                        }
>                }
> -               if (!next) {
> +               if (this != NULL)
> +                       next = this;
> +               else {  /*
> +                        * we have to check next idx even if next != NULL
> +                        */
>                        idx = find_next_bit(array->bitmap, MAX_RT_PRIO, idx+1);
>                        goto next_idx;
>                }
>



-- 
Only stand for myself
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
