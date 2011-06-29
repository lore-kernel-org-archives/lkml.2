Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab1F2DnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 23:43:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:60136 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645Ab1F2DnI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 23:43:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=rWBhs9dUHHOTqMW/B0ZEOPzwGfMmz+7Fgec3D4JHDH6h1yDWbT36PWEMZVeCpmNNk
	1V/EJ7AhGaVEQggeBLUFw==
MIME-Version: 1.0
In-Reply-To: <1309252313.6701.177.camel@twins>
References: <20110621071649.862846205@google.com> <20110621071700.599897751@google.com>
 <1308763751.1022.60.camel@twins> <CAPM31RLbngLP-EuK6TwRCh11RHJMsh1+5vBNisVEvupkJ4q4ng@mail.gmail.com>
 <1309252313.6701.177.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Tue, 28 Jun 2011 20:37:19 -0700
Message-ID: <CAPM31RJMiK5Omhgx3nm219x8BBPdhrBwU8s7fi4q8NXroZgL9w@mail.gmail.com>
Subject: Re: [patch 09/16] sched: unthrottle cfs_rq(s) who ran out of quota at
 period refresh
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 28, 2011 at 2:11 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2011-06-27 at 21:40 -0700, Paul Turner wrote:
>> >> +       if (unlikely(runtime_expires != cfs_b->runtime_expires))
>> >> +               goto out_unlock;
>> >
>> > it might help to explain how, runtime_expires is taken from cfs_b after
>> > calling __refill_cfs_bandwidth_runtime, and we're in the replenishment
>> > timer, so nobody is going to be adding new runtime.
>> >
>>
>> Good idea -- thanks
>
> Aside from being a good idea, I'm genuinely puzzled by that part and
> would love having it explained :-)
>

It's all the users fault!

While we were busy doing this they might have set some new bandwidth
limit (since we drop cfs_b->lock to distribute) via cgroupfs, in which
case we need to make sure we:

a) stop since setting the new runtime will have unthrottled everyone anyway
b) don't put our runtime in cfs_b->runtime as at this point we'd be
over-writing the new-runtime just set by tg_set_cfs_bandwidth

We can catch this happening however, since tg_set_cfs_bandwidth sets a
new expiration' which is what the check above enforces.
