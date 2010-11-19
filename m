Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab0KSTmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 14:42:23 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44537 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab0KSTmV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 14:42:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=RaVJQsqBrsUZjJRsn2iKqJEn5llGdfMZoNn0IKBmxq0fpUaUIRwLuyNtii9ZtztCYu
         BgQrvbrywr2K8nf8icEuOJzfm/kjciDbNMD5qiPY53bcsJXnjdCFx+bMDbsXDS5pIONE
         MgJ/+FEWD3AHZbK9iRGvt2qQMwBkRu5RcMUyY=
MIME-Version: 1.0
In-Reply-To: <20101116142029.721937333@kernel.dk>
References: <20101116140900.039761100@kernel.dk>
	<20101116142029.721937333@kernel.dk>
Date: Fri, 19 Nov 2010 11:42:21 -0800
X-Google-Sender-Auth: vA9TQH_iVyi9fGW9MWRfgxbLdio
Message-ID: <AANLkTin-c3hJ64ytgOp2Yx0SeJE7v6vQ7GRGds09YMQx@mail.gmail.com>
Subject: Re: [patch 16/28] fs: Use rename lock and RCU for multi-step operations
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 6:09 AM, Nick Piggin <npiggin@kernel.dk> wrote:

> +               /* might go back up the wrong parent if we have had a rename
> +                * or deletion */
> +               if (this_parent != child->d_parent ||
> +                               read_seqretry(&rename_lock, seq)) {
> +                       spin_unlock(&this_parent->d_lock);
> +                       spin_unlock(&dcache_lock);
> +                       rcu_read_unlock();
> +                       goto rename_retry;
> +               }
> +               rcu_read_unlock();
> +               next = child->d_u.d_child.next;

Again there are something like three insertions of this check.  Right
now it arguably makes sense to have everything explicitly clear inline
at every instance of the code for review, but eventually it might be
more readable if these became something like:

if (rename_happened(...))
        goto rename_retry;

(accounting for the change in patch 19 of course)
