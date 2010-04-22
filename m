Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab0DVSX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 14:23:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38499 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753409Ab0DVSXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 14:23:23 -0400
Date: Thu, 22 Apr 2010 11:23:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, mathieu.desnoyers@efficios.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix double free in prepare_usermodehelper_creds()
 error handling
Message-Id: <20100422112307.5375e085.akpm@linux-foundation.org>
In-Reply-To: <20100420214117.10400.82534.stgit@warthog.procyon.org.uk>
References: <20100420214117.10400.82534.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Apr 2010 22:41:18 +0100
David Howells <dhowells@redhat.com> wrote:

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

Oleg's umh-creds-kill-subprocess_info-cred-logic.patch removes
prepare_usermodehelper_creds() altogether.  An option would have been
to promote that into 2.6.34?


