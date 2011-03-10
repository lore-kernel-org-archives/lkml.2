Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514Ab1CJVQ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 16:16:59 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:62134 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1CJVQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 16:16:57 -0500
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Justin TerAvest <teravest@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        m-ikeda <m-ikeda@ds.jp.nec.com>, jaxboe <jaxboe@fusionio.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, ryov <ryov@valinux.co.jp>,
        taka <taka@valinux.co.jp>, "righi.andrea" <righi.andrea@gmail.com>,
        guijianfeng <guijianfeng@cn.fujitsu.com>,
        balbir <balbir@linux.vnet.ibm.com>, ctalbott <ctalbott@google.com>,
        nauman <nauman@google.com>, mrubin <mrubin@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC] Storing cgroup id in page->private (Was: Re: [RFC] [PATCH 0/6] Provide cgroup isolation for buffered writes.)
In-reply-to: <20110310194106.GH29464@redhat.com>
References: <1299619256-12661-1-git-send-email-teravest@google.com> <20110309142237.6ab82523.kamezawa.hiroyu@jp.fujitsu.com> <AANLkTimRRAEp75CfyJFxU-5wOYfety6gjq=msZf0Wp8P@mail.gmail.com> <20110310181529.GF29464@redhat.com> <AANLkTi=LL6JEwOcZfSsapYn-isA3RBrV8kPq8EK6va8=@mail.gmail.com> <20110310191115.GG29464@redhat.com> <20110310194106.GH29464@redhat.com>
Date: Thu, 10 Mar 2011 16:15:39 -0500
Message-Id: <1299791640-sup-1874@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D793FA9.00D5,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Vivek Goyal's message of 2011-03-10 14:41:06 -0500:
> On Thu, Mar 10, 2011 at 02:11:15PM -0500, Vivek Goyal wrote:
> > On Thu, Mar 10, 2011 at 10:57:52AM -0800, Justin TerAvest wrote:
> > > On Thu, Mar 10, 2011 at 10:15 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > On Thu, Mar 10, 2011 at 10:08:03AM -0800, Justin TerAvest wrote:
> > > >
> > > > [..]
> > > >> > I don't like to increase size of page_cgroup but I think you can record
> > > >> > information without increasing size of page_cgroup.
> > > >> >
> > > >> > A) As Andrea did, encode it to pc->flags.
> > > >> >   But I'm afraid that there is a racy case because memory cgroup uses some
> > > >> >   test_and_set() bits.
> > > >> > B) I wonder why the information cannot be recorded in page->private.
> > > >> >   When page has buffers, you can record the information to buffer struct.
> > > >> >   About swapio (if you take care of), you can record information to bio.
> > > >>
> > > >> Hi Kame,
> > > >>
> > > >> I'm concerned that by using something like buffer_heads stored in
> > > >> page->private, we will only be supported on some filesystems and not
> > > >> others. In addition, I'm not sure if all filesystems attach buffer
> > > >> heads at the same time; if page->private is modified in the flusher
> > > >> thread, we might not be able to determine the thread that dirtied the
> > > >> page in the first place.
> > > >
> > > > I think the person who dirtied the page can store the information in
> > > > page->private (assuming buffer heads were not generated) and if flusher
> > > > thread later ends up generating buffer heads and ends up modifying
> > > > page->private, this can be copied in buffer heads?
> > > 
> > > This scares me a bit.
> > > 
> > > As I understand it, fs/ code expects total ownership of page->private.
> > > This adds a responsibility for every user to copy the data through and
> > > store it in the buffer head (or anything else). btrfs seems to do
> > > something entirely different in some cases and store a different kind
> > > of value.
> > 
> > If filesystems are using page->private for some other purpose also, then
> > I guess we have issues. 
> > 
> > I am ccing linux-fsdevel to have some feedback on the idea of trying
> > to store cgroup id of page dirtying thread in page->private and/or buffer
> > head for tracking which group originally dirtied the page in IO controller
> > during writeback.
> 
> A quick "grep" showed that btrfs, ceph and logfs are using page->private
> for other purposes also.
> 
> I was under the impression that either page->private is null or it 
> points to buffer heads for the writeback case. So storing the info
> directly in either buffer head directly or first in page->private and
> then transferring it to buffer heads would have helped. 

Right, btrfs has its own uses for page->private, and we expect to own
it.  With a proper callback, the FS could store the extra information you
need in out own structs.

-chris
