Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab0JGVRH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:17:07 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:54070 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab0JGVRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:17:06 -0400
X-Greylist: delayed 1231 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Oct 2010 17:17:05 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19630.13234.840343.153381@quad.stoffel.home>
Date: Thu, 7 Oct 2010 16:55:14 -0400
From: "John Stoffel" <john@stoffel.org>
To: Eric Paris <eparis@redhat.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        agruen@suse.de
Subject: Re: Linux 2.6.36-rc7
In-Reply-To: <1286472835.2656.15.camel@dhcp231-98.rdu.redhat.com>
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com>
	<201010071710.46938.tvrtko.ursulin@sophos.com>
	<201010071815.54303.tvrtko.ursulin@sophos.com>
	<1286472835.2656.15.camel@dhcp231-98.rdu.redhat.com>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Eric" == Eric Paris <eparis@redhat.com> writes:

Eric> On Thu, 2010-10-07 at 18:15 +0100, Tvrtko Ursulin wrote:
>> On Thursday 07 Oct 2010 17:10:46 Tvrtko Ursulin wrote:
>> > On Wednesday 06 Oct 2010 22:45:13 Linus Torvalds wrote:

>> Priority argument was dropped from the fanotify_init syscall, and since it is
>> a syscall once released it is set in stone. Without the priority argument, how
>> are multiple clients supposed to be ordered?
>> 
>> Co-existence between multiple clients was something which was supposed to be
>> designed in from the start. Use cases like hierarchical storage management,
>> anti-malware and content indexing should all be able to co-exist. Without a
>> priority argument I do not see how it can be assured HSM sees the perm event
>> before anti-malware, and content indexing after both of them? If there was any
>> discussion about dropping priority I missed it. :(

Eric> Shit.  I'm trying to remember the logic.  hrmph....  You could
Eric> have a real interface issue....  Shit.  Let me think about it
Eric> for an hour or two.

Eric> Original idea of priorities was to allow multiple permissions
Eric> decision makers to co-exist without having the livelock problem
Eric> of each trying to grant and deny access to each other.  That was
Eric> solved with the O_NONOTIFY hack and I think the priority was
Eric> then thought to be useless.  But you're absolutely right, it
Eric> isn't useless if we consider that an HSM might need to run first
Eric> to make sure data exists on disk before an indexer looks at the
Eric> data.

Eric> I see two possibilities off the top of my head:

Eric> I could just slap an (unused) priority field onto the end of the
Eric> fanotify_init() syscall (assuming Linus doesn't murder me) so we
Eric> can build that support out with explicit priorities down the
Eric> line, which I think might be overkill, or

Eric> The other option (without breaking ABI as it stands today) is to
Eric> define some set of the fanotify_init() flags to be a priority
Eric> field, we've got 32 bits and only use 2 of them so giving 4-8
Eric> bits of that as a priority (next cycle) isn't an issue and can
Eric> be easily backwards compatible.

So what happens when you try to register a priority level and someone
else has already gotten that level?  Does the call fail?  Do you get
bumped down to the next open level?  Can you *tell* what level you're
at and whether or not some other decision maker is ahead of you?  

So if I register an HSM module for /home, with a priority of 1, and
then register a content indexer for /home/john at priority 1, will
they clash?  Who wins?  The one registered first?  

I tried looking in Documentation/fs/fanotify.txt but I couldn't find
it anywhere.  So I had to grep around looking for the file which held
fanotify_init() so I could look it over... and then my brain started
bleeding from the lack of any comments on the various functions on WTF
they were supposed to do.

But hey, I admit I'm not a kernel programmer at all, nor a low level
FS guy, so I probably just don't have the indepth understanding of
Linux kernel internals.  I just need to spend six months hacking on
the code to come upto speed.

But I'd really like some docs in the next release which tells me as a
poor dumb sysadmin how it can and should be used and what the gotchas
are.

Thanks,
John
