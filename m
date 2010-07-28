Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab0G1MCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 08:02:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:50533 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754757Ab0G1MCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 08:02:04 -0400
Message-ID: <4C501BFB.2010607@kernel.org>
Date: Wed, 28 Jul 2010 14:00:59 +0200
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
References: <20100726152510.GA26223@redhat.com> <4C4DAB14.5050809@kernel.org> <20100726155014.GA26412@redhat.com> <4C4DB247.9060709@kernel.org> <4C4DB466.6000409@kernel.org> <20100726165114.GA27353@redhat.com> <4C4DDE7E.8030406@kernel.org> <4C4DE2AE.40302@kernel.org> <20100727191911.GA16350@redhat.com> <4C4FE0CF.3070506@kernel.org> <20100728104858.GB30643@redhat.com>
In-Reply-To: <20100728104858.GB30643@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 28 Jul 2010 12:01:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/28/2010 12:48 PM, Michael S. Tsirkin wrote:
> I'm unsure how flush_work operates under these conditions.  E.g. in
> workqueue.c, this seems to work by keeping a pointer to current
> workqueue in the work.  But what prevents us from destroying the
> workqueue when work might not be running?

In cmwq, work points to the gcwq it was on, which keeps track of all
the works in progress, so flushing work which is on a destroyed
workqueue should be fine, but in the original implementation, it would
end up accessing freed memory.

> Is this currently broken if you use multiple workqueues
> for the same work? If yes, I propose we do as I did,
> making flush_work get worker pointer, and only flushing
> on that worker.

The original semantics of workqueue is that flush_work() guarantees
that the work has finished executing on the workqueue it was last
queued on.  Adding @worker to flush_work() is okay, I think.

Thanks.

-- 
tejun
