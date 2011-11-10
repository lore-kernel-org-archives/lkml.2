Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab1KJSFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 13:05:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34840 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998Ab1KJSFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 13:05:25 -0500
Date: Thu, 10 Nov 2011 19:00:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 1/3] pids: Make alloc_pid return error
Message-ID: <20111110180021.GA31156@redhat.com>
References: <4EBC0696.9030103@parallels.com> <4EBC06B3.2000802@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EBC06B3.2000802@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10, Pavel Emelyanov wrote:
>
> @@ -281,7 +281,7 @@ struct pid *alloc_pid(struct pid_namespace *ns)
>  {
>  	struct pid *pid;
>  	enum pid_type type;
> -	int i, nr;
> +	int i, nr = -ENOMEM;
>  	struct pid_namespace *tmp;
>  	struct upid *upid;

This doesn't look right at first glance... I mean, if
the first kmem_cache_alloc(ns->pid_cachep) fails, this -ENOMEM
won't be returned as ERR_PTR().

> @@ -321,7 +321,7 @@ out_free:
>  		free_pidmap(pid->numbers + i);
>
>  	kmem_cache_free(ns->pid_cachep, pid);
> -	pid = NULL;
> +	pid = ERR_PTR(nr);
>  	goto out;

Off-topic, but with or withoit this patch this "goto out" looks
strange imho. Why not a simple

	-	pid = NULL;
	-	goto out;
	+	return ERR_PTR(nr);

instead? But this is minor and subjective, I won't insist.

Oleg.

