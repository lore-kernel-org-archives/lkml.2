Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab1BJS57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 13:57:59 -0500
Received: from smtp-out.google.com ([216.239.44.51]:10742 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab1BJS56 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 13:57:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OGFlxxHQS7/TRlCYRS+A42m90PhP63kMag8e0ZrnSUGVWv1DLvP61l3dXUbWHMJWMo
         fr6IUa/ZxGAYOhNzrFpA==
MIME-Version: 1.0
In-Reply-To: <20110210035738.GC27040@redhat.com>
References: <20110210013211.21573.69260.stgit@neat.mtv.corp.google.com>
	<20110210020946.GA27040@redhat.com>
	<AANLkTi=dZDK6VosLX8JH4gJyRQ0KXGKMA5vhJ-7D93s7@mail.gmail.com>
	<20110210035738.GC27040@redhat.com>
Date: Thu, 10 Feb 2011 10:57:55 -0800
Message-ID: <AANLkTi=J8x3cEhQ_tJJ0=YM6+y_ZNLtK_34PweQfNJL8@mail.gmail.com>
Subject: Re: [PATCH] Avoid preferential treatment of groups that aren't backlogged
From: Chad Talbott <ctalbott@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jaxboe@fusionio.com, guijianfeng@cn.fujitsu.com, mrubin@google.com,
        teravest@google.com, jmoyer@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 7:57 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Feb 09, 2011 at 06:45:25PM -0800, Chad Talbott wrote:
>> On Wed, Feb 9, 2011 at 6:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > In upstream code once a group gets backlogged we put it at the end
>> > and not at the beginning of the tree. (I am wondering are you looking
>> > at the google internal code :-))
>> >
>> > So I don't think that issue of a low weight group getting more disk
>> > time than its fair share is present in upstream kernels.
>>
>> You've caught me re-using a commit description.  :)
>>
>> Here's an example of the kind of tests that fail without this patch
>> (run via the test that Justin and Akshay have posted):
>>
>> 15:35:35 INFO ----- Running experiment 14: 950 rdrand, 50 rdrand.delay10
>> 15:35:55 INFO Experiment completed in 20.4 seconds
>> 15:35:55 INFO experiment 14 achieved DTFs: 886, 113
>> 15:35:55 INFO experiment 14 FAILED: max observed error is 64, allowed is 50
>>
>> 15:35:55 INFO ----- Running experiment 15: 950 rdrand, 50 rdrand.delay50
>> 15:36:16 INFO Experiment completed in 20.5 seconds
>> 15:36:16 INFO experiment 15 achieved DTFs: 891, 108
>> 15:36:16 INFO experiment 15 FAILED: max observed error is 59, allowed is 50
>>
>> Since this is Jens' unmodified tree, I've had to change
>> BLKIO_WEIGHT_MIN to 10 to allow this test to proceed.  We typically
>> run many jobs with small weights, and achieve the requested isolation:
>> see below results with this patch:
>>
>> 14:59:17 INFO ----- Running experiment 14: 950 rdrand, 50 rdrand.delay10
>> 14:59:36 INFO Experiment completed in 19.0 seconds
>> 14:59:36 INFO experiment 14 achieved DTFs: 947, 52
>> 14:59:36 INFO experiment 14 PASSED: max observed error is 3, allowed is 50
>>
>> 14:59:36 INFO ----- Running experiment 15: 950 rdrand, 50 rdrand.delay50
>> 14:59:55 INFO Experiment completed in 18.5 seconds
>> 14:59:55 INFO experiment 15 achieved DTFs: 944, 55
>> 14:59:55 INFO experiment 15 PASSED: max observed error is 6, allowed is 50
>>
>> As you can see, it's with seeky workloads that come and go from the
>> service tree where this patch is required.
>
> I have not look into or run the tests posted by Justin and Akshay. Can you
> give more details about these tests.

> Are you running with group_isolation=0 or 1. These tests seem to be random
> read and if group_isolation=0 (default), then all the random read queues
> should go in root group and there will be no service differentiation.

The test sets group_isolation=1 as part of its setup, as this is our
standard configuration.

> If you ran different random readers in different groups of differnet
> weight with group_isolation=1, then there is a case of having service
> differentiation. In that case we will idle for 8ms on each group before
> we expire the group. So in these test cases are low weight groups not
> submitting IO with-in 8ms? Putting a random reader in separate group
> with think time > 8, I think is going to hurt a lot because for every
> single IO dispatched group is going to weight for 8ms before it is
> expired.

You're right about the behavior of group_idle.  We have more
experience with earlier kernels (before group_idle).  With this patch
we are able to achieve isolation without group_idle even with these
large ratios.  (Without group_idle the random reader workloads will
get marked seeky, and idling is disabled.  Without group_idle, we have
to remember the vdisktime to get isolation.)

> Can you run blktrace and verify what's happenig?

I can run a blktrace, and I think it will show what you expect.

Chad
