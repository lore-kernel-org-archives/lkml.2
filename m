Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab2EMXuc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 19:50:32 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:42669 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab2EMXub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 19:50:31 -0400
Message-ID: <4FB048A0.9000601@linux.vnet.ibm.com>
Date: Mon, 14 May 2012 05:19:52 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Bojan Smojver <bojan@rexursive.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-kernel@vger.kernel.org,
        bp@alien8.de
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
References: <1336515735.2097.23.camel@shrek.rexursive.com> <201205122347.08176.rjw@sisk.pl> <8b0184d9-0c54-4f6e-b0b7-ce1b7d854b9e@email.android.com> <201205131510.37664.rjw@sisk.pl> <1336951080.2190.4.camel@shrek.rexursive.com>
In-Reply-To: <1336951080.2190.4.camel@shrek.rexursive.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12051323-9574-0000-0000-000002AB94A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2012 04:48 AM, Bojan Smojver wrote:

> On Sun, 2012-05-13 at 15:10 +0200, Rafael J. Wysocki wrote:
>>> So, a suspend after the image write will be just one long "failure",
>> after
>>> which hibernation code has to unwind again. No?
>>
>> Hmm.  Good question.  It should be like this I think, although there
>> may be some corner cases lurking.
> 
> AFAICT, the user space suspend to both works this way.
> 


But does it carry out suspend-to-ram in full, or does it skip the
PM_SUSPEND_PREPARE notifications?

> If I understand thing correctly, at the point of suspend to memory, we
> are not really running a full system any more. All the processes have
> been frozen and they've been told that hibernation is in progress. Ditto
> devices, minus the ones we use to write to swap. So, when hibernation
> code unwinds post resume from memory, it would be doing the correct
> thing.
> 
> Srivatsa, does that make sense to you?
> 


See my concerns about the preparation stage for suspend, in my other
mail as well. I would have been less worried if we did things in full:
1. prepare for hibernation
2. create image
3. prepare for suspend
4. do suspend
5. do resume
6. unwind from hibernation code (like a failed hibernation).

Still no guarantees, but somewhat better.
(consider what will happen if some code expects completion of an operation,
successful or otherwise, before starting another.. and hence is unprepared
for something like:
hibernation prepare -> suspend prepare -> post suspend -> post hibernation)

If we don't rework this thing carefully via a special notification for
save-image-and-suspend like what Rafael suggested, and instead try to go
with existing stuff as it is, I would definitely suggest putting this feature
under something like CONFIG_EXPERIMENTAL ;-)

Regards,
Srivatsa S. Bhat

