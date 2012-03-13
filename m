Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab2CMUXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 16:23:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56034 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab2CMUXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 16:23:44 -0400
Date: Tue, 13 Mar 2012 16:23:38 -0400
From: Dave Jones <davej@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: netdev@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: tun oops dereferencing garbage nsproxy-> address.
Message-ID: <20120313202338.GA23737@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>, netdev@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120313034201.GA13156@redhat.com>
 <m1vcm8e537.fsf@fess.ebiederm.org>
 <20120313182646.GB11500@redhat.com>
 <m1wr6oclep.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wr6oclep.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 01:10:06PM -0700, Eric W. Biederman wrote:

 > >  > > My guess is the fuzzer called some syscall that set current->nsproxy
 > >  > > to garbage (0x0000000100000001), which later got dereferenced when it
 > >  > > subsequently randomly did an open() on tun.
 > >  > 
 > >  > It smells like a memory stomp.  current->nsproxy is always supposed to
 > >  > have a valid value, and it never would have an odd value.  The value
 > >  > should always be at least 8 byte aligned.
 > >  > 
 > >  > Since the value is impossible this doesn't feel like a path where the
 > >  > error handling is wrong.
 > >
 > > 0x0000000100000001 looks like one of strange values my fuzzer passes syscalls
 > > when they ask for an address.
 > >
 > > So something managed to get that set as nsproxy.  The fuzzer avoids calling
 > > clone(), so are there other syscalls that might set this ?
 > 
 > setns and unshare might touch the nsproxy for the same reasons as clone,
 > but the rules are very similar to clone.

Hmm, the only way that seems possible to set nsproxy is if the process was run
with CAP_SYS_ADMIN, which it wasn't.

Maybe your theory holds water, and something else wrote that value to the
current thread at a random offset. Fun.

	Dave 
