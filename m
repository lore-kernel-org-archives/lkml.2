Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab1CHSDH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 13:03:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab1CHSDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 13:03:03 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20110307210656.GA1750@suse.de>
References: <20110307210656.GA1750@suse.de>
To: Tony Jones <tonyj@suse.de>
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: PATCH [1/1]: audit: acquire creds selectively to reduce atomic op overhead
Date: Tue, 08 Mar 2011 18:02:53 +0000
Message-ID: <18893.1299607373@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Jones <tonyj@suse.de> wrote:

> Commit c69e8d9c01db added calls to get_task_cred and put_cred in
> audit_filter_rules.  Profiling with a large number of audit rules active on
> the exit chain shows that we are spending upto 48% in this routine for
> syscall intensive tests, most of which is in the atomic ops.
> 
> The following patch acquires the cred if a rule requires it.  In our
> particular case above, most rules had no cred requirement and this dropped
> the time spent in audit_filter_rules down to ~12%.  An alternative would be
> for the caller to acquire the cred just once for the whole chain and pass
> into audit_filter_rules.  I can create an alternate patch doing this if
> required.

There's no actual need to get a ref on the named task's creds.

If tsk == current, no locking is needed at all.

If tsk != current, the RCU read lock is sufficient.  See task_cred_xxx() in
include/linux/cred.h.

Hmmm...  I wonder...  The audit filter uses tsk->real_cred, but is that
correct?  Should it be using tsk->cred?  And is tsk always going to be
current?

> +	const struct cred *cred=NULL;

Binary operators like '=' should have a space on each side.

David
