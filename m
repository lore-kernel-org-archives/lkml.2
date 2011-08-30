Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab1H3Qnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 12:43:41 -0400
Received: from orbit.nwl.cc ([91.121.141.167]:51444 "EHLO orbit.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab1H3Qnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 12:43:39 -0400
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Tue, 30 Aug 2011 12:43:39 EDT
Date: Tue, 30 Aug 2011 18:33:42 +0200
From: Phil Sutter <phil@nwl.cc>
To: Nikos Mavrogiannopoulos <nmav@gnutls.org>
Cc: cryptodev-linux-devel@gna.org,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [Cryptodev-linux-devel] comparison of the AF_ALG interface
 with the  /dev/crypto
Message-ID: <20110830163342.GC2615@orbit.nwl.cc>
Mail-Followup-To: Nikos Mavrogiannopoulos <nmav@gnutls.org>,
	cryptodev-linux-devel@gna.org,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	linux-kernel@vger.kernel.org
References: <4E5A3FCC.2030504@gnutls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E5A3FCC.2030504@gnutls.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Aug 28, 2011 at 03:17:00PM +0200, Nikos Mavrogiannopoulos wrote:
>   I've compared the cryptodev [0] and AF_ALG interfaces in terms of
> performance [1]. I've put the results, as well as the benchmarks used
> in: http://home.gna.org/cryptodev-linux/comparison.html

Well done, Nikos!

I did a short verification of your results on a (bit older) Via Eden
running at 1GHz (with padlock enabled, of course). I just ran the
cryptodev "fulltest" and  af_alg "aes", so this should relate to the
overall-test using splice. Here are the numbers:

chunksize        cryptodev       af_alg    
-------------------------------------------
512              15.34 MB/s      12.32 MB/s
1024             30.01 MB/s      24.22 MB/s
2048             57.29 MB/s      46.85 MB/s
4096            103.13 MB/s      87.29 MB/s
8192            174.08 MB/s     150.04 MB/s
16384             0.27 GB/s       0.23 GB/s
32768             0.35 GB/s       0.32 GB/s
65536             0.42 GB/s       0.38 GB/s

So at it's best (512byte chunks), cryptodev is about 25% faster. The
worst case is with 32kbyte chunks, then cryptodev is only 9% faster.

> The AF_ALG appears to have poor performance comparing to cryptodev. Note
> that the test with software AES is not really indicative because the
> cost of software encryption masks the overhead of the framework. The
> difference is clearly seen in the NULL cipher that has no cost (as one
> would expect from a hardware cipher accelerator).

Not really. Indeed, a crypto engine accelerates the actual encryption.
But another important benefit of CPU-separate (unlike padlock) engines
is the offloading of that work, so the CPU can do other things in the
mean time. E.g. handling the less efficient userspace interface. ;)
OK, just kidding - in reality you always need to do init and fini stuff
before and after the actual crypto operation to get any result at all.
Skipping the middle should allow for measuring the rest.

> Given my benchmarks have no issues, it is not apparent to me why one
> should use AF_ALG instead of cryptodev. I do not know though why AF_ALG
> performs so poor. I'd speculate by blaming it on the usage of the socket
> API and the number of system calls required.

Interestingly, the splice variant is outrun by regular AF_ALG on small
buffers. I don't know if there is something wrong with the code, but
according to some old benchmarks I found, cryptodev with zero-copy
enabled got faster in every situation (even with 16byte buffers).

Greetings, Phil
