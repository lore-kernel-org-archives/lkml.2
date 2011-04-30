Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389Ab1D3AOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 20:14:03 -0400
Received: from minus.inr.ac.ru ([194.67.69.97]:48347 "HELO ms2.inr.ac.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754492Ab1D3AOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 20:14:00 -0400
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Apr 2011 20:13:59 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=ms2.inr.ac.ru;
  b=OhFIXbBCoH/78S1k/BkcCCi0pyY8X4hTU0h+QdO1znwB8iMTEzxFKgyqet8PscsHP2Sb8z/UO0rvjPTIcJkMKpZyZOUp8EuDVBt87e2uRjKOf3lCKJmITrhDjjuVVktjKpkWfQ5gMPr4GsZ+Ws9fapcAiDp/dMx8wSgRPlQ7vro=;
Date: Sat, 30 Apr 2011 04:07:10 +0400
From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
To: John Gardiner Myers <jgmyers@proofpoint.com>
Cc: David Miller <davem@davemloft.net>, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: fix incorrect unregistration of sysctl when last ip deleted
Message-ID: <20110430000710.GA26995@ms2.inr.ac.ru>
References: <201104272312.p3RNCcl6002068@jgmyers-vm1.eng.proofpoint.com> <20110429.134524.116375005.davem@davemloft.net> <4DBB3480.9020708@proofpoint.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DBB3480.9020708@proofpoint.com>
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 02:58:24PM -0700, John Gardiner Myers wrote:
> If the device isn't going away, then the ip6_ptr shouldn't be zeroed, 
> the /proc/net/dev_snmp6 entry shouldn't be deregistered,

Actually, you are right. Tuned interface parameters and disabling/enabling IPv6
(or IP, or whatever) should be different things. We just did not have an interface
to disable protocol, but leave in*_dev, so that they were merged.

When doing this just keep in mind that addrconf_ifdown(how = 0) did _not_ mean
disabling IPv6. (Probably, it does now in fact, I do not know. But it definitely
did not mean this in the past).

Look, addrconf_ifdown(how = 0) was executed only when the physical device is down, so that we could
neither receive nor send over this interface. If the device is UP, addrconf_ifdown(how = 0)
did not prohibit sending/receiving IPv6. Actually, logically, addrconf_ifdown(how = 0)
on UP interface must be followed by immediate restart of autoconfiguration,
because interface is still actually UP. See?

So, to implement this you should verify that IPv6 packets are not sent/received over
disabled interface (at least over interface with illegal mtu :-)). And add some flag in in6_dev
meaning that IPv6 is actually disabled. So that f.e. after occasional
ifconfig eth0 down; ifconfig eth0 up autoconfiguration would not resume IPv6
(the thing which we could not even implement with destroying in6_dev, but definitely wanted).

Alexey
