Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab2AaAJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 19:09:11 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:33890 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754075Ab2AaAJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 19:09:09 -0500
Message-ID: <4F27311C.5020200@linux.vnet.ibm.com>
Date: Tue, 31 Jan 2012 05:39:00 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] PM/Freezer: Make thaw_processes() thaw only userspace
 tasks
References: <20120130231342.11129.87187.stgit@srivatsabhat.in.ibm.com> <20120130231437.11129.3708.stgit@srivatsabhat.in.ibm.com> <20120130233055.GE27616@google.com>
In-Reply-To: <20120130233055.GE27616@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12013013-5490-0000-0000-000000A4A731
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2012 05:00 AM, Tejun Heo wrote:

> On Tue, Jan 31, 2012 at 04:44:48AM +0530, Srivatsa S. Bhat wrote:
>> Currently the situation is:
>>
>> freeze_processes() - freezes only userspace tasks
>> freeze_kernel_threads() - freezes only kernel threads
>> thaw_kernel_threads() - thaws only kernel threads
>> thaw_processes() - thaws *everything* (both userspace tasks and kernel threads)
> 
> Umm... I don't really get this.  Why is this a problem?  The list is
> not even correct.  freeze_kernel_threads() doesn't freeze "only"
> kernel threads.  It freezes all threads "including" kernel threads and


Oh, you are are right - the list is incorrect. I guess I got carried away
thinking about thaw_kernel_threads().

> that's only natural because you can't freeze kernel threads without
> freezing userland threads and of course you can't thaw userland
> threads without thawing kernel threads.
>

> The system simply won't work if you do it otherwise and making them

> disjoint operations increases the chance of bugs.  These operations
> are naturally enclosed within each other and trying to break them
> apart isn't a good idea.
> 


Yeah, I get it now.. Thanks for the explanation!

> What's the problem you're trying to solve here?  I don't really see
> code clean up.  Code is different but not necessarily cleaner and FWIW
> it seems more unnatural and brittle to me.
> 


The thing is that, I wanted to avoid a bug in the patch posted at
https://lkml.org/lkml/2012/1/29/47 as explained in the link.

So I guess I should have simply done:

freeze_kernel_threads() calls thaw_kernel_threads() upon error.
The caller of freeze_kernel_threads() will call thaw_processes() if
necessary.

This way even the SNAPSHOT_CREATE_IMAGE ioctl would remain safe.

I'll think it through again and post an updated patch.
Thank you very much for the review!

Regards,
Srivatsa S. Bhat

