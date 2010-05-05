Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934572Ab0EEKsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 06:48:16 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34421 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab0EEKsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 06:48:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:references:
	mime-version:content-type:content-disposition:in-reply-to:user-agent:x-system-of-record;
	b=Ge6M6iruWq1aYfHYIMPoIv8H2P8HpwhBkXMWHzOdeaItokoCxtDPk0WEoVBeiLBvY
	AP3PL3HDBIJX8B0aP173A==
Date: Wed, 5 May 2010 03:48:07 -0700
From: Michel Lespinasse <walken@google.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
       Ying Han <yinghan@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: rwsem: down_read_unfair() proposal
Message-ID: <20100505104807.GB32643@google.com>
References: <20100505032033.GA19232@google.com> <22994.1273054004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22994.1273054004@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 11:06:44AM +0100, David Howells wrote:
> Michel Lespinasse <walken@google.com> wrote:
> 
> > and looks like it's doable with the x86 rwsem implementation as well in a
> > way that would only involve changes to the rwsem spinlock-protected slow
> > paths in lib/rwsem.c .
> 
> It's not as easy as it seems.  Once an XADD-based rwsem is contended, you
> cannot necessarily tell without looking at the queue whether the rwsem is
> currently write-locked or read-locked.

I only said it was doable :) Not done with the implementation yet, but I can
describe the general idea if that helps. The high part of the rwsem is
decremented by two for each thread holding or trying to acquire a write lock;
additionally the high part of the rwsem is decremented by one for the first
thread getting queued. Since queuing is done under a spinlock, it is easy
to decrement only for the first blocked thread there. In down_read_unfair(),
the rwsem value is compared with RWSEM_WAITING_BIAS (== -1 << 16 or 32);
if it's smaller then the rwsem might be write owned and we have to block;
otherwise it only has waiters which we can decide to ignore. This is the
idea in a nutshell.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
