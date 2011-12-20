Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab1LTOGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 09:06:46 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36016 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab1LTOGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 09:06:40 -0500
Date: Tue, 20 Dec 2011 14:06:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: mc@linux.vnet.ibm.com, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>, david@fromorbit.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] VFS: br_write_lock locks on possible CPUs other than
 online CPUs
Message-ID: <20111220140628.GD23916@ZenIV.linux.org.uk>
References: <20111219121100.GI2203@ZenIV.linux.org.uk>
 <4EEF9D4E.1000008@linux.vnet.ibm.com>
 <20111219205251.GK2203@ZenIV.linux.org.uk>
 <4EF01565.2000700@linux.vnet.ibm.com>
 <20111220062710.GC23916@ZenIV.linux.org.uk>
 <4EF03915.60902@linux.vnet.ibm.com>
 <1324373854.21588.16.camel@mengcong>
 <4EF0654B.4060904@linux.vnet.ibm.com>
 <4EF06C9B.4010703@linux.vnet.ibm.com>
 <4EF084A4.3000106@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF084A4.3000106@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 06:20:44PM +0530, Srivatsa S. Bhat wrote:

> > Hey, actually there is a simple solution: just nip it (or rather delay it)
> > in the bud ;) That is, we watch out for CPU_UP_PREPARE event and lock it
> > up there itself using our spinlock.. that way, that cpu will not come up
> > until we are done executing br_write_unlock(). In fact, we can even fail
> > the onlining of that cpu by returning appropriate value from our callback,
> > but that would be too harsh.. so we can settle for delaying the cpu online

Eeeek...  Are you serious about leaving a spinlock grabbed by notifier
callback and not released until another callback call?  That would be one
hell of a constraint on what these notifiers can do - _nothing_ between
these calls (including other notifier callbacks, etc.) would be allowed
to block.

That sounds extremely brittle...
