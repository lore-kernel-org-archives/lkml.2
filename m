Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab2C1HNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 03:13:55 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60269 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab2C1HNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 03:13:54 -0400
Date: Wed, 28 Mar 2012 00:13:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, viro@zeniv.linux.org.uk,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: suppress page allocation failure warnings from sys_listxattr
In-Reply-To: <20120327172622.827fd6ab.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1203280007400.16201@chino.kir.corp.google.com>
References: <20120313182220.GA11500@redhat.com> <20120327155149.d41a235b.akpm@linux-foundation.org> <20120328001550.GA3077@redhat.com> <20120327172622.827fd6ab.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2012, Andrew Morton wrote:

> /*
>  * PAGE_ALLOC_COSTLY_ORDER is the order at which allocations are deemed
>  * costly to service.  That is between allocation orders which should
>  * coelesce naturally under reasonable reclaim pressure and those which
>  * will not.
>  */
> #define PAGE_ALLOC_COSTLY_ORDER 3
> 
> 
> Death to magic numbers :(

This isn't as dire as it sounds, memory compaction is specifically 
targeted to run when the order is greater than this, see 
compaction_ready().  If direct reclaim and compaction both fail then 
there's nothing the VM can do other than oom kill to free memory and we 
avoid doing that because there's no guarantee of freeing enough memory 
that the high-order allocation will be successful.

Not even __GFP_REPEAT is going to be helpful since we can't oom kill 
anything, the only alternative would be to use __GFP_NOFAIL and that would 
just be deadly for such an allocation request.  This error is recoverable, 
so

Acked-by: David Rientjes <rientjes@google.com>

to the patch.
