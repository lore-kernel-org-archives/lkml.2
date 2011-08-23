Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab1HWUSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 16:18:24 -0400
Received: from smtp-out.google.com ([74.125.121.67]:47903 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755813Ab1HWUSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 16:18:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=ooNZKZeMpG3hV85PtkooGQ/IlAfscV7myHGAFPgplYcQBEqYCdKDQFCIECaWD0Ei2
	G6ArDZKnaViTTWXAPMCiA==
Date: Tue, 23 Aug 2011 13:18:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] oom: skip frozen tasks
In-Reply-To: <20110823073101.6426.77745.stgit@zurg>
Message-ID: <alpine.DEB.2.00.1108231313520.21637@chino.kir.corp.google.com>
References: <20110823073101.6426.77745.stgit@zurg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011, Konstantin Khlebnikov wrote:

> All frozen tasks are unkillable, and if one of them has TIF_MEMDIE
> we must kill something else to avoid deadlock. After this patch
> select_bad_process() will skip frozen task before checking TIF_MEMDIE.
> 

The caveat is that if the task in the refrigerator is not OOM_DISABLE and 
there are no other eligible tasks (system wide, in the cpuset, or in the 
memcg) to kill, then the machine will panic as a result of this when, in 
the past, we would simply issue the SIGKILL and keep looping in the page 
allocator until it is thawed.

So you may actually be trading a stall waiting for this thread to thaw for 
what would now be a panic, and that's not clearly better to me.
