Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305Ab0GUPBa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 11:01:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:33070 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932070Ab0GUPB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 11:01:26 -0400
Message-ID: <4C470B46.4040604@kernel.org>
Date: Wed, 21 Jul 2010 16:59:18 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        torvalds@linux-foundation.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, jeff@garzik.org,
        akpm@linux-foundation.org, rusty@rustcorp.com.au,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
        andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCHSET] workqueue: implement and use WQ_UNBOUND
References: <7b6bba36-5330-4e27-b7a9-3a4113b6b379@email.android.com> <21485.1279717725@redhat.com>
In-Reply-To: <21485.1279717725@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 21 Jul 2010 14:59:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/21/2010 03:08 PM, David Howells wrote:
> Tejun Heo <tj@kernel.org> wrote:
> 
>> As all unbound works are served by the same gcwq, non reentrancy is
>> automatically guaranteed.
> 
> That doesn't actually explain _how_ it's non-reentrant.  The gcwq includes a
> collection of threads that can execute from it, right?  If so, what mechanism
> prevents two threads from executing the same work item, if that work item
> isn't bound to a CPU?  I've been trying to figure this out from the code, but
> I don't see it offhand.

Sharing the same gcwq is why workqueues bound to one CPU have
non-reentrancy, so they're using the same mechanism.  If it doesn't
work for unbound workqueues, the normal ones are broken too.  Each
gcwq keeps track of currently running works in a hash table and looks
whether the work in question is already executing before starting
executing it.  It's a bit complex but as a work_struct may be freed
once execution starts, the status needs to be tracked outside.

>>> Btw, how does this fare in an RT system, where work items bound to a CPU
>>> can't get executed because their CPU is busy with an RT thread, even
>>> though there are other, idle CPUs?
>>
>> Sure, there's nothing special about unbound workers.  They're just normal
>> kthreads.
> 
> I should've been clearer: As I understand it, normal (unbound) worker items
> are bound to the CPU on which they were queued, and will be executed there
> only (barring CPU removal).  If that's the case, isn't it possible that work
> items can be prevented from getting execution time by an RT thread that's
> hogging a CPU and won't let go?

Yeah, for bound workqueues, sure.  That's exactly the same as the
original workqueue implementation.  For unbound workqueues, it doesn't
matter.

Thanks.

-- 
tejun
