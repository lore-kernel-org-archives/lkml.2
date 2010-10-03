Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab0JCBDf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 21:03:35 -0400
Received: from smtp-out.google.com ([74.125.121.35]:44402 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395Ab0JCBDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 21:03:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=lFqVLo3NCrVjKwOi01mu2R79ziAylRM3gVJ9LpjmuFxaGUHe+TAzuh3YjTzzpeoXux
         zobMprqtFRGj3lZZ+upg==
Date: Sat, 2 Oct 2010 18:03:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>
Subject: Re: [RFC/PATCH] SLUB: Optimize slab_free() debug check
In-Reply-To: <1286008825-5567-1-git-send-email-penberg@kernel.org>
Message-ID: <alpine.DEB.2.00.1010021802120.20855@chino.kir.corp.google.com>
References: <1286008825-5567-1-git-send-email-penberg@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Oct 2010, Pekka Enberg wrote:

> This patch optimizes slab_free() debug check to use "c->node != NUMA_NO_NODE"
> instead of "c->node >= 0" because the former generates smaller code on x86-64:
> 
>   Before:
> 
>     4736:       48 39 70 08             cmp    %rsi,0x8(%rax)
>     473a:       75 26                   jne    4762 <kfree+0xa2>
>     473c:       44 8b 48 10             mov    0x10(%rax),%r9d
>     4740:       45 85 c9                test   %r9d,%r9d
>     4743:       78 1d                   js     4762 <kfree+0xa2>
> 
>   After:
> 
>     4736:       48 39 70 08             cmp    %rsi,0x8(%rax)
>     473a:       75 23                   jne    475f <kfree+0x9f>
>     473c:       83 78 10 ff             cmpl   $0xffffffffffffffff,0x10(%rax)
>     4740:       74 1d                   je     475f <kfree+0x9f>
> 
> This patch also cleans up __slab_alloc() to use NUMA_NO_NODE instead of "-1"
> for enabling debugging for a per-CPU cache.
> 
> Cc: Christoph Lameter <cl@linux.com>
> Cc: David Rientjes <rientjes@google.com>
> Signed-off-by: Pekka Enberg <penberg@kernel.org>

Acked-by: David Rientjes <rientjes@google.com>

You could compare to NUMA_NO_NODE in show_slab_objects(), as well, for the 
same optimization.
