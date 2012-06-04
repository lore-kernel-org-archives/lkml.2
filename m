Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761211Ab2FDXgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 19:36:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57976 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab2FDXge convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 19:36:34 -0400
MIME-Version: 1.0
In-Reply-To: <20120604133457.GA2969@richard>
References: <20120422155202.GA13540@richard>
	<4F95B17B.3030401@redhat.com>
	<20120514015536.GA3331@richard>
	<CAE9FiQUjxH+LWy2zbbL6TVQSMZ44i9grFBZf0ZZQFPEWRKANMw@mail.gmail.com>
	<20120514064615.GB26605@richard>
	<CAE9FiQUuHFoEXMz_Va+FOGnqEbi9=cnnoSB+h7Ug2e4Y2sFTGQ@mail.gmail.com>
	<20120516011833.GA6599@richard>
	<CAE9FiQVUcYu-KM8fBs3zO5ZnL9jxHmJSN6-Ue5-kdC-niM6=Jw@mail.gmail.com>
	<20120529115900.GA31679@richard>
	<CAE9FiQWO1C76ppjZF4Lm4FVpQYPRv5ZirGp9iOM3pm-xrm3Epg@mail.gmail.com>
	<20120604133457.GA2969@richard>
Date: Mon, 4 Jun 2012 16:36:33 -0700
X-Google-Sender-Auth: tAQ_oeWZs5xyilTy1xqqGmEPbls
Message-ID: <CAE9FiQWw=dMBajvGQy_1KoPbGa1wvER5U81oULbkXCjBzQDRpQ@mail.gmail.com>
Subject: Re: One problem in reassign pci bus number?
From: Yinghai Lu <yinghai@kernel.org>
To: Richard Yang <weiyang@linux.vnet.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 4, 2012 at 6:34 AM, Richard Yang <weiyang@linux.vnet.ibm.com> wrote:
> On Tue, May 29, 2012 at 10:14:51AM -0700, Yinghai Lu wrote:
>>On Tue, May 29, 2012 at 4:59 AM, Richard Yang
>><weiyang@linux.vnet.ibm.com> wrote:
>>>
>>> I think about this issue again, this behavior of kernel will bring some
>>> unconvenience to the user.
>>>
>>> Do you think the kernel could handle this situation?
>>
>>in this extreme case, you may need user to do some comprise.
>>
>>We should always try to use setting from BIOS if it is sane.
>>
>>Yinghai
> Yinghai
>
>                    +-------+
>                    |       | root bridge(0,255)
>                    +---+---+
>                        |          Bus 0
>       -----+-----------+------------------------------+--
>            |                                          |
>            |                                          |
>            |                                          |
>       +----+----+                               +-----+-----+
>       |         |  B1(1,15)                     |           |B2(32,35)
>       +----+----+                               +-----+-----+
>            |  Bus 1                                   |    Bus 32
>       -----+-----------------------             -----------
>                             |
>                        +----+----+
>                        |         | B3
>                        +---------+
>
> I reread the current code, v3.4, in linus tree,
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> And I come up with another condition which will have a problem when
> kernel is not given the parameter, pci=assign-busses.
>
> Same condition as previous:
> -------------------------------------------------------------------------------
> B1 and B2 works fine with the BIOS and get the bus number assigned.
> B3 is not probed by BIOS.
>
> Difference between the previous example:
> -------------------------------------------------------------------------------
> In this case, B2 is assigned bus range (32, 35), which has a gap between
> B1 number range (1, 15).
>
> When kernel meets B3 in second pass, B3 will be assigned with bus number
> 16. Well, this time the bus number 16 doesn't overlap with bus number of
> B2.
>
> But, the pci_fixup_parent_subordinate_busnr() will not work since the
> pci=assign-buses is not passed to kernel.
>
> So B1's bus window is still (1,15) not (1,16).
>
> BTW, is this also a extrem case?

that should be handled by busn_alloc branch.

kernel will try to probe in [1,15] at first, and could extend B1 range
to [1, 31] if needed.

Thanks

Yinghai
