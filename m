Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab1EWJcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 05:32:21 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39032 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab1EWJcT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 05:32:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Octavian Purdila <tavi@cs.pub.ro>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [v3 00/39] faster tree-based sysctl implementation
References: <BANLkTim7xn8tM4wTyd_m_nwUQg_CUTapeA@mail.gmail.com>
	<m14o4mavod.fsf@fess.ebiederm.org>
	<BANLkTinqX_=TLU3TuKJFFTJBBxm1scZ3Ew@mail.gmail.com>
Date: Mon, 23 May 2011 02:32:13 -0700
In-Reply-To: <BANLkTinqX_=TLU3TuKJFFTJBBxm1scZ3Ew@mail.gmail.com> (Lucian
	Adrian Grijincu's message of "Mon, 23 May 2011 09:37:35 +0300")
Message-ID: <m1mxid7of6.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19PUzmCh2dkCLwfTZ3VmOLjS4p2ktFp4LQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucian Adrian Grijincu <lucian.grijincu@gmail.com> writes:

> On Mon, May 23, 2011 at 7:27 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> This patchset looks like it is deserving of some close scrutiny, and
>> not just the high level design overview I have given the previous
>> patches.  This is going to be a busy week for me so I probably won't
>> get through all of the patches for a while.
>
>
> I have one more question. The current implementation uses a single
> sysctl_lock to synchronize all changes to the data structures.
>
> In my algorithm I change a few places to use a per-header read-write
> lock. Even though the code is organized to handle a per-header rwlock,
> the implementation uses a single global rwlock. In v2 I got rid of the
> rwlock and replaced the subdirs/files regular lists with rcu-protected
> lists and that's why I did not bother giving each header a rwlock.
>
>
> I have no idea how to use rcu with rbtree. Should I now give each
> header it's own lock to reduce contention?

I would only walk down that path if we can find some profile data
showing that the lock is where we are hot.

> I'm asking this because I don't know why the only is a global sysctl
> spin lock, when multiple locks could have been used, each to protect
> it's own domain of values.

Mostly it is simplicity.  There is also the fact that the spin lock is
used in the implementation of something that is essentially a
reader/writer lock already.

With the help of the reference counts we block when we are unregistering
until there are no more users.

In that context I'm not certain I am comfortable with separating proc
inode usage from other proc usage. But I haven't read through that
section of your code well enough yet to tell if you are making sense.

One of the things that would be very nice to do is add lockdep
annotations like I have to sysfs_activate and sysfs_deactivate, so we
can catch the all too common case of someone unregistering a sysctl
table when there are problems.

Personally I'm not happy with the state of the locking abstractions in
sysctl today.  It is all much too obscure, and there are too few
warnings.  However for your set of changes I think the thing to focus
on is getting sysctl to better data structures so that it can scale.

Once the data structures are simple enough any remaining issues should
be fixable with small straight forward patches.

Eric
