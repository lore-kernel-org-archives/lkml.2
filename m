Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab2BFVhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 16:37:00 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:59449 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755869Ab2BFVg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 16:36:57 -0500
MIME-Version: 1.0
In-Reply-To: <20120206162947.GD5117@oksana.dev.rtsoft.ru>
References: <20120203163056.GA4190@redhat.com> <20120206162947.GD5117@oksana.dev.rtsoft.ru>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Mon, 6 Feb 2012 16:36:37 -0500
Message-ID: <CAHGf_=qMGXViNwhZudXb9GntORjL2wjuim23GbLxMDQdMNfMPQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] staging: android/lowmemorykiller: Better mm handling
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
>  {
> -       struct task_struct *p;
> +       struct task_struct *tsk;
>        struct task_struct *selected = NULL;
>        int rem = 0;
>        int tasksize;
> @@ -134,15 +134,17 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
>        selected_oom_adj = min_adj;
>
>        rcu_read_lock();
> -       for_each_process(p) {
> -               struct mm_struct *mm;
> +       for_each_process(tsk) {
> +               struct task_struct *p;
>                struct signal_struct *sig;
>                int oom_adj;
>
> -               task_lock(p);
> -               mm = p->mm;
> +               p = find_lock_task_mm(tsk);
> +               if (!p)
> +                       continue;
> +
>                sig = p->signal;
> -               if (!mm || !sig) {
> +               if (!sig) {
>                        task_unlock(p);
>                        continue;
>                }
> @@ -151,7 +153,7 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
>                        task_unlock(p);
>                        continue;
>                }
> -               tasksize = get_mm_rss(mm);
> +               tasksize = get_mm_rss(p->mm);
>                task_unlock(p);
>                if (tasksize <= 0)
>                        continue;

ack.
