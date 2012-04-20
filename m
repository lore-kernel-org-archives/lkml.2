Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2DTTEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 15:04:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38988 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab2DTTEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 15:04:21 -0400
Date: Fri, 20 Apr 2012 20:04:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] situation with fput() locking (was Re: [PULL REQUEST] :
 ima-appraisal patches)
Message-ID: <20120420190418.GK6871@ZenIV.linux.org.uk>
References: <1334754302.2137.8.camel@falcor>
 <alpine.LRH.2.02.1204190101380.30151@tundra.namei.org>
 <1334772473.2137.22.camel@falcor>
 <20120418183938.GH6589@ZenIV.linux.org.uk>
 <1334865448.2429.35.camel@falcor>
 <20120420004303.GB6871@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1204201133340.1450@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1204201133340.1450@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 11:54:01AM -0700, Hugh Dickins wrote:
> I can see that the discussion has since moved on quite a way from here.
> 
> But it looks to me fairly easy for mm to stop doing fput() under mmap_sem.
> 
> That's already the case when exiting (no mmap_sem held), and shouldn't add
> observable cost when unmapping (we already work on a chain of vmas to be
> freed, and when unmapping that chain will usually just be of one: shouldn't
> matter to defer a final pass until after mmap_sem is dropped).  Unless I'm
> mistaken, the fput() buried in vma_adjust() can never be a final fput.
> 
> Is it worth my trying to implement that?  Or do you see an immediate
> gotcha that I'm missing?  Or are you happy enough with your deferred
> fput() ideas, that it would be a waste of time to rearrange the mm end?

Deferring the final pass after dropping ->mmap_sem is going to be
interesting; what would protect ->vm_next on those suckers?  Locking
rules are already bloody complicated in mm/*; this will only add more
subtle fun.  Note that right now both the dissolution of ->vm_next
list and freeing of VMAs happen under ->mmap_sem; changing that might
cost us a lot of headache...
