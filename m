Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab0EYM2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 08:28:49 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:49158 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756578Ab0EYM2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 08:28:47 -0400
Subject: Re: Deadlock in NFSv4 in all kernels
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Pavel Machek <pavel@ucw.cz>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       salvet@ics.muni.cz
In-Reply-To: <20100524212422.GA1286@ucw.cz>
References: <20100507153920.GP28167@ics.muni.cz>
	 <20100524212422.GA1286@ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 May 2010 08:28:40 -0400
Message-ID: <1274790520.2949.20.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-2.fc13) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 6 msgs/h 1 sum rcpts/h 10 sum msgs/h 1 total rcpts 344 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: D89BC44D94F68E94067A966358B7542EBBB7DE62
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 171 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-24 at 23:24 +0200, Pavel Machek wrote: 
> Hi!
> 
> > I encountered the following problem. We use short expiration time for
> > kerberos contexts created by rpc.gssd (some patches were included in mainline
> > nfs-utils). In particular, we use 120secs expiration time.
> > 
> > Now, I run application that eats 80% of available RAM. Then I run 10 parallel
> > dd processes that write data into NFS4 volume with sec=krb5.
> > 
> > As soon as the kerberos context expires (i.e., up to 120 secs), the whole
> > system gets stuck in do_page_fault and succesive functions. It is because
> > there is no free memory in kernel, all free memory is used as cache for NFS4
> > (due to dd traffic), kernel ask NFS to write back its pages but NFS cannot do
> > anything as it is missing valid context. NFS contacts rpc.gssd to provide
> > a renewed context, the rpc.gssd does not provide the context as it needs some memory
> > to scan /tmp for a ticket. I.e., it deadlocks.
> > 
> > Longer context expiration time is no real solution as it only makes the
> > deadlock less often. 
> > 
> > Any ideas what can be done here? (Please cc me.) We could preallocate some
> > memory in rpc.gssd and use mlockall but not sure whether this proctects also
> > kernel malloc for things related to rpc.gssd and context creation (new file
> > descriptors and so on). 
> > 
> > This is seen in 2.6.32 kernel but most probably this is related to all kernel
> > versions.
> 
> Seems like pretty fundamental problem in nfs :-(. Limiting writeback
> caches for nfs, so that system has enough memory to perform rpc calls
> with the rest might do the trick, but...
> 

It's the same problem that you have for any file or storage system that
has initiators in userland. On the storage side, iSCSI in particular has
the same problem. On the filesystem side, CIFS, AFS, coda, .... do too.
The clustered filesystems can deadlock if the node that is running the
DLM runs out of memory...

A few years ago there were several people proposing various solutions
for allowing these daemons to run in a protected memory environment to
avoid deadlocks, but those efforts have since petered out. Perhaps it is
time to review the problem?

Cheers
  Trond

