Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab1BYKEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 05:04:38 -0500
Received: from smtp-out.google.com ([74.125.121.67]:47667 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754794Ab1BYKEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 05:04:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=YQHeL3pFb5W8fRuNQjd7P+SfFgP10XF45sNNQnumQds6HxlTXa7Aa+FVL7Iqi/Bd7b
         fUzkL0F7eZyDgSIwI9KA==
MIME-Version: 1.0
In-Reply-To: <20110224161111.7d83a884@jacob-laptop>
References: <20110216031831.571628191@google.com> <20110224161111.7d83a884@jacob-laptop>
From: Paul Turner <pjt@google.com>
Date: Fri, 25 Feb 2011 02:03:54 -0800
Message-ID: <AANLkTi=i-fgng0Pa2JDSy8RgqRs2mo2vc2CKbx12-=Ri@mail.gmail.com>
Subject: Re: [CFS Bandwidth Control v4 0/7] Introduction
To: jacob pan <jacob.jun.pan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval@linux.vnet.ibm.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Gautham R Shenoy <ego@in.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Matt Helsley <matthltc@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 24, 2011 at 4:11 PM, jacob pan
<jacob.jun.pan@linux.intel.com> wrote:
> On Tue, 15 Feb 2011 19:18:31 -0800
> Paul Turner <pjt@google.com> wrote:
>
>> Hi all,
>>
>> Please find attached v4 of CFS bandwidth control; while this rebase
>> against some of the latest SCHED_NORMAL code is new, the features and
>> methodology are fairly mature at this point and have proved both
>> effective and stable for several workloads.
>>
>> As always, all comments/feedback welcome.
>>
>
> Hi Paul,
>
> Your patches provide a very useful but slightly different feature for
> what we need to manage idle time in order to save power. What we
> need is kind of a quota/period in terms of idle time. I have been
> playing with your patches and noticed that when the cgroup cpu usage
> exceeds the quota the effect of throttling is similar to what I have
> been trying to do with freezer subsystem. i.e. freeze and thaw at given
> period and percentage runtime.
> https://lkml.org/lkml/2011/2/15/314
>
> Have you thought about adding such feature (please see detailed
> description in the link above) to your patches?
>

So reading the description it seems like rooting everything in a
'freezer' container and then setting up a quota of

(1 - frozen_percentage)  * nr_cpus * frozen_period * sec_to_usec

on a period of

frozen_period * sec_to_usec

Would provide the same functionality.  Is there other unduplicated
functionality beyond this?

One thing that does seem undesirable about your approach is (as it
seems to be described) threads will not be able to take advantage of
naturally occurring idle cycles and will incur a potential performance
penalty even at use << frozen_percentage.

e.g. From your post

       |  |<-- 90% frozen -     ->|  |                               |  |
____|  |________________x_|  |__________________|  |_____

        |<---- 5 seconds     ---->|


Suppose no threads active until the wake up at x, suppose there is an
accompanying 1 second of work for that thread to do.  That execution
time will be dilated to ~1.5 seconds (as it will span the 0.5 seconds
the freezer will stall for).  But the true usage for this period is
~20% <<< 90%

> Thanks,
>
> Jacob
>
