Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab1CJTLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 14:11:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27664 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752995Ab1CJTLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 14:11:34 -0500
Date: Thu, 10 Mar 2011 14:11:15 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Justin TerAvest <teravest@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, m-ikeda@ds.jp.nec.com,
        jaxboe@fusionio.com, linux-kernel@vger.kernel.org, ryov@valinux.co.jp,
        taka@valinux.co.jp, righi.andrea@gmail.com, guijianfeng@cn.fujitsu.com,
        balbir@linux.vnet.ibm.com, ctalbott@google.com, nauman@google.com,
        mrubin@google.com, linux-fsdevel@vger.kernel.org,
        Chris Mason <chris.mason@oracle.com>
Subject: [RFC] Storing cgroup id in page->private (Was: Re: [RFC] [PATCH 0/6]
 Provide cgroup isolation for buffered writes.)
Message-ID: <20110310191115.GG29464@redhat.com>
References: <1299619256-12661-1-git-send-email-teravest@google.com>
 <20110309142237.6ab82523.kamezawa.hiroyu@jp.fujitsu.com>
 <AANLkTimRRAEp75CfyJFxU-5wOYfety6gjq=msZf0Wp8P@mail.gmail.com>
 <20110310181529.GF29464@redhat.com>
 <AANLkTi=LL6JEwOcZfSsapYn-isA3RBrV8kPq8EK6va8=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=LL6JEwOcZfSsapYn-isA3RBrV8kPq8EK6va8=@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 10:57:52AM -0800, Justin TerAvest wrote:
> On Thu, Mar 10, 2011 at 10:15 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Thu, Mar 10, 2011 at 10:08:03AM -0800, Justin TerAvest wrote:
> >
> > [..]
> >> > I don't like to increase size of page_cgroup but I think you can record
> >> > information without increasing size of page_cgroup.
> >> >
> >> > A) As Andrea did, encode it to pc->flags.
> >> >   But I'm afraid that there is a racy case because memory cgroup uses some
> >> >   test_and_set() bits.
> >> > B) I wonder why the information cannot be recorded in page->private.
> >> >   When page has buffers, you can record the information to buffer struct.
> >> >   About swapio (if you take care of), you can record information to bio.
> >>
> >> Hi Kame,
> >>
> >> I'm concerned that by using something like buffer_heads stored in
> >> page->private, we will only be supported on some filesystems and not
> >> others. In addition, I'm not sure if all filesystems attach buffer
> >> heads at the same time; if page->private is modified in the flusher
> >> thread, we might not be able to determine the thread that dirtied the
> >> page in the first place.
> >
> > I think the person who dirtied the page can store the information in
> > page->private (assuming buffer heads were not generated) and if flusher
> > thread later ends up generating buffer heads and ends up modifying
> > page->private, this can be copied in buffer heads?
> 
> This scares me a bit.
> 
> As I understand it, fs/ code expects total ownership of page->private.
> This adds a responsibility for every user to copy the data through and
> store it in the buffer head (or anything else). btrfs seems to do
> something entirely different in some cases and store a different kind
> of value.

If filesystems are using page->private for some other purpose also, then
I guess we have issues. 

I am ccing linux-fsdevel to have some feedback on the idea of trying
to store cgroup id of page dirtying thread in page->private and/or buffer
head for tracking which group originally dirtied the page in IO controller
during writeback.

> 
> I don't know that it's right to add the burden to copy the original
> value to everything that wants to use page->private.
> 

How many such places are there?

Thanks
Vivek
