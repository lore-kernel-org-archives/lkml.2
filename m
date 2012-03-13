Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410Ab2CMTKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 15:10:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757004Ab2CMTKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 15:10:53 -0400
Date: Tue, 13 Mar 2012 14:26:46 -0400
From: Dave Jones <davej@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: netdev@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: tun oops dereferencing garbage nsproxy-> address.
Message-ID: <20120313182646.GB11500@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>, netdev@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120313034201.GA13156@redhat.com>
 <m1vcm8e537.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1vcm8e537.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 11:19:40AM -0700, Eric W. Biederman wrote:

 > > oops happened here..
 > >
 > >         tfile->net = get_net(current->nsproxy->net_ns);
 > >      548:       48 8b 92 50 05 00 00    mov    0x550(%rdx),%rdx
 > >      54f:       48 8b 52 28             mov    0x28(%rdx),%rdx
 > >
 > > My guess is the fuzzer called some syscall that set current->nsproxy
 > > to garbage (0x0000000100000001), which later got dereferenced when it
 > > subsequently randomly did an open() on tun.
 > >
 > > Any thoughts ?
 > 
 > It smells like a memory stomp.  current->nsproxy is always supposed to
 > have a valid value, and it never would have an odd value.  The value
 > should always be at least 8 byte aligned.
 > 
 > Since the value is impossible this doesn't feel like a path where the
 > error handling is wrong.

0x0000000100000001 looks like one of strange values my fuzzer passes syscalls
when they ask for an address.

So something managed to get that set as nsproxy.  The fuzzer avoids calling
clone(), so are there other syscalls that might set this ?

 > So I am guessing this is a memory stomp.  My guess it would take the
 > same sequence of system calls on the same kernel build to reproduce
 > this problem in the same place.
 > 
 > Do you have any more information?

I've not managed to reproduce it, and that run sadly had logging turned off,
so I don't have the exact syscall sequence that caused it.

	Dave
