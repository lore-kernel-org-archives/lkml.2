Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214Ab2KTMZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 07:25:06 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:55339 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab2KTMZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 07:25:04 -0500
X-Nat-Received: from [202.181.97.72]:51942 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1353414289.16540
To: keescook@chromium.org, linux-kernel@vger.kernel.org
Cc: james.l.morris@oracle.com, john.johansen@canonical.com,
        serge.hallyn@ubuntu.com, eparis@redhat.com,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH] Yama: remove locking from delete path
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20121119233459.GA9524@www.outflux.net>
In-Reply-To: <20121119233459.GA9524@www.outflux.net>
Message-Id: <201211202124.FIA41997.SFtOOOLMQFVFHJ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 20 Nov 2012 21:24:49 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 20112012 #8460918, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook wrote:
> Instead of locking the list during a delete, mark entries as invalid
> and trigger a workqueue to clean them up. This lets us easily handle
> task_free from interrupt context.

> @@ -57,9 +80,12 @@ static int yama_ptracer_add(struct task_struct *tracer,
>  
>  	added->tracee = tracee;
>  	added->tracer = tracer;
> +	added->invalid = false;
>  
> -	spin_lock_bh(&ptracer_relations_lock);
> +	spin_lock(&ptracer_relations_lock);

Can't you use
	spin_lock_irqsave(&ptracer_relations_lock, flags);
	spin_unlock_irqrestore(&ptracer_relations_lock, flags);
instead of adding ->invalid ?
