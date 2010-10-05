Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869Ab0JENXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 09:23:23 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35405 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab0JENXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 09:23:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Xg/SBeg61VaqZYYwoyrQ6g4OX5gXkl1ml+B4wKOTr9FOqTYpusjtXzFOpQGrd7ZHoH
         urO4ZcH4YAjjdEkTj2/tLxdG5kpUqxkpMjVM/oHcjja45N7AJkz9vKxvDOHmzvfoj2qq
         vg5aVB6IKjGN8yUdJP7t20oMImvR5fU3s8TZk=
Message-ID: <4CAB26C7.2020109@gmail.com>
Date: Tue, 05 Oct 2010 06:23:19 -0700
From: Kent Overstreet <kent.overstreet@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9pre) Gecko/20100821 Lanikai/3.1.3pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Greg KH <greg@kroah.com>
Subject: [RFC] Potential kobject functionality (two stage delete, single delete)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been working on reference counting in my own code, and it seemed to 
me that some of this stuff would be best added to the generic code - I 
can't be the only one who's needed to solve these particular problems. 
But kobjects aren't new, maybe someone knows if any of this has been 
tried before?

The easy one would be a flag marking an object as deleted when there's 
still references. The idea is if you've got multiple unserialized ways 
of closing/deleting something - error handling paths and/or a way for a 
user to request that it be closed - you need to make sure you drop only 
one reference.

This is trivial to handle without adding to the kobject code, but it 
seems to me it ought to be common enough to warrant adding it - I 
wouldn't be surprised if there's driver code that doesn't handle it 
correctly, it's easy enough to miss if you don't think about the 
particular case. We need to add an atomic bitflag to struct kobject; 
another callback in struct kobj_type might be useful too. Then something 
like the following should be it:

void kobject_delete(struct kobject *k)
{
	if (!test_and_set_bit(deleted)) {
		if (delete_fn)
			delete_fn(k);
		kobject_put(k);
	}
}

The more annoying one is two stage delete. Unless my google-fu has 
failed me, I don't see a reasonable way of using kobject refcounting if 
you need to drop a refcount from atomic context. Without modifying the 
kobject code, I'd have to have a second refcount and combined with RCU 
things become an unreadable mess of callbacks.

I think all that would be needed would be to add a flag to kobj_type 
indicating that the release function will call kobject_cleanup; the 
release function would then be free to punt to a workqueue.

The only potential problem I see is that either the code to remove a 
kobject from sysfs has to be made safe for atomic context, or you'd have 
dead kobjects sitting in sysfs an arbitrary amount of time - it looks 
like if this was a real issue it would be with the current code too 
though, if a callback for an attribute could take a reference to a kobject.

Comments? I'll work up some patches if no one convinces me either idea's 
insane.
