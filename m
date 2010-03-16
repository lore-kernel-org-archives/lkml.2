Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966447Ab0CPOy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:54:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51402 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966448Ab0CPOyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:54:23 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: Re: howto combat highly pathologic latencies on a server?
Date: Tue, 16 Mar 2010 15:54:16 +0100
User-Agent: KMail/1.9.10
Cc: Christoph Hellwig <hch@infradead.org>
References: <201003101817.42812.hpj@urpla.net> <20100310181548.GA25684@infradead.org> <201003110115.14555.hpj@urpla.net>
In-Reply-To: <201003110115.14555.hpj@urpla.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003161554.16485.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1/wQb2JWilBwb84PU32CyRG0ExenSS8vN2YBwS
 4jSWEt0cNN8pnn4jTbfuVi7IC21W1NgKrfQwzGfkPQ/NePDkyX
 RsAkNPTtS9phC2DaIDFfg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 March 2010, 01:15:14 Hans-Peter Jansen wrote:
> On Wednesday 10 March 2010, 19:15:48 Christoph Hellwig wrote:
> > On Wed, Mar 10, 2010 at 06:17:42PM +0100, Hans-Peter Jansen wrote:
> > > While this system usually operates fine, it suffers from delays, that
> > > are displayed in latencytop as: "Writing page to disk:     8425,5
> > > ms": ftp://urpla.net/lat-8.4sec.png, but we see them also in the
> > > 1.7-4.8 sec range: ftp://urpla.net/lat-1.7sec.png,
> > > ftp://urpla.net/lat-2.9sec.png, ftp://urpla.net/lat-4.6sec.png and
> > > ftp://urpla.net/lat-4.8sec.png.
> > >
> > > >From other observations, this issue "feels" like it is induced by
> > > > single
> > >
> > > syncronisation points in the block layer, eg. if I create heavy IO
> > > load on one RAID array, say resizing a VMware disk image, it can take
> > > up to a minute to log in by ssh, although the ssh login does not
> > > touch this area at all (different RAID arrays). Note, that the
> > > latencytop snapshots above are made during normal operation, not this
> > > kind of load..
> >
> > I had very similar issues on various systems (mostly using xfs, but
> > some with ext3, too) using kernels before ~ 2.6.30 when using the cfq
> > I/O scheduler.  Switching to noop fixed that for me, or upgrading to a
> > recent kernel where cfq behaves better again.
>
> Christoph, thanks for this valuable suggestion: I've changed it to noop
> right away, and also:
>
> vm.dirty_ratio = 20
> vm.dirty_background_ratio = 1
>
> since the defaults of 40 and 10 seem to also not fit my needs. Even the
> 20 might be still oversized with 8GB total mem.

That was an bad idea. I've reverted the vm tweaks, as it turned things even 
worser.

After switching to noop and activating lazy count on all filesystems, the 
pathologic behavior with running io hooks seems to be relieved, but the 
latency due to VMware-Server persists: 

Cause                                                Maximum     Percentage
Writing a page to disk                            435.8 msec          9.9 %
Writing buffer to disk (synchronous)              295.3 msec          1.6 %
Scheduler: waiting for cpu                         80.1 msec         11.7 %
Reading from a pipe                                 9.3 msec          0.0 %
Waiting for event (poll)                            5.0 msec         76.2 %
Waiting for event (select)                          4.8 msec          0.4 %
Waiting for event (epoll)                           4.7 msec          0.0 %
Truncating file                                     4.3 msec          0.0 %
Userspace lock contention                           3.3 msec          0.0 %

Process vmware-vmx (7907)                  Total: 7635.8 msec                                                           
Writing a page to disk                            435.8 msec         43.8 %
Scheduler: waiting for cpu                          9.1 msec         52.7 %
Waiting for event (poll)                            5.0 msec          3.5 %
[HostIF_SemaphoreWait]                              0.2 msec          0.0 %

Although, I set writeThrough to "FALSE" on that VM, and it is operating on a 
monolithic flat 24 GB "drive" file, it's not allowed to swap, and it's 
itself only lightly used, it always writes (? whatever) synchronously and 
trashes the latency of the whole system. (It's nearly always the one, that 
latencytop shows, with combined latencies ranging from one to eigth secs.)

I would love to migrate that stuff to a saner VM technology (e.g. kvm), but 
unfortunately, the Opteron 285 cpus are socket 940 based, and thus not 
supported by any current para-virtualisation. Correct me, if I'm wrong, 
please.

This VMware Server 1.0.* stuff is also getting in the way on trying to 
upgrade to a newer kernel. The only way getting up the kernel stairs might 
be VMware Server 2, but without serious indications, that it works way 
better, I won't take that route. Hints welcome.

Upgrading the hardware combined with using ssd drives seems the only really 
feasible approach, but given the economic preassure in the transport 
industry, that's currently not possible, either. 

Anyway thanks for your suggestions,
Pete
