Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932701Ab2ASSKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 13:10:51 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:45039 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932577Ab2ASSKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 13:10:47 -0500
Message-ID: <4F185C9A.9060408@linux.vnet.ibm.com>
Date: Thu, 19 Jan 2012 23:40:34 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Tejun Heo <tj@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, horms@verge.net.au,
        Len Brown <lenb@kernel.org>
Subject: Re: [Update][PATCH] PM / Hibernate: Fix s2disk regression related
 to unlock_system_sleep()
References: <201201180015.56510.rjw@sisk.pl> <4F16C24A.4050007@linux.vnet.ibm.com> <CAOS58YMBWrD2cMyPJG0Xf16i1vnkB8xerdeqWJ=fk7HVNpoPAw@mail.gmail.com> <4F16F94C.4020000@linux.vnet.ibm.com> <CAOS58YPW3hB3ibaYPLBqhu=2jZTAjjF7DZaXO=hK5tookAX7YA@mail.gmail.com> <4F16FF0D.1030606@linux.vnet.ibm.com> <20120118173037.GE30664@google.com> <20120118173348.GF30664@google.com> <20120119103707.GA13308@elf.ucw.cz> <4F17F6AF.10604@linux.vnet.ibm.com> <20120119174038.GA25397@atrey.karlin.mff.cuni.cz>
In-Reply-To: <20120119174038.GA25397@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12011918-8256-0000-0000-000000F3B08F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2012 11:10 PM, Pavel Machek wrote:

> Hi!
> 
>>>> To give an example,
>>>>
>>>> 	/*
>>>> 	 * XXX: Open code SKIP clearing for now to avoid invoking
>>>> 	 * try_to_freeze().  This isn't correct but this function is
>>>> 	 * called from deep inside hibernation path and calling
>>>> 	 * try_to_freeze() leads to hang during hibernation.  This
>>>> 	 * will be properly fixed soon.  See commit message for
>>>> 	 * more details.
>>>> 	 */
>>>
>>> Which paths are affected?
>>>
>>> With uswsusp, we have userland in control of hibernation process; I'd
>>> say almost anything can be called...
>>
>>
>> Hi Pavel,
>> I am afraid you are looking at a stale comment. We finalized on a
>> different comment altogether.
> 
> I know. But the underlying problem (uswsusp code is userland, and can
> do anything) is still there, right? I guess limitations for
> applications using uswsusp interface should be documented somewhere.

Sorry, but I think you missed the conclusion of the discussion in this
thread: The comment mentioned above is completely wrong! Rewriting
unlock_system_sleep() by open coding the SKIP clearing and omitting the
try_to_freeze() part is not a hack - instead, it is a clean and sane
design. Hence, with the latest version of my patch applied, it would
no longer be "hey, please watch out for this, this and this for now;
we know things are messy but we will fix it up later".
Instead it is like "Don't worry, we have fixed up the buggy
unlock_system_sleep() function. Go ahead and do what you want!"

On a more serious note, here is a (hopefully) convincing explanation
as to why the patch makes perfect sense:

http://thread.gmane.org/gmane.linux.kernel/1240493/focus=1240892
and
http://thread.gmane.org/gmane.linux.kernel/1240493/focus=1240940

Moreover, we have already advised people to use the lock_system_sleep()
and unlock_system_sleep() APIs instead of directly using mutex_lock and
mutex_unlock on pm_mutex, in Documentation/power/freezing-of-tasks.txt

But unfortunately, unlock_system_sleep() was actually not quite correct
and hence this patch fixes it. So things should be fine now...

But, in case you were hinting at some totally different problem, please
let me know..

Regards,
Srivatsa S. Bhat

