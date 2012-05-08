Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757966Ab2EHBID (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 21:08:03 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:44442 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab2EHBIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 21:08:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: paulmck@linux.vnet.ibm.com
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org
References: <m1vckcdoey.fsf@fess.ebiederm.org>
	<1336142995.25479.49.camel@marge.simpson.net>
	<m1zk9oc61j.fsf@fess.ebiederm.org>
	<1336150643.7502.4.camel@marge.simpson.net>
	<m1fwbfd71h.fsf@fess.ebiederm.org>
	<1336197362.7346.9.camel@marge.simpson.net>
	<1336198093.7346.11.camel@marge.simpson.net>
	<1336201977.7346.22.camel@marge.simpson.net>
	<87r4uv64oj.fsf_-_@xmission.com>
	<20120507221706.GI22082@ZenIV.linux.org.uk>
	<20120507235647.GH21152@linux.vnet.ibm.com>
Date: Mon, 07 May 2012 18:07:46 -0700
In-Reply-To: <20120507235647.GH21152@linux.vnet.ibm.com> (Paul E. McKenney's
	message of "Mon, 7 May 2012 16:56:47 -0700")
Message-ID: <87zk9jzdi5.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX185VEFukeiYCxnN32jwuZ8t9JQZGJ0gdoQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
	*  2.5 TO_NO_BRKTS_DIRECT To: misformatted and direct-to-MX
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;paulmck@linux.vnet.ibm.com
X-Spam-Relay-Country: XX
Subject: Re: [PATCH] vfs: Speed up deactivate_super for non-modular filesystems
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:

> On Mon, May 07, 2012 at 11:17:06PM +0100, Al Viro wrote:
>> On Mon, May 07, 2012 at 02:51:08PM -0700, Eric W. Biederman wrote:
>> 
>> > /proc and similar non-modular filesystems do not need a rcu_barrier
>> > in deactivate_locked_super.  Being non-modular there is no danger
>> > of the rcu callback running after the module is unloaded.
>> 
>> There's more than just a module unload there, though - actual freeing
>>  struct super_block also happens past that rcu_barrier()...

Al.  I have not closely audited the entire code path but at a quick
sample I see no evidence that anything depends on inode->i_sb being
rcu safe.  Do you know of any such location?

It has only been a year and a half since Nick added this code which
isn't very much time to have grown strange dependencies like that.

> Is there anything in there for which synchronous operation is required?
> If not, one approach would be to drop the rcu_barrier() calls to a
> workqueue or something similar.

We need to drain all of the rcu callbacks before we free the slab
and unload the module.

This actually makes deactivate_locked_super the totally wrong place
for the rcu_barrier.  We want the rcu_barrier in the module exit
routine where we destroy the inode cache.

What I see as the real need is the filesystem modules need to do:
	rcu_barrier()
	kmem_cache_destroy(cache);

Perhaps we can add some helpers to make it easy.  But I think
I would be happy today with simply moving the rcu_barrier into
every filesystems module exit path, just before the file system
module destoryed it's inode cache.

Eric

