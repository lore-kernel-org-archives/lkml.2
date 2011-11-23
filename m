Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab1KWQPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:15:05 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:46674 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555Ab1KWQPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:15:03 -0500
X-Greylist: delayed 511 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Nov 2011 11:15:03 EST
Message-ID: <4ECD1A01.3060503@mev.co.uk>
Date: Wed, 23 Nov 2011 16:06:25 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111121 Thunderbird/8.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Xi Wang <xi.wang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Mori Hess <fmhess@users.sourceforge.net>,
        "security@kernel.org" <security@kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ian Abbott <ian.abbott@mev.co.uk>,
        Franky Lin <frankyl@broadcom.com>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>,
        Mark Pearson <markpearson_de@yahoo.de>
Subject: Re: [PATCH] comedi: integer overflow in do_insnlist_ioctl()
References: <5C0D372F-F03E-4EB8-8440-83A8D1C95363@gmail.com> <20111123061355.GA3295@mwanda> <CAKU6vyZdC64piK-mn6kLMt1-RhhM8D-4KbAGxje087FJ9X=fNA@mail.gmail.com> <20111123145020.GA3258@mwanda>
In-Reply-To: <20111123145020.GA3258@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-23 14:50, Dan Carpenter wrote:
> On Wed, Nov 23, 2011 at 08:59:52AM -0500, Xi Wang wrote:
>> Thanks for the pointer.  However you cannot do the overflow check using
>>
>>    if (sizeof(struct comedi_insn) * insnlist.n_insns <  insnlist.n_insns)
>>
>> Let's assume 32-bit system, sizeof(struct comedi_insn) = 32, and
>> insnlist.n_insns = 0x7fffffff.
>>
>> Note that 32 * 0x7fffffff = 0xffffffe0 overflows but bypasses your check.
>>
>
> Argh...  You're right, my check is wrong.  What I like about my patch
> though is that it doesn't introduce an arbitrary limit.  Could you
> redo your check without the MAX_INSNS?

Could use something like:

	if (insnlist.n_insns <= ULONG_MAX / sizeof(struct comedi_insn))
		insns =
			kmalloc(sizeof(struct comedi_insn) * insnlist.n_insns,
				GFP_KERNEL);
	if (!insns)
		...

(note that insns is initialized to NULL).

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
