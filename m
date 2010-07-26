Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab0GZSwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 14:52:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:54650 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab0GZSwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 14:52:31 -0400
Message-ID: <4C4DD946.2080502@kernel.org>
Date: Mon, 26 Jul 2010 20:51:50 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>, Sridhar Samudrala <sri@us.ibm.com>,
        netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
        Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH UPDATED 1/3] vhost: replace vhost_workqueue with per-vhost
 kthread
References: <4C06A580.9060300@kernel.org> <20100722155840.GA1743@redhat.com> <4C48B664.9000109@kernel.org> <20100724191447.GA4972@redhat.com> <4C4BEAA2.6040301@kernel.org> <20100726152510.GA26223@redhat.com> <4C4DAB14.5050809@kernel.org> <20100726155014.GA26412@redhat.com> <4C4DB247.9060709@kernel.org> <4C4DB466.6000409@kernel.org> <20100726163108.GE26412@redhat.com>
In-Reply-To: <20100726163108.GE26412@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 26 Jul 2010 18:51:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/26/2010 06:31 PM, Michael S. Tsirkin wrote:
>> On 07/26/2010 06:05 PM, Tejun Heo wrote:
>>> * Placing try_to_freeze() could be a bit annoying.  It shouldn't be
>>>   executed when there's a work to flush.
> 
> BTW why is this important?
> We could always get another work and flush right after
> try_to_freeze, and then flush would block for a long time.
> 
> BTW the vhost patch you sent does not do this at all.
> I am guessing it is because our thread is not freezable?

Yeap, I think so.

>> * Similar issue exists for kthread_stop().  The kthread shouldn't exit
>>   while there's a work to flush (please note that kthread_worker
>>   interface allows detaching / attaching worker kthread during
>>   operation, so it should remain in consistent state with regard to
>>   flushing).
> 
> Not sure I agree here. Users must synchronise flush and stop calls.
> Otherwise a work might get queued after stop is called, and
> you won't be able to flush it.

For freeze, it probably is okay but for stop, I think it's better to
keep the semantics straight forward.  It may be okay to do otherwise
but having such oddity in generic interface is nasty and may lead to
surprises which can be pretty difficult to track down later on.  It's
just a bit more of annoyance while writing the generic code, so...

Thanks.

-- 
tejun
