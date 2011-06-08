Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab1FHUJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:09:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:19159 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab1FHUJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:09:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=s8GBBsJjrHodGjrOmwP3qGqj4CWg/Z/dPuPnF6r5xxQLnclvi8UhWabAiCfHSUKzi4
         qRWase7dXP+LZl83MuBg==
Date: Wed, 8 Jun 2011 13:09:20 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Miles Lane <miles.lane@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        John Johansen <john.johansen@canonical.com>
Subject: Re: 3.0.0-rc2-git1 -- BUG: sleeping function called from invalid
 context at mm/slub.c:847
In-Reply-To: <BANLkTimq+h+WyboMbPGVH1uJuj64YuRLdw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1106081305430.10320@chino.kir.corp.google.com>
References: <BANLkTimq+h+WyboMbPGVH1uJuj64YuRLdw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jun 2011, Miles Lane wrote:

> BUG: sleeping function called from invalid context at mm/slub.c:847
>  in_atomic(): 1, irqs_disabled(): 0, pid: 1583, name: cupsd
>  2 locks held by cupsd/1583:
>   #0:  (tasklist_lock){.+.+.+}, at: [<ffffffff8104dafa>] do_prlimit+0x61/0x189
>   #1:  (&(&p->alloc_lock)->rlock){+.+.+.}, at: [<ffffffff8104db2d>]
> do_prlimit+0x94/0x189
>  Pid: 1583, comm: cupsd Not tainted 3.0.0-rc2-git1 #7
>  Call Trace:
>   [<ffffffff8102ebf2>] __might_sleep+0x10d/0x112
>   [<ffffffff810e6f46>] slab_pre_alloc_hook.isra.49+0x2d/0x33
>   [<ffffffff810e7bc4>] kmem_cache_alloc+0x22/0x132
>   [<ffffffff8105b6e6>] prepare_creds+0x35/0xe4
>   [<ffffffff811c0675>] aa_replace_current_profile+0x35/0xb2
>   [<ffffffff811c4d2d>] aa_current_profile+0x45/0x4c
>   [<ffffffff811c4d4d>] apparmor_task_setrlimit+0x19/0x3a
>   [<ffffffff811beaa5>] security_task_setrlimit+0x11/0x13
>   [<ffffffff8104db6b>] do_prlimit+0xd2/0x189
>   [<ffffffff8104dea9>] sys_setrlimit+0x3b/0x48
>   [<ffffffff814062bb>] system_call_fastpath+0x16/0x1b
> 

Not sure why this ever actually worked with apparmor if prepare_creds() 
does an unconditional GFP_KERNEL allocation since this codepath hasn't 
changed in at least a year and we're holding a spinlock from setrlimit.  
John?
