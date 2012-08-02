Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab2HBLpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 07:45:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59027 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890Ab2HBLpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 07:45:22 -0400
Date: Thu, 2 Aug 2012 13:45:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] parisc: fix personality flag check in copy_thread()
In-Reply-To: <1343897272.5073.5.camel@dabdike.int.hansenpartnership.com>
Message-ID: <alpine.LNX.2.00.1208021342120.4820@pobox.suse.cz>
References: <alpine.LNX.2.00.1208012155330.14910@pobox.suse.cz>  <alpine.LNX.2.00.1208020911300.14910@pobox.suse.cz> <1343897272.5073.5.camel@dabdike.int.hansenpartnership.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2012, James Bottomley wrote:

> > Directly comparing task_struct->personality against PER_* is not fully
> > correct, as it doesn't take flags potentially stored in top three bytes
> > into account.
> > 
> > Analogically, directly forcefully setting personality to PER_LINUX32 or
> > PER_LINUX discards any flags stored in the top three bytes.
> > 
> > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > ---
> > 
> > changed since v1: fix the bit ops to reflect the fact that PER_LINUX is 
> > actually 0
> 
> Tell me what you're trying to achieve (or what problem you're trying to
> solve), because personality is notoriously tricky.

Long story short -- I was debugging a problem where 'setarch --uname-2.6' 
would not work on s390 on (older) 3.x kernel. Turned out to be a 
corruption of top bytes of personality across exec() on s390.

I was doing quite some over-the-tree grepping during this, and found out 
that at least parisc, powerpc and sparc64 (davem already queued my patch 
for this) would under some silently ignore discard the top bytes of 
personality flags passed to sys_personality().

In case of parsic, let's take a process with current->personality == 
PER_LINUX32 callling personality(PER_LINUX | UNAME26). The

        if (personality(current->personality) == PER_LINUX32
            && personality == PER_LINUX)
                personality = PER_LINUX32;

would that have no effect, and sys_personality() would be called with 
(PER_LINUX | UNAME26) instead of PER_LINUX32, just because of UNAME26 
being set as well. That doesn't seem really correct. Is it?

-- 
Jiri Kosina
SUSE Labs
