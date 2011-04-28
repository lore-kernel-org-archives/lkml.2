Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559Ab1D1Wsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 18:48:31 -0400
Received: from smtp-out.google.com ([74.125.121.67]:33835 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab1D1Wsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 18:48:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=sNGg4bfAFzTerfHCNXty36MrndPgcmDtRKp4lSJy50ROUFpNVlrAV9Ja3DTcDKHEIa
         q8LH81x4QXQABbVCbfaw==
Date: Thu, 28 Apr 2011 15:48:25 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: john stultz <johnstul@us.ibm.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] break out page allocation warning code
In-Reply-To: <1303954193.2971.43.camel@work-vm>
Message-ID: <alpine.DEB.2.00.1104281545590.24536@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1104201317410.31768@chino.kir.corp.google.com> <1303331695.2796.159.camel@work-vm> <20110421103009.731B.A69D9226@jp.fujitsu.com> <1303846026.2816.117.camel@work-vm> <alpine.DEB.2.00.1104271641350.25369@chino.kir.corp.google.com>
 <1303950728.2971.35.camel@work-vm> <1303954193.2971.43.camel@work-vm>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011, john stultz wrote:

> So thinking further, this can be simplified by adding the seqlock first,
> and then retaining the task_locking only in the set_task_comm path until
> all comm accessors are converted to using get_task_comm.
> 

On second thought, I think it would be better to just retain using a 
spinlock but instead of using alloc_lock, introduce a new spinlock to 
task_struct for the sole purpose of protecting comm.

And, instead, of using get_task_comm() to write into a preallocated 
buffer, I think it would be easier in the vast majority of cases that 
you'll need to convert to just provide task_comm_lock(p) and 
task_comm_unlock(p) so that p->comm can be dereferenced safely.  
get_task_comm() could use that interface itself and then write into a 
preallocated buffer.

The problem with using get_task_comm() everywhere is it requires 16 
additional bytes to be allocated on the stack in hundreds of locations 
around the kernel which may or may not be safe.
