Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754558Ab2H0UxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 16:53:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53643 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761Ab2H0UxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 16:53:19 -0400
Message-ID: <503BDE58.60101@suse.com>
Date: Mon, 27 Aug 2012 16:53:44 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Russell King <rmk@arm.linux.org.uk>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.kumar@st.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Garzik <jgarzik@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Bhupesh Sharma <bhupesh.sharma@st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Mike Turquette <mturquette@linaro.org>,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] clk.h: Fix shim ifdef guard (HAVE_CLK -> COMMON_CLK)
References: <503B920F.30509@suse.com> <20120827185248.GE25321@flint.arm.linux.org.uk>
In-Reply-To: <20120827185248.GE25321@flint.arm.linux.org.uk>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 8/27/12 2:52 PM, Russell King wrote:
> On Mon, Aug 27, 2012 at 11:28:15AM -0400, Jeff Mahoney wrote:
>> Commit 93abe8e4 (clk: add non HAVE_CLK routines) added shims for 
>> the clk code but HAVE_CLK isn't enough. It's possible to have
>> the clk support but not enable it. We end up with full prototypes
>> for code that is never built - causing module linking to fail
>> later.
>> 
>> This patch changes the guard to use COMMON_CLK, which actually
>> guards the code.
> 
> This is wrong.  COMMON_CLK is an _implementation_ of the CLK API.
> It is not the only implementation in the kernel.  Conditionalizing
> like this breaks existing users.
> 
> HAVE_CLK is the right thing here - if you define HAVE_CLK then you
> _are_ providing an implementation of clk_get() et.al.  If you're
> not, then you do not define HAVE_CLK.  Simples.
> 

Ok. Thanks for the feedback.

It would seem, then, that the powerpc clock implementation doesn't
implement the full API and that's where we're running into problems.

Specifically, the use of clk_devm_get in
drivers/usb/chipidea/ci13xxx_imx.c and
drivers/char/hw_random/exynos-rng.ko is causing module link errors on
powerpc configs for the EFIKA hardware. The EXYNOS RNG driver should
probably have a dependency on ARCH_EXYNOS. The chipidea driver looks
like it was developed on ARM hardware - does it exist anywhere else?

Should the clk_devm stuff be moved someplace generic? I don't have a
horse in this race. My only interest here is to get these configs to
build again. :)

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.18 (Darwin)
Comment: GPGTools - http://gpgtools.org
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJQO95XAAoJEB57S2MheeWy+QQQAK8HRdlhtyj3yy9S1zQ8c15x
72xwM52Yhhwl1L4OsuD4oNjzwGxj54j7VMfe9TMkrrozC7eySlnm3ErSnVNfn6Dp
RnUvjAs+Wr9vYR18f3IgFrYMnu2M3PkxBFciv/K94soCZ90iKuFs6yebqtkVUzP3
XfVmVdJpJpe+GXvGBW7lo8PfZNyLbxhleTqSXftTszuLcTlF8361aZmxz3UKpiWD
EB5a079s1CKf1KAu61P0drEIVHgAayffHjm4TDAE3AYzM7nwcvqjZQcjxSfI9eHF
iPOeS0Kt2+9TrLJjp9p/dZX3dLFHhG5LtS6qZq372JVjZggPGknAdV/MK33qEzuN
Fnr+ag5DeB/Kujfw2NcC+RQoayrMBK52eSxZO451xwHZef0+JP2eVLhht9zfmzDh
4cRj6gybKklEry/kABhy5O59iNVrjn+WrbVFwGO5aezZbAoqnZm2Sb5pU6aDLV6m
p3IMTfFMA13rh8sn/XstFN50T2xG4SP1DMqiV6AbfcfSXyRM0vQ9etOkfjp2ftq+
blbjwNBVp8Hp47q04LIw1XPxDMOEpBX6bVFiIqOWT9GvhvFysetNpB6Ae00FIo7p
1Zdv0Bq9IkWhZ+BxLeqgMUO445GIqUk7k2AElI8G3cCIKZlNp5Od/hFx7rQJ6Gwq
dqydYWi1ogVqg3YpSI7a
=/UyR
-----END PGP SIGNATURE-----
