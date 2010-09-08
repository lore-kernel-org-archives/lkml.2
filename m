Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab0IHVAG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 17:00:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57784 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238Ab0IHVAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 17:00:03 -0400
Message-ID: <4C87F943.4080209@zytor.com>
Date: Wed, 08 Sep 2010 13:59:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Matteo Croce <matteo@openwrt.org>
CC: Thomas Backlund <tmb@mandriva.org>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Natale Vinto <ebballon@gmail.com>
Subject: Re: AMD Geode NOPL emulation for kernel 2.6.36-rc2
References: <AANLkTinq81V6afODRS26Nk1vi68_VUMAfs-tu-P8=dBP@mail.gmail.com> <4C780888.9000301@zytor.com> <AANLkTikCssQSvRX1Gfq0V8B91Sp2gtTCJaPJ=_n9VJXZ@mail.gmail.com> <4C7824F2.1050709@mandriva.org> <AANLkTinjHK-oTmt-6cmN16jWWv9ZjW44wA-A3VTLm+A_@mail.gmail.com> <4C784544.2010305@zytor.com> <AANLkTikaRkwPqB0u3OWknKpG2grZmDR976CBVz7jyVWC@mail.gmail.com>
In-Reply-To: <AANLkTikaRkwPqB0u3OWknKpG2grZmDR976CBVz7jyVWC@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29/2010 06:39 AM, Matteo Croce wrote:
> If the parsing fails due get_user returning error I call
> `do_invalid_op(regs, error_code);`
> which is the default handler, which does the page fault.

No, it doesn't.  It does an SIGILL, not a SIGSEGV.  An application which
does its own VM management depends on the difference.

Also, you only test for specific forms of NOPL, whereas the right thing
is to recognize the overall forms, not just byte sequences.

> to check the CS I do `regs->cs != __USER_CS` but how to check the IP value?
> convert_ip_to_linear() and then check something?

get_user() will check for the validity of a linear address, and yes,
convert_ip_to_linear() should give you the linear address to check for.
 However, you also have to check for the CPU mode, since the byte
sequences mean different things in 16-, 32- and 64-bit mode.

All of this is why I'm extremely reluctant to allow in an ad hoc hack
like this one ... there just are way too many pitfalls, any of which can
turn into a security hole.

	-hpa
