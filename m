Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab2HBNHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 09:07:06 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38853 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750974Ab2HBNHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 09:07:04 -0400
Message-ID: <1343912818.5073.48.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH v2] parisc: fix personality flag check in copy_thread()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 02 Aug 2012 14:06:58 +0100
In-Reply-To: <alpine.LNX.2.00.1208021342120.4820@pobox.suse.cz>
References: <alpine.LNX.2.00.1208012155330.14910@pobox.suse.cz>
	  <alpine.LNX.2.00.1208020911300.14910@pobox.suse.cz>
	 <1343897272.5073.5.camel@dabdike.int.hansenpartnership.com>
	 <alpine.LNX.2.00.1208021342120.4820@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-02 at 13:45 +0200, Jiri Kosina wrote:
> On Thu, 2 Aug 2012, James Bottomley wrote:
> 
> > > Directly comparing task_struct->personality against PER_* is not fully
> > > correct, as it doesn't take flags potentially stored in top three bytes
> > > into account.
> > > 
> > > Analogically, directly forcefully setting personality to PER_LINUX32 or
> > > PER_LINUX discards any flags stored in the top three bytes.
> > > 
> > > Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> > > ---
> > > 
> > > changed since v1: fix the bit ops to reflect the fact that PER_LINUX is 
> > > actually 0
> > 
> > Tell me what you're trying to achieve (or what problem you're trying to
> > solve), because personality is notoriously tricky.
> 
> Long story short -- I was debugging a problem where 'setarch --uname-2.6' 
> would not work on s390 on (older) 3.x kernel. Turned out to be a 
> corruption of top bytes of personality across exec() on s390.
> 
> I was doing quite some over-the-tree grepping during this, and found out 
> that at least parisc, powerpc and sparc64 (davem already queued my patch 
> for this) would under some silently ignore discard the top bytes of 
> personality flags passed to sys_personality().
> 
> In case of parsic, let's take a process with current->personality == 
> PER_LINUX32 callling personality(PER_LINUX | UNAME26). The
> 
>         if (personality(current->personality) == PER_LINUX32
>             && personality == PER_LINUX)
>                 personality = PER_LINUX32;
> 
> would that have no effect, and sys_personality() would be called with 
> (PER_LINUX | UNAME26) instead of PER_LINUX32, just because of UNAME26 
> being set as well. That doesn't seem really correct. Is it?

Heh, no.  This is a nasty mess.  Our assumption was that we own the
flags ... hence the code.  There are some flags we can't allow to be set
or reset ... but that's only for the mythical 64 bit userspace, so I
suppose we just ignore that for now and fix it if this ever appears.

I don't like the hidden assumption that PER_LINUX == 0, but otherwise
the code looks fine.

How about 

personality = (personality & ~PER_MASK) | PER_LINUX32;

and

err = (personality & ~PER_MASK) | PER_LINUX;

James



