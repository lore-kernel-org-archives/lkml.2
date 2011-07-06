Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab1GFBzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 21:55:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:10459 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1GFBzV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 21:55:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=SeFFPKPIjk0gI9IPMTdUfTjJAkeDvIx9q3n/YYSINQc9R32ev4NfH/fU0AVHxsiCA
	LGmbki3W555L9zs6wpCtQ==
MIME-Version: 1.0
In-Reply-To: <1309600625.10073.8.camel@twins>
References: <20110702005222.262883892@google.com> <20110702005228.481583467@google.com>
 <20110702090817.GB17482@elte.hu> <1309600625.10073.8.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Tue, 5 Jul 2011 18:54:48 -0700
Message-ID: <CAPM31RKh+HcBRKyoFr3dkqMEVqxqZdBBZ0t7Tf1bS71rwkhGoQ@mail.gmail.com>
Subject: Re: [patch 1/1] sched: update_curr versus correct cfs_rq in check_preempt_wakeup
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 2, 2011 at 2:57 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Sat, 2011-07-02 at 11:08 +0200, Ingo Molnar wrote:
>> * Paul Turner <pjt@google.com> wrote:
>>
>> > We update_curr() versus the current entity as the preemption
>> > decision is based on the relative vruntime.  However, update_curr()
>> > is not hierarchical and in the group scheduling case
>> > find_matching_se() will have us making the comparison on a cfs_rq
>> > different to the one just updated.
>>
>> Would be nice to include more contextual information in the
>> changelog: how did you find it, what effect (if any) did you
>> see from this patch, what effect do you expect others to see
>> (if any).
>
> Agreed that the Changelog can be improved. From talking to pjt on IRC
> though, I think he spotted this by reading through the code.
>
> The effect of not updating the correct se for comparison is that you
> compare the new task to old data of the existing task, thereby giving a
> slight preference to the old task (its further to the left than it
> should be and thus more desirable to run).
>
> That said, I'm not quite sure the patch is correct though, both se and
> pse can change in find_match_se(), maybe we should do update_curr() on
> every se we traverse in there, or at least the final two.
>

For the pre-emption decision we only need to update on the final
entity reached as the other levels do not factor into the decision
(and will be updated later).

We also don't need to worry about updates versus pse as until we reach
a common parent there can be no current entity for these levels (and
once we reach a common parent we're on the same cfs_rq anyway).


>
>
