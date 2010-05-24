Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab0EYHvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 03:51:45 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41157 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753247Ab0EYHvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 03:51:43 -0400
Date: Mon, 24 May 2010 23:24:23 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, salvet@ics.muni.cz
Subject: Re: Deadlock in NFSv4 in all kernels
Message-ID: <20100524212422.GA1286@ucw.cz>
References: <20100507153920.GP28167@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100507153920.GP28167@ics.muni.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I encountered the following problem. We use short expiration time for
> kerberos contexts created by rpc.gssd (some patches were included in mainline
> nfs-utils). In particular, we use 120secs expiration time.
> 
> Now, I run application that eats 80% of available RAM. Then I run 10 parallel
> dd processes that write data into NFS4 volume with sec=krb5.
> 
> As soon as the kerberos context expires (i.e., up to 120 secs), the whole
> system gets stuck in do_page_fault and succesive functions. It is because
> there is no free memory in kernel, all free memory is used as cache for NFS4
> (due to dd traffic), kernel ask NFS to write back its pages but NFS cannot do
> anything as it is missing valid context. NFS contacts rpc.gssd to provide
> a renewed context, the rpc.gssd does not provide the context as it needs some memory
> to scan /tmp for a ticket. I.e., it deadlocks.
> 
> Longer context expiration time is no real solution as it only makes the
> deadlock less often. 
> 
> Any ideas what can be done here? (Please cc me.) We could preallocate some
> memory in rpc.gssd and use mlockall but not sure whether this proctects also
> kernel malloc for things related to rpc.gssd and context creation (new file
> descriptors and so on). 
> 
> This is seen in 2.6.32 kernel but most probably this is related to all kernel
> versions.

Seems like pretty fundamental problem in nfs :-(. Limiting writeback
caches for nfs, so that system has enough memory to perform rpc calls
with the rest might do the trick, but...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
