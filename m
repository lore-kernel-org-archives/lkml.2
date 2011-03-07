Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab1CGXmP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 18:42:15 -0500
Received: from smtp-out.google.com ([216.239.44.51]:40028 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741Ab1CGXmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:42:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Xtdk4LKT/CKERdnrt7h8uvhoxRdtF22f0NXCv1l4qwIKxtqpEjCf81vyYv7gkVWPs6
         8pRMKF0mWQ/q07phw1lA==
MIME-Version: 1.0
In-Reply-To: <4D75447E.1080902@kernel.dk>
References: <AANLkTinXa4Zjg0zGbPQRZQi2QW_-0y+PBzQwcdjPLVKZ@mail.gmail.com>
 <20110301142002.GB25699@redhat.com> <4D6F0ED0.80804@kernel.dk>
 <AANLkTin+TycqQxWGyxWOsuT+WOaEA0XhqFkJBMKe7-uY@mail.gmail.com>
 <4D753488.6090808@kernel.dk> <20110307202432.GH9540@redhat.com>
 <4D7540F6.3080303@kernel.dk> <20110307204651.GK9540@redhat.com> <4D75447E.1080902@kernel.dk>
From: Justin TerAvest <teravest@google.com>
Date: Mon, 7 Mar 2011 15:41:50 -0800
Message-ID: <AANLkTimtem6ny_gpsNqXrCiGe-2jgW3Y_0dBk5HxuN15@mail.gmail.com>
Subject: Re: RFC: default group_isolation to 1, remove option
To: Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>, Chad Talbott <ctalbott@google.com>,
        Nauman Rafique <nauman@google.com>, Divyesh Shah <dpshah@google.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Corrado Zoccolo <czoccolo@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 7, 2011 at 12:47 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2011-03-07 21:46, Vivek Goyal wrote:
>> On Mon, Mar 07, 2011 at 09:32:54PM +0100, Jens Axboe wrote:
>>
>> [..]
>>>> So given then fact that per-ioc-per-disk accounting of request descriptors
>>>> makes the accounting complicated and also makes it hard for block IO
>>>> controller to use it, the other approach of implementing per group limit
>>>> and per-group-per-bdi congested might be reasonable. Having said that, the
>>>> patch I had written for per group descritor was also not necessarily very
>>>> simple.
>>>
>>> So before all of this gets over designed a lot... If we get rid of the
>>> one remaining direct buffered writeback in bdp(), then only the flusher
>>> threads should be sending huge amounts of IO. So if we attack the
>>> problem from that end instead, have it do that accounting in the bdi.
>>> With that in place, I'm fairly confident that we can remove the request
>>> limits.
>>>
>>> Basically just replace the congestion_wait() in there with a bit of
>>> accounting logic. Since it's per bdi anyway, we don't even have to
>>> maintain that state in the bdi itself. It can remain in the thread
>>> stack.
>>
>> Moving the accounting up sounds interesting. For cgroup stuff we again
>> shall have to do something additional like having per cgroup per bdi
>> flusher threads or mainting the number of pending IO per group and not
>> flusher thread does not submitting IOs for groups which have lots of
>> pending IOs (to avoid faster group getting blocked behind slower one).
>
> So since there are at least two use cases, we could easily provide
> helpers to do that sort of blocking to not throw too much work at it.
>
> I think we are making progress :-)

This generally sounds good to me, though I didn't think per-cgroup limits
were terribly complicated.

I wanted to make a quick note-- it sounds like part of the intent here is to
avoid doing any page tracking in the page_cgroup structure, but I think that
we will inevitably have to do some tracking there for css ids, to provide
isolation between buffered writers. I'd like to send out a patchset soon
to track buffered writers, but we should probably work out the request
descriptor limits first.


>
> --
> Jens Axboe
>
>
