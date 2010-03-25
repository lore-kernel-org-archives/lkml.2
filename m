Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab0CYOCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:02:24 -0400
Received: from mail.artecdesign.ee ([195.50.213.123]:51419 "EHLO
	postikukk.artecdesign.ee" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab0CYOCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:02:23 -0400
X-Greylist: delayed 3106 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Mar 2010 10:02:22 EDT
Message-ID: <4BAB609A.9030407@artecdesign.ee>
Date: Thu, 25 Mar 2010 15:09:46 +0200
From: Anti Sullin <anti.sullin@artecdesign.ee>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Harro Haan <hrhaan@gmail.com>, Andrew Victor <avictor.za@gmail.com>
CC: Ryan Mallon <ryan@bluewatersys.com>, Remy Bohmer <linux@bohmer.net>,
       Andrew Victor <linux@maxim.org.za>,
       David Brownell <dbrownell@users.sourceforge.net>,
       H Hartley Sweeten <hartleys@visionengravers.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v3 2/3] at91_udc HW glitch
References: <20100203143736.564974126@gmail.com>	 <20100203143803.528679118@gmail.com>	 <cd73a99e1003231326r7623bbc0icba163f9b2e0e96e@mail.gmail.com> <6681f8e11003250503k20efc864ve6d916ad5a7c67b2@mail.gmail.com>
In-Reply-To: <6681f8e11003250503k20efc864ve6d916ad5a7c67b2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ADG-Spam-Score: -4.4 (----)
X-ADG-Spam-ScoreInt: -43
X-ADG-Spam-Report: Content analysis details:   (-4.4 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
X-ADG-ExiScan-Signature: ab4684dd8cf1a569b3f27c3f25c2be8e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harro Haan wrote:
> On 23 March 2010 21:26, Andrew Victor <avictor.za@gmail.com> wrote:
>> The at91_udc driver does not seem to do that for its CSR register writes.
>> So I was wondering if we implement what the datasheet says, would we
>> still need the "fix" above.

Another read is still needed after verifying that the flag is changed.

We are writing a bit that does not have a register behind it. It just
triggers the acknowledge that the data has been read.
We could poll if the corresponding data ready flag is cleared to check
if the write has propagated. But this leads to another problem:
the reads do not seem to be re-syncronized between clock domains.
We just get what is there at the moment the read is performed. This
means that even if the "data ready" bit is cleared, we could not be sure
at that moment that the rest of the changes have been performed
that were triggered by the same write. We even get reads, where
some bits in rx data counter have changed and some bits are old.
So to be fully sure, we should wait until the bit has been cleared
and then perform another read to be sure that the rest of the bits
have been changed as well. See my 2009-03-25 17:08 e-mail for details.

>From practical standpoint: I have not seen a case where the
second read was not ready. If this delay is adequate for the worst
case propagate time it takes for the bits to change, it is not
needed to read the register more than twice. I determined this
experimentally by reading the register 3 times right after write
and comparing the  2nd and 3rd read when doing different transfers
between PC and ARM. As I have tested it only on 9261, somebody should
either run the same kind of tests on other SoC's as well or figure
out the worst case timings on all of them.
The datasheet describes that some changes are performed in
3 USB clock + 3 master clock periods. If so, then one/some extra reads
could create the master-clock dependant small delay needed to
be sure that everything is ready.

Actually, this leads to a another problem. We are able to read the
rx fifo count when the bits are changing there. If some data is being
received at the very moment when we read the register, we're in
trouble. When some bits are old and some new, we can get values that
are larger or smaller than the actual value (ie 0111->1000 change).
This is a rare condition, but it might happen. Should this register
be read always twice to check that nothing was unstable during the
first read?

I would still leave in this extra read because it is known to be
unstable. If it is needed on some SoC's, we could read out the
register value until we get 2 same results to verify that it is
stable. But there is no point of reading the first (known bad) value.

-- 
Anti Sullin
Embedded Software Engineer
Artec Design LLC
Teaduspargi 6/2, 12618, Tallinn, Estonia
http://www.artecdesign.ee 

