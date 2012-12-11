Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab2LKW3C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:29:02 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:57117 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754115Ab2LKW3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:29:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC v1 01/16] lib: devres: don't enclose pcim_*() functions in CONFIG_HAS_IOPORT
Date: Tue, 11 Dec 2012 22:28:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Eran Ben-Avi" <benavi@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shadi Ammouri <shadi@marvell.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-arm-kernel@lists.infradead.org
References: <1354917879-32073-1-git-send-email-thomas.petazzoni@free-electrons.com> <20121211164608.GT14363@n2100.arm.linux.org.uk> <20121211173232.43668ab3@pyramind.ukuu.org.uk>
In-Reply-To: <20121211173232.43668ab3@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212112228.53720.arnd@arndb.de>
X-Provags-ID: V02:K0:q/sYaBWOCe/0BwmtCYwvOmy+bgWiYMd2awimnsZvU9Z
 mUPoINd5senNtIoxztcJ4EKTm1hsdguaIMZFDCkvU6fwIsGf/7
 KAuI8rzNKRubH5ILJQc1XeiyFHDzMufv6aq8sS+WxYd8x3Sg56
 mRH9OUCaz21IBCewXWNcQ/Q2Uf4BJm/yJmMQgAx27q1ZKl1o1R
 nnRvJ51DeCwmKyiErP65Wwq4zvja0OHD2L4U+j1oU+ZhBNHlD9
 jG0Hj8z5ho7XtoEKSqiECFy7oMqavgo68MpeHJ35AK142NLg1R
 SWwD+aWg6rljQAPf2tEozx6rxwf4Nf/XiwVOJlfEqXKo4HlOG8
 EBmFYzyZfzb7IIy677OI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 December 2012, Alan Cox wrote:
> > Plus, if you have IO space support, you must have some MMIO region for
> > them to target - doing what many platforms have done to date and targetted
> > ISA IO address 0 at virtual address 0 is just not on because as soon as
> > you build a device driver which probes ISA addresses into your kernel,
> > you will oops.
> 
> There shouldn't really be anything poking around that is modern - this is
> true of some PC stuff too.
> 
> In general however if its because you have a window partly mapped you
> could just catch the exception and load 0xFF for reads (and probably
> whine with a backtrace so you know who to moan at).

The problem that Russell refers to is that some platforms define a window
that is 4GB large and starts at NULL. They then ioremap their PCI
or PCMCIA I/O space window and use the virtual __iomem address as the
offset into the 4GB I/O space window. Any driver (e.g. vgacon, /dev/port
or some legacy alsa sound driver) that tries to access a low port number
then ends up in user space memory, typically in an unmapped area there.

We definitely don't want to catch and fixup those exceptions. The solution
is to change the platforms so they actually use the proper I/O window
at a virtual address that is not used for anything else.

	Arnd
