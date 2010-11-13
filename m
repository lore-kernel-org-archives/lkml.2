Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab0KMCbR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 21:31:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750804Ab0KMCbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 21:31:14 -0500
MIME-Version: 1.0
In-Reply-To: <4CDDF34D.7080201@garzik.org>
References: <1289606118.3015.539.camel@mulgrave.site> <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com>
 <4CDDF1DB.1020707@garzik.org> <4CDDF34D.7080201@garzik.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 12 Nov 2010 18:30:25 -0800
Message-ID: <AANLkTi=DKT2xQfwF4jbYd_zgquUWgR1A16tscKWsLp_X@mail.gmail.com>
Subject: Re: [GIT PULL] SCSI queuecommand API change for 2.6.37-rc1
To: Jeff Garzik <jeff@garzik.org>
Cc: James Bottomley <James.Bottomley@suse.de>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 6:09 PM, Jeff Garzik <jeff@garzik.org> wrote:
>
> For the record, I prefer a rename to a prototype change.

I'm certainly ok with a rename in most cases, but in this case I think
the prototype change might be better:

 - adding something like a "lck" prefix (or postfix) to the function
pointer name is the logical thing to do, but it's only logical right
_now_. Once it all becomes historic and the normal way to do things,
rather than a flag-day issue, any name change is likely to just be
annoying.

   So then we' either have to plan to rename it back once all the
flag-day issues are over and everybody is convinced that things have
been converted both in and out of tree, or we'd have to live with an
odd "lock" thing. We've seen this issue before: now we've finally
gotten rid of the BKL, and what do we call our "ioctl()" function? We
call it "unlocked_ioctl". It still makes sense today because the BKL
is in fresh memory, but I already wince when I look at it.

 - it would add another line of change to each driver, just for the
name change. Maybe not a big deal, and maybe it means you could avoid
renaming the existing function instead (and add the "lck" postfix to
the new _wrapper_ function, since you need to change the line that
initializes things anyway)

 - in this case, I think the prototype would probably be improved by
passing in the Scsi_Host pointer. Both the caller and the callee _do_
need it, after all. So yes, it's an "artificial" change, but it's one
that doesn't make the code look worse.

But really, I don't care deeply. I think changing the name of the
"queuecommand" function in scsi_host_template (or whatever) is fine
too, and will certainly fix the "silently and happily compile even
non-converted code" problem too. That _is_ the more common way of
handling this, but as mentioned above, we've had issues with that
approach too. So whatever...

                           Linus
