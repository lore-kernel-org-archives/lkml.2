Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1KUXu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:50:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57696 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab1KUXuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:50:25 -0500
Date: Mon, 21 Nov 2011 15:50:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Daney <ddaney@caviumnetworks.com>,
        David Daney <ddaney.cavm@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Robin Holt <holt@sgi.com>
Subject: Re: [patch] hugetlb: remove dummy definitions of HPAGE_MASK and
 HPAGE_SIZE
Message-Id: <20111121155024.33b1b881.akpm@linux-foundation.org>
In-Reply-To: <CA+55aFzSNqCOFuvtEc2V1THVOsOVnz6NOa1U_9p5=Y4E=sj6qg@mail.gmail.com>
References: <1321567050-13197-1-git-send-email-ddaney.cavm@gmail.com>
	<alpine.DEB.2.00.1111171520130.20133@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1111171522131.20133@chino.kir.corp.google.com>
	<4ECACF68.3020701@gmail.com>
	<CA+55aFwZxqHfEOemj+OJNKCj2toqGf3rkK-9iuS39L7iZsoH1Q@mail.gmail.com>
	<4ECADD83.3090108@caviumnetworks.com>
	<CA+55aFzSNqCOFuvtEc2V1THVOsOVnz6NOa1U_9p5=Y4E=sj6qg@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Nov 2011 15:43:26 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, Nov 21, 2011 at 3:23 PM, David Daney <ddaney@caviumnetworks.com> wrote:
> >
> > Ok Linus, for you I would recommend against running this git command on your
> > tree:
> >
> > git grep -E '#define.+BUG\(\);'
> >
> > It's not like there isn't precedence.
> 
> So two wrongs make a right?
> 
> I do note that almost all the BUG() ones are in the same broken area:
> hugepages. There's something wrong with the development there.
> 
> I wish people whose code had stuff like that would take a deep look at it.
> 

The original decision way back when was that huge pages shouldn't mess
up the core VM too much.  One way in which we addressed that was to
make all its functions compilable with CONFIG_HUGETLB_PAGE=n, but they
should never be executed.  So the basic implementation pattern is:

#ifndef CONFIG_HUGETLB_PAGE
#define is_vm_hugetlb_page(p) 0
#define hugetlb_foo(x) BUG()

and...

	if (is_vm_hugetlb_page(...))
		hugetlb_foo(...);

The is_vm_hugetlb_page() evaluates to literal zero and so no code is
emitted for the hugetlb_foo() call.  The BUG() should never appear in
vmlinux but it's in there as a we-screwed-up thing.



