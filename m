Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab2LHAPu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 19:15:50 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:50014 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683Ab2LHAPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 19:15:49 -0500
Date: Sat, 8 Dec 2012 00:15:45 +0000
From: Cong Ding <dinggnu@gmail.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] uio.c: solve memory leak
Message-ID: <20121208001544.GD6179@gmail.com>
References: <1354210800-27230-1-git-send-email-dinggnu@gmail.com>
 <20121130001304.GB2590@local>
 <CAM3j68q7LPJM1aUZbwHJkyive3UcRYwg-yF-O=UXmfsi98E6dA@mail.gmail.com>
 <CAM3j68pwEanEC3v=thNs=_95S4BqyXdCoi-kUZ06+-50X-+qGw@mail.gmail.com>
 <20121208001040.GC3786@local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121208001040.GC3786@local>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 08, 2012 at 01:10:40AM +0100, Hans J. Koch wrote:
> On Fri, Dec 07, 2012 at 12:02:11AM +0100, Cong Ding wrote:
> > ping Hans, did you have any comment on this?
> 
> Sounds right what you say. Is your patch v2 your final solution, or would
> you like to come up with v3?
> 
> Thanks a lot for your patience and your thorough analysis.
If you don't have more comment or objection, it would be the final version.

Thanks

- cong
> > On Fri, Nov 30, 2012 at 12:03 PM, Cong Ding <dinggnu@gmail.com> wrote:
> > > Hi Hans, I think the memory allocated with kzalloc is properly freed
> > > by calling kobject_put.
> > >
> > > I can give a simple explanation.
> > >
> > > 1)  when we call kobject_init, the parameter portio_attr_type is
> > > passed in. portio_attr_type includes a function pointer to
> > > portio_release, which releases the memory of portio.
> > >
> > > 2) when we call kobject_put, kref_put is called with the pointer of
> > > function kobject_release.
> > > 3) kref_put calls kref_sub, with the same pointer of function kobject_release.
> > > 4) and kref_put calls the function kboject_release if
> > > atomic_sub_and_test returns true
> > >
> > > 5) let's look at what kobject_release is. it calls kobject_cleanup,
> > > and kobject_cleanup calls t->release(kobj) where t->release is exactly
> > > the function we passed in through portio_init at step (1). so function
> > > portio_release is called, and the memory allocated with kzalloc is
> > > freed.
> > >
> > > If there are anything wrong in my analysis, please feel free to let me know.
> > >
> > > Personally, I suggest to add a function to create and release
> > > uio_portio, which is similar as kobject_create and kobject_put in file
> > > lib/kobject.c. In this way, it avoid other readers thinking the memory
> > > is not freed (and we should add some comments here). For example,
> > > uio_portio_create call kzalloc and kboject_init, and returns
> > > uio_portio, which is similar as function kobject_create; and
> > > uio_portio_release calls kobject_put to release the memory. And we do
> > > same thing for uio_map.
> > >
> > > The usage here is quite strange, but it works. If I write this
> > > function from zero, I will use a pointer to kobject in uio_portio
> > > struct instead of kobject struct itself. In this case I can call
> > > kobject_create instead of kobject_init, and then we do both
> > > kzalloc(uio_portio) and kfree(uio_portio) in the file uio.c.
> > >
> > > Best,
> > > Cong
> > >
> > > On Fri, Nov 30, 2012 at 1:13 AM, Hans J. Koch <hjk@hansjkoch.de> wrote:
> > >> There's still another bug: The memory allocated with kzalloc is
> > >> never freed.
> > 
