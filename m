Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab0C2U0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:26:47 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:53815 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512Ab0C2U0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:26:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GRvdkVCWUKaIKvfLvenHr5twPyhutCV0aDGFugGk7ZC8UnSPrulcwSiNVIjJJeDl2R
         MWzeKxUddb/cKFBQb3rfQgoAmyJlfrhdtGkLjMUgf6EbRMXJDpAKBhu/QUkGcsc9Z9au
         NpoI62pgYZVnH3PZoHOBnOANHBoj0oI2ADlHM=
Subject: Re: [PATCH] NFS: Fix RCU warnings in
 nfs_inode_return_delegation_noreclaim() [ver #2]
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: paulmck@linux.vnet.ibm.com, Trond.Myklebust@netapp.com,
       linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <23274.1269893706@redhat.com>
References: <20100329192159.GM2569@linux.vnet.ibm.com>
	 <20100319022527.GC2894@linux.vnet.ibm.com>
	 <20100318133302.29754.1584.stgit@warthog.procyon.org.uk>
	 <19192.1269889348@redhat.com>  <23274.1269893706@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 22:26:40 +0200
Message-ID: <1269894400.1958.76.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 29 mars 2010 à 21:15 +0100, David Howells a écrit :
> My objection to using rcu_dereference_check() here is that it's a dynamic
> check: the compiler emits code to do it, since the lock/unlock status of what
> the pointer points to cannot be determined easily at compiler time - and then
> the barrier is interpolated anyway unnecessarily.
> 

Then in this case, use either a condition ORing all possibilities,
or just use rcu_dereference_raw() because its just too complex ?

ptr = rcu_dereference_check(xxx->ptr,
			    rcu_read_lock_held() ||
			    lockdep_is_held(&some_global_lock) ||
			    lockdep_is_held(&xxx->lock));

OR

/* This is too complex to check what protects us at this point */
ptr = rcu_dereference_raw(xxx->ptr);



