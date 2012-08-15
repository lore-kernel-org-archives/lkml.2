Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab2HOJK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 05:10:58 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59078 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751081Ab2HOJK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 05:10:57 -0400
Date: Wed, 15 Aug 2012 10:10:29 +0100
From: Will Deacon <will.deacon@arm.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nico@linaro.org>,
        Shan Kang <kangshan0910@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [ 10/65] ARM: 7467/1: mutex: use generic xchg-based
 implementation for ARMv6+
Message-ID: <20120815091028.GA29154@mudshark.cambridge.arm.com>
References: <20120813221414.965154048@linuxfoundation.org>
 <20120813221415.872342783@linuxfoundation.org>
 <1345004966.824.214.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345004966.824.214.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Wed, Aug 15, 2012 at 05:29:26AM +0100, Ben Hutchings wrote:
> On Mon, 2012-08-13 at 15:13 -0700, Greg Kroah-Hartman wrote:
> > From: Greg KH <gregkh@linuxfoundation.org>
> > 
> > 3.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Will Deacon <will.deacon@arm.com>
> > 
> > commit a76d7bd96d65fa5119adba97e1b58d95f2e78829 upstream.
> > 
> > The open-coded mutex implementation for ARMv6+ cores suffers from a
> > severe lack of barriers, so in the uncontended case we don't actually
> > protect any accesses performed during the critical section.
> > 
> > Furthermore, the code is largely a duplication of the ARMv6+ atomic_dec
> > code but optimised to remove a branch instruction, as the mutex fastpath
> > was previously inlined. Now that this is executed out-of-line, we can
> > reuse the atomic access code for the locking (in fact, we use the xchg
> > code as this produces shorter critical sections).
> > 
> > This patch uses the generic xchg based implementation for mutexes on
> > ARMv6+, which introduces barriers to the lock/unlock operations and also
> > has the benefit of removing a fair amount of inline assembly code.
> [...]
> 
> I understand that a further fix is needed on top of this
> <http://article.gmane.org/gmane.linux.ports.arm.kernel/181693> but it's
> not in Linus's tree yet.  Is it better to apply this on its own or to
> wait for the complete fix?

The additional patch should also be CC'd to stable and is sitting in -tip
somewhere I believe, so it shouldn't be long before it does hit mainline.

Without this patch there's a memory-ordering bug (which we seem to have hit
once in > 5 years). With the patch there's a mutex lockup issue on SMP systems
that I can provoke with enough hackbenching, so you may want to hold off for
now.

Will
