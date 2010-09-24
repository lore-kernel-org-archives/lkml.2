Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab0IXHUc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 03:20:32 -0400
Received: from pegase1.c-s.fr ([194.2.40.7]:15484 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab0IXHUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 03:20:31 -0400
Message-ID: <4C9C513B.40501@c-s.fr>
Date: Fri, 24 Sep 2010 09:20:27 +0200
From: LEROY Christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: David Brownell <dbrownell@users.sourceforge.net>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Kumar Gala <galak@kernel.crashing.org>,
        Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH] spi_mpc8xxx: issue with using definition of pram in Device
 Tree
References: <20100916070503.10046C7391@messagerie.si.c-s.fr> <20100924071006.GA21318@angua.secretlab.ca>
In-Reply-To: <20100924071006.GA21318@angua.secretlab.ca>
Content-Type: multipart/mixed;
 boundary="------------070408010709090906090605"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070408010709090906090605
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

  Hello,

The issue is that cpm_muram_alloc_fixed() allocates memory from the 
general purpose muram area (from 0x0 to 0x1bff).
Here we need to return a pointer to the parameter RAM, which is located 
somewhere starting at 0x1c00. It is not a dynamic allocation that is 
required here but only to point on the correct location in the parameter 
RAM.

For the CPM2, I don't know. I'm working with a MPC866.

Attached is a previous discussion on the subject where I explain a bit 
more in details the issue.

Regards
C. Leroy

Le 24/09/2010 09:10, Grant Likely a écrit :
> On Thu, Sep 16, 2010 at 09:05:03AM +0200, christophe leroy wrote:
>> This patch applies to 2.6.34.7 and 2.6.35.4
>> It fixes an issue during the probe for CPM1 with definition of parameter ram from DTS
>>
>> Signed-off-by: christophe leroy<christophe.leroy@c-s.fr>
> I'm sorry, I don't understand the fix from the given description.
> What is the problem, and why is cpm_muram_alloc_fixed() the wrong
> thing to call on CPM1?  Does CPM2 still need it?
>
> g.
>
>> diff -urN b/drivers/spi/spi_mpc8xxx.c c/drivers/spi/spi_mpc8xxx.c
>> --- b/drivers/spi/spi_mpc8xxx.c	2010-09-08 16:43:50.000000000 +0200
>> +++ c/drivers/spi/spi_mpc8xxx.c	2010-09-08 16:44:03.000000000 +0200
>> @@ -822,7 +822,7 @@
>>   	if (!iprop || size != sizeof(*iprop) * 4)
>>   		return -ENOMEM;
>>
>> -	spi_base_ofs = cpm_muram_alloc_fixed(iprop[2], 2);
>> +	spi_base_ofs = iprop[2];
>>   	if (IS_ERR_VALUE(spi_base_ofs))
>>   		return -ENOMEM;
>>
>> @@ -844,7 +844,6 @@
>>   			return spi_base_ofs;
>>   	}
>>
>> -	cpm_muram_free(spi_base_ofs);
>>   	return pram_ofs;
>>   }

--------------070408010709090906090605
Content-Type: message/rfc822;
 name="Message joint"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="Message joint"

Return-Path: <linuxppc-dev-bounces+christophe.leroy=c-s.fr@lists.ozlabs.org>
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 07CC4C73C8
	for <christophe.leroy@c-s.fr>; Tue,  7 Sep 2010 22:01:34 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id I38khnVvb5+l for <christophe.leroy@c-s.fr>;
	Tue,  7 Sep 2010 22:01:34 +0200 (CEST)
Received: from mailhub1.si.c-s.fr (mailhub1.cstelecom.cie-signaux.fr [192.168.12.233])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id CDF71C7393
	for <chleroy@messagerie.si.c-s.fr>; Tue,  7 Sep 2010 22:01:33 +0200 (CEST)
Received: from mailhub1.si.c-s.fr (mailhub1 [192.168.12.233])
	by localhost (Postfix) with ESMTP id 8EC603C006
	for <chleroy@messagerie.si.c-s.fr>; Tue,  7 Sep 2010 22:01:32 +0200 (CEST)
X-Spam-Status: No, score=0.0 required=6.0 tests=AWL autolearn=unavailable
	version=3.3.0
X-Spam-Level: 
X-Spam-Checker-Version: SpamAssassin 3.3.0 (2010-01-18) on mailhub1.si.c-s.fr
Received: from localhost (mailhub1 [192.168.12.233])
	by pegase1.c-s.fr (Postfix) with ESMTP id 8B9613C005
	for <chleroy@messagerie.si.c-s.fr>; Tue,  7 Sep 2010 22:01:32 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from mailhub1.si.c-s.fr ([192.168.12.233])
	by localhost (mailhub1.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id 2SA7qGc2i3x5 for <chleroy@messagerie.si.c-s.fr>;
	Tue,  7 Sep 2010 22:01:32 +0200 (CEST)
Received: from ozlabs.org (ozlabs.org [203.10.76.45])
	by pegase1.c-s.fr (Postfix) with ESMTP id C974A3C004
	for <christophe.leroy@c-s.fr>; Tue,  7 Sep 2010 22:01:31 +0200 (CEST)
Received: from bilbo.ozlabs.org (localhost [127.0.0.1])
	by ozlabs.org (Postfix) with ESMTP id 93CDCB71D5
	for <christophe.leroy@c-s.fr>; Wed,  8 Sep 2010 06:01:22 +1000 (EST)
Received: from TX2EHSOBE008.bigfish.com (tx2ehsobe004.messaging.microsoft.com
	[65.55.88.14]) by ozlabs.org (Postfix) with ESMTP id 4F478B6EF7
	for <linuxppc-dev@lists.ozlabs.org>;
	Wed,  8 Sep 2010 06:01:11 +1000 (EST)
Received: from mail26-tx2-R.bigfish.com (10.9.14.237) by
	TX2EHSOBE008.bigfish.com (10.9.40.28) with Microsoft SMTP Server id
	8.1.340.0; Tue, 7 Sep 2010 20:01:04 +0000
Received: from mail26-tx2 (localhost.localdomain [127.0.0.1])	by
	mail26-tx2-R.bigfish.com (Postfix) with ESMTP id 8110DE0439	for
	<linuxppc-dev@lists.ozlabs.org>; Tue,  7 Sep 2010 20:01:04 +0000 (UTC)
X-SpamScore: -12
X-BigFish: VS-12(zz1432N98dNzz1202hzzz2dh2a8h61h)
Received: from mail26-tx2 (localhost.localdomain [127.0.0.1]) by mail26-tx2
	(MessageSwitch) id 1283889664159557_3552;
	Tue,  7 Sep 2010 20:01:04 +0000 (UTC)
Received: from TX2EHSMHS009.bigfish.com (unknown [10.9.14.247])	by
	mail26-tx2.bigfish.com (Postfix) with ESMTP id 246DD1590052	for
	<linuxppc-dev@lists.ozlabs.org>; Tue,  7 Sep 2010 20:01:04 +0000 (UTC)
Received: from az33egw02.freescale.net (192.88.158.103) by
	TX2EHSMHS009.bigfish.com (10.9.99.109) with Microsoft SMTP Server (TLS)
	id 14.0.482.44; Tue, 7 Sep 2010 20:00:50 +0000
Received: from az33smr01.freescale.net (az33smr01.freescale.net
	[10.64.34.199])	by az33egw02.freescale.net (8.14.3/8.14.3) with ESMTP
	id o87K0e8f009102	for <linuxppc-dev@lists.ozlabs.org>;
	Tue, 7 Sep 2010 13:00:50 -0700 (MST)
Received: from az33exm25.fsl.freescale.net (az33exm25.am.freescale.net
	[10.64.32.16])	by az33smr01.freescale.net (8.13.1/8.13.0) with ESMTP id
	o87KD2vx011794	for <linuxppc-dev@lists.ozlabs.org>;
	Tue, 7 Sep 2010 15:13:02 -0500 (CDT)
Received: from schlenkerla.am.freescale.net ([10.82.120.40]) by
	az33exm25.fsl.freescale.net with Microsoft SMTPSVC(6.0.3790.4675);
	Tue, 7 Sep 2010 13:00:39 -0700
Date: Tue, 7 Sep 2010 15:00:38 -0500
From: Scott Wood <scottwood@freescale.com>
To: LEROY Christophe <christophe.leroy@c-s.fr>
Subject: Re: Small issue at init with spi_mpc8xxx.c with CPM1
Message-ID: <20100907150038.57a7b065@schlenkerla.am.freescale.net>
In-Reply-To: <4C86031D.5080804@c-s.fr>
References: <4C86031D.5080804@c-s.fr>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
MIME-Version: 1.0
X-OriginalArrivalTime: 07 Sep 2010 20:00:39.0706 (UTC)
	FILETIME=[584C87A0:01CB4EC7]
X-Reverse-DNS: az33egw02.freescale.net
Cc: Kumar Gala <kumar.gala@freescale.com>,
	LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>
X-BeenThere: linuxppc-dev@lists.ozlabs.org
X-Mailman-Version: 2.1.13
Precedence: list
List-Id: Linux on PowerPC Developers Mail List <linuxppc-dev.lists.ozlabs.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailman-Copy: yes
Sender: linuxppc-dev-bounces+christophe.leroy=c-s.fr@lists.ozlabs.org
Errors-To: linuxppc-dev-bounces+christophe.leroy=c-s.fr@lists.ozlabs.org

On Tue, 7 Sep 2010 11:17:17 +0200
LEROY Christophe <christophe.leroy@c-s.fr> wrote:

> 
>   Dear Kumar,
> 
> I have a small issue in the init of spi_mpc8xxx.c with MPC866 (CPM1)
> 
> Unlike cpm_uart that maps the parameter ram directly using 
> of_iomap(np,1), spi_mpc8xxx.c uses cpm_muram_alloc_fixed().
> 
> This has two impacts in the .dts file:
> * The driver must be declared with pram at 1d80 instead of 3d80 whereas 
> it is not a child of muram@2000 but a child of cpm@9c0
> * muram@2000/data@0 must be declared with reg = <0x0 0x2000>   whereas 
> is should be reg=<0x0 0x1c00> to avoid cpm_muram_alloc() to allocate 
> space from parameters ram.
> 
> Maybe I misunderstood something ?

Don't make the device tree lie, fix the driver instead.

The allocator should not be given any chunks of muram that are
dedicated to a fixed purpose -- it might hand it out to something else
before you reserve it.  I don't think that cpm_muram_alloc_fixed() has
any legitimate use at all.

-Scott

_______________________________________________
Linuxppc-dev mailing list
Linuxppc-dev@lists.ozlabs.org
https://lists.ozlabs.org/listinfo/linuxppc-dev


--------------070408010709090906090605--
