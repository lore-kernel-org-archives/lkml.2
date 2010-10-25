Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab0JYPOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 11:14:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41152 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab0JYPOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 11:14:38 -0400
Date: Mon, 25 Oct 2010 17:14:27 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Borislav Petkov <petkovbb@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [NAK] Re: [PATCH -v2 9/9] ACPI, APEI, Generic Hardware Error
 Source POLL/IRQ/NMI notification type support
Message-ID: <20101025151427.GD17622@basil.fritz.box>
References: <1287992610-14996-1-git-send-email-ying.huang@intel.com>
 <1287992610-14996-10-git-send-email-ying.huang@intel.com>
 <20101025084553.GA27119@elte.hu>
 <1287997112.2862.322.camel@yhuang-dev>
 <20101025091913.GA17622@basil.fritz.box>
 <20101025111530.GA27659@elte.hu>
 <20101025123753.GB17622@basil.fritz.box>
 <20101025125531.GA6075@elte.hu>
 <20101025131127.GC17622@basil.fritz.box>
 <20101025134740.GA8888@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101025134740.GA8888@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Different events in different contexts with different drivers with different 
> > parameters [...]
> 
> Correct.
> 
> > [...] using different tools.
> 
> That's possible, but i'd expect tools/ras/ to be populated with uniformly working 
> tools. There's little sense in fragmenting the hw-testing field...

First if you want to avoid fragmentation please contribute to mce-test

git://git.kernel.org/pub/scm/utils/cpu/mce/mce-test.git

That's the standard area for tests in this area for several years
with many contributors. If anyone has anything new they want
to inject and it roughly fits hardware errors it can be placed there.
These days it already tests more than just mces.

Then the tools are actually more like test suites that do all kind
of different things. For example the testers for hwpoison high level
is a set of programs that get continuously extended. There's no
straight forward way to do all this from the command line, because
you need to write quite a lot of code just to get the basic 
context needed for the specific code path.

As an example of this see the cases in tinjpage:

http://git.kernel.org/?p=utils/cpu/mce/mce-test.git;a=blob;f=tsrc/tinjpage.c;h=1042c132a3235c6bc0fbbe4ee8f68f0c6f96804f;hb=HEAD

Compare it to random_offline which tests global soft offline coverage

http://git.kernel.org/?p=utils/cpu/mce/mce-test.git;a=blob;f=tsrc/random_offline;h=c380a86075511de4fedb0cff9bf99a53d9215cf0;hb=HEAD

Compare it to the file system stress suite which tests file system buffer recovery:

http://git.kernel.org/?p=utils/cpu/mce/mce-test.git;a=tree;f=stress;h=e0c7c281ea9a2753d326d6ab9e0dbe566f762cf1;hb=HEAD

And compare it to the mce coverage test suite which tests low level machine check coverage:

http://git.kernel.org/?p=utils/cpu/mce/mce-test.git;a=tree;f=cases/soft-inj;h=b0eac7aad53709c0ca7899d56698445646a51c3a;hb=HEAD

with mce-inject (software) as base:

http://git.kernel.org/?p=utils/cpu/mce/mce-inject.git;a=blob;f=mce.y;h=9a8bb0385e4c3f35f8115b42e0c859623ff9cde7;hb=HEAD

and with APEI as base

http://git.kernel.org/?p=utils/cpu/mce/mce-test.git;a=tree;f=cases/apei-inj;h=bbdffe6528f763b89b9ee1f954869a0f90d4deda;hb=HEAD

They are really all quite different. 

On merging them:

Well ok in theory one could have ras test1|test2|test3

But you would end up like git and perf where you have lots of different tools
just linked into the same executable. Not really an advantage, would you agree
on that? Ok i understand in the git/perf case there's also a common library,
but at least in the error injection case there isn't really.

Anyways if the request is to link everything into a single binary
it could be looked at, but I must admit I personally don't see any
advantage from that.

Or you could have a single kernel inject interface with a bazillion modi and 
different options that needs to be extended all the time to cover some new case.
Aka the ioctl multiplexer from hell. I don't think that's really 
an appealing alternative. It would work if all the injections were
very similar, but they are really not. They are all different.

Current way is to have own files in debugfs for each
or put in other places where it fits (e.g. madvise for in process injection)

Is the problem that there is no cleanly defined place in debugfs for it?
Maybe could simply define a standard directory structure in debugfs? 

I don't have a problem with that. Right now the approach was to put
it into a directory per subsystem, but perhaps there could be something
better. 

> Your refusal to even consider this possibility and to look at the EDAC/RAS patches 
> that deal with this is puzzling to me.

What I find puzzling is that you really continue to ignore all the practical details,
and still nack other people's work without even trying to understand it.

That's not really the old Ingo I used to know.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
