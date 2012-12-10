Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab2LJTMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 14:12:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab2LJTMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 14:12:22 -0500
Date: Mon, 10 Dec 2012 20:12:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] uprobes: Kill the pointless inode/uc checks in
	register/unregister
Message-ID: <20121210191232.GA32462@redhat.com>
References: <20121123202741.GA18858@redhat.com> <20121123202806.GA18887@redhat.com> <20121210061901.GF22164@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121210061901.GF22164@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2012-11-23 21:28:06]:
>
> > register/unregister verifies that inode/uc != NULL. For what?
> > This really looks like "hide the potential problem", the caller
> > should pass the valid data.
> >
>
> Agree that users should pass valid data.
> I do understand that we expect the users to be knowledge-able.
> Also users are routed thro in-kernel api that does this check.
>
> However from an api perspective, if a user passes invalid data, do we
> want the system to crash.
>
> Esp if kernel can identify that users has indeed passed wrong info. I do agree
> that users can still pass invalid data that kernel maynot be able to
> identify in most cases.

inode != NULL can't verify that it actually points to the valid inode,
NULL is only one example of invalid data.

I agree, sometimes it makes sense to protect against the stupid mistakes,
but if we want to check against NULL we should do

	if (WARN_ON(!inode))
		return;

Especially in uprobe_unregister(). The current code is really "hide
the possible problem" and nothing more. It is better to crash imho
than silently return.

> > register() also checks uc->next == NULL, probably to prevent the
> > double-register but the caller can do other stupid/wrong things.
>
> Users can surely do more stupid things. But this is again something that
> kernel can identify. By allowing a double-register of a consumer, thats
> already registered, we might end up allowing circular loop of consumers.

I understand. But in this case we should document that uc->next must
be cleared before uprobe_register(). Or add init_consumer().

And we should change uprobe_unregister() to clear uc->next as well.
I think that the code like this

	uprobe_register(uc);
	uprobe_unregister(uc);

	uprobe_register(uc);

should work. Currently it doesn't because of this check.


So I still think these checks are pointless and (at least in unregister)
even harmful.

But I won't insist too much, I can drop this patch if you do not change
your mind.

Oleg.

