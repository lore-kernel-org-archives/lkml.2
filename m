Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759206Ab1DNPxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:53:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57661 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759095Ab1DNPxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 11:53:33 -0400
MIME-Version: 1.0
In-Reply-To: <fs-unreg-rcu@mdm.bga.com>
References: <4DA48AF4.5080803@teksavvy.com> <20110413004938.GE3682@thunk.org>
 <4DA5ADA6.5060301@teksavvy.com> <5A35771F-49B6-491E-B012-DBE68907E382@mit.edu>
 <ext4-masq@mdm.bga.com> <fs-unreg-rcu@mdm.bga.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 14 Apr 2011 08:52:43 -0700
Message-ID: <BANLkTi=Tt8HRmqODM_qPAbGMeQ9UvVDXfA@mail.gmail.com>
Subject: Re: [PATCH] fs: synchronize_rcu when unregister_filesystem success
 not failure
To: Milton Miller <miltonm@bga.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 8:41 AM, Milton Miller <miltonm@bga.com> wrote:
>
> While checking unregister_filesystem for saftey vs extra calls for
> "ext4: register ext2 and ext3 alias after ext4" I realized that
> the synchronize_rcu() was called on the error path but not on
> the success path.

Good catch.

I think this is the bug that then caused us to do commit d863b50ab013
("vfs: call rcu_barrier after ->kill_sb()")

That said, that commit says that "synchronize_rcu()" isn't enough, and
uses rcu_barrier().

Which _should_ mean that there are no actual users that care about RCU
events by the time you actually hit "unregister_filesystem()".

So I think your patch is correct, but won't actually matter. But maybe
I'm missing something.

> Should we call it in both?

No, I think the success path is the one that would matter.

Comments?

                              Linus
