Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab0IYJmU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 05:42:20 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43041 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab0IYJmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 05:42:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WWTRc7G3zyBfghkeKkRmhrBiHnKk+ALvLhGtUylwPQhG1yUw6nCSVieCz5CwYif4QL
         JbXfOyvds09xTX4tEUZhOPv0O+ezhXNpN/iu9nVUCbTAWwQBvCG+J4yLLjFgpM2UnF5x
         gYHw0Y1wOQIHMzjQGf2NwfR/QcWUy1JrY+m2Q=
Subject: Re: [PATCH] signal: annotate siglock acquisition
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1285406495-20080-1-git-send-email-namhyung@gmail.com>
References: <1285406495-20080-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 25 Sep 2010 11:42:07 +0200
Message-ID: <1285407727.2478.288.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le samedi 25 septembre 2010 à 18:21 +0900, Namhyung Kim a écrit :
> lock_task_sighand() conditionally acquires sighand->siglock in case of
> returning non-NULL but unlock_task_sighand() releases it unconditionally.
> This leads sparse to complain about the lock context imbalance. Annotate it
> to make sparse happier.

> @@ -1403,7 +1404,9 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
>  	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
>  
>  	ret = -1;
> -	if (!likely(lock_task_sighand(t, &flags)))
> +	if (likely(lock_task_sighand(t, &flags)))
> +		__acquire(&t->sighand->siglock);
> +	else
>  		goto ret;
>  
>  	ret = 1; /* the signal is ignored */

making sparse happy is good, but changing a likely clause is not,
unless you meant it ;)

maybe -->

	if (!likely(lock_task_sighand(t, &flags)))
		goto ret;
	else
		__acquire(&t->sighand->siglock);



