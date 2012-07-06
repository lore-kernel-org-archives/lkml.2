Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910Ab2GFQXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 12:23:32 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:22104 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756856Ab2GFQXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 12:23:30 -0400
Message-ID: <4FF710FD.2090100@hp.com>
Date: Fri, 06 Jul 2012 09:23:25 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>
CC: mst@redhat.com, mashirle@us.ibm.com, krkumar2@in.ibm.com,
        habanero@linux.vnet.ibm.com, rusty@rustcorp.com.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        tahm@linux.vnet.ibm.com, jwhan@filewood.snu.ac.kr, davem@davemloft.net,
        akong@redhat.com, kvm@vger.kernel.org, sri@us.ibm.com
Subject: Re: [net-next RFC V5 0/5] Multiqueue virtio-net
References: <1341484194-8108-1-git-send-email-jasowang@redhat.com> <4FF5D2B7.6080602@hp.com> <4FF696C9.5070907@redhat.com>
In-Reply-To: <4FF696C9.5070907@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/06/2012 12:42 AM, Jason Wang wrote:
> I'm not expert of tcp, but looks like the changes are reasonable:
> - we can do full-sized TSO check in tcp_tso_should_defer() only for
> westwood, according to tcp westwood
> - run tcp_tso_should_defer for tso_segs = 1 when tso is enabled.

I'm sure Eric and David will weigh-in on the TCP change.  My initial 
inclination would have been to say "well, if multiqueue is draining 
faster, that means ACKs come-back faster, which means the "race" between 
more data being queued by netperf and ACKs will go more to the ACKs 
which means the segments being sent will be smaller - as TCP_NODELAY is 
not set, the Nagle algorithm is in force, which means once there is data 
outstanding on the connection, no more will be sent until either the 
outstanding data is ACKed, or there is an accumulation of > MSS worth of 
data to send.

>> Also, how are you combining the concurrent netperf results?  Are you
>> taking sums of what netperf reports, or are you gathering statistics
>> outside of netperf?
>>
>
> The throughput were just sumed from netperf result like what netperf
> manual suggests. The cpu utilization were measured by mpstat.

Which mechanism to address skew error?  The netperf manual describes 
more than one:

http://www.netperf.org/svn/netperf2/trunk/doc/netperf.html#Using-Netperf-to-Measure-Aggregate-Performance

Personally, my preference these days is to use the "demo mode" method of 
aggregate results as it can be rather faster than (ab)using the 
confidence intervals mechanism, which I suspect may not really scale all 
that well to large numbers of concurrent netperfs.

I also tend to use the --enable-burst configure option to allow me to 
minimize the number of concurrent netperfs in the first place.  Set 
TCP_NODELAY (the test-specific -D option) and then have several 
transactions outstanding at one time (test-specific -b option with a 
number of additional in-flight transactions).

This is expressed in the runemomniaggdemo.sh script:

http://www.netperf.org/svn/netperf2/trunk/doc/examples/runemomniaggdemo.sh

which uses the find_max_burst.sh script:

http://www.netperf.org/svn/netperf2/trunk/doc/examples/find_max_burst.sh

to pick the burst size to use in the concurrent netperfs, the results of 
which can be post-processed with:

http://www.netperf.org/svn/netperf2/trunk/doc/examples/post_proc.py

The nice feature of using the "demo mode" mechanism is when it is 
coupled with systems with reasonably synchronized clocks (eg NTP) it can 
be used for many-to-many testing in addition to one-to-many testing 
(which cannot be dealt with by the confidence interval method of dealing 
with skew error)

>> A single instance TCP_RR test would help confirm/refute any
>> non-trivial change in (effective) path length between the two cases.
>>
>
> Yes, I would test this thanks.

Excellent.

happy benchmarking,

rick jones

