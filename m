Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab1FGQDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 12:03:04 -0400
Received: from nm27-vm0.access.bullet.mail.mud.yahoo.com ([66.94.236.227]:34615
	"HELO nm27-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753189Ab1FGQDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:03:03 -0400
X-Greylist: delayed 355 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jun 2011 12:03:03 EDT
X-Yahoo-Newman-Id: 328926.74983.bm@omp1001.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zwtb.24VM1kPrm9HlYWNcDf7MK6ZKX1wY8fmmds95hpU7u2
 aYnTevhLm5YGNn.0ub0zgjpgfPfGL8KLRrHsvIqB.FpetKMGIpLdj_oj6V7M
 wONHT1VZgz4ZIT5xCTrgr8hx.SR03bOjxsz4HKUPEEEq3sZnam1yevJGebpU
 6Qr_JTL2jTPU3a5KQVgRKVMTRL2DW_XKqfnLjnD58Se76BBADNbKnusPq2qa
 3TrGZ2mBjSWUzGtZ_VyfZQ_LeYrZyBwHqWVscA8QmZHi7ZF.xCeleOSzT.cr
 X2hn0hdXiTDYVDg6OvDNbadnUA2mupoiEnlc1TIt2wFnM3hFeDEfDqXos1s5
 lZsFFTphRfQ7Dos.d2cii8C7mCPqbmsvD1k9XJgZqFkrwWYdY1wN7aOy_.28
 4oVXr4x.YrKwip3lHNbHDj5fQGDc214XCbCYteBbDQ44Cxck-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4DEE4A39.9010003@schaufler-ca.com>
Date: Tue, 07 Jun 2011 08:56:41 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
CC: Dave Chinner <david@fromorbit.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.s.kasatkin@gmail.com>,
        Mimi Zohar <zohar@us.ibm.com>,
        Sunil Mushran <sunil.mushran@oracle.com>,
        Tiger Yang <tiger.yang@oracle.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        David Howells <dhowells@yahoo-wildcard.a05.yahoodns.net>
Subject: Re: [PATCH v6 08/20] evm: evm_inode_post_init
References: <1307017423-15093-1-git-send-email-zohar@linux.vnet.ibm.com>	 <1307017423-15093-9-git-send-email-zohar@linux.vnet.ibm.com>	 <20110603022100.GA561@dastard>	 <1307077592.3124.65.camel@localhost.localdomain>	 <20110604235058.GN32466@dastard> <1307241985.3189.71.camel@localhost.localdomain>
In-Reply-To: <1307241985.3189.71.camel@localhost.localdomain>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 2011-06-05 at 09:50 +1000, Dave Chinner wrote:
>> On Fri, Jun 03, 2011 at 01:06:32AM -0400, Mimi Zohar wrote:
>>> On Fri, 2011-06-03 at 12:21 +1000, Dave Chinner wrote:
>>>> On Thu, Jun 02, 2011 at 08:23:31AM -0400, Mimi Zohar wrote:
>>>>> Initialize 'security.evm' for new files. Reduce number of arguments
>>>>> by defining 'struct xattr'.
>>>> why does this need a new security callout from every filesystem?
>>>> Once the security xattr is initialised, the name, len and value is
>>>> not going to change so surely the evm xattr can be initialised at
>>>> the same time the lsm xattr is initialised.
>>> Steve Whitehouse asked a similar question, suggesting that
>>> security_inode_init_security() return a vector of xattrs to minimize the
>>> number of xattr writes.  Casey pointed out the "stacking" of LSMs will
>>> result in multiple calls to security_inode_init_security(), once for
>>> each LSM. The conclusion (http://lkml.org/lkml/2011/5/19/125) was:
>>>
>>> Moving evm_inode_init_security() into security_inode_init_security()
>>> only works for the single LSM and EVM case, but not for the multiple
>>> LSMs and EVM case, as the 'stacker' would call each LSM's
>>> security_inode_iint_security().  Having the 'stacker' return an array of
>>> xattrs would make sense and, at the same time, resolve the EVM issue. In
>>> evm_inode_post_init_security(), EVM could then walk the list of xattrs.
>> But that does not change the fact that ther eis a _single external
>> call_ from the filesystem to security_inode_init_security(), and the
>> attribute (array) that it returns is only read by
>> evm_inode_post_init_security() to calculate a new attribute.
>>
>> If evm_inode_post_init_security() only needs to read the security
>> attributes, then why does it need to be calculated _after_ the
>> security attributes are written to the filesystem inode?
>>
>> i.e, your current code is:
>>
>> 	security_inode_init_security(&lsm_xattr)
>> 	set_xattr(&lsm_xattr)
>> 	evm_inode_post_init_security(&lsm_xattr, &evm_xattr)
>> 	set_xattr(&evm_xattr)
>>
>> and I'm asking why you can't do it like this:
>>
>>
>> 	security_inode_init_security(&lsm_xattr, &evm_xattr)
>> 	set_xattr(&lsm_xattr)
>> 	set_xattr(&evm_xattr)
>>
>> where security_inode_init_security() calls:
>>
>> 	evm_inode_post_init_security(&lsm_xattr, &evm_xattr)
>>
>> before returning to calculate the evm xattr?
> Steve was suggesting to optimize set_xattr(), by passing an array of
> xattrs, but this would work in the single LSM case.
>
>> Indeed, if we are stacking LSMs, the iteration must occur internally
>> to security_inode_init_security(), and so that would mean the entire
>> stacking/multiple attr thing could be handled simply by passing an
>> array and having the EVM xattr always be the last in the array.
> EVM would need access to the entire array of xattrs in order to
> calculate the single security.evm value.
>
>> i.e.:
>>
>> XXXfs_init_security()
>> {
>> 	xattr_count = security_inode_init_security(&xattr_array)
>>
>> 	for (i = 0; i < xattr_count; i++)
>> 		set_xattr(&xattr_array[i])
>>
>> 	security_free_xattr(&xattr_array);
>> }
> I might be missing something, but this doesn't look right.
> security_inode_init_security() needs to be called for each LSM that
> registers this hook.  Then after all the security_inode_init_security()
> calls are made, for performance, a single call to set_xattr(), with the
> array of xattrs, could be made.

This would require that the individual LSMs know if they are being
"stacked". If the LSM is not part of a "stack" it needs to call
set_xattr() where if it is part of a "stack" it mustn't. It's actually
worse than that, because if an LSM has a mumble_inode_init_security()
hook it might require a call to set_xattr(), but it might not if it
does not use xattrs, and now the "stacker" needs to know about which
LSMs have hooks that it cares about, as opposed to just which ones
have hooks. I suggest that you will likely lose any performance gained
within an individual LSM to the additional overhead of checking to
see what environment it is in.

Conceptually, a "stacker" should be as dumb as possible, leaving all
interactions with other subsystems to the underlying LSMs. Also, as
others have pointed out on multiple occasions, if you've got "stacked"
LSMs you are likely to have performance issues well in excess of
what this particular optimization is going to address.

> Could evm_inode_post_init_security() be called before the set_xattr()?
> That would depend on the "stacker" implementation.  David? Casey?

It also depends on the integrity implementation, which is NOT an LSM.
 

>> And then the filesystems need to know _nothing at all_ about the
>> internals of the security subsystem or how it uses xattrs or even
>> whether EVM is enabled or active or neither. This is far cleaner
>> than spewing security-flavour-of-the-month junk widely across the
>> tree...
> Agreed, it would be a lot cleaner.
>
>> This also makes it possible for the filesystems to atomically set or
>> fail to set all the security attributes in one
>> operation/transaction, which will help guarantee the integrity of
>> the system in the face of externally induced failures.
>>
>>>> Then all you need to do in each filesystem is add the evm_xattr
>>>> structure to the existing security init call and a:
>>>>
>>>> #ifdef CONFIG_EVM
>>>> 	/* set evm.xattr */
>>>> #endif
>>>>
>>>> to avoid adding code that is never executed when EVM is not
>>>> configured into the kernel.
>>>>
>>>> That way you don't create the lsm_xattr at all if the evm_xattr is
>>>> not created, and then the file creation should fail in an atomic
>>>> manner, right?  i.e. you don't leave files with unverified security
>>>> attributes around when interesting failure corner cases occur (e.g.
>>>> ENOSPC).
>>> That would imply EVM must be enabled for all LSMs that define a security
>>> xattr.  That's definitely a good goal, but probably not a good idea for
>>> right now.
>>>
>>>> And while you are there, it's probably also be a good idea to add
>>>> support for all filesystems that support xattrs, not just a random
>>>> subset of them...
>>>>
>>>> Cheers,
>>>>
>>>> Dave.
>>> The EVM xattr is initialized based on the LSM xattr.  At this point, as
>>> far as I'm aware, the only remaining filesystems that call
>>> security_inode_init_security() to initialize the LSM xattr, are ocfs2
>>> and reiserfs.  Both of which might have memory leaks.  Tiger Yang is
>>> addressing the memory leak for ocfs2.
>> I don't follow you - I didn't see any patches that remove
>> security_inode_init_security() from any of the filesystems, so they
>> all still call that function....
>>
>> Cheers,
>>
>> Dave.
> Sorry, it should have read the only remaining filesystems that call
> security_inode_init_security() to initialize the LSM xattr, that don't
> call evm_inode_post_init_security() afterwards, are ocfs2 and reiserfs.
>
> The point being it's not "just a random subset of them ..."
>
> thanks,
>
> Mimi
>
>

