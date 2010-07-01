Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286Ab0GAQWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 12:22:10 -0400
Received: from smtp-out.google.com ([216.239.44.51]:13521 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab0GAQWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 12:22:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:from:to:cc:in-reply-to:references:content-type:
	organization:date:message-id:mime-version:x-mailer:
	content-transfer-encoding:x-system-of-record;
	b=s4BYAYXxEajR/CKpYzhFztX7btykkp8yFEA7YRdYA05Tmhl6/dADroSoxI2PjH/nm
	YAceitayN1L+eb7P+/v6Q==
Subject: Re: [patch 29/52] fs: icache lock i_count
From: Frank Mayhar <fmayhar@google.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>
In-Reply-To: <20100701075426.GC22976@laptop>
References: <20100624030212.676457061@suse.de>
	 <20100624030730.245992858@suse.de> <20100630072702.GF24712@dastard>
	 <20100630120502.GB21358@laptop> <20100701023618.GQ24712@dastard>
	 <20100701075426.GC22976@laptop>
Content-Type: text/plain
Organization: Google, Inc.
Date: Thu, 01 Jul 2010 09:21:46 -0700
Message-Id: <1278001306.822.8.camel@bobble.smo.corp.google.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-01 at 17:54 +1000, Nick Piggin wrote:
> On Thu, Jul 01, 2010 at 12:36:18PM +1000, Dave Chinner wrote:
> > Seriously: use a new lock for high level inode operations you are
> > optimising - don't repurpose an existing lock with different usage
> > rules just because it's convenient.
> 
> That's what scalability development is all about, I'm afraid. Just
> adding more and more locks is what makes things more complex, so
> you have to juggle around or change locks when possible. If there is a
> difficulty with locking pops up in future, I'd prefer to look at it
> then.

I must agree strongly with Nick here.  Lock proliferation is a Bad
Thing; adding a new lock here just adds complexity without really
improving anything, since you still have to deal with lock ordering
_and_ add a new one to the mix.  It also makes struct inode bigger for
no real gain.  Since i_lock is already well understood and its use is
pretty isolated, it seems ideal to extend it to more general use while
keeping the isolation intact as much as possible.  Hell, if the code
were designed with this kind of scalability in mind, i_lock would be
doing all the locking directly related to struct inode.  Much as it is
after Nick's work.

My argument here is that it's not just convenient, it makes the
implementation simpler since instead of dealing with two locks there's
just one.
-- 
Frank Mayhar <fmayhar@google.com>
Google, Inc.

