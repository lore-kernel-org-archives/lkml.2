Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934514Ab1IOTZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 15:25:44 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43875 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934209Ab1IOTZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 15:25:43 -0400
Message-ID: <4E725109.3010609@linux.vnet.ibm.com>
Date: Thu, 15 Sep 2011 14:24:57 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Nitin Gupta <ngupta@vflare.org>, Greg KH <greg@kroah.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, cascardo@holoscopio.com,
        linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
        linux-mm@kvack.org, brking@linux.vnet.ibm.com, rcj@linux.vnet.ibm.com
Subject: Re: [PATCH v2 0/3] staging: zcache: xcfmalloc support
References: <1315404547-20075-1-git-send-email-sjenning@linux.vnet.ibm.com> <20110909203447.GB19127@kroah.com> <4E6ACE5B.9040401@vflare.org> <4E6E18C6.8080900@linux.vnet.ibm.com> <4E6EB802.4070109@vflare.org> <4E6F7DA7.9000706@linux.vnet.ibm.com> <4E6FC8A1.8070902@vflare.org 4E72284B.2040907@linux.vnet.ibm.com> <075c4e4c-a22d-47d1-ae98-31839df6e722@default>
In-Reply-To: <075c4e4c-a22d-47d1-ae98-31839df6e722@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11091519-6078-0000-0000-000000C973F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2011 12:29 PM, Dan Magenheimer wrote:
>> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
>> Subject: Re: [PATCH v2 0/3] staging: zcache: xcfmalloc support
>>
>> Hey Nitin,
>>
>> So this is how I see things...
>>
>> Right now xvmalloc is broken for zcache's application because
>> of its huge fragmentation for half the valid allocation sizes
>> (> PAGE_SIZE/2).
> 
> Um, I have to disagree here. It is broken for zcache for
> SOME set of workloads/data, where the AVERAGE compression
> is poor (> PAGE_SIZE/2).
> 

True.

But are we not in agreement that xvmalloc needs to be replaced
with an allocator that doesn't have this issue? I thought we all
agreed on that...

>> My xcfmalloc patches are _a_ solution that is ready now.  Sure,
>> it doesn't so compaction yet, and it has some metadata overhead.
>> So it's not "ideal" (if there is such I thing). But it does fix
>> the brokenness of xvmalloc for zcache's application.
> 
> But at what cost?  As Dave Hansen pointed out, we still do
> not have a comprehensive worst-case performance analysis for
> xcfmalloc.  Without that (and without an analysis over a very
> large set of workloads), it is difficult to characterize
> one as "better" than the other.
> 

I'm not sure what you mean by "comprehensive worst-case performance
analysis".  If you're talking about theoretical worst-case runtimes
(i.e. O(whatever)) then apparently we are going to have to
talk to an authority on algorithm analysis because we can't agree
how to determine that.  However, it isn't difficult to look at the
code and (within your own understanding) see what it is.

I'd be interested so see what Nitin thinks is the worst-case runtime
bound.

How would you suggest that I measure xcfmalloc performance on a "very
large set of workloads".  I guess another form of that question is: How
did xvmalloc do this?

>> So I see two ways going forward:
>>
>> 1) We review and integrate xcfmalloc now.  Then, when you are
>> done with your allocator, we can run them side by side and see
>> which is better by numbers.  If yours is better, you'll get no
>> argument from me and we can replace xcfmalloc with yours.
>>
>> 2) We can agree on a date (sooner rather than later) by which your
>> allocator will be completed.  At that time we can compare them and
>> integrate the best one by the numbers.
>>
>> Which would you like to do?
> 
> Seth, I am still not clear why it is not possible to support
> either allocation algorithm, selectable at runtime.  Or even
> dynamically... use xvmalloc to store well-compressible pages
> and xcfmalloc for poorly-compressible pages.  I understand
> it might require some additional coding, perhaps even an
> ugly hack or two, but it seems possible.

But why do an ugly hack if we can just use a single allocator
that has the best overall performance for the allocation range
the zcache requires.  Why make it more complicated that it
needs to be?

> 
> Dan

