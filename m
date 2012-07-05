Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab2GEJn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 05:43:58 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42700 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028Ab2GEJn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 05:43:56 -0400
Date: Thu, 5 Jul 2012 19:13:48 +0930
From: Alan Modra <amodra@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20120705094348.GA5805@bubble.grove.modra.org>
References: <20120705183345.ee84ec1048a19aa1c7129578@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120705183345.ee84ec1048a19aa1c7129578@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 06:33:45PM +1000, Stephen Rothwell wrote:
> powerpc64-linux-ld: drivers/built-in.o: In function `.gpiochip_is_requested':
> (.text+0x4): sibling call optimization to `_savegpr0_29' does not allow automatic multiple TOCs; recompile with -mminimal-toc or -fno-optimize-sibling-calls, or make `_savegpr0_29' extern
> 
> I got more than 60000 of these messages before I killed the link. :-(  I
> am not sure what has changed to do this, but it may have been masked for
> the past few releases due to other linking problems.

Let me guess.  You're using bleeding edge gcc but not binutils.

a) Recent gcc has fixed prologue and epilogue generation which now
   properly makes use of out-of-line register save and restore
   functions when compiling with -Os.
b) Recent ld doesn't emit out-of-line save/restore function for ld -r,
   but yours does.  You need my 2012-06-22 patch.
c) Kernel uses ld -r for packaging.

(b) and (c) together mean you get a definition for _savegpr0_29 munged
together with other functions.  That's bad.  If _savegpr0_29 wasn't
emitted until the final link stage then it would be in a code section
containing just save/restore functions.  ld will analyse that section
and notice the absense of toc relocations; functions therein don't
use the toc and can thus be called from any toc group without needing
a toc adjusting stub.  In your case _savegpr0_29 is in a section that
has toc relocations (from normal compiled code), so ld decides that
any function in that section must have a proper value for the toc
register.  But calls to _savegpr0_29 don't have a following nop to
overwrite with a toc restore insn, hence the ld error.

Score another black mark for ld -r.

-- 
Alan Modra
Australia Development Lab, IBM
