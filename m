Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab0DUNrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 09:47:12 -0400
Received: from mail.openrapids.net ([64.15.138.104]:50846 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754531Ab0DUNrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 09:47:08 -0400
Date: Wed, 21 Apr 2010 09:47:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix double free in
	prepare_usermodehelper_creds() error handling
Message-ID: <20100421134704.GA27473@Krystal>
References: <20100420214117.10400.82534.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100420214117.10400.82534.stgit@warthog.procyon.org.uk>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:46:22 up 88 days, 16:23,  9 users,  load average: 0.03, 0.01,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Howells (dhowells@redhat.com) wrote:
> Patch 570b8fb505896e007fd3bb07573ba6640e51851d:
> 
> 	Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> 	Date:   Tue Mar 30 00:04:00 2010 +0100
> 	Subject: CRED: Fix memory leak in error handling
> 
> attempts to fix a memory leak in the error handling by making the offending
> return statement into a jump down to the bottom of the function where a
> kfree(tgcred) is inserted.
> 
> This is, however, incorrect, as it does a kfree() after doing put_cred() if
> security_prepare_creds() fails.  That will result in a double free if 'error'
> is jumped to as put_cred() will also attempt to free the new tgcred record by
> virtue of it being pointed to by the new cred record.

OK, I missed the fact taht put_cred() performs the kfree. Thanks for the fix.

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  kernel/cred.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/cred.c b/kernel/cred.c
> index e1dbe9e..ce1a52b 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -398,6 +398,8 @@ struct cred *prepare_usermodehelper_creds(void)
>  
>  error:
>  	put_cred(new);
> +	return NULL;
> +
>  free_tgcred:
>  #ifdef CONFIG_KEYS
>  	kfree(tgcred);
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
