Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab2BCKDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 05:03:42 -0500
Received: from service87.mimecast.com ([91.220.42.44]:55004 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab2BCKDj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 05:03:39 -0500
Date: Fri, 3 Feb 2012 10:03:31 +0000
From: Matthew Gretton-Dann <matthew.gretton-dann@arm.com>
To: Richard Guenther <rguenther@suse.de>
Cc: DJ Delorie <dj@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>,
        "ptesarik@suse.cz" <ptesarik@suse.cz>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
Subject: Re: Memory corruption due to word sharing
Message-ID: <20120203100331.GB2544@e103070-lin.arm.com>
Mail-Followup-To: Richard Guenther <rguenther@suse.de>,
	DJ Delorie <dj@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	"linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"dsterba@suse.cz" <dsterba@suse.cz>,
	"ptesarik@suse.cz" <ptesarik@suse.cz>,
	"gcc@gcc.gnu.org" <gcc@gcc.gnu.org>
References: <20120201151918.GC16714@quack.suse.cz>
 <xnbopg8lex.fsf@greed.delorie.com>
 <alpine.LNX.2.00.1202031034450.4999@zhemvz.fhfr.qr>
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1202031034450.4999@zhemvz.fhfr.qr>
Thread-Topic: Memory corruption due to word sharing
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 03 Feb 2012 10:03:31.0749 (UTC) FILETIME=[157FA550:01CCE25B]
X-MC-Unique: 112020310033403301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 09:37:22AM +0000, Richard Guenther wrote:
> On Fri, 3 Feb 2012, DJ Delorie wrote:
> 
> > 
> > Jan Kara <jack@suse.cz> writes:
> > >   we've spotted the following mismatch between what kernel folks expect
> > > from a compiler and what GCC really does, resulting in memory corruption on
> > > some architectures. Consider the following structure:
> > > struct x {
> > >     long a;
> > >     unsigned int b1;
> > >     unsigned int b2:1;
> > > };
> > 
> > If this structure were volatile, you could try
> > -fstrict-volatile-bitfields, which forces GCC to use the C type to
> > define the access width, instead of doing whatever it thinks is optimal.
> > 
> > Note: that flag is enabled by default for some targets already, most
> > notably ARM.
> 
> Note that -fstrict-volatile-bitfields does not work for
> 
> volatile struct S {
>     int i : 1;
>     char c;
> } s;
> int main()
> {
>   s.i = 1;
>   s.c = 2;
> }
> 
> where it accesses s.i using SImode.  -fstrict-volatile-bitfields
> falls foul of all the games bitfield layout plays and the
> irrelevantness of the declared bitfield type (but maybe the
> ARM ABI exactly specifies it that way).

Indeed the ARM ABI does - see Section 7.1.7.5 of the PCS available at:

http://infocenter.arm.com/help/topic/com.arm.doc.ihi0042-/

In fact the example above is pretty much the same as that given in the ABI
docs, and it says that accessing s.i will also cause an access
to s.c, but not vice-versa.

Thanks,

Matt

-- 
Matthew Gretton-Dann
Principal Engineer, PD Software, ARM Ltd.

