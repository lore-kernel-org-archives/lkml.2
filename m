Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab1BQQg1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 11:36:27 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49643 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab1BQQgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 11:36:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CE6ecKnaIyP/mc/1tV2/+LEJlIC4IK1+TxMSKW1CYtHD4oEzYkk4FWI3Otit63p0IB
         73x6vwDdyWLOy0LY8DfdavZkRpWy8GDji2nWXwwR8yQ0vcwYZcS34YVoNaGL7ImI13yp
         m4QbaY886J1IaGLgUl7AcQxH2X3NIsjIBpuqM=
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in
 2.6.38-rc4
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Ingo Molnar <mingo@elte.hu>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Octavian Purdila <opurdila@ixiacom.com>,
        David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTikPKpNHxDQAYBd3fiQsmVozLtCVDsNn=+eF_q2r@mail.gmail.com>
References: <20110216185234.GA11636@tiehlicka.suse.cz>
	 <20110216193700.GA6377@elte.hu>
	 <AANLkTinDxxbVjrUViCs=UaMD9Wg9PR7b0ShNud5zKE3w@mail.gmail.com>
	 <AANLkTi=xnbcs5BKj3cNE_aLtBO7W5m+2uaUacu7M8g_S@mail.gmail.com>
	 <20110217090910.GA3781@tiehlicka.suse.cz>
	 <AANLkTikPKpNHxDQAYBd3fiQsmVozLtCVDsNn=+eF_q2r@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Feb 2011 17:36:14 +0100
Message-ID: <1297960574.2769.20.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 17 février 2011 à 08:13 -0800, Linus Torvalds a écrit :
> On Thu, Feb 17, 2011 at 1:09 AM, Michal Hocko <mhocko@suse.cz> wrote:
> >
> > I have seen that thread but I didn't think it is related. I thought
> > this is an another anon_vma issue. But you seem to be right that the
> > offset pattern can be related.
> 
> Hey, maybe it turns out to be about anon_vma's in the end, but I see
> no big reason to blame them per se. And we haven't had all that much
> churn wrt anon_vma's this release window, so I wouldn't expect
> anything exciting unless you're actively using transparent hugepages.
> And iirc, Eric was not using them (or memory compaction).
> 
> I'd be more likely to blame either the new path lookup (which uses
> totally new RCU freeing of inodes _and_
> INIT_LIST_HEAD(&inode->i_dentry)), but I'm not seeing how that could
> break either (I've gone through that patch many times).
> 
> And in addition, I don't see why others wouldn't see it (I've got
> DEBUG_PAGEALLOC and SLUB_DEBUG_ON turned on myself, and I know others
> do too).
> 
> So I'm wondering what triggers it. Must be something subtle.
> 
> > OK. I have just booted with the same kernel and the config turned on.
> > Let's see if I am able to reproduce.
> 
> Thanks. It might have been good to turn on SLUB_DEBUG_ON and
> DEBUG_LIST too, but PAGEALLOC is the big one.
> 
> > Btw.
> > $ objdump -d ./vmlinux-2.6.38-rc4-00001-g07409af-vmscan-test | grep 0x1e68
> >
> > didn't print out anything. Do you have any other way to find out the
> > structure?
> 
> Nope, that's roughly what I did to (in addition to doing all the .ko
> files and checking for 0xe68 too). Which made me worry that the 0x1e68
> offset is actually just the stack offset at some random code-path (it
> would stay constant for a particular kernel if there is only one way
> to reach that code, and it's always reached through some stable
> non-irq entrypoint).
> 
> People do use on-stack lists, and if you do it wrong I could imagine a
> stale list entry still pointing to the stack later. And while
> INIT_LIST_HEAD() is one pattern to get that "two consecutive words
> pointing to themselves", so is doing a "list_del()" on the last list
> entry that the head points to.
> 
> So _if_ somebody has a list_head on the stack, and leaves a stale list
> entry pointing to it, and then later on, when the stack has been
> released that stale list entry is deleted with "list_del()", you'd see
> the same memory corruption pattern. But I'm not aware of any new code
> that would do anything like that.
> 
> So I'm stumped, which is why I'm just hoping that extra debugging
> options would catch it closer to the place where it actually occurs.
> The "2kB allocation with a nice compile-time structure offset" sounded
> like _such_ a great way to catch it, but it clearly doesn't :(
> 
>  

Hmm, this rings a bell here.

Unfortunately I have to run so cannot check right now.

Please take a look at commit 443457242beb6716b43db4d (net: factorize
sync-rcu call in unregister_netdevice_many)

CC David and Octavian

dev_close_many() can apparently return with an non empty list






