Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab1HXCKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 22:10:31 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:42870 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab1HXCKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 22:10:25 -0400
MIME-Version: 1.0
In-Reply-To: <20110823164035.ca28fdc6.rdunlap@xenotime.net>
References: <20110822145304.980529cb921e5f1321c622da@canb.auug.org.au>
	<20110822125355.bb01d76b.rdunlap@xenotime.net>
	<CACqU3MVjg60pTPyNWm+41w144QzPgtHQ4wZPUUV=vok8gGffuQ@mail.gmail.com>
	<20110822174958.73dd96c7.rdunlap@xenotime.net>
	<1314065358.3225.44.camel@localhost.localdomain>
	<20110823164035.ca28fdc6.rdunlap@xenotime.net>
Date: Tue, 23 Aug 2011 22:10:24 -0400
Message-ID: <CACqU3MWfKji5BcGRmwO_Y4_15oOq7Trw3u6j1g2meFAaG-s9-w@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 22 (evm)
From: Arnaud Lacombe <lacombar@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Mimi Zohar <zohar@us.ibm.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 23, 2011 at 7:40 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> I think that you are going to need to do something like Arnaud suggested
> and use "depends on TCG_TPM=y" instead of just "depends on TCG_TPM",
> unless you can convince someone that this is a kconfig bug.
>
dammit... I guess there is...

If you consider the following Kconfig:

config MOD
        bool
        default y
        option modules

config EXPERIMENTAL
        bool
        default y

menuconfig A
        tristate "A"
        depends on EXPERIMENTAL

config B
        bool "B"

config B0
        bool

config C
        tristate "C"
        depends on B

config C0
        tristate

config D
        boolean "D"
        depends on A && B
        select C
        select C0

config E
        tristate "E"

config F
        tristate "F"
        select E

B (KEYS) allows to set C (TRUSTED_KEYS). Also, B (KEYS) and A
(TCG_TPM) allows to set D (EVM), which will select (C). Now,
menuconfig highlight the problem very well. Proceeding as following
A=m, B=y, C=m, E=y, F=y, we ends up having:

 <M> A  --->
 [*] B
 {M} C
 [*] D
 -*- E
 <*> F

which translate in the following config:

CONFIG_MOD=y
CONFIG_EXPERIMENTAL=y
CONFIG_A=m
CONFIG_B=y
CONFIG_C=m
CONFIG_C0=m
CONFIG_D=y
CONFIG_E=y
CONFIG_F=y

I would have expected CONFIG_C and CONFIG_C0 to be 'y', just as 'E'.
If you remove D's dependency on 'A', everything works as expected. So
it would seem direct dependency state influence the state of reverse
dependencies...

Will have a look...

 - Arnaud
