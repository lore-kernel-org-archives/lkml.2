Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab0DMRlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 13:41:19 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:55291 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab0DMRlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 13:41:17 -0400
Date: Tue, 13 Apr 2010 13:39:41 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: zach.brown@oracle.com, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 1/2] ipc semaphores: reduce ipc_lock contention in
 semtimedop
Message-ID: <20100413173941.GI13327@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Manfred Spraul <manfred@colorfullife.com>, zach.brown@oracle.com,
	jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
	Nick Piggin <npiggin@suse.de>
References: <1271098163-3663-1-git-send-email-chris.mason@oracle.com>
 <1271098163-3663-2-git-send-email-chris.mason@oracle.com>
 <4BC4A6B2.1090906@colorfullife.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC4A6B2.1090906@colorfullife.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BC4ACB2.00A4:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 13, 2010 at 07:15:30PM +0200, Manfred Spraul wrote:
> Hi Chris,
> 
> 
> On 04/12/2010 08:49 PM, Chris Mason wrote:
> >  /*
> >+ * when a semaphore is modified, we want to retry the series of operations
> >+ * for anyone that was blocking on that semaphore.  This breaks down into
> >+ * a few different common operations:
> >+ *
> >+ * 1) One modification releases one or more waiters for zero.
> >+ * 2) Many waiters are trying to get a single lock, only one will get it.
> >+ * 3) Many modifications to the count will succeed.
> >+ *
> Have you thought about odd corner cases:
> Nick noticed the last time that it is possible to wait for arbitrary values:
> in one semop:
>     - decrease semaphore 5 by 10
>     - wait until semaphore 5 is 0
>     - increase semaphore 5 by 10.

Do you mean within a single sop array doing all three of these?  I don't
know if the sort is going to leave the three operations on semaphore 5
in the same order (it probably won't).

But I could change that by having it include the slot in the original
sop array in the sorting.  That way if we have duplicate semnums in the
array, they will end up in the same position relative to each other in
the sorted result.

(ewwww ;)

-chris
