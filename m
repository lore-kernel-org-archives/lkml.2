Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821Ab1ALDz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 22:55:26 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47134 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab1ALDzW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 22:55:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=p3Zct6WT8hoYkJE9zh/xJmFpIO501OQ9XCKJ+DMbc9kGTDcluPh0TwvmK47koXyLXz
         3kmDxH2QPf6RL7oo4N+we8NG5NvVpUXiOwMjSm50bSMUe3p14iWMy412Iy9tGDYBY+uq
         3GBvWZGuvL4HkmgE+5WFZwY3MxZ0whZlCIX0s=
MIME-Version: 1.0
In-Reply-To: <AANLkTikomwroDXYmtA1crJeEdcpo_T1-g=O1zhHie4sC@mail.gmail.com>
References: <20110107075831.GA14915@amd>
	<1294763679.2435.72.camel@doink>
	<AANLkTin67OXYYKk6y+_MKfXEXBz-F_+qAH0cpiJ24yEQ@mail.gmail.com>
	<1294768668.2435.177.camel@doink>
	<AANLkTikomwroDXYmtA1crJeEdcpo_T1-g=O1zhHie4sC@mail.gmail.com>
Date: Wed, 12 Jan 2011 14:55:20 +1100
Message-ID: <AANLkTi=e29v7qSRHv=5=eeujOJGbSWszYAnpWhvPZeVh@mail.gmail.com>
Subject: Re: [announce] vfs-scale git tree update
From: Nick Piggin <npiggin@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: aelder@sgi.com, Ian Kent <raven@themaw.net>,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 5:13 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> [ Added Ian to cc - the BUG_ON() in d_set_d_op() triggers on autofs4,
> see lkml thread for more details if you care ]
>
> On Tue, Jan 11, 2011 at 9:57 AM, Alex Elder <aelder@sgi.com> wrote:
>>
>> Looking at it quickly, I don't think that would matter for
>> the case at hand.  I.e., that might be safer but it doesn't
>> address the fact that these fields are getting initialized
>> multiple times.
>
> You're right - without looking closer or thinking about it any more, I
> was thinking mkdir etc would create the new dentry, but it can easily
> be a pre-existing negative one. So it's not like mkdir is always going
> to be something new that can just be initialized.
>
> So yeah, no race or anything like that required - just regular acceses.
>
> That said, if we make sure that the d_op gets cleared (or the dentry
> dropped) when something turns negative, and a negative lookup never
> sets d_op, it should all basically work.
>
> Can you figure out the exact sequence that causes this? Is it enough
> to just mount something once?

Doh, sorry I probably didn't re-test autofs4 since putting that BUG_ON
in there. Now it's trivial to revert the d_set_d_op function to the same
raciness that was "allowed" before (simply by resetting the d_flags bits).
There is no new fundamental race that the patch introduced there...
But I think it is much cleaner to just fix up all filesystems, and will
potentially close obscure races.

Often the best way is to just set the same d_ops for negative and
positive dentries, and have the operations handle both cases.

Ian?
