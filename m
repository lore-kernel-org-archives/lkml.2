Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199Ab3AIVNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:13:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933663Ab3AIVNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:13:42 -0500
Message-ID: <1357765998.1342.25.camel@localhost>
Subject: Re: Friendlier EPERM - Request for input
From: Eric Paris <eparis@redhat.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: linux-kernel@vger.kernel.org, libc-alpha@sourceware.org, dwalsh@redhat.com,
        dmalcolm@redhat.com, sds@tycho.nsa.gov, segoon@openwall.com,
        linux-security-module@vger.kernel.org
Date: Wed, 09 Jan 2013 16:13:18 -0500
In-Reply-To: <50EDD8D4.60003@schaufler-ca.com>
References: <1357747463.2593.28.camel@localhost>
	  <1357760637.2593.55.camel@localhost> <50EDCFC0.3010401@schaufler-ca.com>
	 <1357763560.1342.7.camel@localhost> <50EDD8D4.60003@schaufler-ca.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-09 at 12:53 -0800, Casey Schaufler wrote:

> Let me try again, I think I didn't quite get the idea across.
> 
> I'm suggesting that the string returned by get_extended_error_info()
> ought to be the audit record the system call would generate, regardless
> of whether the audit system would emit it or not.
> If the audit record doesn't have the information you need we should
> fix the audit system to provide it. Any bit of the information in
> the audit record might be relevant, and your admin or developer might
> need to see it.
> 
> I'm suggesting using the audit record because there are tools to
> examine them and it's a pity to use a different format instead of
> fixing the one that's already there.

I get the point.  My problem with using audit records is that they have
to be stored on disk, forever.  We have to store a record on disk for
EVERY denial because of rwx bits, acls, capabilities, LSM, etc.  We
don't do that today and I'm scared of disk growth explosion.  Then we
could have a kernel interface, say get_last_audit_record(), which could
query the audit system for that record number.

A thought on disk size explosion might be something like generating
these records in the kernel and just store them in the task struct until
some later point in time.  If userspace calls get_last_audit_record() we
might be able to dump the record to auditd.  If another record comes
along we have to free the last one and replace it.  Lot more of a perf
hit than setting a couple of ints and taking the hit at the time when
userspace actually wants to collect/use this information.

But are we just building up a rube goldburg machine?  I don't see a
problem storing the last audit record if it exists, but I don't like
making audit part of the normal workflow.  I'd do it if others like that
though....

