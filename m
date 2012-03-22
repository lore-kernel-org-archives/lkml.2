Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759868Ab2CVUoF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 16:44:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34446 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759778Ab2CVUoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 16:44:01 -0400
Date: Thu, 22 Mar 2012 20:44:00 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: Regression introduced by
 bfcfaa77bdf0f775263e906015982a608df01c76 (vfs: use 'unsigned long' accesses
 for dcache name comparison and hashing)
Message-ID: <20120322204400.GD6589@ZenIV.linux.org.uk>
References: <20120322183845.GA17264@phenom.dumpdata.com>
 <20120322200918.GZ6589@ZenIV.linux.org.uk>
 <20120322202445.GB6589@ZenIV.linux.org.uk>
 <CA+55aFyiNKdkkvK0FH1ibo1iJj1HF9RjLEw3VOEjVwc0eiX8Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyiNKdkkvK0FH1ibo1iJj1HF9RjLEw3VOEjVwc0eiX8Sw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 01:38:28PM -0700, Linus Torvalds wrote:
> On Thu, Mar 22, 2012 at 1:24 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > OK, full_name_hash()/hash_name() definitely have a mismatch and it's on the
> > names of length 8*n: trivial experiment shows that we have
> > name hash_name full_name_hash
> 
> Good catch, guys.
> 
> Ugh. And I never noticed despite having run this code on my machines
> for several weeks, because I don't think I have anything that uses the
> "full_name_hash()" function. And it looked so obviously the same.
> 
> > Linus, which way do you prefer to shift it? ?Should hash_name() change to
> > match full_name_hash() or should it be the other way round?
> >
> > What happens is that you get multiplication by 9 and adding 0 in the former,
> > after having added the last full word. ?In the latter we add the last full
> > word, see that there's nothing left and bugger off.
> 
> Yes. I think we should make things match "hash_name()", because that's
> the one that is critical and we want to really generate good code for.
> 
> I think you can just move the "*=9" down in full_name_hash(), so that
> we always "pre-multiply" the hash for the next round.  But I'll have
> to double-check my logic.

See upthread for diff doing just that ;-)  Let's see if that fixes the
crap guys are seeing...  BTW, you have used full_name_hash(), just not
on something 8 char long - devpts uses d_alloc_name(), but pty numbers
tend to be less than ten millions...
