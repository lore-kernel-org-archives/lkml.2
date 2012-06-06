Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab2FFLOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 07:14:39 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:52064 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab2FFLOh convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 6 Jun 2012 07:14:37 -0400
Message-Id: <4FCF57B902000078000887EA@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 06 Jun 2012 12:14:33 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Don Zickus" <dzickus@redhat.com>
Cc: <x86@kernel.org>, <zhong@linux.vnet.ibm.com>,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,nmi: Fix section mismatch warnings on 32-bit
References: <1338839763-11140-1-git-send-email-dzickus@redhat.com>
 <4FCDDB7D0200007800088390@nat28.tlf.novell.com>
 <20120605144734.GU32472@redhat.com>
 <4FCE44FC0200007800088524@nat28.tlf.novell.com>
 <20120605183539.GA32472@redhat.com>
In-Reply-To: <20120605183539.GA32472@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 05.06.12 at 20:35, Don Zickus <dzickus@redhat.com> wrote:
> On Tue, Jun 05, 2012 at 04:42:20PM +0100, Jan Beulich wrote:
>> >>> On 05.06.12 at 16:47, Don Zickus <dzickus@redhat.com> wrote:
>> > On Tue, Jun 05, 2012 at 09:12:13AM +0100, Jan Beulich wrote:
>> >> So before applying a change like this, I'd really like to understand
>> >> the issue itself. Could you simply attach the nmi_selftest.o file
>> >> that you get without your patch here (and indicate which
>> >> upstream version or revision the corresponding source file was
>> >> from, to be able to re-construct what the compiler actually did)?
>> > 
>> > I could but it might be easier for you to re-create it on your end.
>> > Using gcc-4.4.4 on an x86_64 box and v3.5-rc1, I just set
>> > CONFIG_DEBUG_NMI_SELFTEST to 'y' and compile with
>> > 
>> > make ARCH=i386 O=out/i686
>> > 
>> > and it easily reproduces for me.
>> 
>> I don't think I have a plain 4.4.4 around anywhere, nor is it clear
>> whether you used a plain one (and how it was configured). For
>> tricky, highly version dependent things like this (where a compiler
>> bug also can't be excluded), having the _exact_ object file the
>> problem was seen with would be much easier than trying to hunt
>> down a compiler version that I can reproduce this with.
> 
> I didn't think it would be compiler dependent as I do not know what
> compiler the reporter was using.  I used a RHEL-6 4.4.4 compiler (which
> you probably don't have :^) ).

Indeed, somehow I failed to see the obvious - it's commit
72b3fb24713755cf9740b403e95aa67ceedf3509 that causes
these problems. Instantiating static data like this just doesn't
play with any of the pointers passed being into .init.*.

I'd suggest either open coding register_nmi_handler() (with
the static data put into __initdata), or further abstracting it
by allowing an optional fifth argument (specifying the section
annotation if needed).

Jan

