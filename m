Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab2BBNBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 08:01:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42102 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753353Ab2BBNBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 08:01:11 -0500
Date: Thu, 2 Feb 2012 13:54:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg KH <gregkh@suse.de>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        San Mehat <san@google.com>, Colin Cross <ccross@android.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        linaro-kernel@lists.linaro.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] staging: android/lowmemorykiller: Don't grab
	tasklist_lock
Message-ID: <20120202125441.GA32229@redhat.com>
References: <20120201043330.GA25511@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120201043330.GA25511@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01, Anton Vorontsov wrote:
>
> @@ -132,7 +133,7 @@ static int lowmem_shrink(struct shrinker *s, struct shrink_control *sc)
>  	}
>  	selected_oom_adj = min_adj;
>
> -	read_lock(&tasklist_lock);
> +	rcu_read_lock();

This has the same problem, force_sig() becomes unsafe.

Why do you need force_? Do you really want to kill /sbin/init (or sub-namespace
init) ?

We could change force_sig_info() to use lock_task_sighand(), but I'd like to
avoid this. Imho, this interface should be cleanuped, and it should be used
for synchronous signals only.

With or without this patch, sig == NULL is not possible but !mm is not right,
there could be other other threads with mm != NULL.

Oleg.

