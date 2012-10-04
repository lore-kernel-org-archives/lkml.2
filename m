Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab2JDXbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 19:31:07 -0400
Received: from 1wt.eu ([62.212.114.60]:35934 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755580Ab2JDXbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 19:31:05 -0400
Date: Fri, 5 Oct 2012 01:27:37 +0200
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 133/180] cciss: fix incorrect scsi status reporting
Message-ID: <20121004232737.GA16406@1wt.eu>
References: <6a854f579a99b4fe2efaca1057e8ae22@local> <20121001225203.249985461@1wt.eu> <20121004224950.GL13292@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004224950.GL13292@decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 11:49:50PM +0100, Ben Hutchings wrote:
> On Tue, Oct 02, 2012 at 12:54:10AM +0200, Willy Tarreau wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> > 
> > commit b0cf0b118c90477d1a6811f2cd2307f6a5578362 upstream.
> > 
> > Delete code which sets SCSI status incorrectly as it's already been set
> > correctly above this incorrect code.  The bug was introduced in 2009 by
> > commit b0e15f6db111 ("cciss: fix typo that causes scsi status to be
> > lost.")
> 
> That commit was in 2.6.33 and it changed the '<' to '<<'.  It hasn't
> been backported to 2.6.32.y.

But apparently the status was already incorrect before the first patch
which tried to fix it first. I based myself on the comment from this
patch which says "it's already been set correctly above this incorrect code".

Above we find this :
        cmd->result = (DID_OK << 16);           /* host byte */
        cmd->result |= (COMMAND_COMPLETE << 8); /* msg byte */
        /* cmd->result |= (GOOD < 1); */                /* status byte */

        cmd->result |= (ei->ScsiStatus);

If such a status is valid, then I conclude that both the following forms
from the two previous versions are incorrect :

-       cmd->result |= (ei->ScsiStatus < 1);
+       cmd->result |= (ei->ScsiStatus << 1);

Hence I preferred to backport the fix and have the same code as in mainline
and newer versions which nobody has yet complained about.

> > -					cmd->result |= (ei->ScsiStatus < 1);
> [...]
> 
> Unless ei->ScsiStatus can be negative (it is declared as int, but
> I don't think it's actually meant to be negative), this statement
> is a no-op.

Hmmm I disagree here, the code above does exactly the same thing as :

        cmd->result |= !ei->ScsiStatus;

Which looks kind of strange to me after doing the exact opposite above,
since the result is that the lowest bit of cmd->result will always be
forced to 1 whatever ScsiStatus between 0 and 1. This might be what the
original patch author meant with "fix typo that causes scsi status to
be lost".

So I'd rather keep this fix.

Regards,
Willy

