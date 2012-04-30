Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270Ab2D3DlE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 23:41:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:57698 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755089Ab2D3DlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 23:41:02 -0400
Message-ID: <1335757246.20866.31.camel@pasglop>
Subject: Re: [REGRESSION][PATCH V4 3/3] bpf jit: Let the powerpc jit handle
 negative offsets
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: kaffeemonster@googlemail.com, eric.dumazet@gmail.com, matt@ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date: Mon, 30 Apr 2012 13:40:46 +1000
In-Reply-To: <1335753820.20866.27.camel@pasglop>
References: <4F75CA89.4010709@googlemail.com>
	 <4F75D2A5.7060407@googlemail.com>
	 <20120403.180302.342779808900865443.davem@davemloft.net>
	 <1333491102.3040.12.camel@pasglop> <1335753820.20866.27.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-30 at 12:43 +1000, Benjamin Herrenschmidt wrote:

> Ok, he hasn't so I'll dig a bit.
> 
> No obvious wrongness (but I'm not very familiar with bpf), though I do
> have a comment: sk_negative_common() and bpf_slow_path_common() should
> be made one and single macro which takes the fallback function as an
> argument.
> 
> I'll mess around & try to test using Jan test case & will come back
> with an updated patch.

Wow, hit that nasty along the way: The test program will not work
on big endian machines because of a nasty difference between
the kernel struct sock_fprog and libpcap struct bpf_program:

Kernel expects:

struct sock_fprog {     /* Required for SO_ATTACH_FILTER. */
        unsigned short          len;    /* Number of filter blocks */
        struct sock_filter __user *filter;
};

libpcap provides:

struct bpf_program {
        u_int bf_len;
        struct bpf_insn *bf_insns;
};

Note the unsigned short vs. unsigned int there ? This totally
breaks it here.

Is it expected that one can pass a struct bpf_program directly
to the kernel or should it be "converted" by the library in which
case it's just a bug in Jan's test program ?

Cheers,
Ben.


