Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756364Ab1I2NcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 09:32:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab1I2NcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 09:32:04 -0400
Subject: Re: [PATCH v3 19/24] C6X: headers
From: Mark Salter <msalter@redhat.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Date: Thu, 29 Sep 2011 09:32:00 -0400
In-Reply-To: <201109281607.11228.arnd@arndb.de>
References: <1317155405-26235-1-git-send-email-msalter@redhat.com>
	 <1317155405-26235-20-git-send-email-msalter@redhat.com>
	 <201109281607.11228.arnd@arndb.de>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1317303121.2580.113.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 16:07 +0200, Arnd Bergmann wrote:
> On Tuesday 27 September 2011, Mark Salter wrote:
> 
> > +
> > +static inline void __delay(unsigned long loops)
> > +{
> > +	uint32_t tmp;
> > +
> > +	/* 6 cycles per loop */
> > +	asm volatile ("        mv    .s1  %0,%1\n"
> > +		      "0: [%1] b     .s1  0b\n"
> > +		      "        add   .l1  -6,%0,%0\n"
> > +		      "        cmplt .l1  1,%0,%1\n"
> > +		      "        nop   3\n"
> > +		      : "+a"(loops), "=A"(tmp));
> > +}
> > +
> > +static inline void _c6x_tickdelay(unsigned int x)
> > +{
> > +	uint32_t cnt, endcnt;
> > +
> > +	asm volatile ("        mvc   .s2   TSCL,%0\n"
> > +		      "        add   .s2x  %0,%1,%2\n"
> > +		      " ||     mvk   .l2   1,B0\n"
> > +		      "0: [B0] b     .s2   0b\n"
> > +		      "        mvc   .s2   TSCL,%0\n"
> > +		      "        sub   .s2   %0,%2,%0\n"
> > +		      "        cmpgt .l2   0,%0,B0\n"
> > +		      "        nop   2\n"
> > +		      : "=b"(cnt), "+a"(x), "=b"(endcnt) : : "B0");
> > +}
> 
> Do you actually need to provide the __delay function here?
> I think it's really only used by the calibrate_delay() function
> that you don't need.
> 

It is still used in spinlock_debug.c and a few drivers.

--Mark


