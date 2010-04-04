Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab0DDQNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 12:13:12 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:12938 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab0DDQNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 12:13:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=B2+EIm6IywyCFg4WZvKjetGedkUoIHwnK+08knsk2XIcmxHg2eXlHoT0X52Wd1fgw0
         8tgZXNigxfk6x/u+9e1Ttb5rRK5KHds4eFiBS8dH7RFzL/piXzqhFlrassTbDT1yHdDF
         SPaZFXfIWP2lSpEtPZrTn40tWiaqzVgCQ7+OE=
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux
 2.6.34-rc3)
From: Minchan Kim <minchan.kim@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
In-Reply-To: <4BB66941.1060809@redhat.com>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org>
	 <20100402175937.GA19690@liondog.tnic>
	 <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>
	 <20100402112428.f46ddc44.akpm@linux-foundation.org>
	 <alpine.LFD.2.00.1004021135530.3634@i5.linux-foundation.org>
	 <4BB66941.1060809@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Apr 2010 01:12:55 +0900
Message-ID: <1270397575.1814.106.camel@barrios-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Rik. 

On Fri, 2010-04-02 at 18:01 -0400, Rik van Riel wrote:
> On 04/02/2010 02:37 PM, Linus Torvalds wrote:
> > On Fri, 2 Apr 2010, Andrew Morton wrote:
> >> On Fri, 2 Apr 2010 11:09:14 -0700 (PDT) Linus Torvalds<torvalds@linux-foundation.org>  wrote:
> >>
> >>>
> >>> I think this is likely due to the new scalable anon_vma linking by Rik.
> >>
> >> Similar to https://bugzilla.kernel.org/show_bug.cgi?id=15680
> >
> > Yup, looks like the same thing, except that bugzilla entry was due to
> > swapping rather than hibernation and memory shrinking. But same end
> > result, just different reasons for why we were trying to shrink the page
> > lists.
> 
> Interesting that it is a null pointer dereference, given
> that we do not zero out the anon_vma_chain structs before
> freeing them.
> 
> Page_referenced_anon() takes the anon_vma->lock before
> walking the list.  The three places where we modify the
> anon_vma_chain->same_anon_vma list, we also hold the
> lock.
> 
> No doubt something in mm/ is doing something silly, but
> I have not found anything yet :(
> 
> If I had to guess, I'd say maybe we got one of the
> mprotect & vma_adjust cases wrong.  Maybe a page stayed
> around in the LRU (and in a process?) after its anon_vma
> already got freed?

While I review the code again due to this BUG, I found some strange
thing. 

In anon_vma_fork, if anon_vma_clone is successful but anon_vma_alloc is
failed, what happens? Parent VMA's anon_vmas have anon_vma_chain which
has vma which is destroyed. 
I couldn't find any clean routine to remove this garbage. 
I am missing something?

But I think it isn't related to this bug because oops point is not
vma_address but anon_vma_chain.next.



-- 
Kind regards,
Minchan Kim


