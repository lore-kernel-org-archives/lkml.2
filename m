Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab2DICTK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 22:19:10 -0400
Received: from [221.122.61.228] ([221.122.61.228]:39182 "EHLO mx.nrchpc.ac.cn"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753139Ab2DICTI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 22:19:08 -0400
From: "Liu Yu" <liuyums@bwstor.com.cn>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
References: <006001cd0cb2$20f547b0$62dfd710$@com.cn> <20120406120521.1a6dcd1b.akpm@linux-foundation.org>
In-Reply-To: <20120406120521.1a6dcd1b.akpm@linux-foundation.org>
Subject: re: Wrong use of MAX_JIFFY_OFFSET?
Date: Mon, 9 Apr 2012 10:18:23 +0800
Message-ID: <003501cd15f7$13547560$39fd6020$@com.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
thread-index: Ac0UUMIZuiyu2ahpSkaIbU1YSV5XOABphEOg
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----邮件原件-----
> 发件人: Andrew Morton [mailto:akpm@linux-foundation.org]
> 发送时间: 2012年4月7日 3:05
> 收件人: Liu Yu
> 抄送: linux-kernel@vger.kernel.org
> 主题: Re: Wrong use of MAX_JIFFY_OFFSET?
> 
> On Wed, 28 Mar 2012 15:12:24 +0800
> "Liu Yu" <liuyums@bwstor.com.cn> wrote:
> 
> > Hi guys,
> >
> > I saw a couple of places in current kernel have this kind of code:
> >
> > > static inline unsigned int elapsed_jiffies_msecs(unsigned long start)
> > > {
> > >         unsigned long end = jiffies;
> > >
> > >         if (end >= start)
> > >                return jiffies_to_msecs(end - start);
> > >
> > >         return jiffies_to_msecs(end + (MAX_JIFFY_OFFSET - start) + 1);
> > > }
> >
> > As you know, jiffies has a type of unsigned long, so if we know which is
the
> > end and
> > which is the start, then (end - start) can simply figure out how much
> > jiffies flies,
> > without worry about the overflow.
> >
> > Look at the code above, assume that there is just an overflow happening
on
> > jiffies: end=0 and start=~0UL.
> > Since end < start, then the return value of the function is
> > jiffies_to_msecs(MAX_JIFFY_OFFSET+2).
> > But shouldn't the correct value be jiffies_to_msecs(1)?
> >
> > could someone tell me that am I missing anything?
> >
> 
> Seems right.  The code should be
> 
> static inline unsigned long elapsed_jiffies_msecs(unsigned long start)
> {
> 	return jiffies_to_msecs(jiffies - start);
> }
> 
> Note the return type.  jiffies_to_msecs() currently returns unsigned
> int.  I think it should return unsigned long.  Even then, it can still
> overflow with valid inputs on HZ=100 32-bit machines.

Thanks a lot for your reply :)

I saw similar code in
	drivers/net/wireless/ipw2x00/libipw_wx.c
	net/wireless/scan.c
	include/linux/jbd2.h

hope someone can fix this. :)

Thanks,
Yu

