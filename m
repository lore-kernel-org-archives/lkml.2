Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053Ab1EQCAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 22:00:15 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:41684 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab1EQCAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 22:00:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mFyL9FtzYJn09IT5kNNJt/PhrDoEaw7XTx7U3lFrQ7RJUsjGiwcoNLK1I10GCI3lEh
         IwU5EM24cO7VEx/zQ1UqKWWpqMef3XCpCI0HeFdNGYAX38vOBkyumXhtfhYSIn5KHHXK
         bmd3Gbqc2bML+Ex2ajAjs9BFyl6WqbcW/cJXQ=
MIME-Version: 1.0
In-Reply-To: <4DD0F614.2040408@gmail.com>
References: <4DD0F614.2040408@gmail.com>
Date: Tue, 17 May 2011 10:00:12 +0800
Message-ID: <BANLkTikjbggOatoiv1pcXq+5n+HzWz7Wiw@mail.gmail.com>
Subject: Re: [PATCH] Documentation: statistics about nested locks
From: Yong Zhang <yong.zhang0@gmail.com>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p4H20LOM027695

On Mon, May 16, 2011 at 6:01 PM, Juri Lelli <juri.lelli@gmail.com> wrote:
> Hi all,
> just a little patch to the Documentation. I had some trouble understanding
> the trailing "/1" on some lock class names of lock_stat output, so I added
> something on this inside lockstat documentation.
>
> Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
>
> ---
>  Documentation/lockstat.txt |   36 ++++++++++++++++++++++++++++++++++--
>  1 files changed, 34 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/lockstat.txt b/Documentation/lockstat.txt
> index 65f4c79..75eeb65 100644
> --- a/Documentation/lockstat.txt
> +++ b/Documentation/lockstat.txt
> @@ -12,8 +12,9 @@ Because things like lock contention can severely impact
> performance.
>  - HOW
>
>  Lockdep already has hooks in the lock functions and maps lock instances to
> -lock classes. We build on that. The graph below shows the relation between
> -the lock functions and the various hooks therein.
> +lock classes. We build on that (see Documentation/lockdep-design.txt).
> +The graph below shows the relation between the lock functions and the
> various
> +hooks therein.
>
>         __acquire
>             |
> @@ -128,6 +129,37 @@ points are the points we're contending with.
>
>  The integer part of the time values is in us.
>
> +Dealing with nested locks, subclasses may appear:
> +
> +32...............................................................................................................................................................................................
> +33
> +34                               &rq->lock:         13128 13128
> 0.43         190.53      103881.26          97454  3453404           0.00
>       401.11    13224683.11
> +35                               ---------
> +36                               &rq->lock            645
> [<ffffffff8103bfc4>] task_rq_lock+0x43/0x75
> +37                               &rq->lock            297
> [<ffffffff8104ba65>] try_to_wake_up+0x127/0x25a
> +38                               &rq->lock            360
> [<ffffffff8103c4c5>] select_task_rq_fair+0x1f0/0x74a
> +39                               &rq->lock            428
> [<ffffffff81045f98>] scheduler_tick+0x46/0x1fb
> +40                               ---------
> +41                               &rq->lock             77
> [<ffffffff8103bfc4>] task_rq_lock+0x43/0x75
> +42                               &rq->lock            174
> [<ffffffff8104ba65>] try_to_wake_up+0x127/0x25a
> +43                               &rq->lock           4715
> [<ffffffff8103ed4b>] double_rq_lock+0x42/0x54
> +44                               &rq->lock            893
> [<ffffffff81340524>] schedule+0x157/0x7b8
> +45
> +46...............................................................................................................................................................................................
> +47
> +48                             &rq->lock/1:         11526 11488
> 0.33         388.73      136294.31          21461    38404           0.00
>        37.93      109388.53
> +49                             -----------
> +50                             &rq->lock/1          11526
> [<ffffffff8103ed58>] double_rq_lock+0x4f/0x54
> +51                             -----------
> +52                             &rq->lock/1           5645
> [<ffffffff8103ed4b>] double_rq_lock+0x42/0x54
> +53                             &rq->lock/1           1224
> [<ffffffff81340524>] schedule+0x157/0x7b8
> +54                             &rq->lock/1           4336
> [<ffffffff8103ed58>] double_rq_lock+0x4f/0x54
> +55                             &rq->lock/1            181
> [<ffffffff8104ba65>] try_to_wake_up+0x127/0x25a
> +
> +Line 48 shows statistics for the first subclass (/1) of &rq->lock class,

Actually it's the second subclass because subclass starts from 0.

Thanks,
Yong

> since
> +in this case, as line 50 suggests, double_rq_lock actually acquires a
> nested
> +lock of two spinlocks.
> +
>  View the top contending locks:
>
>  # grep : /proc/lock_stat | head
> --
> 1.7.4.1
>



-- 
Only stand for myself
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
