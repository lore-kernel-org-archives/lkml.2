Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759225Ab1D0Q07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 12:26:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48928 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757925Ab1D0Q05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 12:26:57 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=i38SgkEfDKkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=obuGd26_AAAA:8 a=KS5SXdNKKjFin6_52PkA:9 a=Cxd6WFkownpmQIO-fewA:7 a=PUjeQqilurYA:10 a=autfX1nt8JkA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, gmack@innerfire.net,
        Christoph Hellwig <hch@infradead.org>,
        Thiago Farina <tfransosi@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTikGYLEWx8xrYs3Nv=-oPS3n95rXZA@mail.gmail.com>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	 <20110427005243.GI9486@thunk.org> <20110427064719.GB597@infradead.org>
	 <alpine.DEB.2.00.1104270445210.7570@mtl.rackplans.net>
	 <20110427145209.GJ9486@thunk.org>
	 <BANLkTikGYLEWx8xrYs3Nv=-oPS3n95rXZA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 27 Apr 2011 12:26:55 -0400
Message-ID: <1303921616.18763.64.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 19:04 +0300, Alexey Dobriyan wrote:
> On Wed, Apr 27, 2011 at 5:52 PM, Ted Ts'o <tytso@mit.edu> wrote:
> > On Wed, Apr 27, 2011 at 04:47:40AM -0400, gmack@innerfire.net wrote:
> >> Knowing about it and not screwing it up are two different things. I was
> >> working on a project a few years ago and we made this exact change thanks
> >> to the backwards logic of strcmp constantly screwing people up and the bug
> >> count went down considerably.
> >
> > If someone could even vaguely possibly screw up strcmp(), I don't want
> > them submitting patches to my subsystem.  I'm generally worried about
> > far more subtle bugs (deadlocks, locking screwups), and as Christoph
> > said, if you can't notice a strcmp bug, there's something
> > ***seriousl**** wrong with your code review process, test suite,
> > testing discpline, or all of the above.
> 
> This can be good excuse in math where proof of existence is enough.
> For some reason, the one making excuses always fails to say
> what exactly is wrong with all of the above.

Note, Ted only NAK'd it for his own code. Christoph seemed to do the
same for his. I'm fine with it in my code as when I see:

	if (le32_to_cpu(de->inode) != inode->i_ino ||
			!le32_to_cpu(de1->inode) ||
			strcmp (".", de->name) ||
			strcmp ("..", de1->name)) {
		ext3_warning (inode->i_sb, "empty_dir",
			      "bad directory (dir #%lu) - no `.' or `..'",
			      inode->i_ino);
		brelse (bh);
		return 1;
	}

(from fs/ext3/namei.c)

it does not stand out to me that this if statement will return true if
de->name does not equal "." or de1->name does not equal "..". If this
looked like:

	if (le32_to_cpu(de->inode) != inode->i_ino ||
			!le32_to_cpu(de1->inode) ||
			!streq (".", de->name) ||
			!streq ("..", de1->name)) {
		ext3_warning (inode->i_sb, "empty_dir",
			      "bad directory (dir #%lu) - no `.' or `..'",
			      inode->i_ino);
		brelse (bh);
		return 1;
	}

IMO looks much easier to understand.

Although I also think this is easier to understand too:

	if (le32_to_cpu(de->inode) != inode->i_ino ||
			!le32_to_cpu(de1->inode) ||
			strcmp (".", de->name) != 0 ||
			strcmp ("..", de1->name) != 0) {
		ext3_warning (inode->i_sb, "empty_dir",
			      "bad directory (dir #%lu) - no `.' or `..'",
			      inode->i_ino);
		brelse (bh);
		return 1;
	}


But again, I'm not the maintainer that needs to make sure this is
correct. I still feel this is personal preference decided by the
maintainer of said code.


> But instead of agreeing
> that, yes, streq() as "compare strings by value, relative order is not
> important,
> interesting or relevant" should have existed from the very beginning,
> let's add it into kernel at least,

I'm all for adding a streq() and may even use it. Simply because it
makes reading the code easier to understand, and not necessarily less
buggy (although I think it might help).

Note, I was having a similar discussion with a fellow kernel developer
on IRC a few years ago about using:

	!strcmp() vs strcmp() == 0

and in that discussion, the example the other developer had done with 
!strcmp() had a bug in it. Which did convince him to switch to
strcmp() == 0 ;)

-- Steve



