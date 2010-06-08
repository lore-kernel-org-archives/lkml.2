Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab0FHOaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 10:30:01 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:46945 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297Ab0FHO37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 10:29:59 -0400
Message-ID: <4C0E53E0.3010300@linux.vnet.ibm.com>
Date: Tue, 08 Jun 2010 07:29:52 -0700
From: "Venkateswararao Jujjuri (JV)" <jvrao@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Eric Van Hensbergen <ericvh@gmail.com>,
       V9FS Developers <v9fs-developer@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [V9fs-developer] [GIT PULL] 9p file system bug fixes for 2.6.35-rc2
References: <AANLkTik3ax1SlAKRo6laMfACdzh6IUKLGSvMK4Gp9GY9@mail.gmail.com> <alpine.LFD.2.00.1006071654290.4506@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006071654290.4506@i5.linux-foundation.org>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 7 Jun 2010, Eric Van Hensbergen wrote:
>> jvrao (2):
>>       Add a helper function to get fsgid for a file create.
>>       9p: Add a wstat after TCREATE to fix the gid.
> 
> Quite frankly, this looks rather broken.
> 
> It uses "dentry->d_parent" without locking (it so happens to likely be ok, 
> since we are in "create()" and thus should be holding the parent 
> semaphore). On its own, that might be excusable (if people were even 
> _aware_ of the this locking rule!), but it does so just to get the inode 
> pointer to that parent.
> 
> And the only thing that makes it ok to access dentry->d_parent - the fact 
> that we are in v9fs_create() - is also the thing that should have made 
> people look at the arguments to the function and say "hmm".

Silly me. I sent out another patch using the dir inode passed through arguments.
But we still need to analyze the use of dentry->d_parent in other parts of code.. 

- JV


> 
> We pass in the directory inode pointer as an argument to the create 
> function! The code could have used that thing directly, instead of 
> mucking around with dentry pointers that it had no business looking at.
> 
> I see why it seems to have happened: v9fs does the exact same thing for 
> the pre-existing "v9fs_fid_lookup()". So there is history to this 
> behavior.
> 
> Maybe people weren't aware of the fact that just dereferencing 
> dentry->d_parent willy-nilly isn't actually allowed. That field changes. 
> Sure, there are cases where it's ok, but this is a dangerous thing to do 
> in general. 
> 
> In fact, the other thing that I find doing that whole "dentry->d_parent" 
> thing seems to literally be broken. If you look at v9fs_fid_lookup(), 
> you'll notice how it walks up the d_parent chain, and at that point you do 
> NOT own the directory i_mutex, so at that point d_parent really _can_ be 
> changing wildly due to concurrent renames or whatever.
> 
> So 9pfs seems to have some preexisting bugs in this area. I'm not going to 
> pull new bug-prone code. See the other discussions about being tight this 
> release about really _only_ taking regressions after the merge window 
> closed.
> 
> 		Linus
> 
> ------------------------------------------------------------------------------
> ThinkGeek and WIRED's GeekDad team up for the Ultimate 
> GeekDad Father's Day Giveaway. ONE MASSIVE PRIZE to the 
> lucky parental unit.  See the prize list and enter to win: 
> http://p.sf.net/sfu/thinkgeek-promo
> _______________________________________________
> V9fs-developer mailing list
> V9fs-developer@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/v9fs-developer


