Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014Ab2JYSD0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 14:03:26 -0400
Received: from mail.lang.hm ([64.81.33.126]:34476 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759899Ab2JYSDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 14:03:24 -0400
Date: Thu, 25 Oct 2012 11:03:13 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Theodore Ts'o" <tytso@mit.edu>
cc: Nico Williams <nico@cryptonector.com>,
        General Discussion of SQLite Database 
	<sqlite-users@sqlite.org>,
        =?GB2312?Q?=D1=EE=CB=D5=C1=A2_Yang_Su_Li?= <suli@cs.wisc.edu>,
        linux-fsdevel@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>, drh@hwaci.com
Subject: Re: [sqlite] light weight write barriers
In-Reply-To: <20121025140327.GB13562@thunk.org>
Message-ID: <alpine.DEB.2.02.1210251048280.8519@asgard.lang.hm>
References: <m2fw5mtffg.fsf_-_@firstfloor.org> <CABK4GYNKF6LCgsQ5SN+dATtRm-0Qh_QmNdqZqZcj6S98z+ofXg@mail.gmail.com> <5086F5A7.9090406@vlnb.net> <CAK3OfOjYgTQBeCh1SucYw=Vriw6W3qaygwmiRmude0oAYhcaxg@mail.gmail.com> <alpine.DEB.2.02.1210241447210.8519@asgard.lang.hm>
 <CAK3OfOh4MEq5PwW5xk07d4fDZi64tF-vgCKYOuA3oq=9PLwyUQ@mail.gmail.com> <alpine.DEB.2.02.1210241748180.8519@asgard.lang.hm> <CAK3OfOjtH9qVghb6+33HSb8+dPZVexLC9Z5XO1KKvjoTYiYp4A@mail.gmail.com> <20121025060231.GC9860@thunk.org> <alpine.DEB.2.02.1210242331060.31862@asgard.lang.hm>
 <20121025140327.GB13562@thunk.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2012, Theodore Ts'o wrote:

> Or does rsyslog *really* need to issue an fsync after each log
> message?  Or could it batch updates so that every N seconds, it
> flushes writes to the disk?

In part this depends on how paranoid the admin is. By default rsyslog 
doesn't do fsyncs, but admins can configure it to do so and can configure 
the batch size.

However, what I'm talking about here is not normal message traffic, it's 
the case where the admin has decided that they don't want to use the 
normal inmemory queues, they want to have the queues be on disk so that if 
the system crashes the queued data will still be there to be processed 
after the crash (In addition, this can get used to cover cases where you 
want queue sizes larger than your available RAM)

In this case, the extreme, and only at the explicit direction of the 
admin, is to fsync after every message.

The norm is that it's acceptable to loose the last few messages, but 
loosing a chunk out of the middle of the queue file can cause a whole lot 
more to be lost, passing the threshold of acceptable.

> Sometimes, the answer is not to try to create exotic database like
> functionality in the file system --- the answer is to be more
> intelligent at the application leyer.  Not only will the application
> be more portable, it will also in the end be more efficient, since
> even with the most exotic database technologies, the most efficient
> transactional commit is the unneeded commit that you optimize away at
> the application layer.

I agree, this is why I'm trying to figure out the recommended way to do 
this without needing to do full commits.

Since in most cases it's acceptable to loose the last few chunks written, 
if we had some way of specifying ordering, without having to specify 
"write this NOW", the solution would be pretty obvious.

David Lang
