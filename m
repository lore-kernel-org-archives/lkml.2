Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab0GZTFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 15:05:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:56140 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788Ab0GZTFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 15:05:32 -0400
Message-ID: <4C4DDC31.9070206@kernel.org>
Date: Mon, 26 Jul 2010 21:04:17 +0200
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
References: <4C04D41B.4050704@kernel.org> <4C06A580.9060300@kernel.org> <20100722155840.GA1743@redhat.com> <4C48B664.9000109@kernel.org> <20100724191447.GA4972@redhat.com> <4C4BEAA2.6040301@kernel.org> <20100726152510.GA26223@redhat.com> <4C4DAB14.5050809@kernel.org> <20100726155014.GA26412@redhat.com> <4C4DB247.9060709@kernel.org> <20100726162346.GD26412@redhat.com>
In-Reply-To: <20100726162346.GD26412@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 26 Jul 2010 19:04:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2010 06:23 PM, Michael S. Tsirkin wrote:
>> * Can you please keep the outer goto repeat loop?  I just don't like
>>   outermost for (;;).
> 
> Okay ... can we put the code in a {} scope to make it clear
> where does the loop starts and ends?

If we're gonna do that, it would be better to put it inside a loop
construct.  The reason why I don't like it is that loops like that
don't really help read/writeability much while indenting the whole
logic unnecessarily and look more like a result of obsession against
goto rather than any practical reason.  It's just a cosmetic
preference and I might as well be the weirdo here, so if you feel
strong about it, please feel free to put everything in a loop.

>> * Placing try_to_freeze() could be a bit annoying.  It shouldn't be
>>   executed when there's a work to flush.
> 
> It currently seems to be executed when there is work to flush.
> Is this wrong?

Oh, does it?  As I wrote in the other mail, things like that wouldn't
necessarily break correctness but I think it would be better to avoid
surprises in the generic code if not too difficult.

>> * I think A - B <= 0 test would be more familiar.  At least
>>   time_before/after() are implemented that way.
> 
> I am concerned that this overflows a signed integer -
> which I seem to remeber that C99 disallows.

Really?  Overflows of pointer isn't expected and that's why we have
weird RELOC_HIDE() macro for such calculations but integers not
expected to overflow is a news to me.  Are you sure?  That basically
means time_before/after() aren't safe either.

> timer macros are on data path so might be worth the risk there,
> but flush is slow path so better be safe?

I don't think performance matters much here.  I just think the sign
test is clearer / more familiar for the logic.

Thanks.

-- 
tejun
