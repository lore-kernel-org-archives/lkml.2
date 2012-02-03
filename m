Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab2BCQnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:43:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757005Ab2BCQnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:43:40 -0500
Date: Fri, 3 Feb 2012 17:36:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v3] staging: android/lowmemorykiller: Don't grab
	tasklist_lock
Message-ID: <20120203163651.GB4190@redhat.com>
References: <20120202171659.GA29378@oksana.dev.rtsoft.ru> <20120203000345.GA14338@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203000345.GA14338@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03, Anton Vorontsov wrote:
>
> @@ -132,7 +133,7 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
>  	}
>  	selected_oom_adj = min_adj;
>
> -	read_lock(&tasklist_lock);
> +	rcu_read_lock();
>  	for_each_process(p) {
>  		struct mm_struct *mm;
>  		struct signal_struct *sig;
> @@ -180,12 +181,12 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
>  		lowmem_deathpending = selected;
>  		task_handoff_register(&task_nb);
>  #endif
> -		force_sig(SIGKILL, selected);
> +		send_sig(SIGKILL, selected, 0);
>  		rem -= selected_tasksize;
>  	}
>  	lowmem_print(4, "lowmem_shrink %lu, %x, return %d\n",
>  		     sc->nr_to_scan, sc->gfp_mask, rem);
> -	read_unlock(&tasklist_lock);
> +	rcu_read_unlock();

I think this is correct. As for ->mm check please look at
find_lock_task_mm().

You can also remove the !sig check.

And, forgot to mention. There is another reason why mm != NULL
check is wrong (send_sig_all too). A kernel thread can do use_mm().
You should also check PF_KTHREAD.

Oleg.

