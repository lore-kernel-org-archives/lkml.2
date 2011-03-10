Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab1CJS6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 13:58:21 -0500
Received: from smtp-out.google.com ([74.125.121.67]:61511 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab1CJS6S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 13:58:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=qRlXRJijiDg2eFcycdlDiB3015dKkBN/UcOhW2rbLMcOlUIZN9oq5ZgAJoA63pnf1Z
         pQxJ7WLIz7sh9YJrOuiw==
MIME-Version: 1.0
In-Reply-To: <20110310181529.GF29464@redhat.com>
References: <1299619256-12661-1-git-send-email-teravest@google.com>
 <20110309142237.6ab82523.kamezawa.hiroyu@jp.fujitsu.com> <AANLkTimRRAEp75CfyJFxU-5wOYfety6gjq=msZf0Wp8P@mail.gmail.com>
 <20110310181529.GF29464@redhat.com>
From: Justin TerAvest <teravest@google.com>
Date: Thu, 10 Mar 2011 10:57:52 -0800
Message-ID: <AANLkTi=LL6JEwOcZfSsapYn-isA3RBrV8kPq8EK6va8=@mail.gmail.com>
Subject: Re: [RFC] [PATCH 0/6] Provide cgroup isolation for buffered writes.
To: Vivek Goyal <vgoyal@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, m-ikeda@ds.jp.nec.com,
        jaxboe@fusionio.com, linux-kernel@vger.kernel.org, ryov@valinux.co.jp,
        taka@valinux.co.jp, righi.andrea@gmail.com, guijianfeng@cn.fujitsu.com,
        balbir@linux.vnet.ibm.com, ctalbott@google.com, nauman@google.com,
        mrubin@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 10:15 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Mar 10, 2011 at 10:08:03AM -0800, Justin TerAvest wrote:
>
> [..]
>> > I don't like to increase size of page_cgroup but I think you can record
>> > information without increasing size of page_cgroup.
>> >
>> > A) As Andrea did, encode it to pc->flags.
>> >   But I'm afraid that there is a racy case because memory cgroup uses some
>> >   test_and_set() bits.
>> > B) I wonder why the information cannot be recorded in page->private.
>> >   When page has buffers, you can record the information to buffer struct.
>> >   About swapio (if you take care of), you can record information to bio.
>>
>> Hi Kame,
>>
>> I'm concerned that by using something like buffer_heads stored in
>> page->private, we will only be supported on some filesystems and not
>> others. In addition, I'm not sure if all filesystems attach buffer
>> heads at the same time; if page->private is modified in the flusher
>> thread, we might not be able to determine the thread that dirtied the
>> page in the first place.
>
> I think the person who dirtied the page can store the information in
> page->private (assuming buffer heads were not generated) and if flusher
> thread later ends up generating buffer heads and ends up modifying
> page->private, this can be copied in buffer heads?

This scares me a bit.

As I understand it, fs/ code expects total ownership of page->private.
This adds a responsibility for every user to copy the data through and
store it in the buffer head (or anything else). btrfs seems to do
something entirely different in some cases and store a different kind
of value.

I don't know that it's right to add the burden to copy the original
value to everything that wants to use page->private.

>
> Thanks
> Vivek
>
