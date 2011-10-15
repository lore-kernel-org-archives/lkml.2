Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab1JOXD2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 19:03:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51093 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab1JOXD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 19:03:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=XWIipPMoAYB0wbO0L+9iY00c+5VFgaGL7sV0LjwaAggAdvsv/JDsZvQh4e5TBWId2
	3yywnXzU9JmS9B+sh7WAQ==
Date: Sat, 15 Oct 2011 16:03:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: James Bottomley <James.Bottomley@hansenpartnership.com>
cc: Andi Kleen <andi@firstfloor.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: Please include const-sections into linux-next
In-Reply-To: <1318631204.3018.101.camel@dabdike.int.hansenpartnership.com>
Message-ID: <alpine.DEB.2.00.1110151543220.25063@chino.kir.corp.google.com>
References: <20111013233818.GB26654@one.firstfloor.org> <1318631204.3018.101.camel@dabdike.int.hansenpartnership.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, James Bottomley wrote:

> It's not incredibly trivial: it causes a compile failure on parisc:
> 
> mm/percpu.c:1372: error: __setup_str_percpu_alloc_setup causes a section
> type conflict
> make[1]: *** [mm/percpu.o] Error 1
> 
> I have no idea why, though.
> 

Not sure why this would only happen on parisc, but I haven't looked at it 
closely.  It means something qualified with const is being defined in a 
section with other definitions that are not const, or vice versa.

For example:

	static int x __attribute__((__section__("foo"))) = 1;
	static const int y __attribute__((__section__("foo"))) = 2;

will result in the same error.  Since __setup_param() places 
__setup_str_percpu_alloc_setup in .init.rodata as const, it means 
something else has already been defined in .init.rodata without being 
qualified as such.
